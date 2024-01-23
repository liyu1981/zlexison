const std = @import("std");
const zcmd = @import("zcmd");
const jstring = @import("jstring");

const FlexParser = @import("zlex/flexParser.zig");
const ParserTpl = @import("zlex/parserTpl.zig");

const usage =
    \\ usage: zlex -t [parser_h|parser_zig|parser_yy_c] <input_file_path>
    \\        zlex flex <all_flex_options>
    \\
;

const OutputType = enum(u8) {
    parser_zig,
    parser_h,
    parser_yy_c,
};

const MainOptions = struct {
    input_file_path: []const u8,
    output_type: OutputType,
};

const MainOptionError = error{
    InvalidOption,
};

fn parseArgs(args: [][:0]u8) !MainOptions {
    var r: MainOptions = .{ .input_file_path = "", .output_type = .parser_zig };
    const args1 = args[1..];
    var i: usize = 0;
    if (args1.len == 0) return MainOptionError.InvalidOption;
    if (std.mem.eql(u8, args1[0], "flex")) {
        run_as_flex(args1); // there is no turning back :)
    }
    if (std.mem.eql(u8, args1[0], "exp")) {
        try run_exp(args1);
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
    });
    defer parser.deinit();
    _ = try parser.buffer.yy_scan_bytes(content);

    try parser.lex();

    // try dumpCodeBlocks("definition_cbs", &parser.context.definitions_cbs);
    // try dumpCodeBlocks("rules_cbs_1", &parser.context.rules_cbs_1);
    // try dumpCodeBlocks("rules_action_cbs", &parser.context.rules_action_cbs);
    // try dumpCodeBlocks("rules_cbs_2", &parser.context.rules_cbs_2);
    // try dumpCodeBlocks("user_cbs", &parser.context.user_cbs);

    switch (opts.output_type) {
        .parser_zig => {
            try generateParserZig(allocator, &parser, stdout_writer);
        },
        .parser_h => {
            try generateParserH(allocator, &parser, stdout_writer);
        },
        .parser_yy_c => {
            try generateParserYYc(allocator, &parser, stdout_writer);
        },
    }

    return 0;
}

