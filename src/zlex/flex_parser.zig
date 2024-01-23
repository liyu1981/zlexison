const std = @import("std");

pub extern var action_array: [*c]u8;
pub extern var defs1_offset: c_int;
pub extern var prolog_offset: c_int;
pub extern var action_offset: c_int;
pub extern var action_index: c_int;
pub extern var action_size: c_int;
pub extern var syntaxerror: c_int;

pub extern fn flexinit(argc: c_int, argv: [*c]const [*c]const u8) void;
pub extern fn flexend(a: c_int) void;
pub extern fn readin() void;
pub extern fn yyparse() void;

pub extern fn flex_set_parser_only(v: c_int) void;

pub const FlexParserError = error{
    SyntaxError,
};

pub fn parse(args: []const [:0]const u8) !void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();
    // _ = arena;

    // const f = try std.fs.cwd().openFile(file_path, .{});
    // defer f.close();
    // try std.os.dup2(f.handle, std.os.STDIN_FILENO);

    const argv_buf = try arena.alloc([*c]const u8, args.len);
    for (args, 0..) |arg, i| {
        argv_buf[i] = arg.ptr[0 .. arg.len - 1].ptr;
    }

    flex_set_parser_only(1); // prevent flex fork processes as we only need parsing

    flexinit(
        @as(c_int, @intCast(args.len)),
        argv_buf.ptr,
    );
    // yyparse();
    readin();

    if (syntaxerror != 0) return FlexParserError.SyntaxError;
    std.debug.print("{d}\n", .{action_size});

    var i: usize = 0;
    var s: usize = 0;
    var e: usize = 0;
    const action_array_len = @as(usize, @intCast(action_size));
    while (i < action_array_len) {
        s = i;
        e = brk: {
            var j: usize = i;
            while (j < action_array_len) : (j += 1) {
                if (action_array[j] == 0) break :brk j;
            }
            break :brk j;
        };
        if (s != e) {
            std.debug.print("\n{s}\n", .{action_array[s..e]});
            std.debug.print("=============================\n", .{});
        }
        i = e + 1;
    }
    if (s < action_array_len) {
        std.debug.print("\n{s}\n", .{action_array[s..]});
        std.debug.print("=============================\n", .{});
    }

    // const defs1_ofst = @as(usize, @intCast(defs1_offset));

    flexend(0);
}
