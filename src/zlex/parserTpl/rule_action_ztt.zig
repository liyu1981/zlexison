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
    try stream.writeAll("(parser_intptr: usize) u32 {\n    var parser = @as(*Parser, @ptrFromInt(parser_intptr));\n    _ = &parser;\n    ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_");
    try stream.print("{s}", .{ctx.name});
    try stream.writeAll("_impl(parser) catch |err| switch (err) {\n        ZA.YYControl.E.RETURN => return ZA.YYControl.INT_RETURN,\n        ZA.YYControl.E.REJECT => return ZA.YYControl.INT_REJECT,\n        ZA.YYControl.E.TERMINATE => return ZA.YYControl.INT_TERMINATE,\n        ZA.YYControl.E.YYLESS => return ZA.YYControl.INT_YYLESS,\n        else => {\n            std.io.getStdErr().writer().print(\"{any}, line: {d}, column: {d}\\n\", .{err, Parser.ZA.yyget_lineno(), Parser.ZA.yyget_column()}) catch {};\n            @panic(\"parser crashed\");\n        },\n    };\n    return ZA.YYControl.INT_CONTINUE;\n}\nfn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_");
    try stream.print("{s}", .{ctx.name});
    try stream.writeAll("_impl(parser: *Parser) anyerror!void {\n");
    try stream.print("{s}", .{ctx.code});
    try stream.writeAll("\n}\n");
}
