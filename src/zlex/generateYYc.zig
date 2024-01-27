const std = @import("std");
const jstring = @import("jstring");
const zcmd = @import("zcmd");
const FlexParser = @import("flexParser.zig");
const ParserTpl = @import("parserTpl.zig");
const genCbName = @import("util.zig").genCbName;

const GenerateCodeBlockHashMap = std.AutoHashMap(usize, FlexParser.Context.CodeBlock);

pub fn generateYYc(
    allocator: std.mem.Allocator,
    parser: *const FlexParser,
    stdout_writer: std.fs.File.Writer,
    opts: struct {
        zlex_exe: []const u8,
        input_file_path: []const u8,
        noline: bool = false,
        stop_after_generate_l: bool = false,
        stop_after_2nd_flex: bool = false,
    },
) !void {
    var aa = jstring.ArenaAllocator.init(allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    // first we run flex once to find whether this .l file with any syntax problem
    {
        const prefix_opt = try jstring.JString.newFromFormat(arena, "--prefix={s}", .{parser.prefix});
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &.{ opts.zlex_exe, "flex", "-t", prefix_opt.valueOf(), "-R", opts.input_file_path },
            },
        });
        result.assertSucceededPanic(.{ .check_stderr_empty = false });
        if (result.stderr) |se| {
            try std.io.getStdErr().writer().print("{s}\n", .{se});
        }
    }

    // no problem, then try to replace zig codes in .l with generated c code and run flex again
    const generated_parser_h = brk: {
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &.{ opts.zlex_exe, "-t", "h", "-p", parser.prefix, "--no-sanitize", opts.input_file_path },
            },
        });
        result.assertSucceededPanic(.{});
        break :brk result.stdout.?;
    };
    // std.debug.print("\n{s}\n", .{generated_parser_h});

    const CodeBlockType = enum {
        DefinitionCb,
        RulesCb1,
        RulesActionCb,
        RulesCb2,
        UserCodeCb,
    };
    const CodeBlockEntry = struct {
        type: CodeBlockType,
        line_count: usize,
        cb: FlexParser.Context.CodeBlock,
    };
    const CodeBlockHashMap = std.AutoArrayHashMap(usize, CodeBlockEntry);
    const cbmap = brk: {
        var m = CodeBlockHashMap.init(arena);
        for (parser.context.definitions_cbs.items) |cb| try m.put(cb.start.line, .{
            .type = CodeBlockType.DefinitionCb,
            .line_count = cb.end.line - cb.start.line,
            .cb = cb,
        });
        for (parser.context.rules_cbs_1.items) |cb| try m.put(cb.start.line, .{
            .type = CodeBlockType.RulesCb1,
            .line_count = cb.end.line - cb.start.line,
            .cb = cb,
        });
        for (parser.context.rules_action_cbs.items) |cb| try m.put(cb.start.line, .{
            .type = CodeBlockType.RulesActionCb,
            .line_count = cb.end.line - cb.start.line,
            .cb = cb,
        });
        for (parser.context.rules_cbs_2.items) |cb| try m.put(cb.start.line, .{
            .type = CodeBlockType.RulesCb2,
            .line_count = cb.end.line - cb.start.line,
            .cb = cb,
        });
        for (parser.context.user_cbs.items) |cb| try m.put(cb.start.line, .{
            .type = CodeBlockType.UserCodeCb,
            .line_count = cb.end.line - cb.start.line,
            .cb = cb,
        });
        break :brk m;
    };

    const input_file_lines = brk: {
        const f = try std.fs.cwd().openFile(opts.input_file_path, .{});
        defer f.close();
        const s = try f.readToEndAlloc(arena, std.math.maxInt(usize));
        var js = try jstring.JString.newFromSlice(arena, s);
        break :brk try js.split("\n", -1);
    };

    const yyc_header = try ParserTpl.generateYYcHeader(arena, .{ .prefix = parser.prefix });

    var generated_l_file = std.ArrayList(u8).init(arena);
    const generated_writer = generated_l_file.writer();

    try generated_writer.print("{s}\n{s}\n{s}\n{s}\n{s}\n", .{
        "%option reject",
        "%option yymore",
        "%option unput",
        "%option stack",
        "%option yylineno",
    });

    var cur_section: FlexParser.Context.Section = FlexParser.Context.Section.Definitions;
    var i: usize = 0;
    while (i < input_file_lines.len) {
        var line = input_file_lines[i];

        // insert zlex_utils_c right after enter rules section
        if (line.startsWithSlice("%%")) {
            if (cur_section == FlexParser.Context.Section.Definitions) {
                try generated_writer.print("{s}\n", .{line});
                cur_section = FlexParser.Context.Section.Rules;
                i += 1;
                continue;
            } else if (cur_section == FlexParser.Context.Section.Rules) {
                cur_section = FlexParser.Context.Section.UserCode;
                try generated_writer.print("{s}\n", .{line});
                i += 1;
                continue;
            } else {
                // very unlikely as we have validate before, but anyway
                std.debug.print("FlexSyntaxError, really?: {d}", .{i});
                return error.FlexSyntaxError;
            }
        }

        // for first line, insert generated_parser_h before it
        if (i == 0) {
            try generated_l_file.appendSlice("%{\n");
            try generated_writer.print("{s}\n{s}\n", .{ generated_parser_h, yyc_header });
            try generated_l_file.appendSlice("%}\n");
        }

        if (cbmap.get(i)) |cb_entry| {
            switch (cur_section) {
                .Definitions => {
                    i += cb_entry.line_count + 1;
                    continue;
                },
                .Rules => switch (cb_entry.type) {
                    .RulesCb1, .RulesCb2 => {
                        try generated_l_file.appendSlice("%{\n");
                        try generated_writer.print(
                            "{s}\n",
                            .{
                                try ParserTpl.generateCodeBlockCaller(
                                    arena,
                                    .not_action,
                                    .{
                                        .prefix = parser.prefix,
                                        .name = try genCbName(arena, cb_entry.cb),
                                    },
                                ),
                            },
                        );
                        try generated_l_file.appendSlice("%}\n");
                        i += cb_entry.line_count + 1;
                        continue;
                    },
                    .RulesActionCb => {
                        if (cb_entry.line_count == 0) {
                            try generated_writer.print("{s} ", .{line.valueOf()[0 .. cb_entry.cb.start.col - 1]});
                            try generated_l_file.append('{');
                            try generated_writer.print(
                                " {s} ",
                                .{
                                    try ParserTpl.generateCodeBlockCaller(
                                        arena,
                                        .action,
                                        .{
                                            .prefix = parser.prefix,
                                            .name = try genCbName(arena, cb_entry.cb),
                                        },
                                    ),
                                },
                            );
                            try generated_l_file.appendSlice("    }\n");
                            i += 1;
                            continue;
                        } else {
                            try generated_writer.print("{s} ", .{line.valueOf()[0 .. cb_entry.cb.start.col - 1]});
                            try generated_l_file.appendSlice(" {\n");
                            const gened = try ParserTpl.generateCodeBlockCaller(
                                arena,
                                .action,
                                .{
                                    .prefix = parser.prefix,
                                    .name = try genCbName(arena, cb_entry.cb),
                                },
                            );
                            try generated_writer.print(" {s}\n", .{gened});
                            try generated_l_file.appendSlice("    }\n");
                            i += cb_entry.line_count + 1;
                            continue;
                        }
                    },
                    else => {
                        return error.FlexSyntaxError;
                    },
                },
                .UserCode => {
                    try generated_l_file.appendSlice("%{\n");
                    try generated_writer.print(
                        "{s}\n",
                        .{
                            try ParserTpl.generateCodeBlockCaller(
                                arena,
                                .not_action,
                                .{
                                    .prefix = parser.prefix,
                                    .name = try genCbName(arena, cb_entry.cb),
                                },
                            ),
                        },
                    );
                    try generated_l_file.appendSlice("%}\n");
                },
            }
        } else {
            try generated_writer.print("{s}\n", .{line});
            i += 1;
            continue;
        }
    }

    try generated_writer.print(
        "{s}\n",
        .{try ParserTpl.generateYywrapEtc(
            arena,
            .{ .prefix = parser.prefix },
        )},
    );

    if (opts.stop_after_generate_l) {
        try stdout_writer.print("{s}\n", .{generated_l_file.items});
        return;
    }

    // now just rerun flex to the final .yy.c
    const yyc_candidate = brk: {
        const prefix_opt = try jstring.JString.newFromFormat(arena, "--prefix={s}", .{parser.prefix});
        const commands = cmds_brk: {
            if (opts.noline) {
                break :cmds_brk &[_][]const []const u8{
                    &.{ opts.zlex_exe, "flex", "-t", prefix_opt.valueOf(), "-R", "-L" },
                };
            } else {
                break :cmds_brk &[_][]const []const u8{
                    &.{ opts.zlex_exe, "flex", "-t", prefix_opt.valueOf(), "-R" },
                };
            }
        };
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = commands,
            .stdin_input = generated_l_file.items,
        });
        result.assertSucceededPanic(.{});
        break :brk result.stdout.?;
    };

    if (opts.stop_after_2nd_flex) {
        try stdout_writer.print("{s}\n", .{yyc_candidate});
        return;
    }

    // and finally inject zlex_utils_c
    const yyc_final = brk: {
        var arr_buf = std.ArrayList(u8).init(arena);
        const yyc_candidate_js = try jstring.JString.newFromSlice(arena, yyc_candidate);
        const pos = yyc_candidate_js.indexOf("/** The main scanner function which does all the work.", 0);
        const zlex_utils_c = try ParserTpl.generateZlexUtilsC(arena, .{ .prefix = parser.prefix });
        if (pos < 0) {
            // no main scanner line ??!
            unreachable;
        } else {
            try arr_buf.writer().print("{s}\n{s}\n{s}", .{
                yyc_candidate_js.valueOf()[0..@as(usize, @intCast(pos))],
                zlex_utils_c,
                yyc_candidate_js.valueOf()[@as(usize, @intCast(pos))..],
            });
            break :brk try arr_buf.toOwnedSlice();
        }
    };

    var yyc_final_final = brk: {
        var js_yyc = try jstring.JString.newFromSlice(allocator, yyc_final);
        defer js_yyc.deinit();
        var js_yyc_final = try js_yyc.replaceAll("<stdin>", opts.input_file_path);
        _ = &js_yyc_final;
        break :brk js_yyc_final;
    };
    defer yyc_final_final.deinit();

    try stdout_writer.print("{s}\n", .{yyc_final_final});
}
