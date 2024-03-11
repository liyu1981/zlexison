const std = @import("std");
const testing = std.testing;
const YYLexer = @import("scan.zig");
const YYParser = @import("parser.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("scan", scan_test_data, runScanTest);
    try Util.runTests("parse", parse_test_data, runParseTest);
}

const scan_test_data = .{
    .{
        \\2.5 + .5 * 8.6 - 12
        \\
        ,
        \\tk: 258 at loc: L0:C0 - L0:C3
        \\tk: 43 at loc: L0:C4 - L0:C5
        \\tk: 258 at loc: L0:C6 - L0:C8
        \\tk: 42 at loc: L0:C9 - L0:C10
        \\tk: 258 at loc: L0:C11 - L0:C14
        \\tk: 45 at loc: L0:C15 - L0:C16
        \\tk: 258 at loc: L0:C17 - L0:C19
        \\tk: 10 at loc: L0:C19 - L1:C0
        \\
    },
};

fn runScanTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };

    try lexer.init();
    defer lexer.deinit();

    try lexer.scan_string(input);

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    const buf_writer = buf.writer();

    while (true) {
        const tk = lexer.yylex(&yylval, &yylloc) catch |err| {
            std.debug.print("{any}\n", .{err});
            return err;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
        switch (tk) {
            YYLexer.TOK_TYPE.YYEOF => {
                break;
            },
            else => |cur_tk| {
                try buf_writer.print("tk: {any} at loc: {s}\n", .{ cur_tk, yylloc });
            },
        }
    }

    try testing.expectEqualSlices(u8, buf.items, expected_output);
}

const parse_test_data = .{
    .{
        \\2.5 + .5 * 8.6 - 12
        \\
        ,
        \\-5.2000000000
    },
};

fn runParseTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var scanner = YYLexer{ .allocator = allocator };

    try scanner.init();
    defer scanner.deinit();

    try scanner.scan_string(input);

    YYParser.yydebug = false;

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    var yyps = try YYParser.yypstate.init(allocator);
    defer yyps.deinit();

    YYParser.result_buf = std.ArrayList(u8).init(allocator);
    defer YYParser.result_buf.deinit();

    while (true) {
        const tk = scanner.yylex(&yylval, &yylloc) catch |err| {
            std.debug.print("{any}\n", .{err});
            return err;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
        const result = try YYParser.yypush_parse(allocator, yyps, @intCast(tk), &yylval, &yylloc);
        if (result != YYParser.YYPUSH_MORE)
            break;
    }

    try testing.expectEqualSlices(u8, YYParser.result_buf.items, expected_output);
}
