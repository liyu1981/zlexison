const std = @import("std");

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
    "-std=c17",
    "-DHAVE_CONFIG_H",
};

const c_flags = [_][]const u8{} ++ common_flags;

const flex_srcs_c = [_][]const u8{
    "flex/src/buf.c",
    "flex/src/ccl.c",
    "flex/src/dfa.c",
    "flex/src/ecs.c",
    "flex/src/filter.c",
    // "flex/src/flexdef.h",
    // "flex/src/flexint.h",
    "flex/src/gen.c",
    "flex/src/main.c",
    "flex/src/misc.c",
    "flex/src/nfa.c",
    "flex/src/options.c",
    "flex/src/options.h",
    // "flex/src/parse.y",
    "flex/src/regex.c",
    "flex/src/scanflags.c",
    "flex/src/scanopt.c",
    "flex/src/scanopt.h",
    "flex/src/skel.c",
    "flex/src/sym.c",
    "flex/src/tables.c",
    "flex/src/tables.h",
    "flex/src/tables_shared.c",
    // "flex/src/tables_shared.h",
    "flex/src/tblcmp.c",
    "flex/src/version.h",
    "flex/src/yylex.c",
    "flex/src/scan.c",
    "flex/src/parse.c",
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

    b.installArtifact(flex_as_lib);
}
