const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zparser_lib = b.addStaticLibrary(.{
        .name = "zparserlib",
        .root_source_file = .{ .path = "src/zparserLib.zig" },
        .target = target,
        .optimize = optimize,
    });
    var zparser_h_gf = std.Build.GeneratedFile{ .step = &zparser_lib.step, .path = "" };
    zparser_lib.generated_h = &zparser_h_gf;
    b.installArtifact(zparser_lib);

    const exe = b.addExecutable(.{
        .name = "zparser",
        .root_source_file = .{ .path = "src/zparser.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
