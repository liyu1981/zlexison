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
        TOK_NUM,
        TOK_STR,
        TOK_EOL,
    };

    pub const TOK = union(TOK_TYPE) {
        TOK_PLUS: u8,
        TOK_MINUS: u8,
        TOK_STAR: u8,
        TOK_SLASH: u8,
        TOK_EOL : u8,
        TOK_NUM : i64,
        TOK_STR : []const u8,
    };

    nesting: usize = 0,
    str: std.ArrayList(u8),
    cur_tok: TOK = undefined,

    pub fn init() Context {
      return Context{
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

"+"      { parser.context.cur_tok = .{ .TOK_PLUS = '+' }; return 0; }
"-"      { parser.context.cur_tok = .{ .TOK_MINUS = '-' }; return 0; }
"*"      { parser.context.cur_tok = .{ .TOK_STAR = '*' }; return 0; }
"/"      { parser.context.cur_tok = .{ .TOK_SLASH = '/' }; return 0; }

"("      {
    parser.context.nesting += 1;
    parser.context.str.clearAndFree();
    parser.startCondition.BEGIN(Parser.StartCondition.SC_STRING);
  }

 /* Scan an integer.  */
[0-9]+   {
    const intval = try std.fmt.parseInt(i64, parser.yy.text[0..parser.YY.leng], 10);
    parser.context.cur_tok = .{ .TOK_NUM = intval };
    return 0;
  }

 /* Ignore white spaces. */
[ \t]+   { }

"\n"     { parser.context.cur_tok = .{ .TOK_EOL = 'e' }; return 0; }

.        {
    std.io.getStdErr().writer().print("syntax error, invalid character: {c} at line: {d}, column: {d}.\n", .{ parser.YY.text[0], parser.ZA.yyget_lineno(), parser.ZA.yyget_column() }) catch |err| { return err };
    return error.SyntaxError;
  }

<SC_STRING>"("+   {
    parser.context.nesting += parser.yy.leng;
    parser.context.str.appendSlice(parser.yy.text[0..parser.yy.leng]);
  }

<SC_STRING>")"    {
    parser.context.nesting -= 1;
    if (parser.context.nesting == 0) {
        parser.startCondition.BEGIN(Parser.StartCondition.INITIAL);
        if (parser.context.str.items.len > 0) {
            parser.context.cur_tok = .{ .TOK_STR = parser.context.str.items[0..] };
            return 0;
        }
    } else {
        parser.context.str.appendSlice(parser.yy.text[0..parser.yy.leng]);
    }
  }

<SC_STRING>[^()]+  { parser.context.str.appendSlice(parser.yy.text[0..parser.yy.leng]); }

<<EOF>>  { return TOK.TOK_EOF; }

%%

/* Epilogue (C code). */
