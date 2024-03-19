const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("user_init.zig");
const tmpfile = @import("../../utils/tmpfile.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("user_init", user_init_test_data, runUserInitTest);
}

const user_init_test_data = .{
    .{
        \\hello, world
        ,
        \\hello, world
    },
};

fn runUserInitTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    // prepare tmp file
    var tmp_file = try tmpfile.tmpFile(.{});
    defer tmp_file.deinit();
    try tmp_file.f.writeAll(input);

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    var output_buf = std.ArrayList(u8).init(allocator);
    defer output_buf.deinit();

    var args = [_][:0]const u8{ "regtest", "" };
    args[1] = try allocator.dupeZ(u8, tmp_file.abs_path);
    defer allocator.free(args[1]);

    YYLexer.YY_USER_INIT = YYLexer.userInitOpenFileFromArg1;
    YYLexer.exe_args = &args;

    lexer.yyg.yyout_r = .{ .buf = &output_buf };

    _ = lexer.yylex(&yylval, &yylloc) catch |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    };

    try testing.expectEqualSlices(u8, output_buf.items, expected_output);
}
