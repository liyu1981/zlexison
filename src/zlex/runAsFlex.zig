const std = @import("std");
const flexbin = @embedFile("../flex.bin");

pub fn run_as_flex(args: [][:0]const u8) void {
    _ = args;
    std.debug.print("embed flex: {d}bytes.\n", .{flexbin.len});
    std.os.exit(0);
}
