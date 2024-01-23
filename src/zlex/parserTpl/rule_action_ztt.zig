pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("export fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_");
    try stream.print("{s}", .{ctx.name});
    try stream.writeAll("_start(parser_intptr: usize) u32 {\n    var parser = @as(*Parser, @ptrFromInt(parser_intptr));\n    _ = &parser;\n    ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_");
    try stream.print("{s}", .{ctx.name});
    try stream.writeAll("_impl(parser) catch return 1;\n    return 0;\n}\nfn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_");
    try stream.print("{s}", .{ctx.name});
    try stream.writeAll("_impl(parser: *Parser) !void {\n");
    try stream.print("{s}", .{ctx.code});
    try stream.writeAll("\n}\n");
}
