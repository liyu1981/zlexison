%{
    // This example demos how to use YY_USER_EXTRA
    // another way of implement zlex/simple
%}

%%

\n      { yyg.yyextra_r.num_lines += 1; yyg.yyextra_r.num_chars += 1; }
.       { yyg.yyextra_r.num_chars += 1; }
%%

const Counter = struct {
    num_lines: usize = 0,
    num_chars: usize = 0,
};

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    var f = try std.fs.cwd().openFile(args[1], .{});
    defer f.close();

    const content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(content);

    // here we define a YYLexer type knows about our Counter type as extra
    const MyYYLexer = defineYYLexer(.{ .YY_EXTRA_TYPE = Counter });

    var yylval_param: MyYYLexer.YYSTYPE = MyYYLexer.YYSTYPE.default();
    var yylloc_param: MyYYLexer.YYLTYPE = .{};

    var lexer = MyYYLexer{ .allocator = allocator };

    // init our extra data, remember that its type is Counter
    lexer.yyg.yyextra_r = .{};

    try lexer.init();
    defer lexer.deinit();

    try lexer.scan_string(content);

    while (true) {
        const tk = lexer.yylex(&yylval_param, &yylloc_param) catch |err| {
            std.debug.print("{any}\n", .{err});
            break;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
    }
    std.debug.print("# of lines = {d}, # of chars = {d}\n", .{
        lexer.yyg.yyextra_r.num_lines,
        lexer.yyg.yyextra_r.num_chars,
    });
    return 0;
}
