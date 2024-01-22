const std = @import("std");

const Parser = @This();

const ZA = @import("zlexAPI.zig");

const uint_ptr = ZA.uint_ptr;

pub const ParserError = error{
    InlineCodeBlockInDefinitionSection,
    NoCodeBlockAllowed,
    InvalidStartCondition,
} || ZA.YYError;

// TODO: this needs to be auto gened
// #define INITIAL 0
// #define rule 1
// #define user_block 2
// #define code_block 3
pub const SC_INITIAL = 0;
pub const SC_rule = 1;
pub const SC_user_block = 2;
pub const SC_code_block = 3;

export fn zlex_prepare_yy(
    parser_intptr: uint_ptr,
    text: [*c]u8,
    leng: usize,
    in: uint_ptr, // FILE* as uint_ptr
    out: uint_ptr, // FIlE* as uint_ptr
    current_buffer_intptr: uint_ptr,
    start: usize,
) void {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    parser.yy.text = text;
    parser.yy.leng = leng;
    parser.yy.in = in;
    parser.yy.out = out;
    parser.yy.current_buffer = @as(*ZA.YYBufferState, @ptrFromInt(current_buffer_intptr));
    parser.yy.start = start;
}

pub fn lex(this: *Parser) !void {
    ZA.zlex_setup_parser(@as(usize, @intFromPtr(this)));
    ZA.yylex();
}

allocator: std.mem.Allocator,
input: ?[]const u8,
startCondition: ZA.StartCondition = ZA.StartCondition{},
yy: ZA.YY = .{},
action: ZA.Action = .{},
buffer: ZA.Buffer = .{},

context: Context = undefined,

pub fn init(args: struct {
    allocator: std.mem.Allocator,
    input: ?[]const u8 = null,
}) Parser {
    return Parser{
        .allocator = args.allocator,
        .input = args.input,
        .context = Context.init(args.allocator),
    };
}

pub fn deinit(this: *const Parser) void {
    this.context.deinit();
}

pub fn readRestLine(parser: *Parser) ![]u8 {
    var line_array = std.ArrayList(u8).init(parser.allocator);
    defer line_array.deinit();
    var c = parser.action.input();
    while (c != null and c != '\n') {
        try line_array.append(@as(u8, @intCast(c.?)));
        c = parser.action.input();
    }
    return line_array.toOwnedSlice();
}

// generated from .zig.l

// flex.zig.l, line 2
pub const Context = struct {
    pub const Error = error{
        LexSyntaxError,
    };

    const Section = enum {
        Definitions,
        Rules,
        UserCode,
    };
    const Loc = struct {
        line: usize = 0,
        col: usize = 0,
    };
    pub const CodeBlock = struct {
        allocator: std.mem.Allocator,
        content: std.ArrayList(u8),
        start: Loc = Loc{},
        end: Loc = Loc{},

        pub fn init(context: *const Context) CodeBlock {
            return CodeBlock{
                .allocator = context.allocator,
                .content = std.ArrayList(u8).init(context.allocator),
                .start = context.cur_loc,
                .end = context.cur_loc,
            };
        }

        pub fn isEmpty(this: *const CodeBlock) bool {
            return std.mem.trim(u8, this.content.items, " \t\r\n").len == 0;
        }

        pub fn countLines(this: *const CodeBlock) usize {
            var c: usize = 0;
            for (0..this.content.items.len) |i| {
                if (this.content.items[i] == '\n') c += 1;
            }
            return c;
        }

        pub fn lastLineCol(this: *const CodeBlock) usize {
            const maybe_last_newline_pos = std.mem.lastIndexOf(u8, this.content.items, "\n");
            if (maybe_last_newline_pos) |last_newline_pos| {
                return this.content.items.len - last_newline_pos - 1;
            } else {
                return this.content.items.len;
            }
        }
    };
    pub const StartConditionDefinitions = struct {
        names: std.ArrayList([]const u8),
        name_buf: std.ArrayList(u8),
        locs: std.ArrayList(Loc),

        pub fn init(allocator: std.mem.Allocator) StartConditionDefinitions {
            return StartConditionDefinitions{
                .names = std.ArrayList([]const u8).init(allocator),
                .name_buf = std.ArrayList(u8).init(allocator),
                .locs = std.ArrayList(Loc).init(allocator),
            };
        }

        pub fn deinit(this: *const StartConditionDefinitions) void {
            this.names.deinit();
            this.name_buf.deinit();
            this.locs.deinit();
        }
    };

    allocator: std.mem.Allocator,

    start_conditions: StartConditionDefinitions,
    definitions_cbs: std.ArrayList(CodeBlock),
    rules_cbs_1: std.ArrayList(CodeBlock),
    rules_action_cbs: std.ArrayList(CodeBlock),
    rules_cbs_2: std.ArrayList(CodeBlock),
    user_cbs: std.ArrayList(CodeBlock),

    cur_codeblock: CodeBlock = undefined,
    cur_section: Section = .Definitions,
    cur_loc: Loc = Loc{},
    last_sc: usize = SC_INITIAL,

    pub fn init(allocator: std.mem.Allocator) Context {
        var c = Context{
            .allocator = allocator,
            .start_conditions = StartConditionDefinitions.init(allocator),
            .definitions_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_1 = std.ArrayList(CodeBlock).init(allocator),
            .rules_action_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_2 = std.ArrayList(CodeBlock).init(allocator),
            .user_cbs = std.ArrayList(CodeBlock).init(allocator),
        };
        c.start_conditions.name_buf.appendSlice("INITIAL") catch unreachable;
        c.start_conditions.names.append(c.start_conditions.name_buf.items[0..7]) catch unreachable;
        c.start_conditions.locs.append(.{ .line = 0, .col = 0 }) catch unreachable;
        c.cur_codeblock = Parser.Context.CodeBlock.init(&c);
        return c;
    }

    pub fn deinit(this: *const Context) void {
        this.start_conditions.deinit();
        this.definitions_cbs.deinit();
        this.rules_cbs_1.deinit();
        this.rules_action_cbs.deinit();
        this.rules_cbs_2.deinit();
        this.user_cbs.deinit();
    }
};

