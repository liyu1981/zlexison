const std = @import("std");

const Parser = @This();

const uint_ptr = usize;

pub const ParserError = error{
    InlineCodeBlockInDefinitionSection,
    NoCodeBlockAllowed,

    YYScanStringFailed,
    YYScanBytesFailed,
    YYScanBufferFailed,
};

pub const YYBufferState = struct {
    yy_input_file: uint_ptr, // FILE* as uint_ptr
    yy_ch_buf: [*c]u8, // input buffer
    yy_buf_pos: [*c]u8, // current position in input buffer
    yy_buf_size: i64, // Size of input buffer in bytes, not including room for EOB characters.
    yy_n_chars: i64, // Number of characters read into yy_ch_buf, not including EOB characters.
    yy_is_our_buffer: i64, // Whether we "own" the buffer - i.e., we know we created it,
    // and can realloc() it to grow
    // it, and should free() it to delete it.
    yy_is_interactive: i64, // Whether this is an "interactive" input source; if so, and
    // if we're using stdio for input, then we want to use getc()
    // instead of fread(), to make sure we stop fetching input after
    // each newline.
    yy_at_bol: i64, // Whether we're considered to be at the beginning of a line.
    // If so, '^' rules will be active on the next match, otherwise not.
    yy_bs_lineno: i64, // *< The line count.
    yy_bs_column: i64, // *< The column count.
    yy_fill_buffer: i64, // Whether to try to fill the input buffer when we reach the end of it.
    yy_buffer_status: i64,

    const YY_BUFFER_NEW = 0;
    const YY_BUFFER_NORMAL = 1;
    const YY_BUFFER_EOF_PENDING = 2; // When an EOF's been seen but there's still some text to process
    // then we mark the buffer as YY_EOF_PENDING, to indicate that we
    // shouldn't try reading from the input source any more.  We might
    // still have a bunch of tokens to match, though, because of
    // possible backing-up.
    //
    // When we actually see the EOF, we change the status to "new"
    // (via yyrestart()), so that the user can continue scanning by
    // just pointing yyin at a new input file.
};

pub const StartCondition = struct {
    pub fn BEGIN(this: *const StartCondition, start_condition: usize) void {
        _ = this;
        zlex_begin(start_condition);
    }

    // TODO: this needs to be auto gened
    // #define INITIAL 0
    // #define rule 1
    // #define user_block 2
    // #define code_block 3
    pub const INITIAL = 0;
    pub const rule = 1;
    pub const user_block = 2;
    pub const code_block = 3;
};

// ch14, values available to the user
pub const YY = struct {
    text: [*c]u8 = undefined,
    leng: usize = undefined,
    in: uint_ptr = undefined,
    out: uint_ptr = undefined,
    current_buffer: *YYBufferState = undefined,
    start: usize = undefined,

    pub fn restart(this: *const YY) void {
        _ = this;
    }
};

// ch8, actions
pub const Action = struct {
    pub fn ECHO(this: *const Action) void {
        _ = this;
        zlex_action_echo();
    }

    pub fn BEGIN(this: *const Action) void {
        _ = this;
    }

    pub fn REJECT(this: *const Action) void {
        _ = this;
    }

    pub fn yymore(this: *const Action) void {
        _ = this;
    }

    pub fn yyless(this: *const Action) void {
        _ = this;
    }

    pub fn unput(this: *const Action) void {
        _ = this;
    }

    pub fn input(this: *const Action) ?u8 {
        _ = this;
        const c = zlex_action_input();
        if (c < 0) {
            return null;
        }
        return @as(u8, @intCast(c));
    }

    pub fn YY_FLUSH_BUFFER(this: *const Action) void {
        _ = this;
    }

    pub fn yyterminate(this: *const Action) void {
        _ = this;
    }
};

// TODO: state related function, ch10, start conditions
// void yy_push_state ( int new_state )
// void yy_pop_state ()
// int yy_top_state ()

