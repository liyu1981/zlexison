pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("pub const uint_ptr = usize;\nconst ZA = struct {\n    pub var zyy_yyg_intptr: uint_ptr = undefined;\n\n    pub const YYError = error{\n        YYScanStringFailed,\n        YYScanBytesFailed,\n        YYScanBufferFailed,\n    };\n\n    pub const YYControl = struct {\n        const E = error{\n            RETURN,\n            REJECT,\n            TERMINATE,\n            YYLESS,\n        };\n        pub const INT_RETURN = 0;\n        pub const INT_REJECT = 1;\n        pub const INT_TERMINATE = 2;\n        pub const INT_YYLESS = 3;\n        pub const INT_CONTINUE = std.math.maxInt(c_int);\n\n        pub fn RETURN() !void {\n            return YYControl.E.RETURN;\n        }\n    };\n\n    pub const YYGuts = struct {\n        // /* User-defined. Not touched by flex. */\n        // YY_EXTRA_TYPE yyextra_r;\n\n        yyin_r: *std.c.FILE,\n        yyout_r: *std.c.FILE,\n        yy_buffer_stack_top: isize, // /**");
    try stream.writeAll("< ");
    try stream.writeAll("index of top of stack. */\n        yy_buffer_stack_max: isize, // /**");
    try stream.writeAll("< ");
    try stream.writeAll("capacity of stack. */\n        yy_buffer_stack: *YYBufferState, // /**");
    try stream.writeAll("< ");
    try stream.writeAll("Stack as an array. */\n        yy_hold_char: u8,\n        yy_n_chars: c_int,\n        yyleng_r: c_int,\n        yy_c_buf_p: [*c]i8,\n        yy_init: c_int,\n        yy_start: c_int,\n        yy_did_buffer_switch_on_eof: c_int,\n        yy_start_stack_ptr: c_int,\n        yy_start_stack_depth: c_int,\n        yy_start_stack: *c_int,\n        yy_last_accepting_state: c_int,\n        yy_last_accepting_cpos: [*c]i8,\n\n        yylineno_r: c_int,\n        yy_flex_debug_r: c_int,\n\n        yytext_r: [*c]i8,\n        yy_more_flag: c_int,\n        yy_more_len: c_int,\n    };\n\n    pub const YYBufferState = struct {\n        yy_input_file: uint_ptr, // FILE* as uint_ptr\n        yy_ch_buf: [*c]u8, // input buffer\n        yy_buf_pos: [*c]u8, // current position in input buffer\n        yy_buf_size: i64, // Size of input buffer in bytes, not including room for EOB characters.\n        yy_n_chars: i64, // Number of characters read into yy_ch_buf, not including EOB characters.\n        yy_is_our_buffer: i64, // Whether we \"own\" the buffer - i.e., we know we created it,\n        // and can realloc() it to grow\n        // it, and should free() it to delete it.\n        yy_is_interactive: i64, // Whether this is an \"interactive\" input source; if so, and\n        // if we're using stdio for input, then we want to use getc()\n        // instead of fread(), to make sure we stop fetching input after\n        // each newline.\n        yy_at_bol: i64, // Whether we're considered to be at the beginning of a line.\n        // If so, '^' rules will be active on the next match, otherwise not.\n        yy_bs_lineno: i64, // *");
    try stream.writeAll("< ");
    try stream.writeAll("The line count.\n        yy_bs_column: i64, // *");
    try stream.writeAll("< ");
    try stream.writeAll("The column count.\n        yy_fill_buffer: i64, // Whether to try to fill the input buffer when we reach the end of it.\n        yy_buffer_status: i64,\n\n        const YY_BUFFER_NEW = 0;\n        const YY_BUFFER_NORMAL = 1;\n        const YY_BUFFER_EOF_PENDING = 2; // When an EOF's been seen but there's still some text to process\n        // then we mark the buffer as YY_EOF_PENDING, to indicate that we\n        // shouldn't try reading from the input source any more.  We might\n        // still have a bunch of tokens to match, though, because of\n        // possible backing-up.\n        //\n        // When we actually see the EOF, we change the status to \"new\"\n        // (via yyrestart()), so that the user can continue scanning by\n        // just pointing yyin at a new input file.\n    };\n\n    pub const StartCondition = struct {\n        pub fn BEGIN(this: *const StartCondition, start_condition: usize) void {\n            _ = this;\n            zyy_begin(zyy_yyg_intptr, start_condition);\n        }\n\n        pub fn yy_push_state(this: *const StartCondition, new_state: usize) void {\n            _ = this;\n            zyy_yy_push_state(zyy_yyg_intptr, new_state);\n        }\n\n        pub fn yy_pop_state(this: *const StartCondition) void {\n            _ = this;\n            zyy_yy_pop_state(zyy_yyg_intptr);\n        }\n\n        pub fn yy_top_state(this: *const StartCondition) usize {\n            _ = this;\n            return zyy_yy_top_state(zyy_yyg_intptr);\n        }\n    };\n\n    // ch14, values available to the user\n    pub const YY = struct {\n        yyg: uint_ptr = undefined,\n        text: [*c]u8 = undefined,\n        leng: usize = undefined,\n        in: uint_ptr = undefined,\n        out: uint_ptr = undefined,\n        current_buffer: *YYBufferState = undefined,\n        start: usize = undefined,\n\n        pub fn restart(this: *const YY, f: *std.c.FILE) void {\n            _ = this;\n            zyy_yyrestart(zyy_yyg_intptr, f);\n        }\n    };\n\n    pub fn yyget_lineno() usize {\n        return zyy_yyget_lineno(zyy_yyg_intptr);\n    }\n\n    pub fn yyget_column() usize {\n        return zyy_yyget_column(zyy_yyg_intptr);\n    }\n\n    // ch8, actions\n    pub const Action = struct {\n        pub fn ECHO(this: *const Action) void {\n            _ = this;\n            zyy_ECHO(zyy_yyg_intptr);\n        }\n\n        // use REJECT as\n        //     `return ZA.YYControl.E.REJECT;`\n\n        pub fn yymore(this: *const Action) void {\n            _ = this;\n            zyy_yymore();\n        }\n\n        // use yyless as\n        //     `ZA.Action.yyless(n); return ZA.YYControl.E.YYLESS;`\n        pub fn yyless(this: *const Action, n: usize) void {\n            _ = this;\n            zyy_set_parser_param_reg(0, @as(c_int, @intCast(n)));\n        }\n\n        pub fn unput(this: *const Action, c: u8) void {\n            _ = this;\n            zyy_unput(zyy_yyg_intptr, c);\n        }\n\n        pub fn input(this: *const Action) ?u8 {\n            _ = this;\n            const c = zyy_input(zyy_yyg_intptr);\n            if (c ");
    try stream.writeAll("< ");
    try stream.writeAll("0) {\n                return null;\n            }\n            return @as(u8, @intCast(c));\n        }\n\n        pub fn YY_FLUSH_BUFFER(this: *const Action) void {\n            _ = this;\n            zyy_YY_FLUSH_BUFFER(zyy_yyg_intptr);\n        }\n\n        // use yyterminate as:\n        //     `return ZA.YYControl.E.TERMINATE;`\n    };\n\n    pub const Buffer = struct {\n        pub fn yy_create_buffer(this: *const Buffer, f: std.c.FILE, size: usize) *YYBufferState {\n            _ = this;\n            const yybuf_intptr = zyy_yy_create_buffer(zyy_yyg_intptr, f, size);\n            return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));\n        }\n\n        pub fn yy_switch_to_buffer(this: *const Buffer, new_buffer: *YYBufferState) void {\n            _ = this;\n            zyy_yy_switch_to_buffer(zyy_yyg_intptr, @as(uint_ptr, @intFromPtr(new_buffer)));\n        }\n\n        pub fn yy_delete_buffer(this: *const Buffer, buffer: *YYBufferState) void {\n            _ = this;\n            zyy_yy_delete_buffer(zyy_yyg_intptr, @as(uint_ptr, @intFromPtr(buffer)));\n        }\n\n        pub fn yypush_buffer_state(this: *const Buffer, buffer: *YYBufferState) void {\n            _ = this;\n            zyy_yypush_buffer_state(zyy_yyg_intptr, @as(uint_ptr, @intFromPtr(buffer)));\n        }\n\n        pub fn yypop_buffer_state(this: *const Buffer) void {\n            _ = this;\n            zyy_yypop_buffer_state(zyy_yyg_intptr);\n        }\n\n        pub fn yy_flush_buffer(this: *const Buffer, buffer: *YYBufferState) void {\n            _ = this;\n            zyy_yy_flush_buffer(zyy_yyg_intptr, @as(uint_ptr, @intFromPtr(buffer)));\n        }\n\n        /// yy_new_buffer is an alias for yy_create_buffer(), provided for compatibility with the C++ use of new and delete\n        /// for creating and destroying dynamic objects. We will only deal with c so skip it here.\n        pub fn yy_new_buffer(this: *const Buffer, file: std.fs.File) YYBufferState {\n            _ = this;\n            _ = file;\n            @compileError(\"yy_new_buffer in flex is for c++! just use yy_create_buffer.\");\n        }\n\n        pub fn yy_scan_string(this: *const Buffer, str: []const u8) YYError!*YYBufferState {\n            _ = this;\n            const yybuf_intptr = zyy_yy_scan_string(zyy_yyg_intptr, str.ptr);\n            if (yybuf_intptr == 0) {\n                return YYError.YYScanStringFailed;\n            } else {\n                return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));\n            }\n        }\n\n        pub fn yy_scan_bytes(this: *const Buffer, str: []const u8) YYError!*YYBufferState {\n            _ = this;\n            const yybuf_intptr = zyy_yy_scan_bytes(zyy_yyg_intptr, str.ptr, str.len);\n            if (yybuf_intptr == 0) {\n                return YYError.YYScanBytesFailed;\n            } else {\n                return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));\n            }\n        }\n\n        pub fn yy_scan_buffer(this: *const Buffer, base: []u8) YYError!*YYBufferState {\n            _ = this;\n            const yybuf_intptr = zyy_yy_scan_buffer(zyy_yyg_intptr, base.ptr, base.len);\n            if (yybuf_intptr == 0) {\n                return YYError.YYScanBufferFailed;\n            } else {\n                return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));\n            }\n        }\n    };\n\n    pub var YY_USER_ACTION: ?UserActionFn = null;\n    pub var YY_USER_INIT: ?UserInitFn = null;\n\n    pub const Misc = struct {\n        // yy_set_interactive\n        // skip this as our parser will never be interactive\n\n        pub fn yy_set_bol(this: *const Misc, at_bol: isize) void {\n            _ = this;\n            zyy_yy_set_bol(zyy_yyg_intptr, at_bol);\n        }\n\n        pub fn YY_AT_BOL(this: *const Misc) bool {\n            _ = this;\n            return zyy_YY_AT_BOL(zyy_yyg_intptr) != 0;\n        }\n\n        // YYBREAK\n        // skip this too :)\n    };\n\n    // alias\n\n    pub const zyy_yyget_lineno = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yyget_lineno;\n    pub const zyy_yyget_column = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yyget_column;\n    pub const zyy_yyrestart = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yyrestart;\n\n    pub const zyy_yy_create_buffer = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_create_buffer;\n    pub const zyy_yy_switch_to_buffer = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_switch_to_buffer;\n    pub const zyy_yy_delete_buffer = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_delete_buffer;\n    pub const zyy_yypush_buffer_state = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yypush_buffer_state;\n    pub const zyy_yypop_buffer_state = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yypop_buffer_state;\n    pub const zyy_yy_flush_buffer = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_flush_buffer;\n    pub const zyy_yy_scan_string = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_scan_string;\n    pub const zyy_yy_scan_bytes = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_scan_bytes;\n    pub const zyy_yy_scan_buffer = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_scan_buffer;\n\n    pub const zyy_begin = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_begin;\n    pub const zyy_yy_push_state = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_push_state;\n    pub const zyy_yy_pop_state = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_pop_state;\n    pub const zyy_yy_top_state = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_top_state;\n\n    pub const zyy_ECHO = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_ECHO;\n    pub const zyy_yymore = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yymore;\n    pub const zyy_unput = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_unput;\n    pub const zyy_input = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_input;\n    pub const zyy_YY_FLUSH_BUFFER = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_YY_FLUSH_BUFFER;\n\n    pub const zyy_yy_set_bol = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_set_bol;\n    pub const zyy_YY_AT_BOL = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_YY_AT_BOL;\n\n    pub const zyylex_init = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("lex_init;\n    pub const zyylex = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("lex;\n    pub const zyylex_destroy = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("lex_destroy;\n\n    pub const zyy_setup_parser = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_setup_parser;\n    pub const zyy_set_parser_param_reg = ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_set_parser_param_reg;\n\n    // externs\n\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yyget_lineno(yyg_intptr: uint_ptr) usize;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yyget_column(yyg_intptr: uint_ptr) usize;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yyrestart(yyg_intptr: uint_ptr, f: *std.c.FILE) void;\n\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_create_buffer(yyg_intptr: uint_ptr, f: std.c.FILE, size: usize) uint_ptr;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_switch_to_buffer(yyg_intptr: uint_ptr, new_buffer: uint_ptr) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_delete_buffer(yyg_intptr: uint_ptr, buffer: uint_ptr) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yypush_buffer_state(yyg_intptr: uint_ptr, buffer: uint_ptr) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yypop_buffer_state(yyg_intptr: uint_ptr) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_flush_buffer(yyg_intptr: uint_ptr, buffer: uint_ptr) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_scan_string(yyg_intptr: uint_ptr, str: [*c]const u8) uint_ptr;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_scan_bytes(yyg_intptr: uint_ptr, str: [*c]const u8, len: usize) uint_ptr;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_scan_buffer(yyg_intptr: uint_ptr, base: [*c]u8, size: usize) uint_ptr;\n\n    extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_begin(yyg_intptr: uint_ptr, start_condition: usize) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_push_state(yyg_intptr: uint_ptr, new_state: usize) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_pop_state(yyg_intptr: uint_ptr) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_top_state(yyg_intptr: uint_ptr) usize;\n\n    extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_ECHO(yyg_intptr: uint_ptr) void;\n    // pub extern fn zyy_REJECT(yyg_intptr: uint_ptr) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yymore(yyg_intptr: uint_ptr) void;\n    // pub extern fn zyy_yyless(yyg_intptr: uint_ptr, n: c_int) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_unput(yyg_intptr: uint_ptr, c: u8) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_input(yyg_intptr: uint_ptr) c_int;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_YY_FLUSH_BUFFER(yyg_intptr: uint_ptr) void;\n    // yyterminate\n\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_set_bol(yyg_intptr: uint_ptr, at_bol: c_int) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_YY_AT_BOL(yyg_intptr: uint_ptr) c_int;\n\n\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("lex_init(yyg: [*c]?*anyopaque) c_int;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("lex(yyg: ?*anyopaque) c_int;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("lex_destroy(yyg: ?*anyopaque) c_int;\n\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_setup_parser(parser_intptr: uint_ptr) void;\n    pub extern fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_set_parser_param_reg(index: usize, value: c_int) void;\n};\nconst UserActionFn = *const fn (parser: *Parser) void;\nconst UserInitFn = *const fn (parser: *Parser) void;\npub export fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_call_user_action(parser_intptr: uint_ptr) void {\n    if (ZA.YY_USER_ACTION) |user_action_fn| {\n        user_action_fn(@as(*Parser, @ptrFromInt(parser_intptr)));\n    }\n}\npub export fn ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_call_user_init(parser_intptr: uint_ptr) void {\n    if (ZA.YY_USER_INIT) |user_init_fn| {\n        user_init_fn(@as(*Parser, @ptrFromInt(parser_intptr)));\n    }\n}\n");
}
