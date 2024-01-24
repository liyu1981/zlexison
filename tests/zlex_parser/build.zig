const std = @import("std");

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
};

const c_flags = [_][]const u8{} ++ common_flags;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var zlex_exe = b.addExecutable(.{
        .name = "zlex_parser",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = optimize,
    });

    zlex_exe.addCSourceFiles(.{
        .files = &[_][]const u8{
            "zlex_parser.yy.c",
        },
        .flags = &c_flags,
    });

    b.installArtifact(zlex_exe);

    const run_cmd = b.addRunArtifact(zlex_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
