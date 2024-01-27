const std = @import("std");

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
};

const c_flags = [_][]const u8{} ++ common_flags;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var exe = b.addExecutable(.{
        .name = "rpcalc",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.addCSourceFiles(.{
        .files = &[_][]const u8{
            "scan.yy.c",
        },
        .flags = &c_flags,
    });

    b.installArtifact(exe);
}
