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
    dump_parse,
    dump_generated_l,
};

const MainOptions = struct {
    input_file_path: []const u8,
    output_type: OutputType,
    prefix: ?[]const u8 = null,
    output_file_prefix: ?[]const u8 = null,
};

const ZlexError = error{
    FlexSyntaxError,
};

const MainOptionError = error{
    InvalidOption,
};

var zlex_exe: []const u8 = undefined;

fn parseArgs(args: [][:0]u8) !MainOptions {
    var r: MainOptions = .{ .input_file_path = "", .output_type = .all };
    zlex_exe = args[0];
    const args1 = args[1..];
    var i: usize = 0;
    if (args1.len == 0) return MainOptionError.InvalidOption;
    if (std.mem.eql(u8, args1[0], "flex")) {
        run_as_flex(args1); // there is no turning back :)
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
                    return MainOptionError.InvalidOption;
                }
            } else {
                return MainOptionError.InvalidOption;
            }
        } else if (std.mem.eql(u8, arg, "-p")) {
            if (i + 1 < args1.len) {
                r.prefix = args1[i + 1];
                i += 2;
                continue;
            } else {
                return MainOptionError.InvalidOption;
            }
        } else if (std.mem.eql(u8, arg, "-o")) {
            if (i + 1 < args1.len) {
                r.output_file_prefix = args1[i + 1];
                i += 2;
                continue;
            } else {
                return MainOptionError.InvalidOption;
            }
        }

        if (r.input_file_path.len > 0) {
            return MainOptionError.InvalidOption;
        } else {
            // std.debug.print("{any}\n", .{@TypeOf(arg)});
            r.input_file_path = arg;
        }
        i += 1;
    }
    return r;
}

var opts: MainOptions = undefined;

pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
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

    const allocator = std.heap.page_allocator;
    const stdout_writer = std.io.getStdOut().writer();

    var f = try std.fs.cwd().openFile(opts.input_file_path, .{});
    defer f.close();
    var content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    _ = &content;
    // try stdout_writer.print("read {d}bytes\n", .{content.len});
    defer allocator.free(content);

    var parser = FlexParser.init(.{
        .allocator = allocator,
        .input = content,
    });
    defer parser.deinit();

    if (opts.prefix) |prefix| {
        parser.prefix = try parser.allocator.dupe(u8, prefix);
    }

    try parser.lex();

    switch (opts.output_type) {
        .zig => {
            try generateParserZig(allocator, &parser, stdout_writer);
        },
        .h => {
            try generateParserH(allocator, &parser, stdout_writer);
        },
        .yyc => {
            try generateParserYYc(allocator, &parser, stdout_writer);
        },
        .dump_parse => {
            try dump(allocator, &parser, stdout_writer);
        },
        .dump_generated_l => {
            generateParserYYc_stop_after_generate_l = true;
            try generateParserYYc(allocator, &parser, stdout_writer);
        },
        else => {},
    }

    return 0;
}

extern fn flex_main(argc: usize, argv: [*c]const u8) u8;

fn run_as_flex(args: [][:0]const u8) void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // later there is no going back, so Cool Guys Don't Look At Explosions
    // defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();
    const argv_buf = arena.allocSentinel(?[*:0]const u8, args.len, null) catch {
        @panic("Oops! OOM!");
    };
    for (args, 0..) |arg, i| {
        const duped = arena.dupeZ(u8, arg) catch {
            @panic("Oops! OOM!");
        };
        argv_buf[i] = duped.ptr;
    }
    std.os.exit(flex_main(
        args.len,
        @as([*c]const u8, @ptrCast(argv_buf.ptr)),
    ));
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
                &.{ zlex_exe, "-t", "zig", "-p", parser.prefix, opts.input_file_path },
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
                &.{ zlex_exe, "-t", "yyc", "-p", parser.prefix, opts.input_file_path },
            },
        });
        result.assertSucceededPanic(.{});
        const yyc_file_name = try jstring.JString.newFromFormat(allocator, "{s}.yy.c", .{opts.output_file_prefix.?});
        var f = try std.fs.cwd().createFile(yyc_file_name.valueOf(), .{});
        defer f.close();
        try f.writeAll(result.stdout.?);
    }
    return 0;
}

const GenerateCodeBlockHashMap = std.AutoHashMap(usize, FlexParser.Context.CodeBlock);

var generateParserYYc_stop_after_generate_l: bool = false;

