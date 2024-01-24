pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("  int ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("wrap(yyscan_t yyscanner) {\n      return 1;\n  }\n\n  int ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_main() {\n      yyscan_t scanner;\n      ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("lex_init(&scanner);\n      int r = yylex(scanner);\n      ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("lex_destroy(scanner);\n      return r;\n  }\n");
}
