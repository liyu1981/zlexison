%{
//
// cat.lex: A demonstration of YY_NEW_FILE.
//

pub var names: []const []const u8 = undefined;
pub var current: usize = 1;
%}

%%

<<EOF>> {
            current += 1;
            if (current < names.len) {
                yyg.yyin_r.close();
                if (std.fs.path.isAbsolute(names[current])) {
                    yyg.yyin_r = try std.fs.openFileAbsolute(names[current], .{});
                } else {
                    yyg.yyin_r = try std.fs.cwd().openFile(names[current], .{});
                }
                try YY_NEW_FILE(yyg);
            } else {
                return YY_TERMINATED;
            }
        }

%%

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if(args.len < 2) {
        std.debug.print("Usage: cat files....\n", .{});
        return 1;
    }

    var yylval_param: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc_param: YYLexer.YYLTYPE = .{};

    YYLexer.names = args;

    var scanner = YYLexer{ .allocator = allocator };
    try scanner.init();
    defer scanner.deinit();

    scanner.yyg.yyin_r = try std.fs.cwd().openFile(YYLexer.names[YYLexer.current], .{});

    _ = try scanner.yylex(&yylval_param, &yylloc_param);

    return 0;
}
