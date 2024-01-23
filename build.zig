const std = @import("std");
const jstring_build = @import("jstring");

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
    // "-fsanitize=address",
};

const c_flags = [_][]const u8{} ++ common_flags;

const zlex_srcs_c = [_][]const u8{
    "src/zlex/flex.yy.c",
    "src/zlex/flex_parser.c",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zcmd_dep = b.dependency("zcmd", .{});
    var jstring_dep = b.dependency("jstring", .{});

    var zlex_exe = b.addExecutable(.{
        .name = "zlex",
        .root_source_file = .{ .path = "src/zlex.zig" },
        .target = target,
        .optimize = optimize,
    });

    zlex_exe.addModule("zcmd", zcmd_dep.module("zcmd"));

    zlex_exe.addModule("jstring", jstring_dep.module("jstring"));
    jstring_build.linkPCRE(zlex_exe, jstring_dep);

    zlex_exe.addCSourceFiles(.{ .files = &zlex_srcs_c, .flags = &c_flags });

    // zlex_exe.addObjectFile(.{ .path = "/opt/homebrew/opt/flex/lib/libfl.a" });
    zlex_exe.addObjectFile(.{ .path = "./flex/zig-out/lib/libflex.a" });

    b.installArtifact(zlex_exe);

    const run_cmd = b.addRunArtifact(zlex_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
