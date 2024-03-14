%{
// 
//  eof_rules.lex : An example of using multiple buffers
//                  EOF rules, and start states
//

pub const MAX_NEST = 10;

pub var include_stack: [MAX_NEST]*allowzero yy_buffer_state = undefined;
pub var include_count: usize = 0;
%}


%x INCLUDE

%%

^"#include"[ \t]*\"  BEGIN(INCLUDE, yyg);
<INCLUDE>\"          BEGIN(INITIAL, yyg);
<INCLUDE>[^\"]+ {
        // get the include file name
        if (include_count >= MAX_NEST) {
            std.debug.print("Too many include files", .{});
            return error.TooManyIncludeFiles;
        }

        const current_buffer: *yy_buffer_state = @ptrCast(YY_CURRENT_BUFFER(yyg));
        // if want to save yy_buffer_state for later use, it must be cloned before saving
        // as when yy_switch_to_buffer, the old buffer will be destoryed.
        // the clone method of yy_buffer_state is using the arena_allocator inside yyg and will
        // be released when yyg is destroyed, so we can either release it or not
        include_stack[include_count] = try current_buffer.clone(yyg);
        include_count += 1;

        yyg.yyin_r = brk: {
            const path = yyget_text(yyg);
            if (std.fs.path.isAbsolute(path)) {
                break :brk try std.fs.openFileAbsolute(path, .{});
            } else {
                break :brk try std.fs.cwd().openFile(path, .{});
            }
        };

        try yy_switch_to_buffer(try yy_create_buffer(yyg.yyin_r, YY_BUF_SIZE, yyg), yyg);

        BEGIN(INITIAL, yyg);
    }
<INCLUDE><<EOF>> {
        std.debug.print("EOF in include", .{});
        return YY_TERMINATED;
    }
<<EOF>> {
        if (include_count <= 0) {
            yy_delete_buffer(@ptrCast(include_stack[include_count]), yyg);
            return YY_TERMINATED;
        } else {
            include_count -= 1;
            try yy_switch_to_buffer(@ptrCast(include_stack[include_count]), yyg);
            BEGIN(INCLUDE, yyg);
        }
    }
[a-z]+               try ECHO(yyg);
.|\n                 try ECHO(yyg);

%%

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: eof_rules input_file\n", .{});
        return 1;
    }

    var yylval_param: YYSTYPE = YYSTYPE.default();
    var yylloc_param: YYLTYPE = .{};

    @memset(&YYLexer.include_stack, @ptrFromInt(0));

    var scanner = YYLexer{ .allocator = allocator };
    try scanner.init();
    defer scanner.deinit();

    scanner.yyg.yyin_r = try std.fs.cwd().openFile(args[1], .{});

    _ = try scanner.yylex(&yylval_param, &yylloc_param);

    return 0;
}
