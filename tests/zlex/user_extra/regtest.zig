const std = @import("std");
const testing = std.testing;
const YYLexer = @import("user_extra.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("user_extra", user_extra_test_data, runUserExtraTest);
}

const user_extra_test_data = .{
    .{
        \\ line 1
        \\ line 2
        \\
        ,
        \\# of lines = 2, # of chars = 16
        \\
    },
};

fn runUserExtraTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    const Counter = struct {
        num_lines: usize = 0,
        num_chars: usize = 0,
    };

    const MyYYLexer = YYLexer.defineYYLexer(.{ .YY_EXTRA_TYPE = Counter });

    var yylval_param: MyYYLexer.YYSTYPE = MyYYLexer.YYSTYPE.default();
    var yylloc_param: MyYYLexer.YYLTYPE = .{};

    var lexer = MyYYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    lexer.yyg.yyextra_r = .{};

    try lexer.scan_string(input);

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();

    while (true) {
        const tk = lexer.yylex(&yylval_param, &yylloc_param) catch |err| {
            std.debug.print("{any}\n", .{err});
            break;
        };
        if (tk == MyYYLexer.YY_TERMINATED) break;
    }
    try buf.writer().print("# of lines = {d}, # of chars = {d}\n", .{
        lexer.yyg.yyextra_r.num_lines,
        lexer.yyg.yyextra_r.num_chars,
    });

    try testing.expectEqualSlices(u8, buf.items, expected_output);
}
