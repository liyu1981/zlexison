const std = @import("std");

const Parser = @This();

pub const uint_ptr = usize;

const ZA = struct {
    pub var zyy_yyg_intptr: uint_ptr = undefined;

    pub const YYError = error{
        YYScanStringFailed,
        YYScanBytesFailed,
        YYScanBufferFailed,
    };

    pub const YYGuts = extern struct {
        // /* User-defined. Not touched by flex. */
        // YY_EXTRA_TYPE yyextra_r;

        yyin_r: *std.c.FILE,
        yyout_r: *std.c.FILE,
        yy_buffer_stack_top: isize, // /**< index of top of stack. */
        yy_buffer_stack_max: isize, // /**< capacity of stack. */
        yy_buffer_stack: *YYBufferState, // /**< Stack as an array. */
        yy_hold_char: u8,
        yy_n_chars: c_int,
        yyleng_r: c_int,
        yy_c_buf_p: [*c]i8,
        yy_init: c_int,
        yy_start: c_int,
        yy_did_buffer_switch_on_eof: c_int,
        yy_start_stack_ptr: c_int,
        yy_start_stack_depth: c_int,
        yy_start_stack: *c_int,
        yy_last_accepting_state: c_int,
        yy_last_accepting_cpos: [*c]i8,

        yylineno_r: c_int,
        yy_flex_debug_r: c_int,

        yytext_r: [*c]i8,
        yy_more_flag: c_int,
        yy_more_len: c_int,
    };

    pub const YYBufferState = extern struct {
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
            zyy_start_condition_begin(zyy_yyg_intptr, start_condition);
        }

        pub fn yy_push_state(this: *const StartCondition, new_state: usize) void {
            _ = this;
            zyy_start_condition_yy_push_state(zyy_yyg_intptr, new_state);
        }

        pub fn yy_pop_state(this: *const StartCondition) void {
            _ = this;
            zyy_start_condition_yy_pop_state(zyy_yyg_intptr);
        }

        pub fn yy_top_state(this: *const StartCondition) usize {
            _ = this;
            return zyy_start_condition_yy_top_state(zyy_yyg_intptr);
        }
    };

    // ch14, values available to the user
    pub const YY = struct {
        yyg: uint_ptr = undefined,
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
            zyy_action_echo(zyy_yyg_intptr);
        }

        pub fn REJECT(this: *const Action) void {
            // TODO:
            _ = this;
        }

        pub fn yymore(this: *const Action) void {
            // TODO:
            _ = this;
        }

        pub fn yyless(this: *const Action, n: usize) void {
            // TODO:
            _ = this;
            _ = n;
            // zyy_action_yyless(zyy_yyg_intptr, n);
        }

        pub fn unput(this: *const Action, c: u8) void {
            _ = this;
            zyy_action_unput(zyy_yyg_intptr, c);
        }

        pub fn input(this: *const Action) ?u8 {
            _ = this;
            const c = zyy_action_input(zyy_yyg_intptr);
            if (c < 0) {
                return null;
            }
            return @as(u8, @intCast(c));
        }

        pub fn YY_FLUSH_BUFFER(this: *const Action) void {
            _ = this;
            zyy_action_YY_FLUSH_BUFFER(zyy_yyg_intptr);
        }

        pub fn yyterminate(this: *const Action) void {
            // TODO:
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
            const yybuf_intptr = zyy_yy_create_buffer(zyy_yyg_intptr, f, size);
            return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
        }

        pub fn yy_switch_to_buffer(this: *const Buffer, new_buffer: *YYBufferState) void {
            _ = this;
            zyy_yy_switch_to_buffer(zyy_yyg_intptr, @as(uint_ptr, @intFromPtr(new_buffer)));
        }

        pub fn yy_delete_buffer(this: *const Buffer, buffer: *YYBufferState) void {
            _ = this;
            zyy_yy_delete_buffer(zyy_yyg_intptr, @as(uint_ptr, @intFromPtr(buffer)));
        }

        pub fn yypush_buffer_state(this: *const Buffer, buffer: *YYBufferState) void {
            _ = this;
            zyy_yypush_buffer_state(zyy_yyg_intptr, @as(uint_ptr, @intFromPtr(buffer)));
        }

        pub fn yypop_buffer_state(this: *const Buffer) void {
            _ = this;
            zyy_yypop_buffer_state(zyy_yyg_intptr);
        }

        pub fn yy_flush_buffer(this: *const Buffer, buffer: *YYBufferState) void {
            _ = this;
            zyy_yy_flush_buffer(zyy_yyg_intptr, @as(uint_ptr, @intFromPtr(buffer)));
        }

        /// yy_new_buffer is an alias for yy_create_buffer(), provided for compatibility with the C++ use of new and delete
        /// for creating and destroying dynamic objects. We will only deal with c so skip it here.
        pub fn yy_new_buffer(this: *const Buffer, file: std.fs.File) YYBufferState {
            _ = this;
            _ = file;
            @compileError("yy_new_buffer in flex is for c++! just use yy_create_buffer.");
        }

        pub fn yy_scan_string(this: *const Buffer, str: []const u8) YYError!*YYBufferState {
            _ = this;
            const yybuf_intptr = zyy_yy_scan_string(zyy_yyg_intptr, str.ptr);
            if (yybuf_intptr == 0) {
                return YYError.YYScanStringFailed;
            } else {
                return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
            }
        }

        pub fn yy_scan_bytes(this: *const Buffer, str: []const u8) YYError!*YYBufferState {
            _ = this;
            const yybuf_intptr = zyy_yy_scan_bytes(zyy_yyg_intptr, str.ptr, str.len);
            if (yybuf_intptr == 0) {
                return YYError.YYScanBytesFailed;
            } else {
                return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
            }
        }

        pub fn yy_scan_buffer(this: *const Buffer, base: []u8) YYError!*YYBufferState {
            _ = this;
            const yybuf_intptr = zyy_yy_scan_buffer(zyy_yyg_intptr, base.ptr, base.len);
            if (yybuf_intptr == 0) {
                return YYError.YYScanBufferFailed;
            } else {
                return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
            }
        }
    };

    pub extern fn zyy_yy_create_buffer(yyg_intptr: uint_ptr, f: std.c.FILE, size: usize) uint_ptr;
    pub extern fn zyy_yy_switch_to_buffer(yyg_intptr: uint_ptr, new_buffer: uint_ptr) void;
    pub extern fn zyy_yy_delete_buffer(yyg_intptr: uint_ptr, buffer: uint_ptr) void;
    pub extern fn zyy_yypush_buffer_state(yyg_intptr: uint_ptr, buffer: uint_ptr) void;
    pub extern fn zyy_yypop_buffer_state(yyg_intptr: uint_ptr) void;
    pub extern fn zyy_yy_flush_buffer(yyg_intptr: uint_ptr, buffer: uint_ptr) void;
    pub extern fn zyy_yy_scan_string(yyg_intptr: uint_ptr, str: [*c]const u8) uint_ptr;
    pub extern fn zyy_yy_scan_bytes(yyg_intptr: uint_ptr, str: [*c]const u8, len: usize) uint_ptr;
    pub extern fn zyy_yy_scan_buffer(yyg_intptr: uint_ptr, base: [*c]u8, size: usize) uint_ptr;

    // TODO: misc macros, ch13

    pub extern fn zyy_setup_parser(parser_intptr: uint_ptr) void;

    pub extern fn zyy_start_condition_begin(yyg_intptr: uint_ptr, start_condition: usize) void;
    pub extern fn zyy_start_condition_yy_push_state(yyg_intptr: uint_ptr, new_state: usize) void;
    pub extern fn zyy_start_condition_yy_pop_state(yyg_intptr: uint_ptr) void;
    pub extern fn zyy_start_condition_yy_top_state(yyg_intptr: uint_ptr) usize;

    pub extern fn zyy_action_echo(yyg_intptr: uint_ptr) void;
    pub extern fn zyy_action_input(yyg_intptr: uint_ptr) c_int;
    pub extern fn zyy_action_unput(yyg_intptr: uint_ptr, c: u8) void;
    pub extern fn zyy_action_YY_FLUSH_BUFFER(yyg_intptr: uint_ptr) void;

    pub extern fn zyylex_init(yyg: [*c]?*anyopaque) c_int;
    pub extern fn zyylex(yyg: ?*anyopaque) c_int;
    pub extern fn zyylex_destroy(yyg: ?*anyopaque) c_int;
};

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

