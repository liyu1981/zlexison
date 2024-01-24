pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("#define ZLEX_CAST_U8PTR(x) ((uint8_t *)(void *)(x))\n#define ZLEX_CAST_UINTPTR(x) ((uintptr_t)(void *)(x))\nuintptr_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_intptr = 0;\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_setup_parser(intptr_t ptr) {\n    ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_intptr = ptr;\n}\n");
}
