const std = @import("std");

const Parser = @This();

const uint_ptr = usize;

const ParserError = error{
    YYScanStringFailed,
    YYScanBytesFailed,
    YYScanBufferFailed,
};

const YYBufferState = struct {
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

const StartCondition = struct {
    pub fn BEGIN(this: *const StartCondition, start_condition: usize) void {
        _ = this;
        zlex_begin(start_condition);
    }

    // TODO: this needs to be auto gened
    pub const INITIAL = 0;
    pub const rule = 1;
    pub const rule_action = 2;
    pub const user_block = 3;
};

// ch14, values available to the user
const YY = struct {
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

    pub fn input(this: *const Action) void {
        _ = this;
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
const Buffer = struct {
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

// generated from .zig.l

// flex.zig.l, line 2
const Context = struct {
    pub const Error = error{
        LexSyntaxError,
    };

    const Scope = enum {
        CodeBlock,
        Comment,
        Flex,
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
    const CodeBlock = struct {
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

        pub fn countLines(this: *const CodeBlock) usize {
            var c: usize = 0;
            for (0..this.content.items.len) |i| {
                if (this.content.items[i] == '\n') c += 1;
            }
            return c;
        }
    };

    allocator: std.mem.Allocator,

    definitions_cbs: std.ArrayList(CodeBlock),
    rules_cbs_1: std.ArrayList(CodeBlock),
    rules_action_cbs: std.ArrayList(CodeBlock),
    rules_cbs_2: std.ArrayList(CodeBlock),
    user_cbs: std.ArrayList(CodeBlock),

    scope_stack: std.ArrayList(Scope),

    cur_codeblock: CodeBlock = undefined,
    cur_section: Section = .Definitions,
    cur_scope: Scope = .Flex,
    cur_loc: Loc = Loc{},

    pub fn init(allocator: std.mem.Allocator) Context {
        var c = Context{
            .allocator = allocator,
            .definitions_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_1 = std.ArrayList(CodeBlock).init(allocator),
            .rules_action_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_2 = std.ArrayList(CodeBlock).init(allocator),
            .user_cbs = std.ArrayList(CodeBlock).init(allocator),
            .scope_stack = std.ArrayList(Scope).init(allocator),
        };
        c.cur_codeblock = Parser.Context.CodeBlock.init(&c);
        return c;
    }
};

export fn zlex_parser_rule_section(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_section_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_rule_section_impl(parser: *Parser) !void {
    // section
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
    std.debug.print("\nsection: {any}\n", .{parser.context.cur_section});
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col += 0;
}

export fn zlex_parser_rule_code_block(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_code_block_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_rule_code_block_impl(parser: *Parser) !void {
    // code block
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);
    parser.context.cur_codeblock.start = parser.context.cur_loc;
    const lines = parser.context.cur_codeblock.countLines();
    parser.context.cur_codeblock.end.line = parser.context.cur_codeblock.start.line + lines;
    parser.context.cur_codeblock.end.col = 0;
    switch (parser.context.cur_section) {
        .Definitions => {
            std.debug.print("\ncode block added to definitions\n", .{});
            try parser.context.definitions_cbs.append(parser.context.cur_codeblock);
        },
        .Rules => {
            if (parser.context.rules_action_cbs.items.len == 0) {
                std.debug.print("\ncode block added to rules_cbs_1\n", .{});
                try parser.context.rules_cbs_1.append(parser.context.cur_codeblock);
            } else {
                std.debug.print("\ncode block added to rules_cbs_2\n", .{});
                try parser.context.rules_cbs_2.append(parser.context.cur_codeblock);
            }
        },
        else => {},
    }

    parser.context.cur_loc.line += lines;
    parser.context.cur_loc.col = 0;
    parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
}

export fn zlex_parser_rule_pattern(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_pattern_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_rule_pattern_impl(parser: *Parser) !void {
    std.debug.print("\nrule: ", .{});
    parser.action.ECHO();
    std.debug.print("\n", .{});
    parser.startCondition.BEGIN(Parser.StartCondition.rule_action);
    parser.context.cur_loc.col += parser.yy.leng;
}

export fn zlex_parser_rule_action_in_newline(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_action_in_newline_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_rule_action_in_newline_impl(parser: *Parser) !void {
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);
    parser.context.cur_loc.col += parser.yy.leng;
}

export fn zlex_parser_rule_action_inline(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_action_inline_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_rule_action_inline_impl(parser: *Parser) !void {
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);
    parser.context.cur_loc.col += parser.yy.leng;
}

export fn zlex_parser_rule_action_new_line(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_action_new_line_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_rule_action_new_line_impl(parser: *Parser) !void {
    parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
    parser.context.cur_codeblock.end.col = parser.context.cur_loc.col + parser.yy.leng;
    try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);

    parser.startCondition.BEGIN(Parser.StartCondition.rule);
    parser.context.cur_loc.col += parser.yy.leng;
    parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
}

export fn zlex_parser_rule_user_code_block(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zlex_parser_rule_user_code_block_impl(parser) catch return 1;
    return 0;
}

fn zlex_parser_rule_user_code_block_impl(parser: *Parser) !void {
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);
    parser.context.cur_codeblock.start = parser.context.cur_loc;
    const lines = parser.context.cur_codeblock.countLines();
    parser.context.cur_codeblock.end.line = parser.context.cur_codeblock.start.line + lines;
    parser.context.cur_codeblock.end.col = 0;
    try parser.context.user_cbs.append(parser.context.cur_codeblock);

    parser.context.cur_loc.line += lines;
    parser.context.cur_loc.col = 0;
    parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
}

export fn zlex_parser_user_code(parser_ptr: *void) u32 {
    _ = parser_ptr;
    return 0;
}