export fn zyy_prepare_yy(
    parser_intptr: uint_ptr,
    yyg: uint_ptr,
    text: [*c]u8,
    leng: usize,
    in: uint_ptr, // FILE* as uint_ptr
    out: uint_ptr, // FIlE* as uint_ptr
    current_buffer_intptr: uint_ptr,
    start: usize,
) void {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    parser.yy.yyg = yyg;
    // copy twice to avoid circular import
    ZA.zyy_yyg_intptr = yyg;
    parser.yy.text = text;
    parser.yy.leng = leng;
    parser.yy.in = in;
    parser.yy.out = out;
    parser.yy.current_buffer = @as(*ZA.YYBufferState, @ptrFromInt(current_buffer_intptr));
    parser.yy.start = start;
}

pub fn lex(this: *Parser) !void {
    ZA.zyy_setup_parser(@as(usize, @intFromPtr(this)));
    _ = ZA.zyylex_init(@as([*c]?*anyopaque, @ptrCast(&this.yy.yyg)));

    // TODO: this is ugly...
    Parser.ZA.zyy_yyg_intptr = this.yy.yyg;

    if (this.input) |input| {
        _ = try this.buffer.yy_scan_bytes(input);
    }

    _ = ZA.zyylex(@as(?*anyopaque, @ptrFromInt(this.yy.yyg)));
    _ = ZA.zyylex_destroy(@as(?*anyopaque, @ptrFromInt(this.yy.yyg)));
}

