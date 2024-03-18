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
GNU        {
                switch (yyg.yyout_r) {
                    .buf => |buf| {
                        try buf.writer().print("GNU is not Unix!\n", .{});
                    },
                    .file => |file| {
                        try file.writer().print("GNU is not Unix!\n", .{});
                    },
                }
           }

%%

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    _ = lexer.yylex(&yylval, &yylloc) catch |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    };

    return 0;
}
