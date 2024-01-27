const std = @import("std");
const ZlexParser = @import("zlex_parser.zig");

pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    const allocator = std.heap.page_allocator;

    const stdout_writer = std.io.getStdOut().writer();

    var f = try std.fs.cwd().openFile(args[1], .{});
    defer f.close();
    var content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    _ = &content;
    // try stdout_writer.print("read {d}bytes\n", .{content.len});
    defer allocator.free(content);

    var parser = ZlexParser.init(.{
        .allocator = allocator,
        .input = content,
    });
    defer parser.deinit();

    // a hacky usage of lex, as our FlexParser is basically lex as parser
    try parser.lexStart();
    parser.lex();
    parser.lexStop();

    try dump(allocator, &parser, stdout_writer);

    return 0;
}

fn dump(allocator: std.mem.Allocator, parser: *const ZlexParser, stdout_writer: std.fs.File.Writer) !void {
    _ = allocator;
    _ = stdout_writer;
    try dumpCodeBlocks("definition_cbs", &parser.context.definitions_cbs);
    try dumpCodeBlocks("rules_cbs_1", &parser.context.rules_cbs_1);
    try dumpCodeBlocks("rules_action_cbs", &parser.context.rules_action_cbs);
    try dumpCodeBlocks("rules_cbs_2", &parser.context.rules_cbs_2);
    try dumpCodeBlocks("user_cbs", &parser.context.user_cbs);
}

fn dumpCodeBlocks(section: []const u8, cbs: *const std.ArrayList(ZlexParser.Context.CodeBlock)) !void {
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
