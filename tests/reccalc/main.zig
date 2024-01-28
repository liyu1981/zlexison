const std = @import("std");
const ScanLex = @import("scan.zig");

pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    const allocator = std.heap.page_allocator;

    const stdout_writer = std.io.getStdOut().writer();

    // var f = try std.fs.cwd().openFile(args[1], .{});
    // defer f.close();
    // var content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    // _ = &content;
    // defer allocator.free(content);

    var scan = ScanLex.init(.{
        .allocator = allocator,
        // .input = content,
    });
    defer scan.deinit();

    try scan.lexStart();
    brk: while (true) {
        scan.lex();
        switch (scan.context.cur_tok) {
            .TOK_EOF => {
                break :brk;
            },
            else => |tk| {
                try stdout_writer.print("tk: {any}\n", .{tk});
            },
        }
    }
    scan.lexStop();

    return 0;
}
