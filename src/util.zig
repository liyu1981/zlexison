const std = @import("std");

pub const ExeInfo = struct {
    allocator: std.mem.Allocator,
    dir: []const u8,
    exe_path: []const u8,

    pub fn init(allocator: std.mem.Allocator) !ExeInfo {
        const dir_path = try std.fs.selfExeDirPathAlloc(allocator);
        const exe_path = try std.fs.selfExePathAlloc(allocator);
        return .{
            .allocator = allocator,
            .dir = dir_path,
            .exe_path = exe_path,
        };
    }

    pub fn deinit(this: *ExeInfo) void {
        this.allocator.free(this.dir);
        this.allocator.free(this.exe_path);
    }
};
