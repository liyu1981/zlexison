const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");

const usage =
    \\ usage: zison -o <output_file_prefix> <input_file_path>
    \\        zison -t [h|zig|yyc] -p <prefix> <input_file_path>
    \\        zison bison <all_bison_options>
    \\
;

const OutputType = enum(u8) {
    all,
    zig,
    h,
    yyc,
    sanitize,
    dump_parse,
    dump_generated_l,
};

const ZisonOptions = struct {
    input_file_path: []const u8,
    output_type: OutputType,
    zlex_exe: []const u8 = undefined,
    prefix: ?[]const u8 = null,
    output_file_prefix: ?[]const u8 = null,
};

const ZisonError = error{
    InvalidOption,
    FlexSyntaxError,
};

fn parseArgs(args: [][:0]u8) !ZisonOptions {
    var r: ZisonOptions = .{
        .input_file_path = "",
        .output_type = .all,
    };
    r.zlex_exe = args[0];
    const args1 = args[1..];
    var i: usize = 0;
    if (args1.len == 0) return ZisonError.InvalidOption;
    if (std.mem.eql(u8, args1[0], "bison")) {
        @import("zison/runAsBison.zig").run_as_bison(args1); // there is no turning back :)
    }
    while (i < args1.len) {
        const arg = args1[i];
        if (std.mem.eql(u8, arg, "-t")) {
            if (i + 1 < args1.len) {
                const arg1 = args1[i + 1];
                if (std.meta.stringToEnum(OutputType, arg1)) |e| {
                    r.output_type = e;
                    i += 2;
                    continue;
                } else {
                    return ZisonError.InvalidOption;
                }
            } else {
                return ZisonError.InvalidOption;
            }
        } else if (std.mem.eql(u8, arg, "-p")) {
            if (i + 1 < args1.len) {
                r.prefix = args1[i + 1];
                i += 2;
                continue;
            } else {
                return ZisonError.InvalidOption;
            }
        } else if (std.mem.eql(u8, arg, "-o")) {
            if (i + 1 < args1.len) {
                r.output_file_prefix = args1[i + 1];
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

var opts: ZisonOptions = undefined;

pub fn main() !u8 {
    const allocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(allocator);
    defer allocator.free(args);

    opts = parseArgs(args) catch {
        try std.io.getStdErr().writer().print("{s}\n", .{usage});
        std.os.exit(1);
    };

    return 0;
}
