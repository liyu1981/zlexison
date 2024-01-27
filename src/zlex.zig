const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");

const FlexParser = @import("zlex/flexParser.zig");
const ParserTpl = @import("zlex/parserTpl.zig");

const usage =
    \\ usage: zlex -o <output_file_prefix> <input_file_path>
    \\        zlex -t [h|zig|yyc] -p <prefix> <input_file_path>
    \\        zlex flex <all_flex_options>
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
    dump_2nd_flex,
};

const ZlexOptions = struct {
    input_file_path: []const u8,
    output_type: OutputType,
    zlex_exe: []const u8 = undefined,
    prefix: ?[]const u8 = null,
    output_file_prefix: ?[]const u8 = null,
    do_sanitize: bool = true,
    noline: bool = false,
};

const ZlexError = error{
    InvalidOption,
    FlexSyntaxError,
};

fn parseArgs(args: [][:0]u8) !ZlexOptions {
    var r: ZlexOptions = .{
        .input_file_path = "",
        .output_type = .all,
    };
    r.zlex_exe = args[0];
    const args1 = args[1..];
    var i: usize = 0;
    if (args1.len == 0) return ZlexError.InvalidOption;
    if (std.mem.eql(u8, args1[0], "flex")) {
        @import("zlex/runAsFlex.zig").run_as_flex(args1); // there is no turning back :)
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
                    return ZlexError.InvalidOption;
                }
            } else {
                return ZlexError.InvalidOption;
            }
        } else if (std.mem.eql(u8, arg, "-p")) {
            if (i + 1 < args1.len) {
                r.prefix = args1[i + 1];
                i += 2;
                continue;
            } else {
                return ZlexError.InvalidOption;
            }
        } else if (std.mem.eql(u8, arg, "-o")) {
            if (i + 1 < args1.len) {
                r.output_file_prefix = args1[i + 1];
                i += 2;
                continue;
            } else {
                return ZlexError.InvalidOption;
            }
        } else if (std.mem.eql(u8, arg, "--no-sanitize")) {
            r.do_sanitize = false;
            i += 1;
            continue;
        } else if (std.mem.eql(u8, arg, "--noline")) {
            r.noline = true;
            i += 1;
            continue;
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

var opts: ZlexOptions = undefined;

pub fn main() !u8 {
    const allocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(allocator);
    defer allocator.free(args);

    opts = parseArgs(args) catch {
        try std.io.getStdErr().writer().print("{s}\n", .{usage});
        std.os.exit(1);
    };

    if (opts.output_type == OutputType.all) {
        if (opts.output_file_prefix == null) {
            try std.io.getStdErr().writer().print("{s}\n", .{usage});
            std.os.exit(1);
        }
        return generateAll();
    }

    const stdout_writer = std.io.getStdOut().writer();

    var content = brk: {
        var f = try std.fs.cwd().openFile(opts.input_file_path, .{});
        defer f.close();
        break :brk try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    };
    defer allocator.free(content);
    _ = &content;

    var parser = FlexParser.init(.{ .allocator = allocator, .input = content });
    defer parser.deinit();

    // if provided prefix in cmd opts, use it here
    if (opts.prefix) |prefix| {
        parser.prefix = try parser.allocator.dupe(u8, prefix);
    }

    // a hacky usage of lex, as our FlexParser is basically lex as parser
    try parser.lexStart();
    parser.lex();
    parser.lexStop();

    switch (opts.output_type) {
        .zig => {
            if (opts.do_sanitize) try @import("zlex/sanitize.zig").sanitizeParser(&parser);
            try @import("zlex/generateZig.zig").generateZig(
                allocator,
                &parser,
                stdout_writer,
                .{
                    .input_file_path = opts.input_file_path,
                },
            );
        },
        .h => {
            if (opts.do_sanitize) try @import("zlex/sanitize.zig").sanitizeParser(&parser);
            try @import("zlex/generateH.zig").generateH(
                allocator,
                &parser,
                stdout_writer,
            );
        },
        .yyc => {
            if (opts.do_sanitize) try @import("zlex/sanitize.zig").sanitizeParser(&parser);
            try @import("zlex/generateYYc.zig").generateYYc(
                allocator,
                &parser,
                stdout_writer,
                .{
                    .zlex_exe = opts.zlex_exe,
                    .input_file_path = opts.input_file_path,
                    .noline = opts.noline,
                },
            );
        },
        .sanitize => {
            try @import("zlex/sanitize.zig").sanitizeParser(&parser);
        },
        .dump_parse => {
            try @import("zlex/dump.zig").dump(
                allocator,
                &parser,
                stdout_writer,
            );
        },
        .dump_generated_l => {
            try @import("zlex/generateYYc.zig").generateYYc(
                allocator,
                &parser,
                stdout_writer,
                .{
                    .zlex_exe = opts.zlex_exe,
                    .input_file_path = opts.input_file_path,
                    .stop_after_generate_l = true,
                },
            );
        },
        .dump_2nd_flex => {
            try @import("zlex/generateYYc.zig").generateYYc(
                allocator,
                &parser,
                stdout_writer,
                .{
                    .zlex_exe = opts.zlex_exe,
                    .input_file_path = opts.input_file_path,
                    .stop_after_2nd_flex = true,
                },
            );
        },
        else => {},
    }

    return 0;
}

fn generateAll() !u8 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    // a fake instance, just use for generate prefix
    const parser = FlexParser.init(.{
        .allocator = allocator,
        .input = "",
    });
    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &.{ opts.zlex_exe, "-t", "zig", "-p", parser.prefix, opts.input_file_path },
            },
        });
        result.assertSucceededPanic(.{});
        const zig_file_name = try jstring.JString.newFromFormat(allocator, "{s}.zig", .{opts.output_file_prefix.?});
        var f = try std.fs.cwd().createFile(zig_file_name.valueOf(), .{});
        defer f.close();
        try f.writeAll(result.stdout.?);
    }
    {
        const result = try zcmd.run(.{
            .allocator = allocator,
            .commands = &[_][]const []const u8{
                &.{ opts.zlex_exe, "-t", "yyc", "-p", parser.prefix, opts.input_file_path },
            },
        });
        result.assertSucceededPanic(.{});
        const yyc_file_name = try jstring.JString.newFromFormat(allocator, "{s}.yy.c", .{opts.output_file_prefix.?});
        var f = try std.fs.cwd().createFile(yyc_file_name.valueOf(), .{});
        defer f.close();

        const yyc_final = brk: {
            var js_yyc = try jstring.JString.newFromSlice(allocator, result.stdout.?);
            defer js_yyc.deinit();
            const js_yyc_final1 = try js_yyc.replaceAll("<stdout>", yyc_file_name.valueOf());
            break :brk js_yyc_final1;
        };

        try f.writeAll(yyc_final.valueOf());
    }
    return 0;
}
