const std = @import("std");
const FlexParser = @import("flexParser.zig");

pub fn main() !u8 {
    const allocator = std.heap.page_allocator;

    const stdout_writer = std.io.getStdOut().writer();

    var f = try std.fs.cwd().openFile("flex.zig.l", .{});
    defer f.close();
    var content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    _ = &content;
    try stdout_writer.print("read {d}bytes\n", .{content.len});
    defer allocator.free(content);

    var parser = FlexParser.init(.{
        .allocator = allocator,
    });
    defer parser.deinit();
    _ = try parser.buffer.yy_scan_bytes(content);

    try parser.lex();

    try dumpCodeBlocks("definition_cbs", &parser.context.definitions_cbs);
    try dumpCodeBlocks("rules_cbs_1", &parser.context.rules_cbs_1);
    try dumpCodeBlocks("rules_action_cbs", &parser.context.rules_action_cbs);
    try dumpCodeBlocks("rules_cbs_2", &parser.context.rules_cbs_2);
    try dumpCodeBlocks("user_cbs", &parser.context.user_cbs);

    return 0;
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
