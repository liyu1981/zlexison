const std = @import("std");

const RunMode = enum {
    zlex,
    zison,
    zlexison,
};

const InitOptions = struct {
    runMode: RunMode,
    output_file_path: ?[]const u8,
    exe_path: []const u8 = undefined,
};

fn parseArgs(args: [][:0]const u8) !InitOptions {
    var r: InitOptions = .{
        .runMode = .zlexison,
        .output_file_path = null,
    };
    const args1 = args[1..];
    var i: usize = 0;
    if (args1.len == 0) return error.InvalidOption;

    while (i < args1.len) {
        const arg = args1[i];
        if (std.mem.eql(u8, arg, "-o")) {
            if (i + 1 < args1.len) {
                r.output_file_path = args1[i + 1];
                i += 2;
                continue;
            } else {
                return error.InvalidOption;
            }
        }

        if (std.mem.eql(u8, arg, "-t")) {
            if (i + 1 < args1.len) {
                if (std.meta.stringToEnum(RunMode, args1[i + 1])) |m| {
                    r.runMode = m;
                } else {
                    return error.InvalidOption;
                }
                i += 2;
                continue;
            } else {
                return error.InvalidOption;
            }
        }

        i += 1;
    }
    return r;
}

var opts: InitOptions = undefined;

pub fn runAsInit(args: [][:0]const u8, exe_path: []const u8) !void {
    opts = try parseArgs(args);
    opts.exe_path = exe_path;

    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    switch (opts.runMode) {
        .zlex => {},
        .zison => {},
        .zlexison => {
            try writeInitZlexisonFile(arena, opts.output_file_path);
        },
    }
}

const zlexison_file_tpl =
    \\// /* Token kinds.  */
    \\pub const yytoken_kind_t = enum(u32) {
    \\    // EOF must be defined with value 0
    \\    TOK_EOF = 0,
    \\    // first TOK must start from 258, e.g., TOK_NUM = 258
    \\};
    \\// /* Value type.  */
    \\pub const YYSTYPE = struct {
    \\    pub fn default() YYSTYPE {
    \\        return YYSTYPE{};
    \\    }
    \\};
    \\
;

pub fn writeInitZlexisonFile(allocator: std.mem.Allocator, maybe_zlexison_file_path: ?[]const u8) !void {
    _ = allocator;
    var outf = brk: {
        if (maybe_zlexison_file_path) |zfp| {
            std.fs.cwd().access(zfp, .{}) catch {
                break :brk try std.fs.cwd().createFile(maybe_zlexison_file_path.?, .{});
            };
            std.debug.print("found existing zlexison.zig in {s}. exit!", .{maybe_zlexison_file_path.?});
            std.os.exit(1);
        } else {
            break :brk std.io.getStdOut();
        }
    };
    defer outf.close();
    try outf.writeAll(zlexison_file_tpl);
}
