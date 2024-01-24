const std = @import("std");
const parser_tpl = @import("parserTpl/parser_ztt.zig");
const rule_action_tpl = @import("parserTpl/rule_action_ztt.zig");
const parser_h_tpl = @import("parserTpl/parser_h_ztt.zig");
const zlex_utils_c_tpl = @import("parserTpl/zlex_utils_c_ztt.zig");
const yyc_header_tpl = @import("parserTpl/yyc_header_ztt.zig");
const action_caller_tpl = @import("parserTpl/action_caller_ztt.zig");
const no_action_caller_tpl = @import("parserTpl/no_action_caller_ztt.zig");
const yywrap_etc_tpl = @import("parserTpl/yywrap_etc_ztt.zig");
const zlex_api_tpl = @import("parserTpl/zlex_api_ztt.zig");

pub fn generateParser(allocator: std.mem.Allocator, args: struct {
    prefix: []const u8,
    za: []const u8,
    source_name: []const u8,
    start_condition_consts: ?[]const u8 = null,
    definitions: ?[]const u8 = null,
    rule_actions: ?[]const u8 = null,
    user_code: ?[]const u8 = null,
}) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();

    try parser_tpl.render(str_array.writer(), .{
        .prefix = args.prefix,
        .za = args.za,
        .start_condition = if (args.start_condition_consts) |scc| scc else "",
        .source_name = args.source_name,
        .definitions = if (args.definitions) |d| d else "",
        .rule_actions = if (args.rule_actions) |ra| ra else "",
        .user_code = if (args.user_code) |uc| uc else "",
    });

    return str_array.toOwnedSlice();
}

pub fn generateRuleAction(allocator: std.mem.Allocator, args: struct { prefix: []const u8, name: []const u8, code: []const u8 }) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();
    try rule_action_tpl.render(str_array.writer(), .{
        .prefix = args.prefix,
        .name = args.name,
        .code = args.code,
    });
    return str_array.toOwnedSlice();
}

pub fn generateH(allocator: std.mem.Allocator, args: struct {
    prefix: []const u8,
    action_fn_names: []const []const u8,
}) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();
    try parser_h_tpl.render(str_array.writer(), .{
        .prefix = args.prefix,
        .action_fn_names = args.action_fn_names,
    });
    return str_array.toOwnedSlice();
}

pub fn generateZlexUtilsC(allocator: std.mem.Allocator, args: struct {
    prefix: []const u8,
}) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();
    try zlex_utils_c_tpl.render(str_array.writer(), .{ .prefix = args.prefix });
    return str_array.toOwnedSlice();
}

pub fn generateYYcHeader(allocator: std.mem.Allocator, args: struct {
    prefix: []const u8,
}) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();
    try yyc_header_tpl.render(str_array.writer(), .{
        .prefix = args.prefix,
    });
    return str_array.toOwnedSlice();
}

pub fn generateCodeBlockCaller(allocator: std.mem.Allocator, cb_type: enum { action, not_action }, args: struct {
    prefix: []const u8,
    name: []const u8,
}) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();
    switch (cb_type) {
        .action => {
            try action_caller_tpl.render(str_array.writer(), .{
                .prefix = args.prefix,
                .name = args.name,
            });
        },
        .not_action => {
            try no_action_caller_tpl.render(str_array.writer(), .{
                .prefix = args.prefix,
                .name = args.name,
            });
        },
    }
    return str_array.toOwnedSlice();
}

pub fn generateYywrapEtc(allocator: std.mem.Allocator, args: struct {
    prefix: []const u8,
}) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();
    try yywrap_etc_tpl.render(str_array.writer(), .{
        .prefix = args.prefix,
    });
    return str_array.toOwnedSlice();
}

pub fn generateZlexApi(allocator: std.mem.Allocator, args: struct {
    prefix: []const u8,
}) ![]const u8 {
    var str_array = std.ArrayList(u8).init(allocator);
    defer str_array.deinit();
    try zlex_api_tpl.render(str_array.writer(), .{
        .prefix = args.prefix,
    });
    return str_array.toOwnedSlice();
}
