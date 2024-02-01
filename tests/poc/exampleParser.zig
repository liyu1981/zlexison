const std = @import("std");

const Parser = @This();

// example.zig.l, line 2
pub const Context = struct {
    num_lines: usize = 0,
    num_chars: usize = 0,
};
context: Context = Context{},

allocator: std.mem.Allocator,
input: ?[]const u8,

pub fn init(args: struct {
    allocator: std.mem.Allocator,
    input: ?[]const u8 = null,
}) Parser {
    return Parser{
        .allocator = args.allocator,
        .input = args.input,
    };
}

pub fn deinit(this: *const Parser) void {
    _ = this;
}

export fn parser_rule_line10(parser_intptr: usize) u32 {
    const parser = @as(*Parser, @ptrFromInt(parser_intptr));
    parser.context.num_lines += 1;
    parser.context.num_chars += 1;
    return 0;
}

export fn parser_rule_line14(parser_intptr: usize) u32 {
    const parser = @as(*Parser, @ptrFromInt(parser_intptr));
    parser.context.num_chars += 1;
    return 0;
}

export fn parser_user_code(parser_ptr: *void) u32 {
    _ = parser_ptr;
    return 0;
}

extern fn setup_parser(parser_intptr: usize) void;
extern fn yylex() void;

pub fn lex(this: *Parser) !void {
    setup_parser(@as(usize, @intFromPtr(this)));
    yylex();
}
