const std = @import("std");

pub const uint_ptr = usize;

pub var zyy_yyg_intptr: uint_ptr = undefined;

pub const YYError = error{
    YYScanStringFailed,
    YYScanBytesFailed,
    YYScanBufferFailed,
};

pub const YYGuts = struct {
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
        zyy_start_condition_begin(zyy_yyg_intptr, start_condition);
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
        const c = zyy_action_input(zyy_yyg_intptr);
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

extern fn zyy_yy_create_buffer(yyg_intptr: uint_ptr, f: std.c.FILE, size: usize) uint_ptr;
extern fn zyy_yy_switch_to_buffer(yyg_intptr: uint_ptr, new_buffer: uint_ptr) void;
extern fn zyy_yy_delete_buffer(yyg_intptr: uint_ptr, buffer: uint_ptr) void;
extern fn zyy_yypush_buffer_state(yyg_intptr: uint_ptr, buffer: uint_ptr) void;
extern fn zyy_yypop_buffer_state(
    yyg_intptr: uint_ptr,
) void;
extern fn zyy_yy_flush_buffer(yyg_intptr: uint_ptr, buffer: uint_ptr) void;
extern fn zyy_yy_scan_string(yyg_intptr: uint_ptr, str: [*c]const u8) uint_ptr;
extern fn zyy_yy_scan_bytes(yyg_intptr: uint_ptr, str: [*c]const u8, len: usize) uint_ptr;
extern fn zyy_yy_scan_buffer(yyg_intptr: uint_ptr, base: [*c]u8, size: usize) uint_ptr;

// TODO: misc macros, ch13

pub extern fn zyy_setup_parser(parser_intptr: uint_ptr) void;

pub extern fn zyy_start_condition_begin(yyg_intptr: uint_ptr, start_condition: usize) void;
pub extern fn zyy_action_echo(yyg_intptr: uint_ptr) void;
pub extern fn zyy_action_input(yyg_intptr: uint_ptr) c_int;

pub extern fn zyylex_init(yyg: [*c]?*anyopaque) c_int;
pub extern fn zyylex(yyg: ?*anyopaque) c_int;
pub extern fn zyylex_destroy(yyg: ?*anyopaque) c_int;