allocator: std.mem.Allocator,
input: ?[]const u8,
prefix: []const u8,
startCondition: ZA.StartCondition = ZA.StartCondition{},
yy: ZA.YY = .{},
action: ZA.Action = .{},
buffer: ZA.Buffer = .{},

context: Context = undefined,

pub fn init(args: struct {
    allocator: std.mem.Allocator,
    input: ?[]const u8 = null,
    prefix: ?[]const u8 = null,
}) Parser {
    return Parser{
        .allocator = args.allocator,
        .input = args.input,
        .context = Context.init(args.allocator),
        .prefix = brk: {
            if (args.prefix) |prefix| {
                if (std.mem.startsWith(u8, prefix, "0123456789")) {
                    @panic("parser prefix can not start with digits");
                }
                if (std.mem.containsAtLeast(u8, prefix, 1, " \t\r\n")) {
                    @panic("parser prefix can not contain spaces or newlines");
                }
                const trimed = std.mem.trim(u8, prefix, " \t\r\n");
                if (trimed.len == 0) {
                    @panic("parser prefix can not be empty or string with only spaces.");
                }
                break :brk args.allocator.dupe(u8, trimed) catch @panic("OOM!");
            }

            var buf_arr = std.ArrayList(u8).init(args.allocator);
            defer buf_arr.deinit();
            buf_arr.writer().print("zyy{d}", .{std.time.microTimestamp()}) catch @panic("OOM!");
            break :brk buf_arr.toOwnedSlice() catch @panic("OOM!");
        },
    };
}

