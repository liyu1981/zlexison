const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");
const util = @import("util.zig");
const runAsM4 = @import("runAsM4.zig");

const usage =
    \\ usage: zison -o <output_file_prefix> <input_file_path>
    \\        zison bison <all_bison_options>
    \\
;

const ZisonRunMode = enum {
    zison,
    zbison,
    bison,
    zm4,
};

const ZisonOptions = struct {
    runMode: ZisonRunMode,
    input_file_path: []const u8,
    outut_file_path: []const u8,
    zison_exe: []const u8 = undefined,
};

const ZisonError = error{
    InvalidOption,
};

fn parseArgs(args: [][:0]u8) !ZisonOptions {
    var r: ZisonOptions = .{
        .runMode = .zison,
        .input_file_path = "",
        .outut_file_path = "",
        .zison_exe = args[0],
    };
    const args1 = args[1..];
    var i: usize = 0;
    if (args1.len == 0) return ZisonError.InvalidOption;

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

    while (i < args1.len) {
        const arg = args1[i];
        if (std.mem.eql(u8, arg, "-o")) {
            if (i + 1 < args1.len) {
                r.outut_file_path = args1[i + 1];
                i += 2;
                continue;
            } else {
                return ZisonError.InvalidOption;
            }
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
    std.os.exit(1);
}

var opts: ZisonOptions = undefined;

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

    var exe_info = try util.getCurrentExeInfo(opts.zison_exe);
    defer exe_info.deinit();

    switch (opts.runMode) {
        .zison => {
            try @import("zison/runAsZison.zig").runAsZison(.{
                .input_file_path = opts.input_file_path,
                .output_file_path = opts.outut_file_path,
                .zison_exe = opts.zison_exe,
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
    }

    return 0;
}
