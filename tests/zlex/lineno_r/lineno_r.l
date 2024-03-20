%{
// A template scanner file to build "scanner.c".
//  Run as:
//       test-lineno-r <lineno_r.one.txt    # report flex's yylineno
//       test-lineno-r 1 <lineno_r.one.txt  # report count_newlines(stdin)
%}

WORD [[:alpha:]]+
DIGIT [[:digit:]]

%%
    /* The goal here is to test the yylineno processing by:
       - providing some rules than CAN match newlines and
         other rules that can NOT match newlines,
       - matching several newlines in one rule,
       - directly modifying yylineno.
    */

"yylineno++"          yyg.yylineno_r += 1;
"yylineno--"          yyg.yylineno_r -= 1;
[[:blank:]]+
{WORD}
{DIGIT}+(\n{DIGIT}+)*
\n
.
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
