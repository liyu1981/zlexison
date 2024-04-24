const std = @import("std");

const usage =
    \\ usage: zig run src/calcHash.zig <input_file_path>
    \\
;

const CalcHahsOptions = struct {
    input_file_path: ?[]const u8,
    exe: []const u8 = undefined,
};

fn parseArgs(args: [][:0]u8, comptime OptionsType: type) !OptionsType {
    var r: OptionsType = .{
        .input_file_path = null,
        .exe = args[0],
    };
    const args1 = args[1..];
    var i: usize = 0;
    if (args1.len == 0) return error.InvalidOption;

    while (i < args1.len) {
        const arg = args1[i];

        if (r.input_file_path != null) {
            return error.InvalidOption;
        } else {
            r.input_file_path = arg;
        }
        i += 1;
    }
    return r;
}

var opts: CalcHahsOptions = undefined;

pub fn main() !u8 {
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    const args = try std.process.argsAlloc(arena);
    defer arena.free(args);

    opts = parseArgs(args, CalcHahsOptions) catch {
        try std.io.getStdErr().writer().print("{s}\n", .{usage});
        std.posix.exit(1);
    };

    if (opts.input_file_path == null) {
        try std.io.getStdErr().writer().print("{s}\n", .{usage});
        std.posix.exit(1);
    }

    const cwd = std.fs.cwd();

    var f = brk: {
        if (std.fs.path.isAbsolute(opts.input_file_path.?))
            break :brk try std.fs.openFileAbsolute(opts.input_file_path.?, .{})
        else
            break :brk try cwd.openFile(opts.input_file_path.?, .{});
    };
    const content = try f.readToEndAlloc(arena, std.math.maxInt(usize));
    // can not defer close as later we may need to overwrite it
    defer f.close();
    defer arena.free(content);

    var hash1: [512 / 8]u8 = undefined;
    std.crypto.hash.Blake3.hash(content, &hash1, .{});
    try std.io.getStdOut().writer().print("{s}\n", .{std.fmt.bytesToHex(hash1, .lower)});

    return 0;
}