// TODO: input buffer related functions, ch11
pub const Buffer = struct {
    pub fn yy_create_buffer(this: *const Buffer, f: std.c.FILE, size: usize) *YYBufferState {
        _ = this;
        const yybuf_intptr = zlex_yy_create_buffer(f, size);
        return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
    }

    pub fn yy_switch_to_buffer(this: *const Buffer, new_buffer: *YYBufferState) void {
        _ = this;
        zlex_yy_switch_to_buffer(@as(uint_ptr, @intFromPtr(new_buffer)));
    }

    pub fn yy_delete_buffer(this: *const Buffer, buffer: *YYBufferState) void {
        _ = this;
        zlex_yy_delete_buffer(@as(uint_ptr, @intFromPtr(buffer)));
    }

    pub fn yypush_buffer_state(this: *const Buffer, buffer: *YYBufferState) void {
        _ = this;
        zlex_yypush_buffer_state(@as(uint_ptr, @intFromPtr(buffer)));
    }

    pub fn yypop_buffer_state(this: *const Buffer) void {
        _ = this;
        zlex_yypop_buffer_state();
    }

    pub fn yy_flush_buffer(this: *const Buffer, buffer: *YYBufferState) void {
        _ = this;
        zlex_yy_flush_buffer(@as(uint_ptr, @intFromPtr(buffer)));
    }

    /// yy_new_buffer is an alias for yy_create_buffer(), provided for compatibility with the C++ use of new and delete
    /// for creating and destroying dynamic objects. We will only deal with c so skip it here.
    pub fn yy_new_buffer(this: *const Buffer, file: std.fs.File) YYBufferState {
        _ = this;
        _ = file;
        @compileError("yy_new_buffer in flex is for c++! just use yy_create_buffer.");
    }

    pub fn yy_scan_string(this: *const Buffer, str: []const u8) ParserError!*YYBufferState {
        _ = this;
        const yybuf_intptr = zlex_yy_scan_string(str.ptr);
        if (yybuf_intptr == 0) {
            return ParserError.YYScanStringFailed;
        } else {
            return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
        }
    }

    pub fn yy_scan_bytes(this: *const Buffer, str: []const u8) ParserError!*YYBufferState {
        _ = this;
        const yybuf_intptr = zlex_yy_scan_bytes(str.ptr, str.len);
        if (yybuf_intptr == 0) {
            return ParserError.YYScanBytesFailed;
        } else {
            return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
        }
    }

    pub fn yy_scan_buffer(this: *const Buffer, base: []u8) ParserError!*YYBufferState {
        _ = this;
        const yybuf_intptr = zlex_yy_scan_buffer(base.ptr, base.len);
        if (yybuf_intptr == 0) {
            return ParserError.YYScanBufferFailed;
        } else {
            return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
        }
    }
};

extern fn zlex_yy_create_buffer(f: std.c.FILE, size: usize) uint_ptr;
extern fn zlex_yy_switch_to_buffer(new_buffer: uint_ptr) void;
extern fn zlex_yy_delete_buffer(buffer: uint_ptr) void;
extern fn zlex_yypush_buffer_state(buffer: uint_ptr) void;
extern fn zlex_yypop_buffer_state() void;
extern fn zlex_yy_flush_buffer(buffer: uint_ptr) void;
extern fn zlex_yy_scan_string(str: [*c]const u8) uint_ptr;
extern fn zlex_yy_scan_bytes(str: [*c]const u8, len: usize) uint_ptr;
extern fn zlex_yy_scan_buffer(base: [*c]u8, size: usize) uint_ptr;

// TODO: misc macros, ch13

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
    parser.yy.current_buffer = @as(*YYBufferState, @ptrFromInt(current_buffer_intptr));
    parser.yy.start = start;
}

extern fn zlex_setup_parser(parser_intptr: uint_ptr) void;

extern fn zlex_begin(start_condition: usize) void;
extern fn zlex_action_echo() void;
extern fn zlex_action_input() i8;
extern fn yylex() void;

pub fn lex(this: *Parser) !void {
    zlex_setup_parser(@as(usize, @intFromPtr(this)));
    yylex();
}

allocator: std.mem.Allocator,
input: ?[]const u8,
startCondition: StartCondition = StartCondition{},
yy: YY = YY{},
action: Action = Action{},
buffer: Buffer = Buffer{},

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
    _ = this;
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

    allocator: std.mem.Allocator,

    definitions_cbs: std.ArrayList(CodeBlock),
    rules_cbs_1: std.ArrayList(CodeBlock),
    rules_action_cbs: std.ArrayList(CodeBlock),
    rules_cbs_2: std.ArrayList(CodeBlock),
    user_cbs: std.ArrayList(CodeBlock),

    cur_codeblock: CodeBlock = undefined,
    cur_section: Section = .Definitions,
    cur_loc: Loc = Loc{},
    last_sc: usize = Parser.StartCondition.INITIAL,

    pub fn init(allocator: std.mem.Allocator) Context {
        var c = Context{
            .allocator = allocator,
            .definitions_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_1 = std.ArrayList(CodeBlock).init(allocator),
            .rules_action_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_2 = std.ArrayList(CodeBlock).init(allocator),
            .user_cbs = std.ArrayList(CodeBlock).init(allocator),
        };
        c.cur_codeblock = Parser.Context.CodeBlock.init(&c);
        return c;
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
            parser.startCondition.BEGIN(Parser.StartCondition.rule);
        },
        .Rules => {
            parser.context.cur_section = .UserCode;
            parser.startCondition.BEGIN(Parser.StartCondition.user_block);
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
            parser.context.last_sc = Parser.StartCondition.INITIAL;
        },
        .Rules => {
            if (!parser.context.cur_codeblock.isEmpty()) {
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
            }
            parser.context.last_sc = Parser.StartCondition.rule;
        },
        else => {
            return ParserError.NoCodeBlockAllowed;
        },
    }
    parser.startCondition.BEGIN(Parser.StartCondition.code_block);

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

export fn zlex_parser_rule_line(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_line_impl(parser) catch return 1;
    return 0;
}

fn findRulePatternStop(line: []const u8) ?usize {
    var i: usize = 0;
    while (i < line.len) {
        if ((i + 1) < line.len and line[i] == '\\' and line[i + 1] == ' ') {
            i += 2;
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
