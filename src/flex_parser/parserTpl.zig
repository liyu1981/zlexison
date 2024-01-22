const std = @import("std");
const tpl = @import("parserTpl/parser_ztt.zig");
const rule_action_tpl = @import("parserTpl/ruleAction_ztt.zig");

pub fn generate(allocator: std.mem.Allocator, args: struct {
    source_name: []const u8,
    start_condition_consts: ?[]const u8 = null,
    definitions: ?[]const u8 = null,
    rule_actions: ?[]const u8 = null,
    user_code: ?[]const u8 = null,
}) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();

    try tpl.render(str_array.writer(), .{
        .start_condition = if (args.start_condition_consts) |scc| scc else "",
        .source_name = args.source_name,
        .definitions = if (args.definitions) |d| d else "",
        .rule_actions = if (args.rule_actions) |ra| ra else "",
        .user_code = if (args.user_code) |uc| uc else "",
    });

    return str_array.toOwnedSlice();
}

pub fn generateRuleAction(allocator: std.mem.Allocator, name: []const u8, code: []const u8) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();
    try rule_action_tpl.render(str_array.writer(), .{ .name = name, .code = code });
    return str_array.toOwnedSlice();
}
