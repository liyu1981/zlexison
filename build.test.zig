const std = @import("std");

var g_build: *std.Build = undefined;

pub fn build(b: *std.Build) !void {
    g_build = b;
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const unit_test_exe = b.addExecutable(.{
        .name = "unit_tests",
        .root_source_file = .{ .path = "tests/test.zig" },
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(unit_test_exe);

    const run_exe = b.addRunArtifact(unit_test_exe);
    const run_step = b.step("run", "Run unit_test");
    run_step.dependOn(&run_exe.step);
}
