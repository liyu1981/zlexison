const std = @import("std");

const all_tests = .{
    @import("glr/unit_test.zig"),
};

pub fn main() !u8 {
    const allocaotr = std.heap.page_allocator;

    var args = try std.process.argsAlloc(allocaotr);
    defer std.process.argsFree(allocaotr, args);
    _ = &args;

    const test_filter: ?[]const u8 = brk: {
        if (args.len >= 2) {
            break :brk args[1];
        } else {
            break :brk null;
        }
    };

    inline for (0..all_tests.len) |i| {
        const skip = brk: {
            if (test_filter) |tf| {
                break :brk std.mem.indexOf(u8, @typeName(all_tests[i]), tf) != null;
            } else break :brk false;
        };
        if (skip) {
            std.debug.print("testing [{d}] ({any}) ... ", .{ i, all_tests[i] });
            all_tests[i].runAllTests() catch |err| {
                return err;
            };
            std.debug.print("\nok!\n", .{});
        }
    }
    return 0;
}
