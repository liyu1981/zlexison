// Prologue (directives).
%expect 0

// Emitted in the header file, before the definition of YYSTYPE.
%code requires
{
  // need to build with: ../../zig-out/bin/zison zbison --locations --no-lines -o parser.zig parser.y
  const YYLexer = @import("scan.zig");

  pub const Result = struct {
    // Whether to print the intermediate results.
    verbose: bool = true,
    // Value of the last computation.
    value: c_int = -1,
    // Number of errors.
    nerrs: usize = 0,
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
// we do not use this in zig
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
%printer { try yyo.writer().print("{d}", .{$$}); } <c_int>

%token <[]const u8> STR "string"
%printer { try yyo.writer().print("{s}", .{$$}); } <[]const u8>

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
    else {
      $$ = @divTrunc($1, $3);
    }
  }
| "+" exp %prec UNARY  { $$ = $2; }
| "-" exp %prec UNARY  { $$ = -$2; }
| STR
  {
    defer yyctx.allocator.free($1);
    const input_with_newline = try std.fmt.allocPrint(yyctx.allocator, "{s}\n", .{$1});
    defer yyctx.allocator.free(input_with_newline);
    var res: Result = Result{};
    var new_scanner = YYLexer{ .allocator = yyctx.allocator };
    YYLexer.context = YYLexer.Context.init(yyctx.allocator);
    defer YYLexer.context.deinit();
    try YYLexer.yylex_init(&new_scanner);
    defer YYLexer.yylex_destroy(&new_scanner);
    _ = try YYLexer.yy_scan_string(input_with_newline, new_scanner.yyg);
    _ = try YYParser.yyparse(yyctx.allocator, &new_scanner, &res);
    if (res.nerrs > 0) {
      yyctx.res.nerrs += res.nerrs;
      return YYERROR;
    } else {
      $$ = res.value;
    }
  }
;

%%
