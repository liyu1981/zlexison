%{
pub const TOK_TYPE = @import("parser_type.zig").TOK_TYPE;
pub const TOK = @import("parser_type.zig").TOK;

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

"+"      { return @intFromEnum(TOK_TYPE.TOK_PLUS); }
"-"      { return @intFromEnum(TOK_TYPE.TOK_MINUS); }
"*"      { return @intFromEnum(TOK_TYPE.TOK_STAR); }
"/"      { return @intFromEnum(TOK_TYPE.TOK_SLASH); }

"("      {
    context.nesting += 1;
    context.str.clearAndFree();
    BEGIN(SC_STRING, yyg);
  }

[0-9]+   {
    // Scan an integer.
    const intval = try std.fmt.parseInt(i64, yyget_text(yyg), 10);
    yylval.TOK_NUM = @intCast(intval);
    return @intFromEnum(TOK_TYPE.TOK_NUM);
  }

[ \t]+   {}

"\n"     { return @intFromEnum(TOK_TYPE.TOK_EOL); }

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
            yylval.TOK_STR = context.str.items[0..];
            return @intFromEnum(TOK_TYPE.TOK_STR);
        }
    } else {
        try context.str.appendSlice(yyget_text(yyg));
    }
  }

<SC_STRING>[^()]+  { try context.str.appendSlice(yyget_text(yyg)); }

<<EOF>>  { return @intFromEnum(TOK_TYPE.TOK_EOF); }

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

    var yylval_param: YYLexer.YYSTYPE = .{};
    _ = &yylval_param;
    var yylloc_param: YYLexer.YYLTYPE = .{};
    _ = &yylval_param;

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };
    YYLexer.context = YYLexer.Context.init(allocator);
    defer YYLexer.context.deinit();

    try YYLexer.yylex_init(&lexer);
    defer YYLexer.yylex_destroy(&lexer);

    _ = try YYLexer.yy_scan_string(content, lexer.yyg);

    while (true) {
        const tk = lexer.yylex(&yylval_param, &yylloc_param) catch |err| {
            std.debug.print("{any}\n", .{err});
            return 1;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
        switch (context.cur_tok) {
            .TOK_EOF => {
                break;
            },
            else => |cur_tk| {
                try stdout_writer.print("tk: {any}\n", .{cur_tk});
            },
        }
    }

    return 0;
}
