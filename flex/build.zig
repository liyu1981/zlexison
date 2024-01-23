const std = @import("std");

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
    "-std=c17",
    "-DHAVE_CONFIG_H",
};

const c_flags = [_][]const u8{} ++ common_flags;

const flex_srcs_c = [_][]const u8{
    "flex-2.6.4/src/buf.c",
    "flex-2.6.4/src/ccl.c",
    "flex-2.6.4/src/dfa.c",
    "flex-2.6.4/src/ecs.c",
    "flex-2.6.4/src/filter.c",
    // "flex-2.6.4/src/flexdef.h",
    // "flex-2.6.4/src/flexint.h",
    "flex-2.6.4/src/gen.c",
    "flex-2.6.4/src/main.c",
    "flex-2.6.4/src/misc.c",
    "flex-2.6.4/src/nfa.c",
    "flex-2.6.4/src/options.c",
    "flex-2.6.4/src/options.h",
    // "flex-2.6.4/src/parse.y",
    "flex-2.6.4/src/regex.c",
    "flex-2.6.4/src/scanflags.c",
    "flex-2.6.4/src/scanopt.c",
    "flex-2.6.4/src/scanopt.h",
    "flex-2.6.4/src/skel.c",
    "flex-2.6.4/src/sym.c",
    "flex-2.6.4/src/tables.c",
    "flex-2.6.4/src/tables.h",
    "flex-2.6.4/src/tables_shared.c",
    // "flex-2.6.4/src/tables_shared.h",
    "flex-2.6.4/src/tblcmp.c",
    "flex-2.6.4/src/version.h",
    "flex-2.6.4/src/yylex.c",
    "flex-2.6.4/src/scan.c",
    "flex-2.6.4/src/parse.c",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const flex_as_lib = b.addStaticLibrary(.{
        .name = "flex",
        .target = target,
        .optimize = optimize,
    });
    flex_as_lib.addIncludePath(.{ .path = "flex-2.6.4/src" });
    flex_as_lib.linkSystemLibrary2("m", .{});

    flex_as_lib.addCSourceFiles(.{ .files = &flex_srcs_c, .flags = &c_flags });

    b.installArtifact(flex_as_lib);
}
