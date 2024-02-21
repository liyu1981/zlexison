const std = @import("std");
const jstring_build = @import("jstring");
const zcmd = @import("zcmd").zcmd;

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
};

const c_flags = [_][]const u8{} ++ common_flags;

var g_build: *std.Build = undefined;

pub fn build(b: *std.Build) !void {
    g_build = b;
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zcmd_dep = b.dependency("zcmd", .{});
    const jstring_dep = b.dependency("jstring", .{});

    const m4_dep = b.dependency("m4", .{});
    const m4phony = m4_dep.artifact("m4_as_lib_phony");

    const flex_dep = b.dependency("flex", .{});
    const libflex_a = flex_dep.artifact("flex_as_lib");

    var zlex_exe = b.addExecutable(.{
        .name = "zlex",
        .root_source_file = .{ .path = "src/zlex.zig" },
        .target = target,
        .optimize = optimize,
    });

    var flex_bin_step = b.step("flex_bin", "copy flex/flex/src/flex as src/flex.bin");
    flex_bin_step.makeFn = flexBinStepMakeFn;

    zlex_exe.step.dependOn(flex_bin_step);
    zlex_exe.step.dependOn(&m4phony.step);
    zlex_exe.step.dependOn(&libflex_a.step);
    zlex_exe.root_module.addImport("zcmd", zcmd_dep.module("zcmd"));
    zlex_exe.root_module.addImport("jstring", jstring_dep.module("jstring"));
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

    var bison_bin_step = b.step("bison_bin", "copy bison/bison/src/bison as src/bison.bin");
    bison_bin_step.makeFn = bisonBinStepMakeFn;

    var bison_share_bin_step = b.step("bison_share_bin", "compress share and save to share.tgz.bin");
    bison_share_bin_step.makeFn = bisonShareBinStepMakeFn;

    zison_exe.step.dependOn(bison_bin_step);
    zison_exe.step.dependOn(bison_share_bin_step);
    zison_exe.step.dependOn(&m4phony.step);
    zison_exe.step.dependOn(&libbison_a.step);
    zison_exe.root_module.addImport("zcmd", zcmd_dep.module("zcmd"));
    zison_exe.root_module.addImport("jstring", jstring_dep.module("jstring"));
    jstring_build.linkPCRE(zison_exe, jstring_dep);

    b.installArtifact(zison_exe);
}

fn flexBinStepMakeFn(step: *std.Build.Step, node: *std.Progress.Node) !void {
    _ = node;
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    "cp",
                    g_build.pathFromRoot("flex/flex/src/flex"),
                    g_build.pathFromRoot("src/flex.bin"),
                },
            },
            .cwd = g_build.pathFromRoot(""),
        });
        result.assertSucceededPanic(.{});
    }

    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    "chmod",
                    "0644",
                    g_build.pathFromRoot("src/flex.bin"),
                },
            },
            .cwd = g_build.pathFromRoot(""),
        });
        result.assertSucceededPanic(.{});
    }
}

fn bisonBinStepMakeFn(step: *std.Build.Step, node: *std.Progress.Node) !void {
    _ = node;
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    "cp",
                    g_build.pathFromRoot("bison/bison/src/bison"),
                    g_build.pathFromRoot("src/bison.bin"),
                },
            },
            .cwd = g_build.pathFromRoot(""),
        });
        result.assertSucceededPanic(.{});
    }

    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    "chmod",
                    "0644",
                    g_build.pathFromRoot("src/bison.bin"),
                },
            },
            .cwd = g_build.pathFromRoot(""),
        });
        result.assertSucceededPanic(.{});
    }
}

fn bisonShareBinStepMakeFn(step: *std.Build.Step, node: *std.Progress.Node) !void {
    _ = node;
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{ "tar", "czf", "src/share.tgz.bin", "./share" },
            },
            .cwd = g_build.pathFromRoot(""),
        });
        result.assertSucceededPanic(.{});
    }

    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{
                    "chmod",
                    "0644",
                    g_build.pathFromRoot("src/share.tgz.bin"),
                },
            },
            .cwd = g_build.pathFromRoot(""),
        });
        result.assertSucceededPanic(.{});
    }

    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{ "zig", "run", "src/calcHash.zig", "--", "src/share.tgz.bin" },
                &[_][]const u8{ "tee", "src/share.tgz.bin.hash" },
            },
            .cwd = g_build.pathFromRoot(""),
        });
        result.assertSucceededPanic(.{});
    }
}
