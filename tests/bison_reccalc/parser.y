// Prologue (directives).
%expect 0

// Emitted in the header file, before the definition of YYSTYPE.
%code requires
{
  const YYLexer = @import("scan.zig");

  pub const Result = struct {
    // Whether to print the intermediate results.
    verbose: bool,
    // Value of the last computation.
    value: i64,
    // Number of errors.
    nerrs: usize,
  };
}

// Emitted in the header file, after the definition of YYSTYPE.
%code provides
{
}

// Emitted on top of the implementation file.
%code top
{
}

%code
{
}

// Include the header in the implementation rather than duplicating it.
// %define api.header.include {"parse.h"}

// Don't share global variables between the scanner and the parser.
%define api.pure full

// To avoid name clashes (e.g., with C's EOF) prefix token definitions
// with TOK_ (e.g., TOK_EOF).
%define api.token.prefix {TOK_}

// Generate YYSTYPE from the types assigned to symbols.
%define api.value.type union

// Error messages with "unexpected XXX, expected XXX...".
%define parse.error detailed

// Enable run-time traces (yydebug).
%define parse.trace

%define api.location.type {YYLexer.YYLTYPE}

// Generate the parser description file (parse.output).
%verbose

// Scanner and error count are exchanged between main, yyparse and yylex.
%param {scanner: *YYLexer}{res: *Result}

%token
  PLUS   "+"
  MINUS  "-"
  STAR   "*"
  SLASH  "/"
  EOL    "end-of-line"
  EOF 0  "end-of-file"
;

%token <c_int> NUM "number"
%type <c_int> exp
%printer { try yyo.writer().print("{d}", $$); } <c_int>

%token <[]const u8> STR "string"
%printer { try yyo.writer().print("{s}", $$); } <[]const u8>
%destructor { allocator.free($$); } <[]const u8>

// Precedence (from lowest to highest) and associativity.
%left "+" "-"
%left "*" "/"
%precedence UNARY

%%
// Rules.
input:
  line
| input line
;

line:
  exp eol
    {
      yyctx.res.value = $exp;
      if (yyctx.res.verbose) {
        std.debug.print("{d}\n", .{$exp});
      }
    }
| error eol
    {
      std.debug.print("yyerrok!", .{});
    }
;

eol:
  EOF
| EOL
;

exp:
  NUM           { $$ = $1; }
| exp "+" exp   { $$ = $1 + $3; }
| exp "-" exp   { $$ = $1 - $3; }
| exp "*" exp   { $$ = $1 * $3; }
| exp "/" exp
  {
    if ($3 == 0)
      {
        std.debug.print("invalid division by zero", .{});
        unreachable;
      }
    else
      $$ = $1 / $3;
  }
| "+" exp %prec UNARY  { $$ = $2; }
| "-" exp %prec UNARY  { $$ = -$2; }
| STR
  {
    const int_value = try std.fmt.parseInt(c_int, $1, 10);
    allocator.free($1);
    $$ = int_value;
  }
;

%%

pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    var aa = std.heap.ArenaAllocator(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    YYParser.allocator = allocator;
    yydebug = true;
    var res: Result = Result{};

    var scanner = YYLexer{ .allocator = arena };
    YYLexer.context = YYLexer.Context.init(arena);
    defer YYLexer.context.deinit();

    try YYLexer.yylex_init(&scanner);
    defer YYLexer.yylex_destroy(&scanner);

    try YYParser.yyparse(&scanner, &res);

    std.debug.print("{any}\n", .{res});
}
