const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");

pub fn runAsZison(opts: struct {
    input_file_path: []const u8,
    output_file_path: []const u8,
    zison_exe: []const u8,
}) !void {
    _ = opts;
}
