%{
  // content here will be copied to scan.zig, after definitions of other lexer module variables
  const Node = @import("zlexison.zig").Node;
%}

%%

[[:alpha:]][[:alnum:][_]]+    {
    const t = yyget_text(yyg);
    if (std.ascii.isUpper(t[0])) {
      yyset_lval(YYSTYPE{.TYPENAME = try Node.newTerm(yyg.lexer_.allocator, t)}, yyg);
      return @intFromEnum(TOK_TYPE.TYPENAME);
    } else {
      yyset_lval(YYSTYPE{.ID = try Node.newTerm(yyg.lexer_.allocator, t)}, yyg);
      return @intFromEnum(TOK_TYPE.ID);
    }
  }

[ \t\f\n]+   {}

.    {
    const t = yyget_text(yyg);
    return t[0];
  }

<<EOF>>  { return @intFromEnum(TOK_TYPE.YYEOF); }

%%

// a default main fn can be used testing scanner
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

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    _ = &yylval;
    var yylloc: YYLexer.YYLTYPE = .{};
    _ = &yylloc;

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };

    try YYLexer.yylex_init(&lexer);
    defer YYLexer.yylex_destroy(&lexer);

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
