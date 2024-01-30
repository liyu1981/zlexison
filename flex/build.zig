const std = @import("std");

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
    // "flex/src/zig_skel.c",
    // "flex/src/nfa_zig.c",
    // "flex/src/gen_zig.c",
    "flex/src/main_zig.c",
    // "flex/src/misc_zig.c",
    // "flex/src/parse_zig.c",
    // "flex/src/stage1scan_zig.c",
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
    "flex/src/flex-zig_skel.o",
    "flex/src/flex-nfa_zig.o",
    "flex/src/flex-gen_zig.o",
    // "flex/src/flex-main_zig.o",
    "flex/src/flex-misc_zig.o",
    "flex/src/flex-parse_zig.o",
    "flex/src/flex-stage1scan_zig.o",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const flex_as_lib = b.addStaticLibrary(.{
        .name = "flex_as_lib",
        .target = target,
        .optimize = optimize,
    });
    flex_as_lib.addIncludePath(.{ .path = "flex/src" });
    flex_as_lib.linkSystemLibrary2("m", .{});

    flex_as_lib.addCSourceFiles(.{ .files = &flex_srcs_c, .flags = &c_flags });
    for (flex_objs) |obj| flex_as_lib.addObjectFile(.{ .path = obj });

    b.installArtifact(flex_as_lib);
}
