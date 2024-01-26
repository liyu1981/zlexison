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
    "bison/src/parse-gram.c",
};

const bison_lib_srcs_c = [_][]const u8{
    "bison/lib/iconv.c",
    "bison/lib/iconv_open.c",
    "bison/lib/iconv_close.c",
};

const gnulib_objects = [_][]const u8{
    "./bison/lib/libbison_a-mbfile.o",
    "./bison/lib/libbison_a-sprintf.o",
    "./bison/lib/libbison_a-getprogname.o",
    "./bison/lib/libbison_a-gl_linked_list.o",
    "./bison/lib/libbison_a-spawn_faction_addopen.o",
    "./bison/lib/bitset/libbison_a-table.o",
    "./bison/lib/bitset/libbison_a-array.o",
    "./bison/lib/bitset/libbison_a-stats.o",
    "./bison/lib/bitset/libbison_a-vector.o",
    "./bison/lib/bitset/libbison_a-list.o",
    "./bison/lib/libbison_a-fprintf.o",
    "./bison/lib/libbison_a-careadlinkat.o",
    "./bison/lib/libbison_a-integer_length.o",
    "./bison/lib/libbison_a-stat.o",
    "./bison/lib/libbison_a-dirname.o",
    "./bison/lib/libbison_a-pipe2-safer.o",
    "./bison/lib/libbison_a-getopt.o",
    "./bison/lib/libbison_a-path-join.o",
    "./bison/lib/libbison_a-binary-io.o",
    "./bison/lib/libbison_a-strverscmp.o",
    "./bison/lib/libbison_a-canonicalize.o",
    "./bison/lib/libbison_a-stat-time.o",
    "./bison/lib/libbison_a-xmemdup0.o",
    "./bison/lib/libbison_a-getcwd-lgpl.o",
    "./bison/lib/libbison_a-openat-proc.o",
    "./bison/lib/libbison_a-asnprintf.o",
    "./bison/lib/libbison_a-openat-die.o",
    "./bison/lib/libbison_a-wait-process.o",
    "./bison/lib/libbison_a-hash-pjw.o",
    "./bison/lib/libbison_a-stripslash.o",
    "./bison/lib/libbison_a-ialloc.o",
    "./bison/lib/libbison_a-unistd.o",
    "./bison/lib/libbison_a-sig-handler.o",
    "./bison/lib/libbison_a-pipe-safer.o",
    "./bison/lib/libbison_a-spawnattr_destroy.o",
    "./bison/lib/libbison_a-xconcat-filename.o",
    "./bison/lib/libbison_a-spawni.o",
    "./bison/lib/libbison_a-fopen-safer.o",
    "./bison/lib/libbison_a-spawn_faction_addclose.o",
    "./bison/lib/libbison_a-timespec.o",
    "./bison/lib/libbison_a-fopen.o",
    "./bison/lib/libbison_a-basename-lgpl.o",
    "./bison/lib/libbison_a-printf-frexp.o",
    "./bison/lib/libbison_a-xsize.o",
    "./bison/lib/libbison_a-gl_hash_map.o",
    "./bison/lib/libbison_a-xalloc-die.o",
    "./bison/lib/libbison_a-xtime.o",
    "./bison/lib/libbison_a-fpending.o",
    "./bison/lib/libbison_a-open.o",
    "./bison/lib/libbison_a-areadlink.o",
    "./bison/lib/libbison_a-fd-safer-flag.o",
    "./bison/lib/libbison_a-unicodeio.o",
    "./bison/lib/libbison_a-execute.o",
    "./bison/lib/libbison_a-spawn_faction_addchdir.o",
    "./bison/lib/libbison_a-spawnattr_setsigmask.o",
    "./bison/lib/libbison_a-mbswidth.o",
    "./bison/lib/libbison_a-fd-safer.o",
    "./bison/lib/libbison_a-c-ctype.o",
    "./bison/lib/libbison_a-obstack.o",
    "./bison/lib/libbison_a-gl_array_list.o",
    "./bison/lib/libbison_a-memrchr.o",
    "./bison/lib/libbison_a-argmatch.o",
    "./bison/lib/libbison_a-mempcpy.o",
    "./bison/lib/libbison_a-free.o",
    "./bison/lib/libbison_a-save-cwd.o",
    "./bison/lib/libbison_a-gettime.o",
    "./bison/lib/libbison_a-spawn_faction_adddup2.o",
    "./bison/lib/libbison_a-perror.o",
    "./bison/lib/libbison_a-rawmemchr.o",
    "./bison/lib/libbison_a-dup-safer.o",
    "./bison/lib/libbison_a-vfprintf.o",
    "./bison/lib/libbison_a-xreadlink.o",
    "./bison/lib/glthread/libbison_a-lock.o",
    "./bison/lib/glthread/libbison_a-tls.o",
    "./bison/lib/glthread/libbison_a-threadlib.o",
    "./bison/lib/libbison_a-pipe2.o",
    "./bison/lib/libbison_a-vsprintf.o",
    "./bison/lib/libbison_a-fatal-signal.o",
    "./bison/lib/libbison_a-fstatat.o",
    "./bison/lib/libbison_a-findprog-in.o",
    "./bison/lib/libbison_a-fseterr.o",
    "./bison/lib/libbison_a-printf-frexpl.o",
    "./bison/lib/libbison_a-allocator.o",
    "./bison/lib/libbison_a-strchrnul.o",
    "./bison/lib/libbison_a-gethrxtime.o",
    "./bison/lib/libbison_a-c-strncasecmp.o",
    "./bison/lib/libbison_a-strerror_r.o",
    "./bison/lib/libbison_a-malloca.o",
    "./bison/lib/libbison_a-xstrndup.o",
    "./bison/lib/libbison_a-unlink.o",
    "./bison/lib/libbison_a-gl_rbtree_oset.o",
    "./bison/lib/libbison_a-basename.o",
    "./bison/lib/libbison_a-vasnprintf.o",
    "./bison/lib/libbison_a-spawn-pipe.o",
    "./bison/lib/libbison_a-bitset.o",
    "./bison/lib/libbison_a-getopt1.o",
    "./bison/lib/libbison_a-localcharset.o",
    "./bison/lib/libbison_a-strerror-override.o",
    "./bison/lib/libbison_a-gl_xlist.o",
    "./bison/lib/libbison_a-chdir-long.o",
    "./bison/lib/uniwidth/libbison_a-width.o",
    "./bison/lib/libbison_a-closeout.o",
    "./bison/lib/libbison_a-error.o",
    "./bison/lib/libbison_a-snprintf.o",
    "./bison/lib/libbison_a-vsnprintf.o",
    "./bison/lib/libbison_a-wcwidth.o",
    "./bison/lib/libbison_a-file-set.o",
    "./bison/lib/libbison_a-dup-safer-flag.o",
    "./bison/lib/libbison_a-integer_length_l.o",
    "./bison/lib/libbison_a-fstrcmp.o",
    "./bison/lib/libbison_a-openat.o",
    "./bison/lib/libbison_a-readlink.o",
    "./bison/lib/libbison_a-getcwd.o",
    "./bison/lib/libbison_a-gl_list.o",
    "./bison/lib/libbison_a-quotearg.o",
    "./bison/lib/libbison_a-hash-triple-simple.o",
    "./bison/lib/libbison_a-strerror.o",
    "./bison/lib/libbison_a-bitrotate.o",
    "./bison/lib/libbison_a-hash.o",
    "./bison/lib/libbison_a-gl_map.o",
    "./bison/lib/libbison_a-timevar.o",
    "./bison/lib/libbison.a",
    "./bison/lib/libbison_a-exitfail.o",
    "./bison/lib/libbison_a-get-errno.o",
    "./bison/lib/malloc/libbison_a-scratch_buffer_dupfree.o",
    "./bison/lib/malloc/libbison_a-scratch_buffer_grow_preserve.o",
    "./bison/lib/malloc/libbison_a-scratch_buffer_set_array_size.o",
    "./bison/lib/malloc/libbison_a-scratch_buffer_grow.o",
    "./bison/lib/libbison_a-spawnattr_init.o",
    "./bison/lib/libbison_a-canonicalize-lgpl.o",
    "./bison/lib/libbison_a-spawnp.o",
    "./bison/lib/libbison_a-xmalloc.o",
    "./bison/lib/libbison_a-printf-parse.o",
    "./bison/lib/libbison_a-rename.o",
    "./bison/lib/libbison_a-dirname-lgpl.o",
    "./bison/lib/libbison_a-cloexec.o",
    "./bison/lib/libbison_a-lstat.o",
    "./bison/lib/libbison_a-xhash.o",
    "./bison/lib/libbison_a-close-stream.o",
    "./bison/lib/libbison_a-gl_rbtreehash_list.o",
    "./bison/lib/libbison_a-progname.o",
    "./bison/lib/libbison_a-gl_oset.o",
    "./bison/lib/libbison_a-spawn_faction_destroy.o",
    "./bison/lib/libbison_a-concat-filename.o",
    "./bison/lib/libbison_a-spawn_faction_init.o",
    "./bison/lib/libbison_a-spawnattr_setpgroup.o",
    "./bison/lib/libbison_a-obstack_printf.o",
    "./bison/lib/libbison_a-reallocarray.o",
    "./bison/lib/libbison_a-bitsetv.o",
    "./bison/lib/libbison_a-mbchar.o",
    "./bison/lib/libbison_a-c-strcasecmp.o",
    "./bison/lib/libbison_a-gl_xmap.o",
    "./bison/lib/libbison_a-math.o",
    "./bison/lib/libbison_a-vasprintf.o",
    "./bison/lib/libbison_a-spawn.o",
    "./bison/lib/libbison_a-printf-args.o",
    "./bison/lib/libbison_a-spawnattr_setflags.o",
    "./bison/lib/libbison_a-asprintf.o",
    "./bison/lib/unistr/libbison_a-u8-mbtoucr.o",
    "./bison/lib/unistr/libbison_a-u8-uctomb.o",
    "./bison/lib/unistr/libbison_a-u8-uctomb-aux.o",
    "./bison/lib/libbison_a-wctype-h.o",
    "./bison/lib/libbison_a-printf.o",
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
    for (gnulib_objects) |obj| bison_as_lib.addObjectFile(.{ .path = obj });

    bison_as_lib.addCSourceFiles(.{ .files = &bison_srcs_c, .flags = &c_flags });
    bison_as_lib.addCSourceFiles(.{ .files = &bison_lib_srcs_c, .flags = &c_flags });

    b.installArtifact(bison_as_lib);
}