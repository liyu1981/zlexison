const std = @import("std");

pub const uint_ptr = usize;

pub const YYError = error{
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
        zlex_start_condition_begin(start_condition);
    }
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

    pub fn yy_scan_string(this: *const Buffer, str: []const u8) YYError!*YYBufferState {
        _ = this;
        const yybuf_intptr = zlex_yy_scan_string(str.ptr);
        if (yybuf_intptr == 0) {
            return YYError.YYScanStringFailed;
        } else {
            return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
        }
    }

    pub fn yy_scan_bytes(this: *const Buffer, str: []const u8) YYError!*YYBufferState {
        _ = this;
        const yybuf_intptr = zlex_yy_scan_bytes(str.ptr, str.len);
        if (yybuf_intptr == 0) {
            return YYError.YYScanBytesFailed;
        } else {
            return @as(*YYBufferState, @ptrFromInt(yybuf_intptr));
        }
    }

    pub fn yy_scan_buffer(this: *const Buffer, base: []u8) YYError!*YYBufferState {
        _ = this;
        const yybuf_intptr = zlex_yy_scan_buffer(base.ptr, base.len);
        if (yybuf_intptr == 0) {
            return YYError.YYScanBufferFailed;
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

pub extern fn zlex_setup_parser(parser_intptr: uint_ptr) void;

pub extern fn zlex_start_condition_begin(start_condition: usize) void;
pub extern fn zlex_action_echo() void;
pub extern fn zlex_action_input() i8;

pub extern fn zlex_yylex() void;
