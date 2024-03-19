pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("const std = @import(\"std\");\n\npub const zlex_version = \"");
    try stream.print("{s}", .{ctx.zlex_version});
    try stream.writeAll("+");
    try stream.print("{s}", .{ctx.commit});
    try stream.writeAll("\";\npub const zison_version = \"");
    try stream.print("{s}", .{ctx.zison_version});
    try stream.writeAll("+");
    try stream.print("{s}", .{ctx.commit});
    try stream.writeAll("\";\n\npub fn main() !void {\n    var gpa = std.heap.GeneralPurposeAllocator(.{}){};\n    defer {\n        _ = gpa.detectLeaks();\n    }\n    const allocator = gpa.allocator();\n\n    const args = try std.process.argsAlloc(allocator);\n    defer std.process.argsFree(allocator, args);\n\n    if (args.len > 1) {\n        if (std.mem.eql(u8, args[1], \"zlex\")) {\n            try std.io.getStdOut().writer().print(\"{s}\", .{zlex_version});\n        }\n\n        if (std.mem.eql(u8, args[1], \"zison\")) {\n            try std.io.getStdOut().writer().print(\"{s}\", .{zison_version});\n        }\n    }\n}\n");
}
