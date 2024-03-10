const std = @import("std");
const zcmd = @import("zcmd").zcmd;

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
    "-std=c17",
    "-DHAVE_CONFIG_H",
    "-DFROM_ZIGBUILD",
};

const c_flags = [_][]const u8{} ++ common_flags;

const flex_srcs_c = [_][]const u8{
    // "flex/src/buf.c",
    // "flex/src/ccl.c",
    // "flex/src/dfa.c",
    // "flex/src/ecs.c",
    // "flex/src/filter.c",
    // "flex/src/options.c",
    // "flex/src/regex.c",
    // "flex/src/scanflags.c",
    // "flex/src/scanopt.c",
    // "flex/src/sym.c",
    // "flex/src/tables.c",
    // "flex/src/tables_shared.c",
    // "flex/src/tblcmp.c",
    // "flex/src/yylex.c",
    // "flex/src/scan.c",
    "flex/src/zig_skel.c",
    "flex/src/nfa_zig.c",
    "flex/src/gen_zig.c",
    "flex/src/main_zig.c",
    "flex/src/misc_zig.c",
    "flex/src/parse_zig.c",
    "flex/src/stage1scan_zig.c",
};

const flex_objs = [_][]const u8{
    "flex/src/flex-buf.o",
    "flex/src/flex-ccl.o",
    "flex/src/flex-dfa.o",
    "flex/src/flex-ecs.o",
    "flex/src/flex-filter.o",
    "flex/src/flex-options.o",
    "flex/src/flex-regex.o",
    "flex/src/flex-scanflags.o",
    "flex/src/flex-scanopt.o",
    "flex/src/flex-sym.o",
    "flex/src/flex-tables.o",
    "flex/src/flex-tables_shared.o",
    "flex/src/flex-tblcmp.o",
    "flex/src/flex-yylex.o",
    // "flex/src/flex-scan.o",
    // "flex/src/flex-zig_skel.o",
    // "flex/src/flex-nfa_zig.o",
    // "flex/src/flex-gen_zig.o",
    // "flex/src/flex-main_zig.o",
    // "flex/src/flex-misc_zig.o",
    // "flex/src/flex-parse_zig.o",
    // "flex/src/flex-stage1scan_zig.o",
};

var zflex_dir: std.fs.Dir = undefined;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    zflex_dir = std.fs.openDirAbsolute(b.pathFromRoot("flex"), .{}) catch |err| {
        std.debug.print("{any}\n", .{err});
        @panic("no flex dir?!");
    };

    const zflex_pre_build_step = b.step("zflex_pre_build", "bootstrap, configure and pre-build zflex");
    zflex_pre_build_step.makeFn = zflexPreBuild;

    _ = b.addModule("flex", .{ .root_source_file = .{ .path = b.pathFromRoot("flex/src") } });

    const flex_as_lib = b.addStaticLibrary(.{
        .name = "flex_as_lib",
        .target = target,
        .optimize = optimize,
    });
    flex_as_lib.step.dependOn(zflex_pre_build_step);
    flex_as_lib.addIncludePath(.{ .path = "flex/src" });
    flex_as_lib.linkSystemLibrary2("m", .{});

    // flex_as_lib.setVerboseCC(true);

    flex_as_lib.addCSourceFiles(.{ .files = &flex_srcs_c, .flags = &c_flags });
    for (flex_objs) |obj| flex_as_lib.addObjectFile(.{ .path = obj });

    flex_as_lib.addIncludePath(.{ .path = "." });

    // switch (target.result.os.tag) {
    //     .linux => {
    //         flex_as_lib.linkLibC();
    //     },
    //     .macos => {},
    //     else => {},
    // }

    b.installArtifact(flex_as_lib);
}

