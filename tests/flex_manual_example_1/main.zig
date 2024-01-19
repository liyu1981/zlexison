const std = @import("std");
const ExampleParser = @import("exampleParser.zig");

pub fn main() !u8 {
    const allocator = std.heap.page_allocator;

    // var input_array = std.ArrayList(u8).init(allocator);
    // defer input_array.deinit();

    const stdout_writer = std.io.getStdOut().writer();

    // const stdin_reader = std.io.getStdIn().reader();
    // var buf: [1024]u8 = undefined;
    // while (true) {
    //     const read_buf_len = try stdin_reader.read(&buf);
    //     if (read_buf_len == 0) break;
    //     try input_array.appendSlice(buf[0..read_buf_len]);
    // }

    // const input = try input_array.toOwnedSlice();
    // defer allocator.free(input);

    // try stdout_writer.print("read {d} bytes.\n", .{input.len});

    var parser = ExampleParser.init(.{
        .allocator = allocator,
    });
    defer parser.deinit();

    try parser.lex();

    try stdout_writer.print(
        "# of lines = {d}, # of chars = {d}\n",
        .{ parser.context.num_lines, parser.context.num_chars },
    );

    return 0;
}
