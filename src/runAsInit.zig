const std = @import("std");
const tpl_zlexison = @embedFile("initTpls/tplZlexison.zig");
const tpl_lexer = @embedFile("initTpls/tplLexer.l");
const tpl_parser = @embedFile("initTpls/tplParser.y");

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
    _ = arena;

    switch (opts.runMode) {
        .zlex => {
            try writeInitLexerFile(opts.output_file_path);
        },
        .zison => {
            try writeInitParserFile(opts.output_file_path);
        },
        .zlexison => {
            try writeInitZlexisonFile(opts.output_file_path);
        },
    }
}

pub inline fn writeInitLexerFile(maybe_lexer_file_path: ?[]const u8) !void {
    try writeInitFile(maybe_lexer_file_path, tpl_lexer);
}

pub inline fn writeInitParserFile(maybe_parser_file_path: ?[]const u8) !void {
    try writeInitFile(maybe_parser_file_path, tpl_parser);
}

pub inline fn writeInitZlexisonFile(maybe_zlexison_file_path: ?[]const u8) !void {
    try writeInitFile(maybe_zlexison_file_path, tpl_zlexison);
}

fn writeInitFile(maybe_output_file_path: ?[]const u8, init_content: []const u8) !void {
    var outf = brk: {
        if (maybe_output_file_path) |ofp| {
            std.fs.cwd().access(ofp, .{}) catch {
                break :brk try std.fs.cwd().createFile(maybe_output_file_path.?, .{});
            };
            std.debug.print("found existing file {s}. exit!", .{maybe_output_file_path.?});
            std.posix.exit(1);
        } else {
            break :brk std.io.getStdOut();
        }
    };
    defer outf.close();
    try outf.writeAll(init_content);
}
