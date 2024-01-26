const std = @import("std");

extern fn bison_main(argc: usize, argv: [*c]const u8) u8;

pub fn run_as_bison(args: [][:0]const u8) void {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // later there is no going back, so Cool Guys Don't Look At Explosions
    // defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();
    const argv_buf = arena.allocSentinel(?[*:0]const u8, args.len, null) catch {
        @panic("Oops! OOM!");
    };
    for (args, 0..) |arg, i| {
        const duped = arena.dupeZ(u8, arg) catch {
            @panic("Oops! OOM!");
        };
        argv_buf[i] = duped.ptr;
    }
    std.os.exit(bison_main(
        args.len,
        @as([*c]const u8, @ptrCast(argv_buf.ptr)),
    ));
}
