const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("string1.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("string1", string1_test_data, runString1Test);
}

const string1_test_data = .{
    .{
        \\"This is a string"
        ,
        \\String = "This is a string"
        \\
    },
    .{
        \\"The next string will be empty"
        ,
        \\String = "The next string will be empty"
        \\
    },
    .{
        \\""
        ,
        \\String = ""
        \\
    },
    .{
        \\ "This is a string with a \b(\\b) in it"
        ,
        \\String = "This is a string with a b(\b) in it"
        \\
    },
    .{
        \\"This is a string with a \t(\\t) in it"
        ,
        \\String = "This is a string with a t(\t) in it"
        \\
    },
    .{
        \\"This is a string with a \n(\\n) in it"
        ,
        \\String = "This is a string with a n(\n) in it"
        \\
    },
    .{
        \\"This is a string with a \v(\\v) in it"
        ,
        \\String = "This is a string with a v(\v) in it"
        \\
    },
    .{
        \\"This is a string with a \f(\\f) in it"
        ,
        \\String = "This is a string with a f(\f) in it"
        \\
    },
    .{
        \\"This is a string with a \r(\\r) in it"
        ,
        \\String = "This is a string with a r(\r) in it"
        \\
    },
    .{
        \\"This is a string with a \"(\\\") in it"
        ,
        \\String = "This is a string with a "(\") in it"
        \\
    },
    .{
        \\"This is a string with a \z(\\z) in it"
        ,
        \\String = "This is a string with a z(\z) in it"
        \\
    },
    .{
        \\"This is a string with a \X4a(\\X4a) in it"
        ,
        \\String = "This is a string with a J(\X4a) in it"
        \\
    },
    .{
        \\"This is a string with a \x4a(\\x4a) in it"
        ,
        \\String = "This is a string with a J(\x4a) in it"
        \\
    },
    .{
        \\"This is a string with a \x7(\\x7) in it"
        ,
        \\String = "This is a string with a 
        ++ [_]u8{7} ++
            \\(\x7) in it"
            \\
    },
    .{
        \\"This is a string with a \112(\\112) in it"
        ,
        \\String = "This is a string with a J(\112) in it"
        \\
    },
    .{
        \\"This is a string with a \043(\\043) in it"
        ,
        \\String = "This is a string with a #(\043) in it"
        \\
    },
    .{
        \\"This is a string with a \7(\\7) in it"
        ,
        \\String = "This is a string with a 
        ++ [_]u8{7} ++
            \\(\7) in it"
            \\
    },
    .{
        \\"This is a multi-line \
        \\string"
        ,
        \\String = "This is a multi-line string"
        \\
    },
    .{
        \\"This is an unterminated string
        \\
        ,
        \\Unterminated string.
    },
    .{
        \\"This is an unterminated string too
        \\
        ,
        \\Unterminated string.
    },
};

fn runString1Test(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc_param: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    var output_buf = std.ArrayList(u8).init(allocator);
    defer output_buf.deinit();

    lexer.yyg.yyout_r = .{ .buf = &output_buf };

    try lexer.scan_string(input);

    YYLexer.err_buf = std.ArrayList(u8).init(allocator);
    defer YYLexer.err_buf.?.deinit();

    var with_error: ?anyerror = null;
    _ = lexer.yylex(&yylval_param, &yylloc_param) catch |err| {
        with_error = err;
    };

    if (with_error) |err| {
        try testing.expectEqual(err, error.yyerror);
        try testing.expectEqualSlices(u8, YYLexer.err_buf.?.items, expected_output);
    } else {
        try testing.expectEqualSlices(u8, output_buf.items, expected_output);
    }
}