pub fn deinit(this: *const Parser) void {
    this.context.deinit();
    this.allocator.free(this.prefix);
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

    pub const Section = enum {
        Definitions,
        Rules,
        UserCode,
    };
    pub const Loc = struct {
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

        pub fn reset(this: *CodeBlock, context: *const Context) void {
            this.content.clearAndFree();
            this.start = context.cur_loc;
            this.end = context.cur_loc;
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

fn extractStartConditionName(line: []const u8) ![]const u8 {
    const s = std.mem.trim(u8, line, " \t\r\n");
    if (s.len == 0) return ParserError.InvalidStartCondition;
    return s;
}

export fn zyy_parser_section(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_section_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_section_impl(parser: *Parser) !void {
    switch (parser.context.cur_section) {
        .Definitions => {
            parser.context.cur_codeblock.reset(&parser.context);
            parser.context.cur_section = .Rules;
            parser.startCondition.BEGIN(SC_rule);
        },
        .Rules => {
            if (!parser.context.cur_codeblock.isEmpty()) {
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
            }
            parser.context.cur_section = .UserCode;
            parser.startCondition.BEGIN(SC_user_block);
        },
        else => {},
    }
    // std.debug.print("\nsection: {any}, line{d}\n", .{ parser.context.cur_section, parser.context.cur_loc.line });
    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zyy_parser_code_block_inline(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_code_block_inline_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_code_block_inline_impl(parser: *Parser) !void {
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

export fn zyy_parser_code_block_start(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_code_block_start_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_code_block_start_impl(parser: *Parser) !void {
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

export fn zyy_parser_code_block_stop(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_code_block_stop_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_code_block_stop_impl(parser: *Parser) !void {
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

export fn zyy_parser_code_block_content(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_code_block_content_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_code_block_content_impl(parser: *Parser) !void {
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);
    parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
    parser.context.cur_codeblock.end.col = parser.yy.leng;
    // std.debug.print("code block content:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.context.cur_loc.col += parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zyy_parser_code_block_new_line(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_code_block_new_line_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_code_block_new_line_impl(parser: *Parser) !void {
    try parser.context.cur_codeblock.content.append('\n');
    parser.context.cur_codeblock.end.line += 1;
    parser.context.cur_codeblock.end.col = 0;
    // std.debug.print("code block newline at: {d},{d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zyy_parser_start_condition(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_start_condition_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_start_condition_impl(parser: *Parser) !void {
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

export fn zyy_parser_rule_line(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_rule_line_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_rule_line_impl(parser: *Parser) !void {
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
            const action_line_start = line.len - trimed_action_line.len + 1;
            // std.debug.print("action_line_start: {d}\n", .{action_line_start});
            if (!parser.context.cur_codeblock.isEmpty()) {
                // std.debug.print("append last cur_codeblock: {d},{any}\n", .{ parser.context.cur_codeblock.content.items.len, parser.context.cur_codeblock.content.items });
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
                parser.context.cur_codeblock.start.col = action_line_start;
            }
            // std.debug.print("rule pattern with action:{s},{s}, {d},{d} {d},{d}\n", .{ line[0..pattern_stop], line[pattern_stop..], parser.context.cur_loc.line, parser.context.cur_loc.col, parser.context.cur_codeblock.start.line, parser.context.cur_codeblock.start.col });
            parser.context.cur_codeblock.content.clearAndFree();
            try parser.context.cur_codeblock.content.appendSlice(trimed_action_line);
            parser.context.cur_codeblock.start = .{
                .line = parser.context.cur_loc.line,
                .col = action_line_start,
            };
            parser.context.cur_codeblock.end = parser.context.cur_codeblock.start;
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

export fn zyy_parser_rule_new_line(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_rule_new_line_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_rule_new_line_impl(parser: *Parser) !void {
    try parser.context.cur_codeblock.content.append('\n');
    // std.debug.print("rule new line:\n", .{});
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zyy_parser_default_rule(parser_intptr: usize) u32 {
    var parser = @as(*Parser, @ptrFromInt(parser_intptr));
    _ = &parser;
    zyy_parser_default_rule_impl(parser) catch return 1;
    return 0;
}

fn zyy_parser_default_rule_impl(parser: *Parser) !void {
    if (parser.yy.leng == 1 and parser.yy.text[0] == '\n') {
        parser.context.cur_loc.line += 1;
        parser.context.cur_loc.col = 0;
    } else {
        parser.context.cur_loc.col += 1;
    }
    // std.debug.print("default now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
}

export fn zyy_parser_user_code_block(parser_ptr: *void) u32 {
    _ = parser_ptr;
    return 0;
}
