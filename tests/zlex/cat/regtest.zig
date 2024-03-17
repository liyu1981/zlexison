const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("cat.zig");
const tmpfile = @import("../../utils/tmpfile.zig");

fn createTmpFiles(allocator: std.mem.Allocator, contents: []const []const u8) ![]tmpfile.TmpFile {
    var tmp_dir = try tmpfile.tmpDirOwned(.{});
    errdefer tmp_dir.deinit();
    const tmp_files: []tmpfile.TmpFile = try allocator.alloc(tmpfile.TmpFile, contents.len);
    errdefer allocator.free(tmp_files);
    for (0..contents.len) |i| {
        tmp_files[i] = try tmpfile.tmpFile(.{ .tmp_dir = tmp_dir });
        errdefer tmp_files[i].deinit();
        try tmp_files[i].f.writeAll(contents[i]);
    }
    return tmp_files;
}

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("cat", cat_test_data, runCatTest);
}

const cat_test_data = .{
    .{
        \\test data, line 1
        ,
        \\test data, line 2
    },
};

fn runCatTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc_param: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    var output_buf = std.ArrayList(u8).init(allocator);
    defer output_buf.deinit();

    lexer.yyg.yyout_r = .{ .buf = &output_buf };

    // prepare 2 tmp files
    var tmp_files = try createTmpFiles(allocator, &[_][]const u8{ input, expected_output });
    var tmp_dir = tmp_files[0].tmp_dir;
    defer tmp_dir.deinit();
    defer {
        for (0..tmp_files.len) |i| tmp_files[i].deinit();
        allocator.free(tmp_files);
    }

    var names_buf: [3]std.ArrayList(u8) = undefined;
    for (0..3) |i| {
        names_buf[i] = std.ArrayList(u8).init(allocator);
    }
    defer {
        for (0..3) |i| names_buf[i].deinit();
    }

    try names_buf[1].writer().print("{s}/{s}/{s}", .{ tmp_files[0].tmp_dir.parent_dir_path, tmp_files[0].tmp_dir.sub_path, tmp_files[0].sub_path });
    try names_buf[2].writer().print("{s}/{s}/{s}", .{ tmp_files[1].tmp_dir.parent_dir_path, tmp_files[1].tmp_dir.sub_path, tmp_files[1].sub_path });

    YYLexer.names = &[_][]u8{ names_buf[0].items, names_buf[1].items, names_buf[2].items };

    lexer.yyg.yyin_r = try std.fs.openFileAbsolute(YYLexer.names[1], .{});

    _ = try lexer.yylex(&yylval_param, &yylloc_param);

    var result_buf = std.ArrayList(u8).init(allocator);
    defer result_buf.deinit();
    try result_buf.writer().print("{s}{s}", .{ input, expected_output });

    try testing.expectEqualSlices(u8, output_buf.items, result_buf.items);
}
