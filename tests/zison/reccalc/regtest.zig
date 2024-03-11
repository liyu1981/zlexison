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
        \\12 + 4 * 5
        \\
        ,
        \\tk: 263 at loc: L0:C0 - L0:C2
        \\tk: 258 at loc: L0:C3 - L0:C4
        \\tk: 263 at loc: L0:C5 - L0:C6
        \\tk: 260 at loc: L0:C7 - L0:C8
        \\tk: 263 at loc: L0:C9 - L0:C10
        \\tk: 262 at loc: L0:C10 - L1:C0
        \\
    },
    .{
        \\(1+2) * 3
        \\
        ,
        \\tk: 264 at loc: L0:C4 - L0:C5
        \\tk: 260 at loc: L0:C6 - L0:C7
        \\tk: 263 at loc: L0:C8 - L0:C9
        \\tk: 262 at loc: L0:C9 - L1:C0
        \\
    },
    .{
        \\2 + (4 + 5 * (6))
        \\
        ,
        \\tk: 263 at loc: L0:C0 - L0:C1
        \\tk: 258 at loc: L0:C2 - L0:C3
        \\tk: 264 at loc: L0:C16 - L0:C17
        \\tk: 262 at loc: L0:C17 - L1:C0
        \\
    },
};

fn runScanTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };
    YYLexer.context = YYLexer.Context.init(allocator);
    defer YYLexer.context.deinit();

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
            YYLexer.TOK_TYPE.TOK_EOF => {
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
        \\12 + 4 * 5
        \\
        ,
        \\Result( .verbose = false, .value = 32, .nerrs = 0 )
        \\
    },
    .{
        \\(1+2) * 3
        \\
        ,
        \\Result( .verbose = false, .value = 9, .nerrs = 0 )
        \\
    },
    .{
        \\2 + (4 + 5 * (6))
        \\
        ,
        \\Result( .verbose = false, .value = 36, .nerrs = 0 )
        \\
    },
};

fn runParseTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var res = YYParser.Result{};
    res.verbose = false;

    var scanner = YYLexer{ .allocator = allocator };
    YYLexer.context = YYLexer.Context.init(allocator);
    defer YYLexer.context.deinit();

    try scanner.init();
    defer scanner.deinit();

    try scanner.scan_string(input);

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    const buf_writer = buf.writer();

    YYParser.yydebug = false;
    _ = try YYParser.yyparse(allocator, &scanner, &res);

    try buf_writer.print("Result( .verbose = {}, .value = {}, .nerrs = {} )\n", .{ res.verbose, res.value, res.nerrs });

    try testing.expectEqualSlices(u8, buf.items, expected_output);
}
