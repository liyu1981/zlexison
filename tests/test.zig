const std = @import("std");

const all_tests = .{
    @import("zlex/simple/regtest.zig"),
    @import("zlex/cat/regtest.zig"),
    @import("zlex/eof_rules/regtest.zig"),
    @import("zlex/reject/regtest.zig"),
    @import("zlex/yymore/regtest.zig"),
    @import("zlex/comments/regtest.zig"),
    @import("zlex/dates/regtest.zig"),

    @import("zison/glr/regtest.zig"),
    @import("zison/reccalc/regtest.zig"),
    @import("zison/pushcalc/regtest.zig"),
    @import("zison/mfcalc/regtest.zig"),
};

const Util = struct {
    const MAX_INPUT_TAG = 32;
    var input_tag_buf: [MAX_INPUT_TAG + 3]u8 = undefined;
    fn inputTag(input: []const u8) []const u8 {
        if (input.len < MAX_INPUT_TAG) {
            return input;
        } else {
            return std.fmt.bufPrint(&input_tag_buf, "{s}...", .{input[0..MAX_INPUT_TAG]}) catch {
                unreachable;
            };
        }
    }

    pub const testFn = *const fn (allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) anyerror!void;

    pub fn runTests(name: []const u8, test_data: anytype, test_fn: testFn) !void {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        inline for (0..test_data.len) |i| {
            std.debug.print("\n  run {s} tests [{d}] input[{s}] ... ", .{ name, i, inputTag(test_data[i][0]) });
            try test_fn(allocator, test_data[i][0], test_data[i][1]);
            std.debug.print("ok!", .{});
        }
        if (gpa.detectLeaks()) {
            return error.MemLeak;
        }
    }
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

    std.debug.print("avaliable tests: ", .{});
    inline for (0..all_tests.len) |i| {
        std.debug.print("\n  {s}", .{@typeName(all_tests[i])});
    }
    std.debug.print("\n", .{});
    std.debug.print("test filter: {?s}\n", .{test_filter});

    inline for (0..all_tests.len) |i| {
        const skip = brk: {
            if (test_filter) |tf| {
                break :brk std.mem.indexOf(u8, @typeName(all_tests[i]), tf) == null;
            } else break :brk false;
        };
        if (!skip) {
            std.debug.print("testing [{d}] ({any}) ... ", .{ i, all_tests[i] });
            all_tests[i].runAllTests(Util) catch |err| {
                return err;
            };
            std.debug.print("\nok!\n", .{});
        }
    }
    return 0;
}
