const std = @import("std");
const testing = std.testing;
const YYLexer = @import("pthread.zig");

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("pthread", pthread_test_data, runPthreadTest);
}

const pthread_test_data = .{
    .{
        \\ line 1
        \\ line 2
        ,
        \\From thread 1: # of lines = 1, # of chars = 15
        \\From thread 2: # of lines = 2, # of chars = 16
        \\
    },
};

// YYLexer in zig default is reentrant so it is ok to use in thread
// the exception is configuration like YY_EXTRA_TYPE/YY_USER_INIT

// the key is to create multiple copies of YYLexer definition
// use unique YYLEXER_DEFID to make the def really different
// lexer type 1 will be used in thread 1 and will start from line 0 and char 0
const MyYYLexer1 = YYLexer.defineYYLexer(.{ .YYLEXER_DEFID = "myyylexer1", .YY_EXTRA_TYPE = Counter });

// lexer type 2 will be used in thread 2 and will start from line 1 and char 1 (with user init startFrom1)
const MyYYLexer2 = YYLexer.defineYYLexer(.{ .YYLEXER_DEFID = "myyylexer2", .YY_EXTRA_TYPE = Counter });

// counter start from 0
const Counter = struct {
    num_lines: usize = 0,
    num_chars: usize = 0,
};

fn startFrom1(this: *MyYYLexer2) anyerror!void {
    // set counter start from line 1 and char 1
    this.yyg.yyextra_r = .{ .num_lines = 1, .num_chars = 1 };
}

fn thread1fn(input: []const u8, buf: *std.ArrayList(u8)) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
        _ = gpa.deinit();
    }

    var lexer = MyYYLexer1{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    var yylval: MyYYLexer1.YYSTYPE = MyYYLexer1.YYSTYPE.default();
    var yylloc: MyYYLexer1.YYLTYPE = .{};
    lexer.yyg.yyextra_r = .{};
    try lexer.scan_string(input);
    _ = try lexer.yylex(&yylval, &yylloc);
    try buf.writer().print("From thread 1: # of lines = {d}, # of chars = {d}\n", .{
        lexer.yyg.yyextra_r.num_lines,
        lexer.yyg.yyextra_r.num_chars,
    });
}

fn thread2fn(input: []const u8, buf: *std.ArrayList(u8)) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
        _ = gpa.deinit();
    }

    // use a different user init to set line and char start from 1
    MyYYLexer2.YY_USER_INIT = startFrom1;

    var lexer = MyYYLexer2{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    var yylval: MyYYLexer2.YYSTYPE = MyYYLexer2.YYSTYPE.default();
    var yylloc: MyYYLexer2.YYLTYPE = .{};
    lexer.yyg.yyextra_r = .{};
    try lexer.scan_string(input);
    _ = try lexer.yylex(&yylval, &yylloc);
    try buf.writer().print("From thread 2: # of lines = {d}, # of chars = {d}\n", .{
        lexer.yyg.yyextra_r.num_lines,
        lexer.yyg.yyextra_r.num_chars,
    });
}

fn runPthreadTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    try testing.expect(!(MyYYLexer1 == MyYYLexer2));

    var buf1 = try std.ArrayList(u8).initCapacity(allocator, 1024);
    defer buf1.deinit();
    var buf2 = try std.ArrayList(u8).initCapacity(allocator, 1024);
    defer buf2.deinit();

    const t1 = try std.Thread.spawn(.{}, thread1fn, .{ input, &buf1 });
    const t2 = try std.Thread.spawn(.{}, thread2fn, .{ input, &buf2 });
    t1.join();
    t2.join();

    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    try buf.writer().print("{s}{s}", .{ buf1.items, buf2.items });

    try testing.expectEqualSlices(u8, buf.items, expected_output);
}
