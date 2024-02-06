const std = @import("std");
const util = @import("util.zig");
const runAsM4 = @import("runAsM4.zig");

const usage =
    \\ usage: zlex -o <output_file_path> <input_file_path>
    \\        zlex flex <all_flex_options>
    \\
;

const ZlexRunMode = enum {
    zlex,
    zflex,
    flex,
    zm4,
};

const ZlexOptions = struct {
    runMode: ZlexRunMode,
    input_file_path: []const u8,
    output_file_path: []const u8,
    zlex_exe: []const u8 = undefined,
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
        .zlex_exe = args[0],
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

    const cwd_dir = try std.process.getCwdAlloc(arena);
    defer arena.free(cwd_dir);

    var exe_info = try util.getCurrentExeInfo(opts.zlex_exe);
    defer exe_info.deinit();

    switch (opts.runMode) {
        .zlex => {
            @import("zlex/runAsZlex.zig").runAsZlex(.{
                .input_file_path = opts.input_file_path,
                .output_file_path = opts.output_file_path,
                .zlex_exe = opts.zlex_exe,
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
