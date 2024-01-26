const std = @import("std");
const jstring_build = @import("jstring");

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
};

const c_flags = [_][]const u8{} ++ common_flags;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zcmd_dep = b.dependency("zcmd", .{});
    var jstring_dep = b.dependency("jstring", .{});

    const flex_dep = b.dependency("flex", .{});
    const libflex_a = flex_dep.artifact("flex_as_lib");

    var zlex_exe = b.addExecutable(.{
        .name = "zlex",
        .root_source_file = .{ .path = "src/zlex.zig" },
        .target = target,
        .optimize = optimize,
    });

    zlex_exe.addCSourceFiles(.{
        .files = &[_][]const u8{
            "src/zlex/flex.zyy.c",
        },
        .flags = &c_flags,
    });

    zlex_exe.step.dependOn(&libflex_a.step);
    zlex_exe.addModule("zcmd", zcmd_dep.module("zcmd"));
    zlex_exe.addModule("jstring", jstring_dep.module("jstring"));
    jstring_build.linkPCRE(zlex_exe, jstring_dep);
    zlex_exe.addObjectFile(libflex_a.getEmittedBin());

    b.installArtifact(zlex_exe);

    const bison_dep = b.dependency("bison", .{});
    const libbison_a = bison_dep.artifact("bison_as_lib");

    var zison_exe = b.addExecutable(.{
        .name = "zison",
        .root_source_file = .{ .path = "src/zison.zig" },
        .target = target,
        .optimize = optimize,
    });

    zison_exe.step.dependOn(&libbison_a.step);
    zison_exe.addModule("zcmd", zcmd_dep.module("zcmd"));
    zison_exe.addModule("jstring", jstring_dep.module("jstring"));
    jstring_build.linkPCRE(zison_exe, jstring_dep);
    zison_exe.addObjectFile(libbison_a.getEmittedBin());
    zison_exe.linkSystemLibrary2("iconv", .{});

    b.installArtifact(zison_exe);
}
