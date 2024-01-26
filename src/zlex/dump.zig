const std = @import("std");
const FlexParser = @import("flexParser.zig");

pub fn dump(allocator: std.mem.Allocator, parser: *const FlexParser, stdout_writer: std.fs.File.Writer) !void {
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
