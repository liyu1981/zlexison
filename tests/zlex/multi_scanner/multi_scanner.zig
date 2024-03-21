const std = @import("std");
const testing = std.testing;
const YYLexer1 = @import("multi_scanner_1.zig").YYLexer;
const YYLexer2 = @import("multi_scanner_2.zig").YYLexer;

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        _ = gpa.detectLeaks();
        _ = gpa.deinit();
    }
    const allocator = gpa.allocator();

    const content = try std.io.getStdIn().readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(content);

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

    try lexer1.scan_string(content);
    try lexer2.scan_string(content);

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

    std.debug.print("result from scanner1: {any}\n", .{ret_buf1.items});
    std.debug.print("result from scanner2: {any}\n", .{ret_buf2.items});

    return 0;
}
