%{
    // This example demos how to use YYLexer in thread
%}

%%

\n      { yyg.yyextra_r.num_lines += 1; yyg.yyextra_r.num_chars += 1; }
.       { yyg.yyextra_r.num_chars += 1; }
%%

// YYLexer in zig default is reentrant so it is ok to use in thread
// the exception is configuration like YY_EXTRA_TYPE/YY_USER_INIT

// the key is to create multiple copies of YYLexer definition
// lexer type 1 will be used in thread 1 and will start from line 0 and char 0
const MyYYLexer1 = defineYYLexer(.{ .YY_EXTRA_TYPE = Counter });

// lexer type 2 will be used in thread 2 and will start from line 1 and char 1 (with user init startFrom1)
const MyYYLexer2 = defineYYLexer(.{ .YY_EXTRA_TYPE = Counter });

// counter start from 0
const Counter = struct {
    num_lines: usize = 0,
    num_chars: usize = 0,
};

fn startFrom1(this: *MyYYLexer2) anyerror!void {
    // set counter start from line 1 and char 1
    this.yyg.yyextra_r = .{ .num_lines = 1, .num_chars = 1 };
}

fn thread1fn(lexer: *MyYYLexer1, input: []const u8) !void {
    var yylval: MyYYLexer1.YYSTYPE = MyYYLexer1.YYSTYPE.default();
    var yylloc: MyYYLexer1.YYLTYPE = .{};
    lexer.yyg.yyextra_r = .{};
    try lexer.scan_string(input);
    _ = try lexer.yylex(&yylval, &yylloc);
    std.debug.print("From thread 1: # of lines = {d}, # of chars = {d}\n", .{
        lexer.yyg.yyextra_r.num_lines,
        lexer.yyg.yyextra_r.num_chars,
    });
}

fn thread2fn(lexer: *MyYYLexer2, input: []const u8) !void {
    // use a different user init to set line and char start from 1
    MyYYLexer2.YY_USER_INIT = startFrom1;
    var yylval: MyYYLexer1.YYSTYPE = MyYYLexer1.YYSTYPE.default();
    var yylloc: MyYYLexer1.YYLTYPE = .{};
    lexer.yyg.yyextra_r = .{};
    try lexer.scan_string(input);
    _ = try lexer.yylex(&yylval, &yylloc);
    std.debug.print("From thread 2: # of lines = {d}, # of chars = {d}\n", .{
        lexer.yyg.yyextra_r.num_lines,
        lexer.yyg.yyextra_r.num_chars,
    });
}

const common_input = 
    \\ line 1
    \\ line 2
    ;

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    var lexer1 = MyYYLexer1{ .allocator = allocator };
    try lexer1.init();
    defer lexer1.deinit();
    const t1 = try std.Thread.spawn(.{}, thread1fn, .{ &lexer1, common_input });

    var lexer2 = MyYYLexer2{ .allocator = allocator };
    try lexer2.init();
    defer lexer2.deinit();
    const t2 = try std.Thread.spawn(.{}, thread2fn, .{ &lexer2, common_input });

    t1.join();
    t2.join();

    return 0;
}