export fn zlex_parser_section(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_section_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_section_impl(parser: *Parser) !void {
    switch (parser.context.cur_section) {
        .Definitions => {
            parser.context.cur_section = .Rules;
            parser.startCondition.BEGIN(SC_rule);
        },
        .Rules => {
            parser.context.cur_section = .UserCode;
            parser.startCondition.BEGIN(SC_user_block);
        },
        else => {},
    }
    // std.debug.print("\nsection: {any}, line{d}\n", .{ parser.context.cur_section, parser.context.cur_loc.line });
    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zlex_parser_code_block_inline(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_code_block_inline_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_code_block_inline_impl(parser: *Parser) !void {
    parser.context.cur_codeblock.start = .{
        .line = parser.context.cur_loc.line,
        .col = 0,
    };
    parser.context.cur_codeblock.end = .{
        .line = parser.context.cur_loc.line,
        .col = parser.yy.leng,
    };
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);

    switch (parser.context.cur_section) {
        .Definitions => {
            try parser.context.definitions_cbs.append(parser.context.cur_codeblock);
        },
        .Rules => {
            return ParserError.InlineCodeBlockInDefinitionSection;
        },
        else => {},
    }

    // std.debug.print("code block inline:{s} {d},{d}\n", .{ parser.yy.text[0..parser.yy.leng], parser.context.cur_loc.line, parser.context.cur_loc.col });

    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
}

export fn zlex_parser_code_block_start(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_code_block_start_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_code_block_start_impl(parser: *Parser) !void {
    switch (parser.context.cur_section) {
        .Definitions => {
            parser.context.last_sc = SC_INITIAL;
        },
        .Rules => {
            if (!parser.context.cur_codeblock.isEmpty()) {
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
            }
            parser.context.last_sc = SC_rule;
        },
        else => {
            return ParserError.NoCodeBlockAllowed;
        },
    }
    parser.startCondition.BEGIN(SC_code_block);

    // std.debug.print("code block start:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.context.cur_codeblock.start.line = parser.context.cur_loc.line;
    parser.context.cur_codeblock.start.col = parser.yy.leng;
    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zlex_parser_code_block_stop(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_code_block_stop_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_code_block_stop_impl(parser: *Parser) !void {
    switch (parser.context.cur_section) {
        .Definitions => {
            try parser.context.definitions_cbs.append(parser.context.cur_codeblock);
        },
        .Rules => {
            if (parser.context.rules_action_cbs.items.len > 0) {
                try parser.context.rules_cbs_2.append(parser.context.cur_codeblock);
            } else {
                try parser.context.rules_cbs_1.append(parser.context.cur_codeblock);
            }
        },
        else => {
            return ParserError.NoCodeBlockAllowed;
        },
    }

    // std.debug.print("code block stop:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.startCondition.BEGIN(parser.context.last_sc);

    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
}

export fn zlex_parser_code_block_content(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_code_block_content_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_code_block_content_impl(parser: *Parser) !void {
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);
    parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
    parser.context.cur_codeblock.end.col = parser.yy.leng;
    // std.debug.print("code block content:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.context.cur_loc.col += parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zlex_parser_code_block_new_line(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_code_block_new_line_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_code_block_new_line_impl(parser: *Parser) !void {
    try parser.context.cur_codeblock.content.append('\n');
    parser.context.cur_codeblock.end.line += 1;
    parser.context.cur_codeblock.end.col = 0;
    // std.debug.print("code block newline at: {d},{d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

fn extractStartConditionName(line: []const u8) ![]const u8 {
    const s = std.mem.trim(u8, line, " \t\r\n");
    if (s.len == 0) return ParserError.InvalidStartCondition;
    return s;
}

export fn zlex_parser_start_condition(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_start_condition_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_start_condition_impl(parser: *Parser) !void {
    const line = try parser.readRestLine();
    const condition_name = try extractStartConditionName(line);
    // std.debug.print("start condition line: {s}, {s}\n", .{ line, condition_name });
    const s = parser.context.start_conditions.name_buf.items.len;
    try parser.context.start_conditions.name_buf.appendSlice(condition_name);
    const e = parser.context.start_conditions.name_buf.items.len;
    try parser.context.start_conditions.names.append(parser.context.start_conditions.name_buf.items[s..e]);
    try parser.context.start_conditions.locs.append(parser.context.cur_loc);
    // std.debug.print("start condition line: {s}, {s}, {d}\n", .{ line, condition_name, parser.context.start_conditions.names.items.len });
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zlex_parser_rule_line(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_line_impl(parser) catch return 1;
    return 0;
}

fn findRulePatternStop(line: []const u8) ?usize {
    var i: usize = 0;
    var inside_class_braket: bool = false;
    while (i < line.len) {
        if ((i + 1) < line.len and line[i] == '\\' and line[i + 1] == ' ') {
            i += 2;
            continue;
        }
        if (line[i] == '[') inside_class_braket = true;
        if (line[i] == ']') inside_class_braket = false;
        //std.debug.print("\ncheck {d}, {c}, {any}\n", .{ i, line[i], inside_class_braket });
        if (inside_class_braket and line[i] == ' ') {
            i += 1;
            continue;
        }
        if (line[i] == ' ' or line[i] == '\t') return i;
        i += 1;
    }
    return null;
}

fn zlex_parser_rule_line_impl(parser: *Parser) !void {
    const line = parser.yy.text[0..parser.yy.leng];
    const maybe_pattern_stop = findRulePatternStop(line);
    if (maybe_pattern_stop) |pattern_stop| {
        if (pattern_stop == 0) {
            //std.debug.print("rule action line:{s}, {d},{d}\n", .{ line, parser.context.cur_loc.line, parser.context.cur_loc.col });
            try parser.context.cur_codeblock.content.appendSlice(line);
            parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
            parser.context.cur_codeblock.end.col = parser.yy.leng;
        } else {
            const trimed_action_line = std.mem.trimLeft(u8, line[pattern_stop..], " \t");
            const action_line_start = pattern_stop + (line.len - trimed_action_line.len);
            if (!parser.context.cur_codeblock.isEmpty()) {
                // std.debug.print("append last cur_codeblock: {d},{any}\n", .{ parser.context.cur_codeblock.content.items.len, parser.context.cur_codeblock.content.items });
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
                parser.context.cur_codeblock.start.col = action_line_start;
            }
            // std.debug.print("rule pattern with action:{s},{s}, {d},{d} {d},{d}\n", .{ line[0..pattern_stop], line[pattern_stop..], parser.context.cur_loc.line, parser.context.cur_loc.col, parser.context.cur_codeblock.start.line, parser.context.cur_codeblock.start.col });
            try parser.context.cur_codeblock.content.appendSlice(trimed_action_line);
            parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
            parser.context.cur_codeblock.end.col = parser.yy.leng;
        }
    } else {
        if (!parser.context.cur_codeblock.isEmpty()) {
            // std.debug.print("append last cur_codeblock: {d},{any}\n", .{ parser.context.cur_codeblock.content.items.len, parser.context.cur_codeblock.content.items });
            try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
            parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
        }
        // std.debug.print("rule pattern without action:{s}, {d},{d} {d},{d}\n", .{ line, parser.context.cur_loc.line, parser.context.cur_loc.col, parser.context.cur_codeblock.start.line, parser.context.cur_codeblock.start.col });
    }

    // std.debug.print("rule line:{s}, {d},{d}\n", .{ line, parser.context.cur_loc.line, parser.context.cur_loc.col });
    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zlex_parser_rule_new_line(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_new_line_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_rule_new_line_impl(parser: *Parser) !void {
    try parser.context.cur_codeblock.content.append('\n');
    // std.debug.print("rule new line:\n", .{});
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zlex_parser_default_rule(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_default_rule_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_default_rule_impl(parser: *Parser) !void {
    if (parser.yy.leng == 1 and parser.yy.text[0] == '\n') {
        parser.context.cur_loc.line += 1;
        parser.context.cur_loc.col = 0;
    } else {
        parser.context.cur_loc.col += 1;
    }
    // std.debug.print("default now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zlex_parser_user_code_block(parser_ptr: *void) u32 {
    _ = parser_ptr;
    return 0;
}
