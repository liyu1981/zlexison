const std = @import("std");

const common_flags = [_][]const u8{
    "-g",
    "-Wall",
    // "-std=c17",
    "-DEXEEXT=\"\"",
};

const c_flags = [_][]const u8{} ++ common_flags;

const bison_objs = [_][]const u8{
    "bison/src/bison-AnnotationList.o",
    "bison/src/bison-InadequacyList.o",
    "bison/src/bison-Sbitset.o",
    "bison/src/bison-assoc.o",
    "bison/src/bison-closure.o",
    "bison/src/bison-complain.o",
    "bison/src/bison-conflicts.o",
    "bison/src/bison-counterexample.o",
    "bison/src/bison-derivation.o",
    "bison/src/bison-derives.o",
    "bison/src/bison-files.o",
    "bison/src/bison-fixits.o",
    "bison/src/bison-getargs.o",
    "bison/src/bison-glyphs.o",
    "bison/src/bison-gram.o",
    "bison/src/bison-graphviz.o",
    "bison/src/bison-ielr.o",
    "bison/src/bison-lalr.o",
    "bison/src/bison-location.o",
    "bison/src/bison-lr0.o",
    "bison/src/bison-lssi.o",
    "bison/src/bison-main.o",
    "bison/src/bison-muscle-tab.o",
    "bison/src/bison-named-ref.o",
    "bison/src/bison-nullable.o",
    "bison/src/bison-output.o",
    "bison/src/bison-parse-simulation.o",
    "bison/src/bison-print-graph.o",
    "bison/src/bison-print-xml.o",
    "bison/src/bison-print.o",
    "bison/src/bison-reader.o",
    "bison/src/bison-reduce.o",
    "bison/src/bison-relation.o",
    "bison/src/bison-scan-code-c.o",
    "bison/src/bison-scan-gram-c.o",
    "bison/src/bison-scan-skel-c.o",
    "bison/src/bison-state.o",
    "bison/src/bison-state-item.o",
    "bison/src/bison-strversion.o",
    "bison/src/bison-symlist.o",
    "bison/src/bison-symtab.o",
    "bison/src/bison-tables.o",
    "bison/src/bison-uniqstr.o",
    "bison/src/bison-parse-gram.o",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const bison_as_lib = b.addStaticLibrary(.{
        .name = "bison_as_lib",
        .target = target,
        .optimize = optimize,
    });
    bison_as_lib.addIncludePath(.{ .path = "bison" });
    bison_as_lib.addIncludePath(.{ .path = "bison/src" });
    bison_as_lib.addIncludePath(.{ .path = "bison/lib" });

    // unfortunately build bison is tricky because of gnulib
    // so here we first configure & make in bison, it will fail without _main (as we modified it)
    // then we take advantage of all those .o/.a already there

    for (bison_objs) |obj| bison_as_lib.addObjectFile(.{ .path = obj });
    // remember to
    // zison_exe.addObjectFile(.{ .path = "bison/bison/lib/libbison.a" });
    // when link zison

    b.installArtifact(bison_as_lib);
}
