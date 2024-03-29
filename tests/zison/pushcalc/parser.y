%code top {
  const YYLexer = @import("scan.zig").YYLexer;

  pub var result_buf: std.ArrayList(u8) = undefined;
}

// %define api.header.include {"calc.h"}

/* Generate YYSTYPE from the types used in %token and %type.  */
%define api.value.type union
%token <f64> NUM "number"
%type  <f64> expr term fact

/* Don't share global variables between the scanner and the parser.  */
// in zison api.pure will always be full, no matter set or not set it
// %define api.pure full

/* Generate a push parser.  */
%define api.push-pull push

/* Nice error messages with details. */
%define parse.error detailed

/* Generate the parser description file (calc.output).  */
// %verbose

 /* Enable run-time traces (yydebug).  */
%define parse.trace

/* Formatting semantic values in debug traces.  */
%printer { try yyo.writer().print("{any}", .{$$}); } <f64>;

%define api.location.type {YYLexer.YYLTYPE}

%% /* The grammar follows.  */
input:
  %empty
| input line
;

line:
  '\n'
| expr '\n'  { try result_buf.writer().print("{d:.10}", .{$1}); }
| error '\n' { yyctx.yyerrok(); }
;

expr:
  expr '+' term { $$ = $1 + $3; }
| expr '-' term { $$ = $1 - $3; }
| term
;

term:
  term '*' fact { $$ = $1 * $3; }
| term '/' fact { $$ = $1 / $3; }
| fact
;

fact:
  "number"
| '(' expr ')' { $$ = $expr; }
;

%%

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

      try stdout_writer.print("read {d}bytes\n", .{line.items.len});

      var scanner = YYLexer{ .allocator = arena };

      try scanner.init();
      defer scanner.deinit();

      try scanner.scan_string(line.items);

      var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
      var yylloc: YYLexer.YYLTYPE = .{};

      var yyps = try yypstate.init(arena);
      defer yyps.deinit();

      YYParser.result_buf = std.ArrayList(u8).init(arena);
      defer YYParser.result_buf.deinit();

      while (true) {
          const tk = scanner.yylex(&yylval, &yylloc) catch |err| {
              std.debug.print("{any}\n", .{err});
              return 1;
          };
          if (tk == YYLexer.YY_TERMINATED) break;
          try stdout_writer.print("tk: {any} at loc: {s}\n", .{ tk, yylloc });
          const result = try yypush_parse(arena, yyps, @intCast(tk), &yylval, &yylloc);
          if (result != YYPUSH_MORE)
              break;
      }

      std.debug.print("{s}\n", .{YYParser.result_buf.items});
    } else |err| switch(err) {
      error.EndOfStream => {},
      else => return err,
    }

    return 0;
}
