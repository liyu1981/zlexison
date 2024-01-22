pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("#include \"");
    try stream.print("{s}", .{ctx.name});
    try stream.writeAll(".h\"\n#define ZLEX_CAST_U8PTR(x) ((uint8_t *)(void *)(x))\n#define ZLEX_CAST_UINTPTR(x) ((uintptr_t)(void *)(x))\nuintptr_t parser_intptr = 0;\nvoid zlex_setup_parser(intptr_t ptr) {\n    parser_intptr = ptr;\n}\n");
}
