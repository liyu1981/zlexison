const std = @import("std");
const jstring_build = @import("jstring");
const zcmd = @import("zcmd").zcmd;

var g_build: *std.Build = undefined;

const zlex_version = "0.1.0";
const zison_version = "0.1.0";

pub fn build(b: *std.Build) !void {
    g_build = b;
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    switch (target.result.os.tag) {
        .linux, .macos => {},
        else => |t| {
            std.debug.print("Found platform: {any}\n", .{t});
            @panic("Not Support Yet!");
        },
    }

    const zcmd_dep = b.dependency("zcmd", .{});
    const jstring_dep = b.dependency("jstring", .{});

    const version_step = b.step("generate_version", "auto generate version str");
    version_step.makeFn = versionStepMakeFn;

    const m4_dep = b.dependency("m4", .{});
    const m4phony = m4_dep.artifact("m4_as_lib_phony");

    const flex_dep = b.dependency("flex", .{});
    var libflex_a = flex_dep.artifact("flex_as_lib");
    libflex_a.step.dependOn(version_step);

    // zlex

    var zlex_exe = b.addExecutable(.{
        .name = "zlex",
        .root_source_file = .{ .path = "src/zlex.zig" },
        .target = target,
        .optimize = optimize,
    });
    var zlex_top_step = b.step("zlex", "build zlex only");
    zlex_top_step.dependOn(&zlex_exe.step);

    var flex_bin_step = b.step("flex_bin", "copy flex/flex/src/flex as src/flex.bin");
    flex_bin_step.makeFn = flexBinStepMakeFn;

    zlex_exe.step.dependOn(version_step);
    zlex_exe.step.dependOn(flex_bin_step);
    zlex_exe.step.dependOn(&m4phony.step);
    zlex_exe.step.dependOn(&libflex_a.step);
    zlex_exe.root_module.addImport("zcmd", zcmd_dep.module("zcmd"));
    zlex_exe.root_module.addImport("jstring", jstring_dep.module("jstring"));
    jstring_build.linkPCRE(zlex_exe, jstring_dep);
    zlex_exe.addObjectFile(libflex_a.getEmittedBin());

    switch (target.result.os.tag) {
        .linux => {
            zlex_exe.linkLibC();
        },
        .macos => {},
        else => {},
    }

    b.installArtifact(zlex_exe);

    // zison

    const bison_dep = b.dependency("bison", .{});
    var libbison_a = bison_dep.artifact("bison_as_lib");
    libbison_a.step.dependOn(version_step);

    var zison_exe = b.addExecutable(.{
        .name = "zison",
        .root_source_file = .{ .path = "src/zison.zig" },
        .target = target,
        .optimize = optimize,
    });
    var zison_top_step = b.step("zison", "build zison only");
    zison_top_step.dependOn(&zison_exe.step);

    var bison_bin_step = b.step("bison_bin", "copy bison/bison/src/bison as src/bison.bin");
    bison_bin_step.makeFn = bisonBinStepMakeFn;

    var bison_share_bin_step = b.step("bison_share_bin", "compress share and save to share.tgz.bin");
    bison_share_bin_step.makeFn = bisonShareBinStepMakeFn;

    zison_exe.step.dependOn(version_step);
    zison_exe.step.dependOn(bison_bin_step);
    zison_exe.step.dependOn(bison_share_bin_step);
    zison_exe.step.dependOn(&m4phony.step);
    zison_exe.step.dependOn(&libbison_a.step);
    zison_exe.root_module.addImport("zcmd", zcmd_dep.module("zcmd"));
    zison_exe.root_module.addImport("jstring", jstring_dep.module("jstring"));
    jstring_build.linkPCRE(zison_exe, jstring_dep);

    switch (target.result.os.tag) {
        .linux => {
            zison_exe.linkLibC();
        },
        .macos => {},
        else => {},
    }

    b.installArtifact(zison_exe);

    // regtest

    var regtest_top_step = b.step("regtest", "regresssion tests");
    if (b.option(bool, "enable_regtest", "enable build regression tests")) |e| {
        if (e) {
            var build_tests_step = b.step("build_all_tests", "run build.sh in all tests folder");
            build_tests_step.makeFn = buildTestsStepMakeFn;

            const regtest_exe = b.addExecutable(.{
                .name = "regtest",
                .root_source_file = .{ .path = "tests/test.zig" },
                .target = target,
                .optimize = optimize,
            });
            regtest_exe.step.dependOn(build_tests_step);
            const install_regtest_step = b.addInstallArtifact(regtest_exe, .{});
            regtest_top_step.dependOn(&install_regtest_step.step);
        }
    } else {
        std.debug.print("Not set '-Denable_regtest', will do nothing in this step.\n", .{});
    }
}

