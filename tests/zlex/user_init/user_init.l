%{
    pub var exe_args: [][:0]const u8 = undefined;

    // this example demos how to use YY_USER_INIT in zig
    pub fn userInitOpenFileFromArg1(lexer: *YYLexer) anyerror!void {
        if (exe_args.len < 2) {
            std.debug.print("Usage: <exe> <input_file>\n", .{});
            return error.InvalidArgs;
        }

        lexer.yyg.yyin_r = if (std.fs.path.isAbsolute(exe_args[1])) 
            try std.fs.openFileAbsolute(exe_args[1], .{})
        else
            try std.fs.cwd().openFile(exe_args[1], .{});
    }
%}

%%

.*         try ECHO(yyg);
\n         try ECHO(yyg);

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

    // this is how to use custom user_init instead of default one
    YYLexer.YY_USER_INIT = userInitOpenFileFromArg1;

    const args = try std.process.argsAlloc(lexer.allocator);
    defer std.process.argsFree(lexer.allocator, args);
    YYLexer.exe_args = args;

    // YYLexer.yydebug = true;

    _ = lexer.yylex(&yylval, &yylloc) catch |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    };

    return 0;
}
