%option reject
%option yymore
%option unput
%option stack
%option bison-bridge
%option bison-locations

%{
var num_lines: usize = 0;
var num_chars: usize = 0;
%}

%%

\n      { num_lines += 1; num_chars += 1; }
.       { num_chars += 1; }
%%

pub fn main() !u8 {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    defer allocator.free(args);

    var f = try std.fs.cwd().openFile(args[1], .{});
    defer f.close();

    const content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(content);

    var yylval_param: YYLexer.YYSTYPE = .{};
    _ = &yylval_param;
    var yylloc_param: YYLexer.YYLTYPE = .{};
    _ = &yylval_param;

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };

    try yylex_init(&lexer);
    defer yylex_destroy(&lexer);

    _ = try yy_scan_string(content, lexer.yyg);

    while (true) {
        const tk = lexer.yylex(&yylval_param, &yylloc_param) catch |err| {
            std.debug.print("{any}\n", .{err});
            break;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
    }
    std.debug.print("# of lines = {d}, # of chars = {d}\n", .{
        num_lines,
        num_chars,
    });
    return 0;
}
