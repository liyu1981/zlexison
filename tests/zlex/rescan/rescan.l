%{
    // This example shows how to rescan
%}

%x STATE_1

%%

<INITIAL>{
0              try yy_push_state(STATE_1, yyg);
.|\n           return 1;
}
<STATE_1>{
1              yy_pop_state(yyg);
.|\n           return yy_top_state(yyg) + 1;
}

%%

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        _ = gpa.detectLeaks();
        _ = gpa.deinit();
    }
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if(args.len < 2) {
        std.debug.print("Usage: rescan <file>\n", .{});
        return 1;
    }

    var f = try std.fs.cwd().openFile(args[1], .{});
    defer f.close();

    std.debug.print("Test 1: Reusing same scanner.\n", .{});

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

    std.debug.print("Test 1 OK\n\n", .{});

    std.debug.print("Test 2: Rescanning with new scanner each time.\n", .{});

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

    std.debug.print("Test 2 OK\n\n", .{});

    return 0;
}
