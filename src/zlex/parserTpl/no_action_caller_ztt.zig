pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("    ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_");
    try stream.print("{s}", .{ctx.name});
    try stream.writeAll("(");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_intptr);\n");
}
