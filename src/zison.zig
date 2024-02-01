const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");

const usage =
    \\ usage: zison -o <output_file_prefix> <input_file_path>
    \\        zison bison <all_bison_options>
    \\
;

const ZisonRunMode = enum {
    zison,
    zbison,
    bison,
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
    const allocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(allocator);
    defer allocator.free(args);

    opts = parseArgs(args) catch {
        try std.io.getStdErr().writer().print("{s}\n", .{usage});
        std.os.exit(1);
    };

    switch (opts.runMode) {
        .zison => {},
        .zbison => {},
        .bison => {
            @import("zison/runAsBison.zig").runAsBison(args[1..], opts.zison_exe);
        },
    }

    return 0;
}
