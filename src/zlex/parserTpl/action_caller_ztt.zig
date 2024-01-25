pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("    ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_prepare_yy(");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_intptr, ZLEX_CAST_UINTPTR(yyg), ZLEX_CAST_U8PTR(yytext), yyleng, ZLEX_CAST_UINTPTR(yyin), ZLEX_CAST_UINTPTR(yyout), ZLEX_CAST_UINTPTR(YY_CURRENT_BUFFER), YY_START);\n    ZLEX_CONTROL(");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_");
    try stream.print("{s}", .{ctx.name});
    try stream.writeAll("(");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_intptr));\n");
}
