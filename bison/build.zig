const std = @import("std");
const zcmd = @import("zcmd").zcmd;

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
    // "-std=c17",
    "-DEXEEXT=\"\"",
};

const c_flags = [_][]const u8{} ++ common_flags;

const bison_objs = [_][]const u8{
    // "bison/src/bison-AnnotationList.o",
    // "bison/src/bison-InadequacyList.o",
    // "bison/src/bison-Sbitset.o",
    // "bison/src/bison-assoc.o",
    // "bison/src/bison-closure.o",
    // "bison/src/bison-complain.o",
    // "bison/src/bison-conflicts.o",
    // "bison/src/bison-counterexample.o",
    // "bison/src/bison-derivation.o",
    // "bison/src/bison-derives.o",
    // "bison/src/bison-files.o",
    // "bison/src/bison-fixits.o",
    // "bison/src/bison-getargs.o",
    // "bison/src/bison-glyphs.o",
    // "bison/src/bison-gram.o",
    // "bison/src/bison-graphviz.o",
    // "bison/src/bison-ielr.o",
    // "bison/src/bison-lalr.o",
    // "bison/src/bison-location.o",
    // "bison/src/bison-lr0.o",
    // "bison/src/bison-lssi.o",
    // "bison/src/bison-main.o",
    // "bison/src/bison-muscle-tab.o",
    // "bison/src/bison-named-ref.o",
    // "bison/src/bison-nullable.o",
    // "bison/src/bison-output.o",
    // "bison/src/bison-parse-simulation.o",
    // "bison/src/bison-print-graph.o",
    // "bison/src/bison-print-xml.o",
    // "bison/src/bison-print.o",
    // "bison/src/bison-reader.o",
    // "bison/src/bison-reduce.o",
    // "bison/src/bison-relation.o",
    // "bison/src/bison-scan-code-c.o",
    // "bison/src/bison-scan-gram-c.o",
    // "bison/src/bison-scan-skel-c.o",
    // "bison/src/bison-state.o",
    // "bison/src/bison-state-item.o",
    // "bison/src/bison-strversion.o",
    // "bison/src/bison-symlist.o",
    // "bison/src/bison-symtab.o",
    // "bison/src/bison-tables.o",
    // "bison/src/bison-uniqstr.o",
    // "bison/src/bison-parse-gram.o",
};

var zbison_dir: std.fs.Dir = undefined;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    zbison_dir = std.fs.openDirAbsolute(b.pathFromRoot("bison"), .{}) catch |err| {
        std.debug.print("{any}\n", .{err});
        @panic("no bison dir?!");
    };

    const zbison_pre_build_step = b.step("zbison_pre_build", "bootstrap, configure and pre-build zbison");
    zbison_pre_build_step.makeFn = zbisonPreBuild;

    _ = b.addModule("bison_data", .{ .root_source_file = .{ .path = b.pathFromRoot("bison/data") } });

    const bison_as_lib = b.addStaticLibrary(.{
        .name = "bison_as_lib",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = optimize,
    });

    bison_as_lib.step.dependOn(zbison_pre_build_step);

    b.installArtifact(bison_as_lib);
}

fn zbisonPreBuild(step: *std.Build.Step, node: *std.Progress.Node) anyerror!void {
    _ = node;
    _ = step;
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const allocator = aa.allocator();

    {
        zbison_dir.access("./configure", .{}) catch {
            std.debug.print("no ./configure found in bison src dir, bootstrap it...\n", .{});
            {
                const result = try zcmd.run(.{
                    .allocator = allocator,
                    .commands = &[_][]const []const u8{
                        &[_][]const u8{ "git", "submodule", "update", "--init" },
                    },
                    .cwd_dir = zbison_dir,
                });
                result.assertSucceededPanic(.{ .check_stderr_empty = false });
            }
            {
                const result = try zcmd.run(.{
                    .allocator = allocator,
                    .commands = &[_][]const []const u8{
                        &[_][]const u8{ "bash", "./boostrap" },
                    },
                    .cwd_dir = zbison_dir,
                });
                result.assertSucceededPanic(.{ .check_stderr_empty = false });
            }
        };
    }

    {
        try zbison_dir.access("./configure", .{});
        zbison_dir.access("./Makefile", .{}) catch {
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
                .cwd_dir = zbison_dir,
                .env_map = &envmap,
            });
            result.assertSucceededPanic(.{ .check_stderr_empty = false });
        };
    }

    {
        try zbison_dir.access("./Makefile", .{});
        std.debug.print("make bison ...\n", .{});
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &[_][]const u8{"make"},
            },
            .cwd_dir = zbison_dir,
        });
        _ = result;
        // this may fail because of `doc`
        // result.assertSucceededPanic(.{ .check_stderr_empty = false });
        // just double check we have the binary
        try zbison_dir.access("./src/bison", .{});
    }
}
