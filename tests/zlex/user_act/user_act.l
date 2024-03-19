%{
// This example demos how to use YY_USER_ACTION in zlex

pub fn user_action(lexer: *YYLexer) anyerror!void {
    const yyg = lexer.yyg;
    for (0..yyg.yyleng_r) |i| {
        if (std.ascii.isLower(yyg.yytext_r[i])) {
            yyg.yytext_r[i] = std.ascii.toUpper(yyg.yytext_r[i]);
        }
    }
}
%}

%%

.*         try ECHO(yyg);
\n         try ECHO(yyg);

%%

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    // this is how to use custom user_action instead of default one
    YYLexer.YY_USER_ACTION = YYLexer.user_action;

    YYLexer.yydebug = true;

    _ = lexer.yylex(&yylval, &yylloc) catch |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    };

    return 0;
}
