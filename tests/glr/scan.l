%{
  // content here will be copied to scan.zig, after definitions of other lexer module variables
  const Node = @import("zlexison.zig").Node;
%}

%%

[[:alpha:]]([[:alnum:][_]])*    {
    const t = yyget_text(yyg);
    if (std.ascii.isUpper(t[0])) {
      yyset_lval(YYSTYPE{ .tag = .TYPENAME, .value = .{ .TYPENAME = try Node.newTerm(yyg.lexer_.allocator, t)} }, yyg);
      return TOK_TYPE.TYPENAME;
    } else {
      yyset_lval(YYSTYPE{ .tag = .ID, .value = .{ .ID = try Node.newTerm(yyg.lexer_.allocator, t)} }, yyg);
      return TOK_TYPE.ID;
    }
  }

[ \t\f\n]+   {}

.    {
    const t = yyget_text(yyg);
    return t[0];
  }

<<EOF>>  { return TOK_TYPE.YYEOF; }

%%

// a default main fn can be used testing scanner
pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        _ = gpa.detectLeaks();
    }
    const allocator = gpa.allocator();

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

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    try lexer.scan_string(content);

    while (true) {
        const tk = lexer.yylex(&yylval, &yylloc) catch |err| {
            std.debug.print("{any}\n", .{err});
            return 1;
        };
        if (tk == YYLexer.YY_TERMINATED) break;
        switch (tk) {
            TOK_TYPE.YYEOF => {
                break;
            },
            else => |cur_tk| {
                try stdout_writer.print("tk: {any} at loc: {s}\n", .{ cur_tk, yylloc });
                switch (yylval.tag) {
                    .default => {},
                    .TYPENAME => yylval.value.TYPENAME.free(allocator),
                    .ID => yylval.value.ID.free(allocator),
                    .stmt => yylval.value.stmt.free(allocator),
                    .expr => yylval.value.expr.free(allocator),
                    .decl => yylval.value.decl.free(allocator),
                    .declarator => yylval.value.declarator.free(allocator),
                }
                yylval = YYLexer.YYSTYPE.default();
            },
        }
    }

    return 0;
}
