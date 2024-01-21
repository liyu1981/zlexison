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

    try stdout_writer.print("# definitions: {d}, rules_cbs_1: {d}, rules_action_cbs: {d}, rules_cbs_2: {d}, user_code: {d}\n", .{
        parser.context.definitions_cbs.items.len,
        parser.context.rules_cbs_1.items.len,
        parser.context.rules_action_cbs.items.len,
        parser.context.rules_cbs_2.items.len,
        parser.context.user_cbs.items.len,
    });

    return 0;
}