fn generateParserYYc(allocator: std.mem.Allocator, parser: *const FlexParser, stdout_writer: std.fs.File.Writer) !void {
    var aa = jstring.ArenaAllocator.init(allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    // first we run flex once to find whether this .l file with any syntax problem
    {
        const prefix_opt = try jstring.JString.newFromFormat(arena, "--prefix={s}", .{parser.prefix});
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &.{ zlex_exe, "flex", "-t", prefix_opt.valueOf(), "-R", opts.input_file_path },
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
                &.{ zlex_exe, "-t", "h", "-p", parser.prefix, opts.input_file_path },
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

    try generated_writer.print("{s}\n{s}\n{s}\n{s}\n", .{
        "%option reject",
        "%option yymore",
        "%option unput",
        "%option stack",
    });

    var cur_section: FlexParser.Context.Section = FlexParser.Context.Section.Definitions;
    var i: usize = 0;
    while (i < input_file_lines.len) {
        var line = input_file_lines[i];

        // insert zlex_utils_c right after enter rules section
        if (line.startsWithSlice("%%")) {
            if (cur_section == FlexParser.Context.Section.Definitions) {
                try generated_writer.print("{s}\n", .{line});
                // try generated_l_file.appendSlice("%{\n");
                // try generated_writer.print("{s}\n", .{zlex_utils_c});
                // try generated_l_file.appendSlice("%}\n");
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
                return ZlexError.FlexSyntaxError;
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
                            try generated_writer.print("{s} ", .{line.valueOf()[0..cb_entry.cb.start.col]});
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
                            try generated_l_file.append('}');
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
                        return ZlexError.FlexSyntaxError;
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

    if (generateParserYYc_stop_after_generate_l) {
        try stdout_writer.print("{s}\n", .{generated_l_file.items});
        return;
    }

    // now just rerun flex to the final .yy.c
    const yyc_candidate = brk: {
        const prefix_opt = try jstring.JString.newFromFormat(arena, "--prefix={s}", .{parser.prefix});
        const result = try zcmd.run(.{
            .allocator = arena,
            .commands = &[_][]const []const u8{
                &.{ zlex_exe, "flex", "-t", prefix_opt.valueOf(), "-R" },
            },
            .stdin_input = generated_l_file.items,
        });
        result.assertSucceededPanic(.{});
        break :brk result.stdout.?;
    };

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

    try stdout_writer.print("{s}\n", .{yyc_final});
}

fn generateParserH(allocator: std.mem.Allocator, parser: *const FlexParser, stdout_writer: std.fs.File.Writer) !void {
    var action_fn_names_arr = std.ArrayList([]const u8).init(allocator);
    defer action_fn_names_arr.deinit();
    var name_buf = std.ArrayList(u8).init(allocator);
    defer name_buf.deinit();
    var buf: [256]u8 = undefined;
    for (parser.context.rules_cbs_1.items) |item| {
        const s = name_buf.items.len;
        const name = try std.fmt.bufPrint(&buf, "line{d}col{d}", .{ item.start.line, item.start.col });
        try name_buf.appendSlice(name);
        const e = name_buf.items.len;
        try action_fn_names_arr.append(name_buf.items[s..e]);
    }
    for (parser.context.rules_action_cbs.items) |item| {
        const s = name_buf.items.len;
        const name = try std.fmt.bufPrint(&buf, "line{d}col{d}", .{ item.start.line, item.start.col });
        try name_buf.appendSlice(name);
        const e = name_buf.items.len;
        try action_fn_names_arr.append(name_buf.items[s..e]);
    }
    for (parser.context.rules_cbs_2.items) |item| {
        const s = name_buf.items.len;
        const name = try std.fmt.bufPrint(&buf, "line{d}col{d}", .{ item.start.line, item.start.col });
        try name_buf.appendSlice(name);
        const e = name_buf.items.len;
        try action_fn_names_arr.append(name_buf.items[s..e]);
    }

    const generated = try ParserTpl.generateH(allocator, .{
        .prefix = parser.prefix,
        .action_fn_names = action_fn_names_arr.items,
    });
    defer allocator.free(generated);
    try stdout_writer.print("{s}\n", .{generated});
}

fn generateParserZig(allocator: std.mem.Allocator, parser: *const FlexParser, stdout_writer: std.fs.File.Writer) !void {
    const generated = try ParserTpl.generateParser(allocator, .{
        .prefix = parser.prefix,
        .source_name = opts.input_file_path,
        .za = try ParserTpl.generateZlexApi(allocator, .{ .prefix = parser.prefix }),
        .start_condition_consts = try generateStartConditionConsts(allocator, parser),
        .definitions = try generateDefinitions(allocator, parser),
        .rule_actions = try generateRuleActions(allocator, parser),
        .user_code = try generateUserCode(allocator, parser),
    });
    defer allocator.free(generated);
    try stdout_writer.print("{s}\n", .{generated});
}

fn generateStartConditionConsts(allocator: std.mem.Allocator, parser: *const FlexParser) ![]const u8 {
    var str = std.ArrayList(u8).init(allocator);
    defer str.deinit();
    var writer = str.writer();
    for (0..parser.context.start_conditions.names.items.len) |i| {
        const name = parser.context.start_conditions.names.items[i];
        const loc = parser.context.start_conditions.locs.items[i];
        try writer.print("//generated from line {d}, col {d}\n", .{ loc.line, loc.col });
        try writer.print("pub const SC_{s} = {d};\n", .{ name, i });
    }
    return str.toOwnedSlice();
}

fn generateDefinitions(allocator: std.mem.Allocator, parser: *const FlexParser) ![]const u8 {
    var str = std.ArrayList(u8).init(allocator);
    defer str.deinit();
    var writer = str.writer();
    for (parser.context.definitions_cbs.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{
            item.start.line,
            item.start.col,
            item.end.line,
            item.end.col,
        });
        try writer.print("{s}\n", .{item.content.items});
    }
    return str.toOwnedSlice();
}

fn genCbName(allocator: std.mem.Allocator, cb: FlexParser.Context.CodeBlock) ![]const u8 {
    return std.fmt.allocPrint(allocator, "line{d}col{d}", .{ cb.start.line, cb.start.col });
}

fn generateRuleActions(allocator: std.mem.Allocator, parser: *const FlexParser) ![]const u8 {
    var str = std.ArrayList(u8).init(allocator);
    defer str.deinit();
    var writer = str.writer();

    var all_cbs = std.ArrayList(FlexParser.Context.CodeBlock).init(allocator);
    defer all_cbs.deinit();
    try all_cbs.appendSlice(parser.context.rules_cbs_1.items);
    try all_cbs.appendSlice(parser.context.rules_action_cbs.items);
    try all_cbs.appendSlice(parser.context.rules_cbs_2.items);

    for (all_cbs.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{
            item.start.line,
            item.start.col,
            item.end.line,
            item.end.col,
        });
        const name = try genCbName(allocator, item);
        defer allocator.free(name);
        const action_str = try ParserTpl.generateRuleAction(
            allocator,
            .{
                .prefix = parser.prefix,
                .name = name,
                .code = item.content.items,
            },
        );
        try writer.print("{s}\n", .{action_str});
    }

    return str.toOwnedSlice();
}

fn generateUserCode(allocator: std.mem.Allocator, parser: *const FlexParser) ![]const u8 {
    var str = std.ArrayList(u8).init(allocator);
    defer str.deinit();
    var writer = str.writer();
    for (parser.context.user_cbs.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{
            item.start.line,
            item.start.col,
            item.end.line,
            item.end.col,
        });
        try writer.print("{s}\n", .{item.content.items});
    }
    return str.toOwnedSlice();
}

fn dump(allocator: std.mem.Allocator, parser: *const FlexParser, stdout_writer: std.fs.File.Writer) !void {
    _ = allocator;
    _ = stdout_writer;
    try dumpCodeBlocks("definition_cbs", &parser.context.definitions_cbs);
    try dumpCodeBlocks("rules_cbs_1", &parser.context.rules_cbs_1);
    try dumpCodeBlocks("rules_action_cbs", &parser.context.rules_action_cbs);
    try dumpCodeBlocks("rules_cbs_2", &parser.context.rules_cbs_2);
    try dumpCodeBlocks("user_cbs", &parser.context.user_cbs);
}

fn dumpCodeBlocks(section: []const u8, cbs: *const std.ArrayList(FlexParser.Context.CodeBlock)) !void {
    std.debug.print(">>>>> code blocks of {s}\n", .{section});
    for (cbs.items) |cbs_item| {
        std.debug.print("##### code block: L{d}-C{d} -> L{d}-C{d}\n", .{
            cbs_item.start.line,
            cbs_item.start.col,
            cbs_item.end.line,
            cbs_item.end.col,
        });
        std.debug.print("      content: {s}\n", .{cbs_item.content.items});
    }
}
