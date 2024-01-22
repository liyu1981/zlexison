const std = @import("std");
const FlexParser = @import("flexParser.zig");
const ParserTpl = @import("parserTpl.zig");

pub fn main() !u8 {
    const allocator = std.heap.page_allocator;

    const stdout_writer = std.io.getStdOut().writer();

    var f = try std.fs.cwd().openFile("flex.zig.l", .{});
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

    const generated = try ParserTpl.generate(allocator, .{
        .source_name = "flex.zig.l",
        .start_condition_consts = try generateStartConditionConsts(allocator, &parser),
        .definitions = try generateDefinitions(allocator, &parser),
        .rule_actions = try generateRuleActions(allocator, &parser),
        .user_code = try generateUserCode(allocator, &parser),
    });
    defer allocator.free(generated);

    try stdout_writer.print("{s}\n", .{generated});

    return 0;
}

fn generateStartConditionConsts(allocator: std.mem.Allocator, parser: *FlexParser) ![]const u8 {
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

fn generateDefinitions(allocator: std.mem.Allocator, parser: *FlexParser) ![]const u8 {
    var str = std.ArrayList(u8).init(allocator);
    defer str.deinit();
    var writer = str.writer();
    for (parser.context.definitions_cbs.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{ item.start.line, item.start.col, item.end.line, item.end.col });
        try writer.print("{s}\n", .{item.content.items});
    }
    return str.toOwnedSlice();
}

fn generateRuleActions(allocator: std.mem.Allocator, parser: *FlexParser) ![]const u8 {
    var str = std.ArrayList(u8).init(allocator);
    defer str.deinit();
    var writer = str.writer();

    for (parser.context.rules_cbs_1.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{ item.start.line, item.start.col, item.end.line, item.end.col });
        try writer.print("{s}\n", .{item.content.items});
    }

    var name_buf: [256]u8 = undefined;
    for (parser.context.rules_action_cbs.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{ item.start.line, item.start.col, item.end.line, item.end.col });
        const name = try std.fmt.bufPrint(&name_buf, "line{d}col{d}", .{ item.start.line, item.start.col });
        const action_str = try ParserTpl.generateRuleAction(allocator, name, item.content.items);
        try writer.print("{s}\n", .{action_str});
    }

    for (parser.context.rules_cbs_2.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{ item.start.line, item.start.col, item.end.line, item.end.col });
        try writer.print("{s}\n", .{item.content.items});
    }

    return str.toOwnedSlice();
}

fn generateUserCode(allocator: std.mem.Allocator, parser: *FlexParser) ![]const u8 {
    var str = std.ArrayList(u8).init(allocator);
    defer str.deinit();
    var writer = str.writer();
    for (parser.context.user_cbs.items) |item| {
        try writer.print("// generated from line {d}, col {d} --> line {d}, col {d}\n", .{ item.start.line, item.start.col, item.end.line, item.end.col });
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
