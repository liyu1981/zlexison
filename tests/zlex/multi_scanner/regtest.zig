const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer1 = @import("multi_scanner_1.zig").YYLexer;
const YYLexer2 = @import("multi_scanner_2.zig").YYLexer;

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("multi_scanner", multi_scanner_test_data, runMultiScannerTest);
}

const multi_scanner_test_data = .{
    .{
        \\foo on bar off
        \\on blah blah off foo on bar off
        ,
        \\result from scanner1: { 12, 12, 12, 12, 10, 13, 12, 12, 12, 12, 11 }
        \\result from scanner2: { 3, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 3, 5, 5, 5, 5, 5, 4 }
    },
};

fn runMultiScannerTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    const brkpos: usize = brk: {
        for (0..input.len) |i| {
            if (input[i] == '\n') break :brk i;
        }
        unreachable;
    };
    const input1 = input[0..brkpos];
    const input2 = input[brkpos + 1 ..];

    var yylval1 = YYLexer1.YYSTYPE.default();
    var yylloc1 = YYLexer1.YYLTYPE{};
    var lexer1 = YYLexer1{ .allocator = allocator };
    try lexer1.init();
    defer lexer1.deinit();
    var ret_buf1 = std.ArrayList(usize).init(allocator);
    defer ret_buf1.deinit();

    var yylval2 = YYLexer2.YYSTYPE.default();
    var yylloc2 = YYLexer2.YYLTYPE{};
    var lexer2 = YYLexer2{ .allocator = allocator };
    try lexer2.init();
    defer lexer2.deinit();
    var ret_buf2 = std.ArrayList(usize).init(allocator);
    defer ret_buf2.deinit();

    try lexer1.scan_string(input1);
    try lexer2.scan_string(input2);

    var tk1: usize = 0;
    var tk2: usize = 0;
    while (true) {
        if (tk1 != YYLexer1.YY_TERMINATED) {
            tk1 = try lexer1.yylex(&yylval1, &yylloc1);
            if (tk1 != YYLexer1.YY_TERMINATED) {
                try ret_buf1.append(tk1);
            }
        }
        if (tk2 != YYLexer2.YY_TERMINATED) {
            tk2 = try lexer2.yylex(&yylval2, &yylloc2);
            if (tk2 != YYLexer2.YY_TERMINATED) {
                try ret_buf2.append(tk2);
            }
        }
        if (tk1 == YYLexer1.YY_TERMINATED and tk2 == YYLexer2.YY_TERMINATED) {
            break;
        }
    }

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    try buf.writer().print("result from scanner1: {any}\nresult from scanner2: {any}", .{ ret_buf1.items, ret_buf2.items });

    try testing.expectEqualSlices(u8, buf.items, expected_output);
}
