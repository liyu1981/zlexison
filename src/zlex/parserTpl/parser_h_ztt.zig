pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("#include ");
    try stream.writeAll("<s");
    try stream.writeAll("tdint.h>\n#define zig_extern extern\nzig_extern void ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_prepare_yy(uintptr_t const a0, uintptr_t const a1, uint8_t *const a2, uintptr_t const a3, uintptr_t const a4, uintptr_t const a5, uintptr_t const a6, uintptr_t const a7);\n");
for(ctx.action_fn_names) |action_fn_name| {
    try stream.writeAll("zig_extern uint32_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_");
    try stream.print("{s}", .{action_fn_name});
    try stream.writeAll("(uintptr_t const a0);\n");
}
}
