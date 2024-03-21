const std = @import("std");
const testing = std.testing;
const zlexison = @import("zlexison.zig");
const YYLexer = @import("scan.zig").YYLexer;
const YYParser = @import("parser.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("scan", scan_test_data, runScanTest);
    try Util.runTests("parse", parse_test_data, runParseTest);
}

const scan_test_data = .{
    .{
        \\1+2*3
        \\
        ,
        \\tk: 258 at loc: L0:C0 - L0:C1
        \\tk: 43 at loc: L0:C1 - L0:C2
        \\tk: 258 at loc: L0:C2 - L0:C3
        \\tk: 42 at loc: L0:C3 - L0:C4
        \\tk: 258 at loc: L0:C4 - L0:C5
        \\tk: 10 at loc: L0:C5 - L1:C0
        \\
    },
    .{
        \\(1+2) * 3
        \\
        ,
        \\tk: 40 at loc: L0:C0 - L0:C1
        \\tk: 258 at loc: L0:C1 - L0:C2
        \\tk: 43 at loc: L0:C2 - L0:C3
        \\tk: 258 at loc: L0:C3 - L0:C4
        \\tk: 41 at loc: L0:C4 - L0:C5
        \\tk: 42 at loc: L0:C6 - L0:C7
        \\tk: 258 at loc: L0:C8 - L0:C9
        \\tk: 10 at loc: L0:C9 - L1:C0
        \\
    },
    .{
        \\a = 256
        \\sqrt (a)
        ,
        \\tk: 259 at loc: L0:C0 - L0:C1
        \\tk: 61 at loc: L0:C2 - L0:C3
        \\tk: 258 at loc: L0:C4 - L0:C7
        \\tk: 10 at loc: L0:C7 - L1:C0
        \\tk: 260 at loc: L1:C0 - L1:C4
        \\tk: 40 at loc: L1:C5 - L1:C6
        \\tk: 259 at loc: L1:C6 - L1:C7
        \\tk: 41 at loc: L1:C7 - L1:C8
        \\
    },
    .{
        \\16 == 12
        \\
        ,
        \\tk: 258 at loc: L0:C0 - L0:C2
        \\tk: 61 at loc: L0:C3 - L0:C4
        \\tk: 61 at loc: L0:C4 - L0:C5
        \\tk: 258 at loc: L0:C6 - L0:C8
        \\tk: 10 at loc: L0:C8 - L1:C0
        \\
    },
};

fn runScanTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    try zlexison.initSymTable(allocator);
    defer zlexison.sym_table.deinit();

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
        \\1+2*3
        \\
        ,
        \\      7.00
    },
    .{
        \\(1+2) * 3
        \\
        ,
        \\      9.00
    },
    .{
        \\a = 256
        \\sqrt (a)
        \\
        ,
        \\    256.00     16.00
    },
    .{
        \\16 == 12
        \\
        ,
        // TODO: check error?
        \\
    },
};

fn runParseTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    try zlexison.initSymTable(allocator);
    defer zlexison.sym_table.deinit();

    var scanner = YYLexer{ .allocator = allocator };

    try scanner.init();
    defer scanner.deinit();

    try scanner.scan_string(input);

    YYParser.yydebug = false;

    YYParser.result_buf = std.ArrayList(u8).init(allocator);
    defer YYParser.result_buf.deinit();

    _ = try YYParser.yyparse(allocator, &scanner);

    try testing.expectEqualSlices(u8, YYParser.result_buf.items, expected_output);
}
