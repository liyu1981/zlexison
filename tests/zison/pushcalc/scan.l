%{
%}

%%

"+"      { return '+'; }
"-"      { return '-'; }
"*"      { return '*'; }
"/"      { return '/'; }

[0-9]+   {
    // Scan an integer.
    const intval = try std.fmt.parseInt(i64, yyget_text(yyg), 10);
    yylval_.* = .{ .tag = .NUM, .value = .{ .NUM = @as(f64, @floatFromInt(intval)) } };
    return TOK_TYPE.NUM;
  }

\.[0-9]+ {
    // Scan an float like .123
    const floatval = try std.fmt.parseFloat(f64, yyget_text(yyg));
    yylval_.* = .{ .tag = .NUM, .value = .{ .NUM = floatval } };
    return TOK_TYPE.NUM;
  }

[0-9]+\.[0-9]+ {
    // Scan an float like 1.23
    const floatval = try std.fmt.parseFloat(f64, yyget_text(yyg));
    yylval_.* = .{ .tag = .NUM, .value = .{ .NUM = floatval } };
    return TOK_TYPE.NUM;
  }

[ \t]+   {}

\n { return '\n'; }

.        {
    std.io.getStdErr().writer().print(
      "syntax error, invalid character: {c} at line: {d}, column: {d}.\n",
      .{ yyg.yytext_r[0], yyget_lineno(yyg), yyget_column(yyg) },
    ) catch |err| { return err; };
    return error.SyntaxError;
  }

<<EOF>>  { return TOK_TYPE.YYEOF; }

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
    var yylloc: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };

    try lexer.init();
    defer lexer.deinit();

    try lexer.scan_string(content);

    while (true) {
        const tk = lexer.yylex(&yylval, &yylloc) catch |err| {
            std.debug.print("{any}\n", .{err});
            return 1;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
        switch (tk) {
            YYLexer.TOK_TYPE.YYEOF => {
                break;
            },
            else => |cur_tk| {
                try stdout_writer.print("tk: {any} at loc: {s}\n", .{ cur_tk, yylloc });
            },
        }
    }

    return 0;
}
