const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const YYLexer = @import("trival.zig").YYLexer;

pub fn runAllTests(comptime Util: type) !void {
    try Util.runTests("trival", trival_test_data, runTrivalTest);
}

const trival_test_data = .{
    .{
        \\
        ,
        \\
    },
};

fn runTrivalTest(allocator: std.mem.Allocator, input: []const u8, expected_output: []const u8) !void {
    _ = expected_output;
    _ = input;

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();
    // in the end if gpa will not complain leaks then we are fine
}