fn zflexPreBuild(step: *std.Build.Step, node: *std.Progress.Node) anyerror!void {
    _ = node;
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    {
        zflex_dir.access("./configure", .{}) catch {
            std.debug.print("no ./configure found in flex src dir, autogen.sh it...\n", .{});
            const result = try zcmd.run(.{
                .allocator = allocator,
                .commands = &[_][]const []const u8{
                    &[_][]const u8{ "bash", "./autogen.sh" },
                },
                .cwd_dir = zflex_dir,
            });
            result.assertSucceededPanic(.{ .check_stderr_empty = false });
        };
    }

    {
        try zflex_dir.access("./configure", .{});
        zflex_dir.access("./Makefile", .{}) catch {
            std.debug.print("no ./Makefile found in flex src dir, configure to gen it...\n", .{});
            var envmap = try std.process.getEnvMap(allocator);
            try envmap.put("CC", "clang");
            try envmap.put("CXX", "clang++");
            try envmap.put("CFLAGS", "-DDEBUG -g");
            const result = try zcmd.run(.{
                .allocator = allocator,
                .commands = &[_][]const []const u8{
                    &[_][]const u8{"./configure"},
                },
                .cwd_dir = zflex_dir,
                .env_map = &envmap,
            });
            result.assertSucceededPanic(.{ .check_stderr_empty = false });
        };
    }

    {
        try zflex_dir.access("./src/mkskel_zig.sh", .{});
        try zflex_dir.access("./src/zig.skl", .{});
        std.debug.print("re-gen zig_skel.c ...\n", .{});
        var zflex_src_dir = try zflex_dir.openDir("src", .{});
        defer zflex_src_dir.close();
        const versions = try getVersions(allocator);
        var buf: [256]u8 = undefined;
        _ = &buf;
        const verstr = try std.fmt.bufPrint(&buf, "{d}.{d}.{d}.{d}", .{
            versions.flex_major_version,
            versions.flex_minor_version,
            versions.flex_subminor_version,
            versions.zlex_version,
        });
        std.debug.print("verstr: {s}\n", .{verstr});
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{ "bash", "./mkskel_zig.sh", ".", "m4", "2.6.4.1" },
                // for last version, first 3 should align to flex version, last 1 digit is for zlex
            },
            .cwd_dir = zflex_src_dir,
        });
        result.assertSucceededPanic(.{ .check_stderr_empty = false });
        var f = try zflex_src_dir.createFile("zig_skel.c", .{});
        defer f.close();
        try f.writeAll(result.stdout.?);
    }

    {
        try zflex_dir.access("./Makefile", .{});
        try zflex_dir.access("./src/Makefile", .{});
        try zflex_dir.access("./src/config.h", .{});
        std.debug.print("make flex & zflex ...\n", .{});
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{"make"},
            },
            .cwd_dir = zflex_dir,
        });
        result.assertSucceededPanic(.{ .check_stderr_empty = false });
    }
}

fn getVersions(allocator: std.mem.Allocator) !struct {
    flex_major_version: usize,
    flex_minor_version: usize,
    flex_subminor_version: usize,
    zlex_version: usize,
} {
    return .{
        .flex_major_version = try getVersion(
            allocator,
            &[_][]const []const u8{
                &[_][]const u8{ "grep", "#define YY_FLEX_MAJOR_VERSION", "src/stage1scan.c" },
                &[_][]const u8{ "awk", "{print $3}" },
            },
            zflex_dir,
        ),
        .flex_minor_version = try getVersion(
            allocator,
            &[_][]const []const u8{
                &[_][]const u8{ "grep", "#define YY_FLEX_MINOR_VERSION", "src/stage1scan.c" },
                &[_][]const u8{ "awk", "{print $3}" },
            },
            zflex_dir,
        ),
        .flex_subminor_version = try getVersion(
            allocator,
            &[_][]const []const u8{
                &[_][]const u8{ "grep", "#define YY_FLEX_SUBMINOR_VERSION", "src/stage1scan.c" },
                &[_][]const u8{ "awk", "{print $3}" },
            },
            zflex_dir,
        ),
        .zlex_version = try getVersion(
            allocator,
            &[_][]const []const u8{
                &[_][]const u8{ "zig", "run", "../../src/version.zig", "--", "zlex" },
            },
            zflex_dir,
        ),
    };
}

fn getVersion(allocator: std.mem.Allocator, commands: []const []const []const u8, cwd_dir: std.fs.Dir) !usize {
    var result = try zcmd.run(.{
        .allocator = allocator,
        .commands = commands,
        .cwd_dir = cwd_dir,
    });
    defer result.deinit();
    result.assertSucceededPanic(.{});
    return try std.fmt.parseInt(usize, result.trimedStdout(), 10);
}
