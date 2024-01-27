/* Disable Flex features we don't need, to avoid warnings. */
/* %option nodefault noinput nounput noyywrap */

/* zlex default assume reentrant */
/* %option reentrant */

%{
pub const Context = struct {
    pub const TOK_TYPE = enum(u32) {
        TOK_PLUS,
        TOK_MINUS,
        TOK_STAR,
        TOK_SLASH,
        TOK_EOF,
        TOK_NUM,
        TOK_STR,
    };

    pub const TOK = union(TOK_TYPE) {
        TOK_PLUS: u8,
        TOK_MINUS: u8,
        TOK_STAR: u8,
        TOK_SLASH: u8,
        TOK_EOF : u8,
        TOK_NUM : i64,
        TOK_STR : []const u8,
    };

    allocator: std.mem.Allocator,
    nesting: usize = 0,
    str: std.ArrayList(u8),
    cur_tok: TOK = undefined,

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
%}

%x SC_STRING

%%

"+"      { parser.context.cur_tok = .{ .TOK_PLUS = '+' }; }
"-"      { parser.context.cur_tok = .{ .TOK_MINUS = '-' }; }
"*"      { parser.context.cur_tok = .{ .TOK_STAR = '*' }; }
"/"      { parser.context.cur_tok = .{ .TOK_SLASH = '/' }; }

"("      {
    parser.context.nesting += 1;
    parser.context.str.clearAndFree();
    parser.startCondition.BEGIN(SC_SC_STRING);
    try ZA.CONTINUE();
  }

[0-9]+   {
    // Scan an integer.
    const intval = try std.fmt.parseInt(i64, parser.yy.text[0..parser.yy.leng], 10);
    parser.context.cur_tok = .{ .TOK_NUM = intval };
  }

[ \t]+   {
    _ = parser;
    // Ignore white spaces.
    try ZA.CONTINUE();
  }

"\n"     { parser.context.cur_tok = .{ .TOK_EOF = 'e' }; }

.        {
    std.io.getStdErr().writer().print("syntax error, invalid character: {c} at line: {d}, column: {d}.\n", .{ parser.yy.text[0], ZA.yyget_lineno(), ZA.yyget_column() }) catch |err| { return err; };
    return error.SyntaxError;
  }

<SC_STRING>"("+   {
    parser.context.nesting += parser.yy.leng;
    try parser.context.str.appendSlice(parser.yy.text[0..parser.yy.leng]);
    try ZA.CONTINUE();
  }

<SC_STRING>")"    {
    parser.context.nesting -= 1;
    if (parser.context.nesting == 0) {
        parser.startCondition.BEGIN(SC_INITIAL);
        if (parser.context.str.items.len > 0) {
            parser.context.cur_tok = .{ .TOK_STR = parser.context.str.items[0..] };
        }
    } else {
        try parser.context.str.appendSlice(parser.yy.text[0..parser.yy.leng]);
        try ZA.CONTINUE();
    }
  }

<SC_STRING>[^()]+  { try parser.context.str.appendSlice(parser.yy.text[0..parser.yy.leng]);
    try ZA.CONTINUE();
  }

<<EOF>>  { parser.context.cur_tok = .{ .TOK_EOF = 'e' }; }

%%

/* Epilogue (C code). */
