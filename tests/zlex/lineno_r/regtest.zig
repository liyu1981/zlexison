const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("lineno_r.zig").YYLexer;
const lineno_r_one_txt = @embedFile("lineno_r.one.txt");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("lineno_r", lineno_r_test_data, runLinenoRTest);
}

const lineno_r_test_data = .{
    .{
        lineno_r_one_txt,
        \\19
        \\
    },
};

fn runLinenoRTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var output_buf = std.ArrayList(u8).init(allocator);
    defer output_buf.deinit();

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    try lexer.scan_string(input);
    lexer.yyg.yyout_r = .{ .buf = &output_buf };
    _ = try lexer.yylex(&yylval, &yylloc);

    try testing.expectEqualSlices(u8, output_buf.items, expected_output);
}