fn versionStepMakeFn(step: *std.Build.Step, node: *std.Progress.Node) !void {
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    node.setEstimatedTotalItems(2);

    const commit_str = brk: {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{ "git", "rev-parse", "--short=8", "HEAD" },
            },
            .cwd = g_build.pathFromRoot(""),
        });
        result.assertSucceededPanic(.{ .check_stdout_not_empty = true });
        node.completeOne();
        break :brk result.trimedStdout();
    };

    const tplm = @import("src/tplVersion.zig");
    var f = try std.fs.createFileAbsolute(g_build.pathFromRoot("src/version.zig"), .{});
    defer f.close();
    try tplm.render(f.writer(), .{
        .zlex_version = zlex_version,
        .zison_version = zison_version,
        .commit = commit_str,
    });
    node.completeOne();
}

fn flexBinStepMakeFn(step: *std.Build.Step, node: *std.Progress.Node) !void {
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    node.setEstimatedTotalItems(2);

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
        node.completeOne();
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
        node.completeOne();
    }
}

fn bisonBinStepMakeFn(step: *std.Build.Step, node: *std.Progress.Node) !void {
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    node.setEstimatedTotalItems(2);

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
        node.completeOne();
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
        node.completeOne();
    }
}

fn bisonShareBinStepMakeFn(step: *std.Build.Step, node: *std.Progress.Node) !void {
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    node.setEstimatedTotalItems(3);

    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{ "tar", "czf", "src/share.tgz.bin", "./share" },
            },
            .cwd = g_build.pathFromRoot(""),
        });
        result.assertSucceededPanic(.{});
        node.completeOne();
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
        node.completeOne();
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
        node.completeOne();
    }
}

fn buildTestsStepMakeFn(step: *std.Build.Step, node: *std.Progress.Node) !void {
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    const all_test_dirs = .{
        "tests/zlex/simple",
        "tests/zlex/cat",
        "tests/zlex/eof_rules",
        "tests/zlex/reject",
        "tests/zlex/yymore",
        "tests/zlex/comments",
        "tests/zlex/dates",
        "tests/zlex/string1",
        "tests/zlex/user_act",
        "tests/zlex/user_init",
        "tests/zlex/user_extra",
        "tests/zlex/pthread",
        "tests/zlex/lineno_r",

        "tests/zison/glr",
        "tests/zison/mfcalc",
        "tests/zison/pushcalc",
        "tests/zison/reccalc",
    };

    node.setEstimatedTotalItems(all_test_dirs.len);

    var envmap = try std.process.getEnvMap(arena);
    try envmap.put("NO_COMPILE", "1");

    inline for (0..all_test_dirs.len) |i| {
        {
            const result = try zcmd.run(.{
                .allocator = arena,
                .commands = &[_][]const []const u8{
                    &[_][]const u8{ "bash", "build.sh" },
                },
                .cwd = g_build.pathFromRoot(all_test_dirs[i]),
                .env_map = &envmap,
            });
            result.assertSucceededPanic(.{});
            node.completeOne();
        }
    }
}
