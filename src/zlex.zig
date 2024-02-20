const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");
const util = @import("util.zig");
const runAsM4 = @import("runAsM4.zig");
const version = @import("version.zig");

const usage =
    \\ usage: zlex -o <output_file_path> -z <zlexison_file_path> -m <yes/no> <input_file_path>
    \\        zlex flex <all_flex_options>
    \\        zlex --version
    \\
;

const ZlexRunMode = enum {
    zlex,
    zflex,
    flex,
    zm4,
    version,
};

const ZlexOptions = struct {
    runMode: ZlexRunMode,
    input_file_path: []const u8,
    output_file_path: []const u8,
    zlexison_file_path: ?[]const u8,
    zlex_exe: []const u8,
    need_main: bool,
};

const ZlexError = error{
    InvalidOption,
    FlexSyntaxError,
};

fn parseArgs(args: [][:0]u8) !ZlexOptions {
    var r: ZlexOptions = .{
        .runMode = .zlex,
        .input_file_path = "",
        .output_file_path = "",
        .zlexison_file_path = null,
        .zlex_exe = args[0],
        .need_main = true,
    };
    const args1 = args[1..];
    var i: usize = 0;
    if (args1.len == 0) return ZlexError.InvalidOption;

    if (std.mem.eql(u8, args1[0], "flex")) {
        r.runMode = .flex;
        return r;
    }

    if (std.mem.eql(u8, args1[0], "zflex")) {
        r.runMode = .zflex;
        return r;
    }

    if (std.mem.eql(u8, args1[0], "m4")) {
        r.runMode = .zm4;
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
                return ZlexError.InvalidOption;
            }
        }

        if (std.mem.eql(u8, arg, "-z")) {
            if (i + 1 < args1.len) {
                r.zlexison_file_path = args1[i + 1];
                i += 2;
                continue;
            } else {
                return ZlexError.InvalidOption;
            }
        }

        if (std.mem.eql(u8, arg, "-m")) {
            if (i + 1 < args1.len) {
                if (std.mem.eql(u8, args1[i + 1], "yes")) {
                    r.need_main = true;
                } else if (std.mem.eql(u8, args1[i + 1], "no")) {
                    r.need_main = false;
                } else {
                    return ZlexError.InvalidOption;
                }
                i += 2;
                continue;
            } else {
                return ZlexError.InvalidOption;
            }
        }

        if (std.mem.eql(u8, arg, "--version")) {
            r.runMode = .version;
            return r;
        }

        if (r.input_file_path.len > 0) {
            return ZlexError.InvalidOption;
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
    std.os.exit(1);
}

var opts: ZlexOptions = undefined;

pub fn main() !u8 {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    const args = try std.process.argsAlloc(arena);
    defer arena.free(args);

    opts = parseArgs(args) catch {
        try std.io.getStdErr().writer().print("{s}\n", .{usage});
        std.os.exit(1);
    };

    var exe_info = try util.ExeInfo.init(arena);
    defer exe_info.deinit();

    switch (opts.runMode) {
        .version => {
            try printVersion();
        },
        .zlex => {
            @import("zlex/runAsZlex.zig").runAsZlex(.{
                .input_file_path = opts.input_file_path,
                .output_file_path = opts.output_file_path,
                .zlexison_file_path = opts.zlexison_file_path,
                .zlex_exe = opts.zlex_exe,
                .need_main = opts.need_main,
            }) catch |err| {
                printErrAndUsageExit(err);
            };
        },
        .zflex => {
            const m4_path = try runAsM4.ensureZm4(arena, exe_info.dir);
            @import("zlex/runAsZlex.zig").runAsZflex(args[1..], m4_path);
        },
        .flex => {
            const m4_path = try runAsM4.ensureZm4(arena, exe_info.dir);
            @import("zlex/runAsFlex.zig").runAsFlex(args[1..], exe_info.exe_path, m4_path);
        },
        .zm4 => {
            runAsM4.runAsM4(args[1..], opts.zlex_exe);
        },
    }

    return 0;
}

fn printVersion() !void {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();
    const stdout_writer = std.io.getStdOut().writer();

    const flex_version = brk: {
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &[_][]const u8{ opts.zlex_exe, "flex", "--version" },
            },
        });
        defer result.deinit();
        result.assertSucceededPanic(.{});
        var tmpjs = try jstring.JString.newFromSlice(arena, result.trimedStdout());
        const m = try tmpjs.match("zlex-flex (?<v>[^ ]+)", 0, true, 0, 0);
        if (m.matchSucceed()) {
            const maybe_r = m.getGroupResultByName("v");
            if (maybe_r) |r| {
                break :brk tmpjs.valueOf()[r.start .. r.start + r.len];
            }
        }

        std.debug.print("oops! zlex-flex returned: {s}\n", .{tmpjs});
        unreachable;
    };

    try stdout_writer.print("zlex v{s} with flex v{s}\n", .{ version.zlex_version, flex_version });
}
