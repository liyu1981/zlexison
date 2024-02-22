%{
const Symrec = @import("zlexison.zig").Symrec;
%}

%%

\.[0-9]+ {
    const fval = try std.fmt.parseFloat(f64, yyget_text(yyg));
    yyset_lval(YYSTYPE{ .NUM = fval }, yyg);
    return @intFromEnum(TOK_TYPE.NUM);
  }

[0-9]+(\.[0-9]+)* {
    const fval = try std.fmt.parseFloat(f64, yyget_text(yyg));
    yyset_lval(YYSTYPE{ .NUM = fval }, yyg);
    return @intFromEnum(TOK_TYPE.NUM);
  }

[a-zA-Z][a-zA-Z0-9]* {
    var s = try Symrec.init(yyg.lexer_.allocator);
    s.type = .VAR;
    s.name = yyget_text(yyg);
    yyset_lval(YYSTYPE{ .VAR = s }, yyg);
    return @intFromEnum(TOK_TYPE.VAR);
  }

[ \t]+   {}

"\n"     { return '\n'; }

.        { return yyget_text(yyg)[0]; }

<<EOF>>  { return @intFromEnum(TOK_TYPE.YYEOF); }

%%

pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    const allocator = std.heap.page_allocator;

    const stdout_writer = std.io.getStdOut().writer();

    var f: std.fs.File = brk: {
        if (args.len > 1) {
            break :brk try std.fs.cwd().openFile(args[1], .{});
        } else {
            break :brk std.io.getStdIn();
        }
    };
    defer f.close();

    var content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(content);
    _ = &content;
    try stdout_writer.print("read {d}bytes\n", .{content.len});

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    _ = &yylval;
    var yylloc: YYLexer.YYLTYPE = .{};
    _ = &yylloc;

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };

    try YYLexer.yylex_init(&lexer);
    defer YYLexer.yylex_destroy(&lexer);

    _ = try YYLexer.yy_scan_string(content, lexer.yyg);

    while (true) {
        const tk = lexer.yylex(&yylval, &yylloc) catch |err| {
            std.debug.print("{any}\n", .{err});
            return 1;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
        switch (tk) {
            @as(usize, @intFromEnum(TOK_TYPE.YYEOF)) => {
                break;
            },
            else => |cur_tk| {
                try stdout_writer.print("tk: {any} at loc: {s}\n", .{ cur_tk, yylloc });
            },
        }
    }

    return 0;
}
