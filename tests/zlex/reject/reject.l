%{
//  reject.lex: An example of REJECT and unput() misuse.
pub var out_buf: std.ArrayList(u8) = undefined;
%}

%%

UNIX       { 
                unput('U', yyg); 
                unput('N', yyg); 
                unput('G', yyg); 
                unput(0, yyg);
                <REJECT>;
           } 
GNU        try std.io.getStdOut().writer().print("GNU is Not Unix!\n", .{});

%%

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // const stdout_writer = std.io.getStdOut().writer();

    // var f: std.fs.File = brk: {
    //     if (args.len > 1) {
    //         break :brk try std.fs.cwd().openFile(args[1], .{});
    //     } else {
    //         break :brk std.io.getStdIn();
    //     }
    // };
    // defer f.close();

    // var content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    // defer allocator.free(content);
    // _ = &content;
    // try stdout_writer.print("read {d}bytes\n", .{content.len});

    // when use reject, need prepare longer buffer than real content, here we use 2x
    // var content_buffer = try allocator.alloc(u8, content.len * 2);
    // defer allocator.free(content_buffer);
    // @memset(content_buffer, 0);
    // @memcpy(content_buffer[0..content.len], content);

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    //YYLexer.out_buf = std.ArrayList(u8).init(allocator);
    // defer YYLexer.out_buf.deinit();

    var lexer = YYLexer{ .allocator = std.heap.page_allocator };
    try lexer.init();
    defer lexer.deinit();

    // try lexer.scan_string_with_reject(content_buffer, content.len);

    _ = try lexer.yylex(&yylval, &yylloc);

    std.debug.print("{s}\n", .{YYLexer.out_buf.items});

    return 0;
}
