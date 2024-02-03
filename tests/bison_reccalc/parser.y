// Prologue (directives).
%expect 0

// Emitted in the header file, before the definition of YYSTYPE.
%code requires
{
  const lexer = @import("scan.zig");

  pub const result = struct {
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

// Generate the parser description file (parse.output).
%verbose

// Scanner and error count are exchanged between main, yyparse and yylex.
%param {scanner: yyscan_t}{res: *result}

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
      res.value = $exp;
      if (res.verbose)
        printf ("%d\n", $exp);
    }
| error eol
    {
      yyerrok;
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
        yyerror (scanner, res, "invalid division by zero");
        YYERROR;
      }
    else
      $$ = $1 / $3;
  }
| "+" exp %prec UNARY  { $$ = $2; }
| "-" exp %prec UNARY  { $$ = -$2; }
| STR
  {
    var r = parse_string ($1);
    free ($1);
    if (r.nerrs)
      {
        res.nerrs += r.nerrs;
        YYERROR;
      }
    else
      $$ = r.value;
  }
;

%%
// Epilogue (C code).
// #include "scan.h"

// result
// parse (void)
// {
//   yyscan_t scanner;
//   yylex_init (&scanner);
//   result res = {1, 0, 0};
//   yyparse (scanner, &res);
//   yylex_destroy (scanner);
//   return res;
// }

// result
// parse_string (const char *str)
// {
//   yyscan_t scanner;
//   yylex_init (&scanner);
//   YY_BUFFER_STATE buf = yy_scan_string (str ? str : "", scanner);
//   result res = {0, 0, 0};
//   yyparse (scanner, &res);
//   yy_delete_buffer (buf, scanner);
//   yylex_destroy (scanner);
//   return res;
// }

// void
// yyerror (yyscan_t scanner, result *res,
//          const char *msg, ...)
// {
//   (void) scanner;
//   va_list args;
//   va_start (args, msg);
//   vfprintf (stderr, msg, args);
//   va_end (args);
//   fputc ('\n', stderr);
//   res->nerrs += 1;
// }

// int
// main (void)
// {
//   // Possibly enable parser runtime debugging.
//   yydebug = !!getenv ("YYDEBUG");
//   result res = parse ();
//   // Exit on failure if there were errors.
//   return !!res.nerrs;
// }
