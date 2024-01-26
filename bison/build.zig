const std = @import("std");

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
    "-std=c17",
};

const c_flags = [_][]const u8{} ++ common_flags;

const bison_srcs_c = [_][]const u8{
    "bison/src/AnnotationList.c",
    "bison/src/InadequacyList.c",
    "bison/src/Sbitset.c",
    "bison/src/assoc.c",
    "bison/src/closure.c",
    "bison/src/complain.c",
    "bison/src/conflicts.c",
    "bison/src/counterexample.c",
    "bison/src/derivation.c",
    "bison/src/derives.c",
    "bison/src/files.c",
    "bison/src/fixits.c",
    "bison/src/getargs.c",
    "bison/src/glyphs.c",
    "bison/src/gram.c",
    "bison/src/graphviz.c",
    "bison/src/ielr.c",
    "bison/src/lalr.c",
    "bison/src/location.c",
    "bison/src/lr0.c",
    "bison/src/lssi.c",
    "bison/src/main.c",
    "bison/src/muscle-tab.c",
    "bison/src/named-ref.c",
    "bison/src/nullable.c",
    "bison/src/output.c",
    "bison/src/parse-simulation.c",
    "bison/src/print-graph.c",
    "bison/src/print-xml.c",
    "bison/src/print.c",
    "bison/src/reader.c",
    "bison/src/reduce.c",
    "bison/src/relation.c",
    "bison/src/scan-code-c.c",
    "bison/src/scan-gram-c.c",
    "bison/src/scan-skel-c.c",
    "bison/src/state.c",
    "bison/src/state-item.c",
    "bison/src/strversion.c",
    "bison/src/symlist.c",
    "bison/src/symtab.c",
    "bison/src/tables.c",
    "bison/src/uniqstr.c",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const bison_as_lib = b.addStaticLibrary(.{
        .name = "libbison",
        .target = target,
        .optimize = optimize,
    });
    bison_as_lib.addIncludePath(.{ .path = "bison" });
    bison_as_lib.addIncludePath(.{ .path = "bison/src" });
    bison_as_lib.addIncludePath(.{ .path = "bison/lib" });
    bison_as_lib.linkSystemLibrary2("m", .{});

    bison_as_lib.addCSourceFiles(.{ .files = &bison_srcs_c, .flags = &c_flags });

    b.installArtifact(bison_as_lib);
}
