const std = @import("std");

pub const zlex_version = "1";
pub const zison_version = "1";

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(allocator);
    defer allocator.free(args);

    if (args.len > 1) {
        if (std.mem.eql(u8, args[1], "zlex")) {
            try std.io.getStdOut().writer().print("{s}", .{zlex_version});
        }

        if (std.mem.eql(u8, args[1], "zison")) {
            try std.io.getStdOut().writer().print("{s}", .{zison_version});
        }
    }
}
