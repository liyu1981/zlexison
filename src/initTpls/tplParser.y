// Prologue (directives).
%expect 0

%code requires
{
  // content in %code requires will be emitted only in the zlexison.zig file, before the definition of YYSTYPE.
}

%code provides
{
  // Emitted in the header file, after the definition of YYSTYPE.
}

%code top
{
  // content in %code top will be emitted on top of the parser.zig, after importing std, and before other definitions
}

%code
{
  // content in %code will be copied to parser.zig

  // This is how to import our lexer to parser, usually a must have
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

// Don't share global variables between the scanner and the parser.
// This is always true in zison, so set it will have no effect.
// %define api.pure full

// To avoid name clashes (e.g., with C's EOF) prefix token definitions
// with TOK_ (e.g., TOK_EOF).
// This has less usage in zig as there is namespace isolation, but if want can still use
// %define api.token.prefix {TOK_}

// Generate YYSTYPE from the types assigned to symbols.
// This will be always true in zison
%define api.value.type union

// Error messages with "unexpected XXX, expected XXX...".
// %define parse.error detailed

// Enable run-time traces (yydebug).
// Control the default value of yydebug, which can also be changed in runtime with YYLexer.yydebug assigning
%define parse.trace

// This will be always true in zison, so setting it or not will have no effect
%define api.location.type {YYLexer.YYLTYPE}

// Generate the parser description file (parse.output).
// %verbose

// Scanner and error count are exchanged between main, yyparse and yylex.
// Please follow the zig param scheme when define fn, and keep at least one YYLexer param
// For adding more, one example is like below
//   %param {scanner: *YYLexer}{res: *Result}
%param {scanner: *YYLexer}

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

%token <*[]const u8> STR "string"
%printer { try yyo.writer().print("{s}", .{$$.*}); } <*[]const u8>

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
    // recursively call our pure parser to get result
    defer yyctx.allocator.free($1.*);
    const input_with_newline = try std.fmt.allocPrint(yyctx.allocator, "{s}\n", .{$1.*});
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

// a default main fn can be used testing parser
pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    var f: std.fs.File = brk: {
        if (args.len > 1) {
            break :brk try std.fs.cwd().openFile(args[1], .{});
        } else {
            break :brk std.io.getStdIn();
        }
    };
    defer f.close();

    const stdout_writer = std.io.getStdOut().writer();

    var line = std.ArrayList(u8).init(arena);
    defer line.deinit();
    const line_writer = line.writer();
    var buf_f_reader = std.io.bufferedReader(f.reader());
    const f_reader = buf_f_reader.reader();

    YYParser.yydebug = true;

    while (f_reader.streamUntilDelimiter(line_writer, '\n', null)) {
        defer line.clearRetainingCapacity();
        try line.append('\n');

        var res: Result = Result{};
        try stdout_writer.print("read {d}bytes\n", .{line.items.len});

        var scanner = YYLexer{ .allocator = arena };

        try YYLexer.yylex_init(&scanner);
        defer YYLexer.yylex_destroy(&scanner);

        // init our lexer's context which is the state shared in the parsing flow
        YYLexer.context = YYLexer.Context.init(arena);
        defer YYLexer.context.deinit();

        _ = try YYLexer.yy_scan_string(line.items, scanner.yyg);

        _ = try YYParser.yyparse(arena, &scanner, &res);

        std.debug.print("{any}\n", .{res});
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }

    return 0;
}
