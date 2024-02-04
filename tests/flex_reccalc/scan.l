%{
pub const Context = struct {
    pub const TOK_TYPE = enum(u32) {
        TOK_PLUS,
        TOK_MINUS,
        TOK_STAR,
        TOK_SLASH,
        TOK_EOF,
        TOK_EOL,
        TOK_NUM,
        TOK_STR,
    };

    pub const TOK = union(TOK_TYPE) {
        TOK_PLUS: u8,
        TOK_MINUS: u8,
        TOK_STAR: u8,
        TOK_SLASH: u8,
        TOK_EOF : u8,
        TOK_EOL : u8,
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

pub var context: Context = undefined;
%}

%x SC_STRING

%%

"+"      { context.cur_tok = .{ .TOK_PLUS = '+' }; return @intFromEnum(Context.TOK_TYPE.TOK_PLUS); }
"-"      { context.cur_tok = .{ .TOK_MINUS = '-' }; return @intFromEnum(Context.TOK_TYPE.TOK_MINUS); }
"*"      { context.cur_tok = .{ .TOK_STAR = '*' }; return @intFromEnum(Context.TOK_TYPE.TOK_STAR); }
"/"      { context.cur_tok = .{ .TOK_SLASH = '/' }; return @intFromEnum(Context.TOK_TYPE.TOK_SLASH); }

"("      {
    context.nesting += 1;
    context.str.clearAndFree();
    BEGIN(SC_STRING, yyg);
  }

[0-9]+   {
    // Scan an integer.
    const intval = try std.fmt.parseInt(i64, yyget_text(yyg), 10);
    context.cur_tok = .{ .TOK_NUM = intval };
    return @intFromEnum(Context.TOK_TYPE.TOK_NUM);
  }

[ \t]+   {}

"\n"     { context.cur_tok = .{ .TOK_EOL = 'l' }; return @intFromEnum(Context.TOK_TYPE.TOK_EOL); }

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
            context.cur_tok = .{ .TOK_STR = context.str.items[0..] };
            return @intFromEnum(Context.TOK_TYPE.TOK_STR);
        }
    } else {
        try context.str.appendSlice(yyget_text(yyg));
    }
  }

<SC_STRING>[^()]+  { try context.str.appendSlice(yyget_text(yyg)); }

<<EOF>>  { context.cur_tok = .{ .TOK_EOF = 'e' }; return @intFromEnum(Context.TOK_TYPE.TOK_EOF); }

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
