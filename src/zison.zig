const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");
const util = @import("util.zig");
const runAsM4 = @import("runAsM4.zig");
const version = @import("version.zig");

const usage =
    \\ usage: zison -o <output_file_path> -m <yes|no> <input_file_path>
    \\        zison init -t <zlex/zison/zlexison> -o <output_file_path>
    \\        zison zlexison -o <output_file_path> <input_file_path>
    \\        zison bison <all_bison_options>
    \\        zison --version
    \\
;

const ZisonRunMode = enum {
    init,
    zison,
    zlexison,
    zbison,
    bison,
    zm4,
    version,
};

const ZisonOptions = struct {
    runMode: ZisonRunMode,
    input_file_path: []const u8,
    output_file_path: []const u8,
    need_main_fn: bool,
    zison_exe: []const u8 = undefined,
};

const ZisonError = error{
    InvalidOption,
};

fn parseArgs(args: [][:0]u8) !ZisonOptions {
    var r: ZisonOptions = .{
        .runMode = .zison,
        .input_file_path = "",
        .output_file_path = "",
        .need_main_fn = false,
        .zison_exe = args[0],
    };
    const args1 = args[1..];
    var i: usize = 0;
    if (args1.len == 0) return ZisonError.InvalidOption;

    if (std.mem.eql(u8, args1[0], "init")) {
        r.runMode = .init;
        return r;
    }

    if (std.mem.eql(u8, args1[0], "bison")) {
        r.runMode = .bison;
        return r;
    }

    if (std.mem.eql(u8, args1[0], "zbison")) {
        r.runMode = .zbison;
        return r;
    }

    if (std.mem.eql(u8, args1[0], "m4")) {
        r.runMode = .zm4;
        return r;
    }

    if (std.mem.eql(u8, args1[0], "zlexison")) {
        r.runMode = .zlexison;
        return r;
    }

    while (i < args1.len) {
        const arg = args1[i];
        if (std.mem.eql(u8, arg, "-o")) {
            if (i + 1 < args1.len) {
                r.output_file_path = args1[i + 1];
                i += 2;
                continue;
            } else {
                return ZisonError.InvalidOption;
            }
        }

        if (std.mem.eql(u8, arg, "-m")) {
            if (i + 1 < args1.len) {
                if (std.mem.eql(u8, args1[i + 1], "yes")) {
                    r.need_main_fn = true;
                } else if (std.mem.eql(u8, args1[i + 1], "no")) {
                    r.need_main_fn = false;
                } else {
                    return ZisonError.InvalidOption;
                }
                i += 2;
                continue;
            } else {
                return ZisonError.InvalidOption;
            }
        }

        if (std.mem.eql(u8, arg, "--version")) {
            r.runMode = .version;
            return r;
        }

        if (r.input_file_path.len > 0) {
            return ZisonError.InvalidOption;
        } else {
            r.input_file_path = arg;
        }
        i += 1;
    }
    return r;
}

fn printErrAndUsageExit(err: anyerror) noreturn {
    std.debug.print("{any}\n", .{err});
    std.debug.print("{s}\n", .{usage});
    std.posix.exit(1);
}

var opts: ZisonOptions = undefined;

pub fn main() !u8 {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    const args = try std.process.argsAlloc(arena);
    defer arena.free(args);

    opts = parseArgs(args) catch |err| {
        printErrAndUsageExit(err);
    };

    var exe_info = try util.ExeInfo.init(arena);
    defer exe_info.deinit();

    switch (opts.runMode) {
        .init => {
            @import("runAsInit.zig").runAsInit(args[1..], opts.zison_exe) catch |err| switch (err) {
                error.InvalidOption => {
                    printErrAndUsageExit(err);
                },
                else => {
                    return err;
                },
            };
        },
        .version => {
            try printVersion();
        },
        .zison => {
            try @import("zison/runAsZison.zig").runAsZison(.{
                .input_file_path = opts.input_file_path,
                .output_file_path = opts.output_file_path,
                .zison_exe = opts.zison_exe,
                .need_main_fn = opts.need_main_fn,
            });
        },
        .zbison => {
            const m4_path = try runAsM4.ensureZm4(arena, exe_info.dir);
            @import("zison/runAsBison.zig").runAsBison(args[1..], .{
                .zison_exe_path = exe_info.exe_path,
                .m4_exe_path = m4_path,
                .bison_rel_pkgdatadir = "share/zison",
            });
        },
        .bison => {
            const m4_path = try runAsM4.ensureZm4(arena, exe_info.dir);
            @import("zison/runAsBison.zig").runAsBison(args[1..], .{
                .zison_exe_path = exe_info.exe_path,
                .m4_exe_path = m4_path,
            });
        },
        .zm4 => {
            runAsM4.runAsM4(args[1..], opts.zison_exe);
        },
        .zlexison => {
            const m4_path = try runAsM4.ensureZm4(arena, exe_info.dir);
            @import("zison/runAsZlexison.zig").runAsZlexison(args[1..], .{
                .zison_exe_path = exe_info.exe_path,
                .m4_exe_path = m4_path,
                .output_file_path = opts.output_file_path,
            }) catch |err| switch (err) {
                ZisonError.InvalidOption => printErrAndUsageExit(err),
                else => return err,
            };
        },
    }

    return 0;
}

fn printVersion() !void {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();
    const stdout_writer = std.io.getStdOut().writer();

    const bison_version = brk: {
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &[_][]const u8{ opts.zison_exe, "bison", "--version" },
            },
        });
        defer result.deinit();
        result.assertSucceededPanic(.{});
        var tmpjs = try jstring.JString.newFromSlice(arena, result.trimedStdout());
        const m = try tmpjs.match("bison \\(GNU Bison\\) (?<v>[^_\\n]+)", 0, true, 0, 0);
        if (m.matchSucceed()) {
            const maybe_r = m.getGroupResultByName("v");
            if (maybe_r) |r| {
                break :brk tmpjs.valueOf()[r.start .. r.start + r.len];
            }
        }

        std.debug.print("oops! zison bison returned: {s}\n", .{tmpjs});
        unreachable;
    };

    try stdout_writer.print("zison v{s} with bison v{s}\n", .{ version.zison_version, bison_version });
}
