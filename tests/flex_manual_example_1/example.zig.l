%{
    const Context = struct {
        num_lines: usize = 0,
        num_chars: usize = 0,
    };
%}

%%

\n      {
            parser.context.num_lines += 1;
            parser.context.num_chars += 1;
        }
.       {
            parser.context.num_chars += 1;
        }

%%

pub fn main() !u8 {
    const input = try std.io.getStdIn().readToEndAlloc(std.heap.page_allocator, std.math.maxInt(u64));
    defer std.heap.page_allocator.free(input);

    const parser = try exampleParser.init({
        .allocator = std.heap.page_allocator,
        .input = input,
    });
    defer parser.deinit();

    try parser.lex();

    try std.io.getStdout().writer().print(
        "# of lines = %d, # of chars = %d\n",
        .{ parser.context.num_lines, parser.context.num_chars },
    );
}
