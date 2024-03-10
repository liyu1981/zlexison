const std = @import("std");
const zcmd = @import("zcmd").zcmd;

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
    "-std=c17",
    "-DHAVE_CONFIG_H",
    // "-DFROM_ZIGBUILD",
};

const c_flags = [_][]const u8{} ++ common_flags;

var g_build: *std.Build = undefined;
var target: std.Build.ResolvedTarget = undefined;

pub fn build(b: *std.Build) void {
    g_build = b;
    target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const m4_pre_build_step = b.step("m4_pre_build", "bootstrap, configure and pre-build m4");
    m4_pre_build_step.makeFn = m4PreBuild;

    const m4_as_lib = b.addStaticLibrary(.{
        .name = "m4_as_lib_phony",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = optimize,
    });
    m4_as_lib.step.dependOn(m4_pre_build_step);

    b.installArtifact(m4_as_lib);
}

fn m4PreBuild(step: *std.Build.Step, node: *std.Progress.Node) anyerror!void {
    _ = node;
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    switch (target.result.os.tag) {
        .linux, .macos => {
            const sys_m4_path = brk: {
                if (findHomebrewM4(arena)) |p| {
                    break :brk p;
                } else if (findSysM4(arena)) |p| {
                    break :brk p;
                } else {
                    @panic("can not find m4 in system!");
                }
            };
            try copyM4AsBin(arena, sys_m4_path);
        },

        else => |t| {
            std.debug.print("Found platform: {any}\n", .{t});
            @panic("Not Support Yet!");
        },
    }
}

fn findHomebrewM4(allocator: std.mem.Allocator) ?[]const u8 {
    _ = allocator;
    std.fs.accessAbsolute(
        "/opt/homebrew/Cellar/m4/1.4.19",
        .{},
    ) catch {
        return null;
    };
    return "/opt/homebrew/Cellar/m4/1.4.19/bin/m4";
}

fn findSysM4(allocator: std.mem.Allocator) ?[]const u8 {
    const result = zcmd.run(.{
        .allocator = allocator,
        .commands = &[_][]const []const u8{
            &[_][]const u8{ "which", "m4" },
        },
    }) catch {
        return null;
    };
    result.assertSucceeded(.{
        .print_cmd_term = false,
        .print_stderr = false,
        .print_stdout = false,
    }) catch {
        return null;
    };
    return result.trimedStdout();
}

fn copyM4AsBin(allocator: std.mem.Allocator, sys_m4_path: []const u8) !void {
    const dest_path = try std.fs.path.join(
        allocator,
        &[_][]const u8{ g_build.pathFromRoot(""), "../src/m4.bin" },
    );
    var result = try zcmd.run(.{
        .allocator = allocator,
        .commands = &[_][]const []const u8{
            &[_][]const u8{ "cp", sys_m4_path, dest_path },
        },
    });
    try result.assertSucceeded(.{ .check_stdout_not_empty = false });
    result = try zcmd.run(.{
        .allocator = allocator,
        .commands = &[_][]const []const u8{
            &[_][]const u8{ "chmod", "0644", dest_path },
        },
    });
    try result.assertSucceeded(.{ .check_stdout_not_empty = false });
}
