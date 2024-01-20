const std = @import("std");
const testing = std.testing;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    const allocator = testing.allocator;
    {
        const f = try std.fs.cwd().openFile("tests/flex_manual_example_1/exampleParser.zig", .{});
        defer f.close();
        const content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
        defer allocator.free(content);
        var content_z = try allocator.alloc(u8, content.len + 1);
        defer allocator.free(content_z);
        @memcpy(content_z[0..content.len], content);
        content_z[content_z.len - 1] = 0;
        var ast = try std.zig.Ast.parse(allocator, content_z[0..content.len :0], .zig);
        ast.deinit(allocator);
    }
}