fn run_exp(args: [][:0]const u8) !void {
    const flex_parser = @import("zlex/flex_parser.zig");
    try flex_parser.parse(args);
    std.os.exit(0);
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

const GenerateCodeBlockHashMap = std.AutoHashMap(usize, FlexParser.Context.CodeBlock);

fn generateParserYYc(allocator: std.mem.Allocator, parser: *const FlexParser, stdout_writer: std.fs.File.Writer) !void {
    const result = try zcmd.run(.{
        .allocator = allocator,
        .commands = &[_][]const []const u8{
            &.{ "flex", "-t", opts.input_file_path },
        },
    });
    defer result.deinit();
    result.assertSucceededPanic(.{});

    // try stdout_writer.print("{s}\n", .{result.trimedStdout()});
    var flex_generated_str = try jstring.JString.newFromSlice(allocator, result.trimedStdout());
    defer flex_generated_str.deinit();
    const flex_generated_lines = try flex_generated_str.split("\n", -1);
    defer jstring.freeJStringArray(flex_generated_lines);
    // try stdout_writer.print("got {d} lines\n", .{flex_generated_lines.len});

    var generated = std.ArrayList(u8).init(allocator);
    defer generated.deinit();

    const codeblocks_map = brk: {
        var m = GenerateCodeBlockHashMap.init(allocator);
        // unfortunately flex's line no starts from 1, not 0
        for (parser.context.definitions_cbs.items) |item| try m.put(item.start.line + 1, item);
        for (parser.context.rules_cbs_1.items) |item| try m.put(item.start.line + 1, item);
        for (parser.context.rules_action_cbs.items) |item| try m.put(item.start.line + 1, item);
        for (parser.context.rules_cbs_2.items) |item| try m.put(item.start.line + 1, item);
        for (parser.context.user_cbs.items) |item| try m.put(item.start.line + 1, item);
        var it = m.keyIterator();
        std.debug.print("keys: ", .{});
        while (it.next()) |k| {
            std.debug.print("{d},", .{k.*});
        }
        std.debug.print("\n", .{});
        break :brk m;
    };

    var i: usize = 0;
    while (i < flex_generated_lines.len) {
        const line = flex_generated_lines[i];
        const is_main_scanner_line = line.startsWithSlice("/** The main scanner function");
        const m = try line.match("^#line (?<line>\\d+) \"(?<file>.+?)\"", 0, true, 0, 0);
        const has_interest = brk: {
            // this line is special, we will use it for inserting zlex_utils.c
            if (is_main_scanner_line) break :brk true;
            // otherwise we try to find : #line <no> "<file>"
            if (m.matchSucceed()) {
                const maybe_line_r = m.getGroupResultByName("line");
                const maybe_file_r = m.getGroupResultByName("file");
                if (maybe_line_r == null or maybe_file_r == null) break :brk false;
                if (maybe_file_r) |file_r| {
                    break :brk std.mem.eql(u8, opts.input_file_path, line.valueOf()[file_r.start .. file_r.start + file_r.len]);
                } else {
                    break :brk false;
                }
            } else {
                break :brk false;
            }
        };
        if (has_interest) {
            const line_no = brk: {
                if (is_main_scanner_line) {
                    break :brk 0;
                } else {
                    const line_r = m.getGroupResultByName("line").?;
                    const line_no_str = line.valueOf()[line_r.start .. line_r.start + line_r.len];
                    break :brk try std.fmt.parseInt(usize, line_no_str, 10);
                }
            };
            const generated_r = try generateYYc(
                allocator,
                parser,
                &codeblocks_map,
                flex_generated_lines,
                line,
                i,
                line_no,
                is_main_scanner_line,
            );
            try generated.appendSlice(generated_r.line);
            i = generated_r.next_i;
            try generated.append('\n');
        } else {
            try generated.appendSlice(line.valueOf());
            try generated.append('\n');
            i += 1;
        }
    }

    try stdout_writer.print("{s}\n", .{generated.items});
}

const GenerateYYcResult = struct {
    line: []const u8,
    next_i: usize,
};

fn generateYYc(
    allocator: std.mem.Allocator,
    parser: *const FlexParser,
    codeblocks_map: *const GenerateCodeBlockHashMap,
    flex_generated_lines: []const jstring.JString,
    line: jstring.JString,
    i: usize,
    line_no: usize,
    is_main_scanner_line: bool,
) !GenerateYYcResult {
    if (is_main_scanner_line) {
        return try generateYYcMainScannerLine(allocator, parser, codeblocks_map, flex_generated_lines, line, i, line_no);
    } else {
        switch (line_no) {
            1 => {
                return try generateYYcLine1(allocator, parser, codeblocks_map, flex_generated_lines, line, i, line_no);
            },
            else => {
                if (codeblocks_map.contains(line_no)) {
                    std.debug.print("will generateYYc for line: {d}\n", .{line_no});
                }
            },
        }
        return .{
            .line = line.valueOf(),
            .next_i = i + 1,
        };
    }
}

fn generateYYcMainScannerLine(
    allocator: std.mem.Allocator,
    parser: *const FlexParser,
    codeblocks_map: *const GenerateCodeBlockHashMap,
    flex_generated_lines: []const jstring.JString,
    line: jstring.JString,
    i: usize,
    line_no: usize,
) !GenerateYYcResult {
    _ = codeblocks_map;
    _ = line_no;
    _ = flex_generated_lines;
    _ = parser;
    var str_arr = std.ArrayList(u8).init(allocator);
    defer str_arr.deinit();
    var writer = str_arr.writer();
    try writer.print("{s}\n{s}\n", .{ try ParserTpl.generateZlexUtilsC(allocator), line });
    return .{
        .line = try str_arr.toOwnedSlice(),
        .next_i = i + 1,
    };
}

fn generateYYcLine1(
    allocator: std.mem.Allocator,
    parser: *const FlexParser,
    codeblocks_map: *const GenerateCodeBlockHashMap,
    flex_generated_lines: []const jstring.JString,
    line: jstring.JString,
    i: usize,
    line_no: usize,
) !GenerateYYcResult {
    _ = codeblocks_map;
    _ = line_no;
    _ = flex_generated_lines;
    _ = parser;
    var str_arr = std.ArrayList(u8).init(allocator);
    defer str_arr.deinit();
    var writer = str_arr.writer();
    const basename = std.fs.path.basename(opts.input_file_path);
    try writer.print("{s}\n{s}\n", .{ line, try ParserTpl.generateYYcHeader(allocator, basename) });
    return .{
        .line = try str_arr.toOwnedSlice(),
        .next_i = i + 1,
    };
}

fn generateParserH(allocator: std.mem.Allocator, parser: *const FlexParser, stdout_writer: std.fs.File.Writer) !void {
    var action_fn_names_arr = std.ArrayList([]const u8).init(allocator);
    defer action_fn_names_arr.deinit();
    var name_buf = std.ArrayList(u8).init(allocator);
    defer name_buf.deinit();
    var buf: [256]u8 = undefined;
    for (parser.context.rules_action_cbs.items) |item| {
        const s = name_buf.items.len;
        const name = try std.fmt.bufPrint(&buf, "line{d}col{d}", .{ item.start.line, item.start.col });
        try name_buf.appendSlice(name);
        const e = name_buf.items.len;
        try action_fn_names_arr.append(name_buf.items[s..e]);
    }

    const generated = try ParserTpl.generateH(allocator, .{ .action_fn_names = action_fn_names_arr.items });
    defer allocator.free(generated);
    try stdout_writer.print("{s}\n", .{generated});
}

fn generateParserZig(allocator: std.mem.Allocator, parser: *const FlexParser, stdout_writer: std.fs.File.Writer) !void {
    const generated = try ParserTpl.generateParser(allocator, .{
        .source_name = "flex.zig.l",
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

fn generateRuleActions(allocator: std.mem.Allocator, parser: *const FlexParser) ![]const u8 {
    var str = std.ArrayList(u8).init(allocator);
    defer str.deinit();
    var writer = str.writer();

    for (parser.context.rules_cbs_1.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{
            item.start.line,
            item.start.col,
            item.end.line,
            item.end.col,
        });
        try writer.print("{s}\n", .{item.content.items});
    }

    var name_buf: [256]u8 = undefined;
    for (parser.context.rules_action_cbs.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{
            item.start.line,
            item.start.col,
            item.end.line,
            item.end.col,
        });
        const name = try std.fmt.bufPrint(&name_buf, "line{d}col{d}", .{ item.start.line, item.start.col });
        const action_str = try ParserTpl.generateRuleAction(allocator, name, item.content.items);
        try writer.print("{s}\n", .{action_str});
    }

    for (parser.context.rules_cbs_2.items) |item| {
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

fn dumpCodeBlocks(section: []const u8, cbs: *std.ArrayList(FlexParser.Context.CodeBlock)) !void {
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
