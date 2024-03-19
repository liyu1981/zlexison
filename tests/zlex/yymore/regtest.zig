const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("yymore.zig").YYLexer;

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("yymore", yymore_test_data, runYymoreTest);
}

const yymore_test_data = .{
    .{
        \\"This is multi line \
        \\text"
        \\
        ,
        \\string = "This is multi line \
        \\text"
        \\
    },
};

fn runYymoreTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc_param: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    var output_buf = std.ArrayList(u8).init(allocator);
    defer output_buf.deinit();

    lexer.yyg.yyout_r = .{ .buf = &output_buf };

    try lexer.scan_string(input);

    _ = try lexer.yylex(&yylval_param, &yylloc_param);

    try testing.expectEqualSlices(u8, output_buf.items, expected_output);
}
