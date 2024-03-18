const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("comments.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("comments", comments_test_data, runCommentsTest);
}

const comments_test_data = .{
    .{
        \\
        ,
        \\
    },
};

fn runCommentsTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    // the test is trival as we only need the generated comments.zig with correct comments so it can be compiled
    _ = expected_output;

    var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc_param: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    try lexer.scan_string(input);

    _ = try lexer.yylex(&yylval_param, &yylloc_param);
}
