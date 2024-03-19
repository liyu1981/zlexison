%{
pub const Context = struct {
    allocator: std.mem.Allocator,
    nesting: usize = 0,
    str: std.ArrayList(u8),

    pub fn init(allocator: std.mem.Allocator) Context {
      return Context{
        .allocator = allocator,
        .str = std.ArrayList(u8).init(std.heap.page_allocator),
      };
    }

    pub fn deinit(this: *const Context) void {
        this.str.deinit();
    }
};

pub var context: Context = undefined;
%}

%x SC_STRING

%%

"+"      { return TOK_TYPE.TOK_PLUS; }
"-"      { return TOK_TYPE.TOK_MINUS; }
"*"      { return TOK_TYPE.TOK_STAR; }
"/"      { return TOK_TYPE.TOK_SLASH; }

"("      {
    context.nesting += 1;
    context.str.clearAndFree();
    BEGIN(SC_STRING, yyg);
  }

[0-9]+   {
    // Scan an integer.
    const intval = try std.fmt.parseInt(i64, yyget_text(yyg), 10);
    yyset_lval(YYSTYPE{ .tag = .TOK_NUM, .value = .{ .TOK_NUM = @intCast(intval)} }, yyg);
    return TOK_TYPE.TOK_NUM;
  }

[ \t]+   {}

"\n"     { return TOK_TYPE.TOK_EOL; }

.        {
    std.io.getStdErr().writer().print(
      "syntax error, invalid character: {c} at line: {d}, column: {d}.\n",
      .{ yyg.yytext_r[0], yyget_lineno(yyg), yyget_column(yyg) },
    ) catch |err| { return err; };
    return error.SyntaxError;
  }

<SC_STRING>"("+   {
    context.nesting += yyget_leng(yyg);
    try context.str.appendSlice(yyget_text(yyg));
  }

<SC_STRING>")"    {
    context.nesting -= 1;
    if (context.nesting == 0) {
        BEGIN(INITIAL, yyg);
        if (context.str.items.len > 0) {
            yyset_lval(YYSTYPE{ .tag = .TOK_STR, .value = .{ .TOK_STR = &context.str.items } }, yyg);
            return TOK_TYPE.TOK_STR;
        }
    } else {
        try context.str.appendSlice(yyget_text(yyg));
    }
  }

<SC_STRING>[^()]+  { try context.str.appendSlice(yyget_text(yyg)); }

<<EOF>>  { return TOK_TYPE.TOK_EOF; }

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
    YYLexer.context = YYLexer.Context.init(allocator);
    defer YYLexer.context.deinit();

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
            YYLexer.TOK_TYPE.TOK_EOF => {
                break;
            },
            else => |cur_tk| {
                try stdout_writer.print("tk: {any} at loc: {s}\n", .{ cur_tk, yylloc });
            },
        }
    }

    return 0;
}
