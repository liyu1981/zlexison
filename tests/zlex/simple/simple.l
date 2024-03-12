%option reject
%option yymore
%option unput
%option stack
%option bison-bridge
%option bison-locations

%{
pub var num_lines: usize = 0;
pub var num_chars: usize = 0;
%}

%%

\n      { num_lines += 1; num_chars += 1; }
.       { num_chars += 1; }
%%

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

    var yylval_param: YYSTYPE = YYSTYPE.default();
    var yylloc_param: YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };

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
        num_lines,
        num_chars,
    });
    return 0;
}
