const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("eof_rules.zig");
const tmpfile = @import("../../utils/tmpfile.zig");
const eof_test01 = @embedFile("eof_test01.txt");
const eof_test02 = @embedFile("eof_test02.txt");
const eof_test03 = @embedFile("eof_test03.txt");
const eof_expected_output = @embedFile("expected_output.txt");

fn createTestData() !*tmpfile.TmpDir {
    const tmp_dir = try tmpfile.tmpDirOwned(.{});
    var e1 = try tmp_dir.dir.createFile("eof_test01.txt", .{});
    defer e1.close();
    try e1.writeAll(eof_test01);
    var e2 = try tmp_dir.dir.createFile("eof_test02.txt", .{});
    defer e2.close();
    try e2.writeAll(eof_test02);
    var e3 = try tmp_dir.dir.createFile("eof_test03.txt", .{});
    defer e3.close();
    try e3.writeAll(eof_test03);
    return tmp_dir;
}

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("cat", eof_rules_test_data, runEofRulesTest);
}

const eof_rules_test_data = .{
    .{
        \\
        ,
        eof_expected_output,
    },
};

fn runEofRulesTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    _ = input;

    var output_buf = std.ArrayList(u8).init(allocator);
    defer output_buf.deinit();

    // prepare test data
    var tmp_dir = try createTestData();
    defer tmp_dir.deinit();

    var cur_dir_buf: [8192]u8 = undefined;
    const cur_dir = try std.process.getCwd(&cur_dir_buf);

    try std.os.chdir(tmp_dir.abs_path);
    defer std.os.chdir(cur_dir) catch {
        @panic("can not restore cwd");
    };

    var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc_param: YYLexer.YYLTYPE = .{};

    @memset(&YYLexer.include_stack, @ptrFromInt(0));

    var scanner = YYLexer{ .allocator = allocator };
    try scanner.init();
    defer scanner.deinit();

    scanner.yyg.yyout_r = .{ .buf = &output_buf };

    scanner.yyg.yyin_r = try std.fs.cwd().openFile("eof_test01.txt", .{});

    _ = try scanner.yylex(&yylval_param, &yylloc_param);

    try testing.expectEqualSlices(u8, output_buf.items, expected_output);
}
