const std = @import("std");
const FlexParser = @import("flexParser.zig");
const ParserTpl = @import("parserTpl.zig");
const genCbName = @import("util.zig").genCbName;

pub fn generateZig(
    allocator: std.mem.Allocator,
    parser: *const FlexParser,
    stdout_writer: std.fs.File.Writer,
    opts: struct {
        input_file_path: []const u8,
    },
) !void {
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
