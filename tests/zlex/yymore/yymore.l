%{
// yymore.lex: An example of using yymore()
//             to good effect.

pub var yyerr_buf: ?std.ArrayList(u8) = null;

pub fn yyerror(comptime fmt: []const u8, comptime tuple: anytype) !void {
    if (yyerr_buf) |*buf| {
        try buf.writer().print(fmt, tuple);
    } else {
        std.debug.print(fmt, tuple);
    }
}

%}

%x STRING

%%
\"   BEGIN(STRING, yyg);

<STRING>[^\\\n"]*  yymore(yyg);
<STRING><<EOF>>    try yyerror("EOF in string.", .{});       BEGIN(INITIAL, yyg);
<STRING>\n         try yyerror("Unterminated string.", .{}); BEGIN(INITIAL, yyg);
<STRING>\\\n       yymore(yyg);
<STRING>\"  {
                const t = yyget_text(yyg);
                // t includes the " matched, so when print, exclude it
                switch(yyg.yyout_r) {
                    .buf => |b| try b.writer().print("string = \"{s}\"", .{t[0..t.len-1]}),
                    .file => |f| try f.writer().print("string = \"{s}\"", .{t[0..t.len-1]}),
                }
                BEGIN(INITIAL, yyg);
            }
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

    _ = lexer.yylex(&yylval, &yylloc) catch |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    };

    return 0;
}
