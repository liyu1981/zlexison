const std = @import("std");
const testing = std.testing;
const YYLexer = @import("scan.zig");
const YYParser = @import("parser.zig");

pub fn runAllTests() !void {
    try runTests("scan", scan_test_data, runScanTest);
    try runTests("parser", parser_test_data, runParserTest);
}

const MAX_INPUT_TAG = 32;
var input_tag_buf: [MAX_INPUT_TAG + 3]u8 = undefined;
fn inputTag(input: []const u8) []const u8 {
    if (input.len < MAX_INPUT_TAG) {
        return input;
    } else {
        return std.fmt.bufPrint(&input_tag_buf, "{s}...", .{input[0..MAX_INPUT_TAG]}) catch {
            unreachable;
        };
    }
}

const testFn = *const fn (allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) anyerror!void;

fn runTests(name: []const u8, test_data: anytype, test_fn: testFn) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    inline for (0..test_data.len) |i| {
        std.debug.print("\n  run {s} tests [{d}] input[{s}] ... ", .{ name, i, inputTag(test_data[i][0]) });
        try test_fn(allocator, test_data[i][0], test_data[i][1]);
        std.debug.print("ok!", .{});
    }
    if (gpa.detectLeaks()) {
        return error.MemLeak;
    }
}

const scan_test_data = .{
    .{
        "z + q;",
        \\tk: 259 at loc: L0:C0 - L0:C1
        \\tk: 43 at loc: L0:C2 - L0:C3
        \\tk: 259 at loc: L0:C4 - L0:C5
        \\tk: 59 at loc: L0:C5 - L0:C6
        \\
    },
    .{
        "T x;",
        \\tk: 258 at loc: L0:C0 - L0:C1
        \\tk: 259 at loc: L0:C2 - L0:C3
        \\tk: 59 at loc: L0:C3 - L0:C4
        \\
    },
    .{
        "T x = y;",
        \\tk: 258 at loc: L0:C0 - L0:C1
        \\tk: 259 at loc: L0:C2 - L0:C3
        \\tk: 61 at loc: L0:C4 - L0:C5
        \\tk: 259 at loc: L0:C6 - L0:C7
        \\tk: 59 at loc: L0:C7 - L0:C8
        \\
    },
    .{
        "x = y;",
        \\tk: 259 at loc: L0:C0 - L0:C1
        \\tk: 61 at loc: L0:C2 - L0:C3
        \\tk: 259 at loc: L0:C4 - L0:C5
        \\tk: 59 at loc: L0:C5 - L0:C6
        \\
    },
    .{
        "T (x) + y;",
        \\tk: 258 at loc: L0:C0 - L0:C1
        \\tk: 40 at loc: L0:C2 - L0:C3
        \\tk: 259 at loc: L0:C3 - L0:C4
        \\tk: 41 at loc: L0:C4 - L0:C5
        \\tk: 43 at loc: L0:C6 - L0:C7
        \\tk: 259 at loc: L0:C8 - L0:C9
        \\tk: 59 at loc: L0:C9 - L0:C10
        \\
    },
    .{
        "T (x);",
        \\tk: 258 at loc: L0:C0 - L0:C1
        \\tk: 40 at loc: L0:C2 - L0:C3
        \\tk: 259 at loc: L0:C3 - L0:C4
        \\tk: 41 at loc: L0:C4 - L0:C5
        \\tk: 59 at loc: L0:C5 - L0:C6
        \\
    },
    .{
        "T (y) = z + q;",
        \\tk: 258 at loc: L0:C0 - L0:C1
        \\tk: 40 at loc: L0:C2 - L0:C3
        \\tk: 259 at loc: L0:C3 - L0:C4
        \\tk: 41 at loc: L0:C4 - L0:C5
        \\tk: 61 at loc: L0:C6 - L0:C7
        \\tk: 259 at loc: L0:C8 - L0:C9
        \\tk: 43 at loc: L0:C10 - L0:C11
        \\tk: 259 at loc: L0:C12 - L0:C13
        \\tk: 59 at loc: L0:C13 - L0:C14
        \\
    },
    .{
        "T (y y) = z + q;",
        \\tk: 258 at loc: L0:C0 - L0:C1
        \\tk: 40 at loc: L0:C2 - L0:C3
        \\tk: 259 at loc: L0:C3 - L0:C4
        \\tk: 259 at loc: L0:C5 - L0:C6
        \\tk: 41 at loc: L0:C6 - L0:C7
        \\tk: 61 at loc: L0:C8 - L0:C9
        \\tk: 259 at loc: L0:C10 - L0:C11
        \\tk: 43 at loc: L0:C12 - L0:C13
        \\tk: 259 at loc: L0:C14 - L0:C15
        \\tk: 59 at loc: L0:C15 - L0:C16
        \\
    },
};

fn runScanTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    try lexer.scan_string(input);

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    var buf_writer = buf.writer();

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    while (true) {
        const tk = try lexer.yylex(&yylval, &yylloc);
        if (tk == YYLexer.YY_TERMINATED) break;
        switch (tk) {
            YYLexer.TOK_TYPE.YYEOF => {
                break;
            },
            else => |cur_tk| {
                try buf_writer.print("tk: {any} at loc: {s}\n", .{ cur_tk, yylloc });
                switch (yylval.tag) {
                    .default => {},
                    .TYPENAME => yylval.value.TYPENAME.free(allocator),
                    .ID => yylval.value.ID.free(allocator),
                    .stmt => yylval.value.stmt.free(allocator),
                    .expr => yylval.value.expr.free(allocator),
                    .decl => yylval.value.decl.free(allocator),
                    .declarator => yylval.value.declarator.free(allocator),
                }
                yylval = YYLexer.YYSTYPE.default();
            },
        }
    }

    try testing.expectEqualSlices(u8, buf.items, expected_output);
}

const parser_test_data = .{
    .{
        "z + q;",
        \\L0:C0 - L0:C6: +(z, q)
        \\
    },
};

fn runParserTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var scanner = YYLexer{ .allocator = allocator };
    try scanner.init();
    defer scanner.deinit();

    try scanner.scan_string(std.mem.trim(u8, input, &std.ascii.whitespace));

    var ast: YYParser.Ast = undefined;

    YYParser.yydebug = false;
    _ = try YYParser.yyparse(allocator, &scanner, &ast);

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    const out_writer = buf.writer();
    try out_writer.print("{s}", .{ast.loc});
    try out_writer.print(": ", .{});
    try out_writer.print("{s}", .{ast.root});
    try out_writer.print("\n", .{});
    defer ast.root.free(allocator);

    try testing.expectEqualSlices(u8, buf.items, expected_output);
}
