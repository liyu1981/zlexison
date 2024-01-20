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

    try stdout_writer.print("# rules: {d},{d}, loc: {d}:{d}\n", .{
        parser.context.code_blocks_before_rules.items.len,
        parser.context.rule_actions.items.len,
        parser.context.cur_loc.line,
        parser.context.cur_loc.col,
    });

    return 0;
}
