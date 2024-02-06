const std = @import("std");
const zcmd = @import("zcmd");

pub const ExeInfo = struct {
    allocator: std.mem.Allocator,
    dir: []const u8,
    exe_path: []const u8,

    pub fn init(allocator: std.mem.Allocator, exe_path: []const u8) !ExeInfo {
        const p = try allocator.dupe(u8, exe_path);
        return .{
            .allocator = allocator,
            .dir = std.fs.path.dirname(p).?,
            .exe_path = p,
        };
    }

    pub fn deinit(this: *ExeInfo) void {
        this.allocator.free(this.exe_path);
    }
};

pub fn getCurrentExeInfo(arg_exe_path: []const u8) !ExeInfo {
    if (std.fs.path.isAbsolute(arg_exe_path)) {
        try std.fs.accessAbsolute(arg_exe_path, .{});
        return ExeInfo.init(std.heap.page_allocator, arg_exe_path);
    } else {
        std.fs.cwd().access(arg_exe_path, .{}) catch {
            return getCurrentExeInfoByWhich(arg_exe_path);
        };
        return ExeInfo.init(std.heap.page_allocator, arg_exe_path);
    }
}

fn getCurrentExeInfoByWhich(arg_exe_name: []const u8) !ExeInfo {
    var result = try zcmd.run(.{
        .allocator = std.heap.page_allocator,
        .commands = &[_][]const []const u8{
            &[_][]const u8{ "which", arg_exe_name },
        },
    });
    defer result.deinit();
    result.assertSucceeded(.{}) catch |err| {
        std.debug.print("which {s} failed with {any}.\n", .{ arg_exe_name, err });
        @panic("getCurrentExeInfoByWhich failed!");
    };
    const resolved_path = result.trimedStdout();
    return ExeInfo.init(std.heap.page_allocator, resolved_path);
}
