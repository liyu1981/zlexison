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
    yyset_lval(YYSTYPE{.TOK_NUM = @intCast(intval)}, yyg);
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
            yyset_lval(YYSTYPE{.TOK_STR = context.str.items[0..]}, yyg);
            return @intFromEnum(TOK_TYPE.TOK_STR);
        }
    } else {
        try context.str.appendSlice(yyget_text(yyg));
    }
  }

<SC_STRING>[^()]+  { try context.str.appendSlice(yyget_text(yyg)); }

<<EOF>>  { return @intFromEnum(TOK_TYPE.TOK_EOF); }

%%
