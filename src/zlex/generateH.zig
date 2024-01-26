const std = @import("std");
const FlexParser = @import("flexParser.zig");
const ParserTpl = @import("parserTpl.zig");

pub fn generateH(allocator: std.mem.Allocator, parser: *const FlexParser, stdout_writer: std.fs.File.Writer) !void {
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
