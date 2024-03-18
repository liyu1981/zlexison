const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("dates.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("dates", dates_test_data, runDatesTest);
}

const dates_test_data = .{
    .{
        \\short
        \\1989:12:23
        \\1989:11:12
        \\23:12:1989
        \\11:12:1989
        \\1989/12/23
        \\1989/11/12
        \\23/12/1989
        \\11/12/1989
        \\1989-12-23
        \\1989-11-12
        \\23-12-1989
        \\11-12-1989
        \\
        ,
        \\Short:
        \\  Day   : 23 
        \\  Month : 12 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 12 
        \\  Month : 11 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 23 
        \\  Month : 12 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 11 
        \\  Month : 12 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 23 
        \\  Month : 12 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 12 
        \\  Month : 11 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 23 
        \\  Month : 12 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 11 
        \\  Month : 12 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 23 
        \\  Month : 12 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 12 
        \\  Month : 11 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 23 
        \\  Month : 12 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 11 
        \\  Month : 12 
        \\  Year  : 1989 
        \\
    },
    .{
        \\long
        \\Friday the 5th of January, 1989
        \\Friday, 5th of January, 1989
        \\Friday, january 5th, 1989
        \\Fri, January 5th, 1989
        \\Fri, Jan 5th, 1989
        \\fri, Jan 5, 1989
        \\FriJan 5, 1989
        \\FriJan5, 1989
        \\friJan51989
        \\Jan51989
        \\
        ,
        \\Long:
        \\  DOW   : Friday 
        \\  Day   : 5th 
        \\  Month : January 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : Friday 
        \\  Day   : 5th 
        \\  Month : January 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : Friday 
        \\  Day   : 5th 
        \\  Month : january 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : Fri 
        \\  Day   : 5th 
        \\  Month : January 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : Fri 
        \\  Day   : 5th 
        \\  Month : Jan 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : fri 
        \\  Day   : 5 
        \\  Month : Jan 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : Fri 
        \\  Day   : 5 
        \\  Month : Jan 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : Fri 
        \\  Day   : 5 
        \\  Month : Jan 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : fri 
        \\  Day   : 5 
        \\  Month : Jan 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : fri 
        \\  Day   : 5 
        \\  Month : Jan 
        \\  Year  : 1989 
        \\
    },
    .{
        \\long
        \\Friday the 5th of January, 1989
        \\short
        \\11/12/1989
        \\long
        \\fri, Jan 5, 1989
        \\
        ,
        \\Long:
        \\  DOW   : Friday 
        \\  Day   : 5th 
        \\  Month : January 
        \\  Year  : 1989 
        \\Short:
        \\  Day   : 11 
        \\  Month : 12 
        \\  Year  : 1989 
        \\Long:
        \\  DOW   : fri 
        \\  Day   : 5 
        \\  Month : Jan 
        \\  Year  : 1989 
        \\
    },
};

fn runDatesTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc_param: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    var out_buf = std.ArrayList(u8).init(allocator);
    defer out_buf.deinit();

    lexer.yyg.yyout_r = .{ .buf = &out_buf };

    try lexer.scan_string(input);

    _ = try lexer.yylex(&yylval_param, &yylloc_param);

    try testing.expectEqualSlices(u8, out_buf.items, expected_output);
}
