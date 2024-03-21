%{
// Run as:
//        test-lineno-trailing <lineno_trailing.one.txt   # report flex's yylineno
//        test-lineno-trailing 1 <lineno_trailing.one.txt # report count_newlines(stdin)
//
%}

WORD [[:alpha:]]+

%%
    /* The goal here is to test the yylineno in the context of trailing-contexts.
       Using rules that have newlines in look-ahead.
    */
"Fixed_trailing:"/[\n]"test"[\n] {}
"Var_trailing:"{WORD}/[\n] {}
"Var_prefix_and_trailing:"{WORD}":"/(\n{WORD})* {}
\n                     {}
.                      {}
<<EOF>>     { 
                switch(yyg.yyout_r) {
                    .buf => |b| {
                        try b.writer().print("{d}\n", .{yyg.yylineno_r});
                    },
                    .file => |f| {
                        try f.writer().print("{d}\n", .{yyg.yylineno_r});
                    },
                } 
                return YY_TERMINATED;
            }

%%

// /* returns number of '\n' characters in input, plus one.
//    This is what flex does, essentially. */
   
fn countNewlines(allocator: std.mem.Allocator, in: std.fs.File) !usize {
    const content = try in.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(content);
    var count: usize = 0;
    for (0..content.len) |i| {
        if (content[i] == '\n') {
            count += 1;
        }
    }
    return count;
}

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len > 1) {
        try std.io.getStdOut().writer().print("{d}\n", .{ try countNewlines(allocator, std.io.getStdIn()) });
        return 0;
    }

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};
    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();
    _ = try lexer.yylex(&yylval, &yylloc);
    return 0;
}
