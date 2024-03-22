const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("rescan.zig").YYLexer;
const tmpfile = @import("../../utils/tmpfile.zig");
const rescan_data_txt = @embedFile("rescan.data.txt");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("rescan", rescan_test_data, runRescanTest);
}

const rescan_test_data = .{
    .{
        \\
        ,
        \\
    },
};

fn runRescanTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    _ = input;
    _ = expected_output;

    var output_buf = std.ArrayList(u8).init(allocator);
    defer output_buf.deinit();

    // prepare tmp file
    var tmp_file = try tmpfile.tmpFile(.{});
    try tmp_file.f.writeAll(rescan_data_txt);
    tmp_file.close();
    defer tmp_file.deinit();

    var f = try std.fs.openFileAbsolute(tmp_file.abs_path, .{});
    defer f.close();

    {
        var yylval = YYLexer.YYSTYPE.default();
        var yylloc = YYLexer.YYLTYPE{};
        var lexer = YYLexer{ .allocator = allocator };
        try lexer.init();
        defer lexer.deinit();

        for (0..4) |_| {
            try f.seekTo(0);
            YYLexer.yyset_in(f, lexer.yyg);
            while (true) {
                const tk = try lexer.yylex(&yylval, &yylloc);
                if (tk == YYLexer.YY_TERMINATED) {
                    break;
                }
            }
        }
    }

    // Test 1 Ok if reach here

    for (0..4) |_| {
        var yylval = YYLexer.YYSTYPE.default();
        var yylloc = YYLexer.YYLTYPE{};
        var lexer = YYLexer{ .allocator = allocator };
        try lexer.init();
        defer lexer.deinit();

        try f.seekTo(0);
        YYLexer.yyset_in(f, lexer.yyg);
        while (true) {
            const tk = try lexer.yylex(&yylval, &yylloc);
            if (tk == YYLexer.YY_TERMINATED) {
                break;
            }
        }
    }

    // Test 2 Ok if reach here
}
