const std = @import("std");
const FlexParser = @import("flexParser.zig");

pub fn genCbName(allocator: std.mem.Allocator, cb: FlexParser.Context.CodeBlock) ![]const u8 {
    return std.fmt.allocPrint(allocator, "line{d}col{d}", .{ cb.start.line, cb.start.col });
}
