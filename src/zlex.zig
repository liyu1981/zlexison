const std = @import("std");
const FlexParser = @import("zlex/flexParser.zig");
const ParserTpl = @import("zlex/parserTpl.zig");

const usage = "usage: zlex -t [parser_h|parser_zig|parser_yy_c] <input_file_path>";

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

pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    const opts = parseArgs(args) catch {
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
        else => {
            @panic("TODO");
        },
    }

    return 0;
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
    const generated = try ParserTpl.generate(allocator, .{
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
