const std = @import("std");
const testing = std.testing;
const YYLexer = @import("simple.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("simple", simple_test_data, runSimpleTest);
}

const simple_test_data = .{
    .{
        \\ line 1
        \\ line 2
        \\
        ,
        \\# of lines = 2, # of chars = 16
        \\
    },
};

fn runSimpleTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc_param: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };
    try lexer.init();
    defer lexer.deinit();

    try lexer.scan_string(input);

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();

    while (true) {
        const tk = lexer.yylex(&yylval_param, &yylloc_param) catch |err| {
            std.debug.print("{any}\n", .{err});
            break;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
    }
    try buf.writer().print("# of lines = {d}, # of chars = {d}\n", .{
        YYLexer.num_lines,
        YYLexer.num_chars,
    });

    try testing.expectEqualSlices(u8, buf.items, expected_output);
}
