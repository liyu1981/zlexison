const std = @import("std");
const FlexParser = @import("flex.zig");

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

    var yylval_param: FlexParser.YYSTYPE = .{};
    _ = &yylval_param;
    var yylloc_param: FlexParser.YYLTYPE = .{};
    _ = &yylval_param;

    var lexer = FlexParser{ .allocator = std.heap.page_allocator };

    try FlexParser.yylex_init(&lexer);
    defer FlexParser.yylex_destroy(&lexer);

    _ = try FlexParser.yy_scan_string(content, lexer.yyg);

    // a hacky usage of lex, as our FlexParser is basically lex as parser
    const tk = lexer.yylex(&yylval_param, &yylloc_param) catch |err| {
        std.debug.print("{any}\n", .{err});
        return 1;
    };
    if (tk != FlexParser.YY_TERMINATED) {
        @panic("exit without YY_TERMINATED");
    }

    try dump(allocator, &FlexParser.context, stdout_writer);

    return 0;
}

fn dump(
    allocator: std.mem.Allocator,
    context: *const FlexParser.Context,
    stdout_writer: std.fs.File.Writer,
) !void {
    _ = allocator;
    _ = stdout_writer;
    try dumpCodeBlocks("definition_cbs", &context.definitions_cbs);
    try dumpCodeBlocks("rules_cbs_1", &context.rules_cbs_1);
    try dumpCodeBlocks("rules_action_cbs", &context.rules_action_cbs);
    try dumpCodeBlocks("rules_cbs_2", &context.rules_cbs_2);
    try dumpCodeBlocks("user_cbs", &context.user_cbs);
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
