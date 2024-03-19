/* 
 * string1.lex: Handling strings by using input()
 */

%{
pub const EOF = std.math.maxInt(u8);

pub var err_buf: ?std.ArrayList(u8) = null;

pub inline fn isxdigit(x: u8) bool {
    return (x >= '0' and x <= '9') or (x >= 'a' and x <= 'f') or (x >= 'A' and x <= 'F');
}

pub inline fn isodigit(x: u8) bool {
    return x >= '0' and x <= '7';
}

pub inline fn hextoint(x: u8) u8 {
    if (isodigit(x)) {
        return x - '0';
    } else {
        return x - 'A' + 10;
    }
}

pub fn getInput(yyg: *yyguts_t) !u8 {
    return input(yyg) catch |err| switch(err) {
        error.EndOfStream => return EOF,
        else => return err,
    };
}

%}

%%

\"  {
        var buffer = std.ArrayList(u8).init(yyg.arena_allocator);
        defer buffer.deinit();
        var inch: u8 = try getInput(yyg); 
        var temp: u8 = undefined;

        while (inch != EOF and inch != '"' and inch != '\n') {
            if(inch == '\\') {
                inch = try getInput(yyg);
                switch(inch) {
                    '\n' => { inch = try getInput(yyg); },
                    'b' => { inch = 'b'; },
                    't' => { inch = 't'; },
                    'n' => { inch = 'n'; },
                    'v' => { inch = 'v'; },
                    'f' => { inch = 'f'; },
                    'r' => { inch = 'r'; },
                    'X', 'x' => { 
                        inch = try getInput(yyg);
                        if(isxdigit(inch)) {
                            temp = hextoint(std.ascii.toUpper(inch));
                            inch = try getInput(yyg);
                            if(isxdigit(inch)) {
                                temp = (temp << 4) + hextoint(std.ascii.toUpper(inch));
                            } else {
                                unput(inch, yyg);
                            }
                            inch = temp; 
                        } else {
                            unput(inch, yyg);
                            inch = 'x';
                        }
                    },
                    else => {
                        if(isodigit(inch)) {
                            temp = inch - '0';
                            inch = try getInput(yyg);
                            if(isodigit(inch)) {
                                temp = (temp << 3) + (inch - '0');
                                inch = try getInput(yyg);
                                if(isodigit(inch)) {
                                    temp = (temp << 3) + (inch - '0');
                                } else {
                                    unput(inch, yyg);
                                }
                            } else {
                                unput(inch, yyg);
                            }
                            inch = temp; 
                        }
                    } 
                }
            }
            try buffer.append(inch);
            inch = try getInput(yyg);
        }
        if (inch == EOF or inch == '\n') {
            // this demos the equiv of yyerror in zig, just print and return with error.yyerror
            if (err_buf) |*b| {
                try b.writer().print("Unterminated string.", .{});
            } else {
                std.debug.print("Unterminated string.", .{});
            }
            return error.yyerror;
        }
        switch(yyg.yyout_r) {
            .buf => |b| {
                try b.writer().print("String = \"{s}\"\n", .{buffer.items});
            },
            .file => |f| {
                try f.writer().print("String = \"{s}\"\n", .{buffer.items});
            },
        }
    }
.
\n

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

    YYLexer.yydebug = true;

    _ = lexer.yylex(&yylval, &yylloc) catch |err| switch (err) {
        error.EndOfStream => {},
        error.yyerror => {},
        else => return err,
    };

    return 0;
}
