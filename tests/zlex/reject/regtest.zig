const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("reject.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("reject", reject_test_data, runRejectTest);
}

const reject_test_data = .{
    .{
        \\GNU
        ,
        \\GNU is not Unix!
        \\
    },
    .{
        \\UNIX
        ,
        \\UGNU is not Unix!
        \\GNU is not Unix!
        \\
    },
};

fn runRejectTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    const in_pipe = try std.os.pipe2(.{});
    const forked_pid = try std.os.fork();

    if (forked_pid != 0) {
        defer _ = std.os.waitpid(forked_pid, 0);

        // we are parent
        std.os.close(in_pipe[1]);
        const back_stdin: std.os.fd_t = try std.os.dup(std.os.STDIN_FILENO);
        try std.os.dup2(in_pipe[0], std.os.STDIN_FILENO);
        std.os.close(in_pipe[0]);
        defer std.os.dup2(back_stdin, std.os.STDIN_FILENO) catch unreachable;

        var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
        var yylloc_param: YYLexer.YYLTYPE = .{};

        var lexer = YYLexer{ .allocator = allocator };
        try lexer.init();
        defer lexer.deinit();

        var output_buf = std.ArrayList(u8).init(allocator);
        defer output_buf.deinit();

        lexer.yyg.yyout_r = .{ .buf = &output_buf };

        _ = lexer.yylex(&yylval_param, &yylloc_param) catch |err| switch (err) {
            error.EndOfStream => {},
            else => return err,
        };

        try testing.expectEqualSlices(u8, output_buf.items, expected_output);
    } else {
        // we are child
        std.os.close(in_pipe[0]);
        try std.os.dup2(in_pipe[1], std.os.STDOUT_FILENO);
        std.os.close(in_pipe[1]);
        try std.io.getStdOut().writeAll(input);
    }
}

const ArrayListReader = struct {
    pub const ReaderError = error{
        EndOfStream,
    } || std.mem.Allocator.Error;
    const DEFAULT_CAPACITY = std.mem.page_size;

    buf: std.ArrayList(u8),
    read_pos: usize,

    pub fn init(allocator: std.mem.Allocator) ArrayListReader {
        return .{
            .buf = std.ArrayList(u8).initCapacity(allocator, DEFAULT_CAPACITY),
            .read_pos = 0,
        };
    }

    pub fn appendSlice(this: *ArrayListReader, items: []const u8) ReaderError!void {
        try this.buf.appendSlice(items);
    }

    pub fn append(this: *ArrayListReader, item: u8) ReaderError!void {
        try this.buf.append(item);
    }

    pub fn memInputReadFn(context: *ArrayListReader, buffer: []u8) ReaderError!usize {
        const rest_bytes = context.buf.items.len - context.read_pos - 1; // read_pos start from 0
        if (rest_bytes == 0) {
            return error.EndOfStream;
        }
        if (buffer.len == 0) {
            return 0;
        }
        if (buffer.len < rest_bytes) {
            @memcpy(buffer, context.buf.items[context.read_pos .. context.read_pos + buffer.len]);
            context.read_pos += buffer.len;
            return buffer.len;
        } else {
            @memcpy(buffer[0..rest_bytes], context.buf.items[context.read_pos .. context.read_pos + rest_bytes]);
            context.read_pos += rest_bytes;
            return rest_bytes;
        }
    }

    pub inline fn reader(this: *ArrayListReader) std.io.GenericReader(
        *ArrayListReader,
        ReaderError,
        memInputReadFn,
    ) {
        return .{ .context = this };
    }
};
