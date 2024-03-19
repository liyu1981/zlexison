%{
  // content here will be copied to scan.zig, after definitions of other lexer module variables
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

  // remember to mark it as pub if you want to modify it from outside
  pub var context: Context = undefined;
%}

%x SC_STRING

%%

"+"      { return @intFromEnum(TOK_TYPE.PLUS); }
"-"      { return @intFromEnum(TOK_TYPE.MINUS); }
"*"      { return @intFromEnum(TOK_TYPE.STAR); }
"/"      { return @intFromEnum(TOK_TYPE.SLASH); }

"("      {
    context.nesting += 1;
    context.str.clearAndFree();
    BEGIN(SC_STRING, yyg);
  }

[0-9]+   {
    // Scan an integer.
    const intval = try std.fmt.parseInt(i64, yyget_text(yyg), 10);
    yyset_lval(YYSTYPE{.NUM = @intCast(intval)}, yyg);
    return @intFromEnum(TOK_TYPE.NUM);
  }

[ \t]+   {}

"\n"     { return @intFromEnum(TOK_TYPE.EOL); }

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
            yyset_lval(YYSTYPE{.STR = &context.str.items}, yyg);
            return @intFromEnum(TOK_TYPE.STR);
        }
    } else {
        try context.str.appendSlice(yyget_text(yyg));
    }
  }

<SC_STRING>[^()]+  { try context.str.appendSlice(yyget_text(yyg)); }

<<EOF>>  { return @intFromEnum(TOK_TYPE.YYEOF); }

%%

// a default main fn can be used testing scanner
pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

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
    try lexer.init();
    defer lexer.deinit();

    YYLexer.context = YYLexer.Context.init(allocator);
    defer YYLexer.context.deinit();

    _ = try YYLexer.yy_scan_string(content, lexer.yyg);

    while (true) {
        const tk = lexer.yylex(&yylval, &yylloc) catch |err| {
            std.debug.print("{any}\n", .{err});
            return 1;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
        switch (tk) {
            @as(usize, @intFromEnum(TOK_TYPE.YYEOF)) => {
                break;
            },
            else => |cur_tk| {
                try stdout_writer.print("tk: {any} at loc: {s}\n", .{ cur_tk, yylloc });
            },
        }
    }

    return 0;
}
