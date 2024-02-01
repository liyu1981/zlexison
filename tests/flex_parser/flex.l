%{
pub const Context = struct {
    pub const Error = error{
        LexSyntaxError,
    };

    pub const Section = enum {
        Definitions,
        Rules,
        UserCode,
    };
    pub const Loc = struct {
        line: usize = 0,
        col: usize = 0,
    };
    pub const CodeBlock = struct {
        allocator: std.mem.Allocator,
        content: std.ArrayList(u8),
        start: Loc = Loc{},
        end: Loc = Loc{},

        pub fn init(c: *const Context) CodeBlock {
            return CodeBlock{
                .allocator = c.allocator,
                .content = std.ArrayList(u8).init(c.allocator),
                .start = c.cur_loc,
                .end = c.cur_loc,
            };
        }

        pub fn reset(this: *CodeBlock, c: *const Context) void {
            this.content.clearAndFree();
            this.start = c.cur_loc;
            this.end = c.cur_loc;
        }

        pub fn isEmpty(this: *const CodeBlock) bool {
            return std.mem.trim(u8, this.content.items, " \t\r\n").len == 0;
        }

        pub fn countLines(this: *const CodeBlock) usize {
            var c: usize = 0;
            for (0..this.content.items.len) |i| {
                if (this.content.items[i] == '\n') c += 1;
            }
            return c;
        }

        pub fn lastLineCol(this: *const CodeBlock) usize {
            const maybe_last_newline_pos = std.mem.lastIndexOf(u8, this.content.items, "\n");
            if (maybe_last_newline_pos) |last_newline_pos| {
                return this.content.items.len - last_newline_pos - 1;
            } else {
                return this.content.items.len;
            }
        }
    };
    pub const StartConditionDefinitions = struct {
        names: std.ArrayList([]const u8),
        name_buf: std.ArrayList(u8),
        locs: std.ArrayList(Loc),

        pub fn init(allocator: std.mem.Allocator) StartConditionDefinitions {
            return StartConditionDefinitions{
                .names = std.ArrayList([]const u8).init(allocator),
                .name_buf = std.ArrayList(u8).init(allocator),
                .locs = std.ArrayList(Loc).init(allocator),
            };
        }

        pub fn deinit(this: *const StartConditionDefinitions) void {
            this.names.deinit();
            this.name_buf.deinit();
            this.locs.deinit();
        }
    };

    allocator: std.mem.Allocator,

    start_conditions: StartConditionDefinitions,
    definitions_cbs: std.ArrayList(CodeBlock),
    rules_cbs_1: std.ArrayList(CodeBlock),
    rules_action_cbs: std.ArrayList(CodeBlock),
    rules_cbs_2: std.ArrayList(CodeBlock),
    user_cbs: std.ArrayList(CodeBlock),

    cur_codeblock: CodeBlock = undefined,
    cur_section: Section = .Definitions,
    cur_loc: Loc = Loc{},
    last_sc: usize = INITIAL,

    pub fn init(allocator: std.mem.Allocator) Context {
        var c = Context{
            .allocator = allocator,
            .start_conditions = StartConditionDefinitions.init(allocator),
            .definitions_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_1 = std.ArrayList(CodeBlock).init(allocator),
            .rules_action_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_2 = std.ArrayList(CodeBlock).init(allocator),
            .user_cbs = std.ArrayList(CodeBlock).init(allocator),
        };
        c.start_conditions.name_buf.appendSlice("INITIAL") catch unreachable;
        c.start_conditions.names.append(c.start_conditions.name_buf.items[0..7]) catch unreachable;
        c.start_conditions.locs.append(.{ .line = 0, .col = 0 }) catch unreachable;
        c.cur_codeblock = Context.CodeBlock.init(&c);
        return c;
    }

    pub fn deinit(this: *const Context) void {
        this.start_conditions.deinit();
        this.definitions_cbs.deinit();
        this.rules_cbs_1.deinit();
        this.rules_action_cbs.deinit();
        this.rules_cbs_2.deinit();
        this.user_cbs.deinit();
    }
};

pub const ParserError = error{
    InlineCodeBlockInDefinitionSection,
    NoCodeBlockAllowed,
    InvalidStartCondition,
};

pub var context: Context = undefined;
%}

%{
fn readRestLine(c: *Context, yyg: *yyguts_t) ![]u8 {
    var line_array = std.ArrayList(u8).init(c.allocator);
    defer line_array.deinit();
    var ch = try input(yyg);
    while (ch != 0 and ch != '\n') {
        try line_array.append(ch);
        ch = try input(yyg);
    }
    return line_array.toOwnedSlice();
}

fn findRulePatternStop(line: []const u8) ?usize {
    var i: usize = 0;
    var inside_class_braket: bool = false;
    while (i < line.len) {
        if ((i + 1) < line.len and line[i] == '\\' and line[i + 1] == ' ') {
            i += 2;
            continue;
        }
        if (line[i] == '[') inside_class_braket = true;
        if (line[i] == ']') inside_class_braket = false;
        //std.debug.print("\ncheck {d}, {c}, {any}\n", .{ i, line[i], inside_class_braket });
        if (inside_class_braket and line[i] == ' ') {
            i += 1;
            continue;
        }
        if (line[i] == ' ' or line[i] == '\t') return i;
        i += 1;
    }
    return null;
}

fn extractStartConditionName(line: []const u8) ![]const u8 {
    const s = std.mem.trim(u8, line, " \t\r\n");
    if (s.len == 0) return ParserError.InvalidStartCondition;
    return s;
}
%}

%x rule
%x user_block
%x code_block

%%

<*>^\%\%$    {
    switch (context.cur_section) {
        .Definitions => {
            context.cur_codeblock.reset(&context);
            context.cur_section = .Rules;
            BEGIN(rule, yyg);
        },
        .Rules => {
            if (!context.cur_codeblock.isEmpty()) {
                try context.rules_action_cbs.append(context.cur_codeblock);
                context.cur_codeblock = Context.CodeBlock.init(&context);
            }
            context.cur_section = .UserCode;
            BEGIN(user_block, yyg);
        },
        else => {},
    }
    // std.debug.print("\nsection: {any}, line{d}\n", .{ parser.context.cur_section, parser.context.cur_loc.line });
    context.cur_loc.col = yyg.yyleng_r;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<INITIAL>^[ \t]+.*$ {
    context.cur_codeblock.start = .{
        .line = context.cur_loc.line,
        .col = 0,
    };
    context.cur_codeblock.end = .{
        .line = context.cur_loc.line,
        .col = yyg.yyleng_r,
    };
    try context.cur_codeblock.content.appendSlice(yyg.yytext_r[0..yyg.yyleng_r]);

    switch (context.cur_section) {
        .Definitions => {
            try context.definitions_cbs.append(context.cur_codeblock);
        },
        .Rules => {
            return ParserError.InlineCodeBlockInDefinitionSection;
        },
        else => {},
    }

    // std.debug.print("code block inline:{s} {d},{d}\n", .{ parser.yy.text[0..parser.yy.leng], parser.context.cur_loc.line, parser.context.cur_loc.col });

    context.cur_loc.col = yyg.yyleng_r;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    context.cur_codeblock = Context.CodeBlock.init(&context);
  }

<INITIAL>^\%\{[ \t]*$ {
    switch (context.cur_section) {
        .Definitions => {
            context.last_sc = INITIAL;
        },
        .Rules => {
            if (!context.cur_codeblock.isEmpty()) {
                try context.rules_action_cbs.append(context.cur_codeblock);
                context.cur_codeblock = Context.CodeBlock.init(&context);
            }
            context.last_sc = rule;
        },
        else => {
            return ParserError.NoCodeBlockAllowed;
        },
    }
    BEGIN(code_block, yyg);

    // std.debug.print("code block start:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    context.cur_codeblock.start.line = context.cur_loc.line;
    context.cur_codeblock.start.col = yyg.yyleng_r;
    context.cur_loc.col = yyg.yyleng_r;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<INITIAL,code_block>^\%\}[ \t]*$ {
    // std.debug.print("yylex loc:L{d}, C{d}\n", .{yyget_lineno(yyg), yyget_column(yyg)});
    switch (context.cur_section) {
        .Definitions => {
            try context.definitions_cbs.append(context.cur_codeblock);
        },
        .Rules => {
            if (context.rules_action_cbs.items.len > 0) {
                try context.rules_cbs_2.append(context.cur_codeblock);
            } else {
                try context.rules_cbs_1.append(context.cur_codeblock);
            }
        },
        else => {
            return ParserError.NoCodeBlockAllowed;
        },
    }

    // std.debug.print("code block stop:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    BEGIN(context.last_sc, yyg);

    context.cur_loc.col = yyg.yyleng_r;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    context.cur_codeblock = Context.CodeBlock.init(&context);
  }

<INITIAL>^%(s|x) {
    // std.debug.print("now loc: line={d} col={d}\n", .{ context.cur_loc.col });
    const line = try readRestLine(&context, yyg);
    const condition_name = try extractStartConditionName(line);
    // std.debug.print("start condition line: {s}, {s}\n", .{ line, condition_name });
    const s = context.start_conditions.name_buf.items.len;
    try context.start_conditions.name_buf.appendSlice(condition_name);
    const e = context.start_conditions.name_buf.items.len;
    try context.start_conditions.names.append(context.start_conditions.name_buf.items[s..e]);
    try context.start_conditions.locs.append(context.cur_loc);
    // std.debug.print("start condition line: {s}, {s}, {d}\n", .{ line, condition_name, context.start_conditions.names.items.len });
    context.cur_loc.line += 1;
    context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ context.cur_loc.line, context.cur_loc.col });
  }

<code_block>.* {
    try context.cur_codeblock.content.appendSlice(yyg.yytext_r[0..yyg.yyleng_r]);
    context.cur_codeblock.end.line = context.cur_loc.line;
    context.cur_codeblock.end.col = yyg.yyleng_r;
    // std.debug.print("code block content:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    context.cur_loc.col += yyg.yyleng_r;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<code_block>\n {
    try context.cur_codeblock.content.appendSlice(yyg.yytext_r[0..yyg.yyleng_r]);
    context.cur_codeblock.end.line = context.cur_loc.line;
    context.cur_codeblock.end.col = yyg.yyleng_r;
    // std.debug.print("code block content:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    context.cur_loc.col += yyg.yyleng_r;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<rule>^\%\{[ \t]*$ {
    switch (context.cur_section) {
        .Definitions => {
            context.last_sc = INITIAL;
        },
        .Rules => {
            if (!context.cur_codeblock.isEmpty()) {
                try context.rules_action_cbs.append(context.cur_codeblock);
                context.cur_codeblock = Context.CodeBlock.init(&context);
            }
            context.last_sc = rule;
        },
        else => {
            return ParserError.NoCodeBlockAllowed;
        },
    }
    BEGIN(code_block, yyg);

    // std.debug.print("code block start:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    context.cur_codeblock.start.line = context.cur_loc.line;
    context.cur_codeblock.start.col = yyg.yyleng_r;
    context.cur_loc.col = yyg.yyleng_r;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.c  }
  }

<rule>.* {
    const line = yyg.yytext_r[0..yyg.yyleng_r];
    const maybe_pattern_stop = findRulePatternStop(line);
    if (maybe_pattern_stop) |pattern_stop| {
        if (pattern_stop == 0) {
            //std.debug.print("rule action line:{s}, {d},{d}\n", .{ line, parser.context.cur_loc.line, parser.context.cur_loc.col });
            try context.cur_codeblock.content.appendSlice(line);
            context.cur_codeblock.end.line = context.cur_loc.line;
            context.cur_codeblock.end.col = yyg.yyleng_r;
        } else {
            const trimed_action_line = std.mem.trimLeft(u8, line[pattern_stop..], " \t");
            const action_line_start = line.len - trimed_action_line.len + 1;
            // std.debug.print("action_line_start: {d}\n", .{action_line_start});
            if (!context.cur_codeblock.isEmpty()) {
                // std.debug.print("append last cur_codeblock: {d},{any}\n", .{ parser.context.cur_codeblock.content.items.len, parser.context.cur_codeblock.content.items });
                try context.rules_action_cbs.append(context.cur_codeblock);
                context.cur_codeblock = Context.CodeBlock.init(&context);
                context.cur_codeblock.start.col = action_line_start;
            }
            // std.debug.print("rule pattern with action:{s},{s}, {d},{d} {d},{d}\n", .{ line[0..pattern_stop], line[pattern_stop..], parser.context.cur_loc.line, parser.context.cur_loc.col, parser.context.cur_codeblock.start.line, parser.context.cur_codeblock.start.col });
            context.cur_codeblock.content.clearAndFree();
            try context.cur_codeblock.content.appendSlice(trimed_action_line);
            context.cur_codeblock.start = .{
                .line = context.cur_loc.line,
                .col = action_line_start,
            };
            context.cur_codeblock.end = .{
                .line = context.cur_loc.line,
                .col = line.len,
            };
        }
    } else {
        if (!context.cur_codeblock.isEmpty()) {
            // std.debug.print("append last cur_codeblock: {d},{any}\n", .{ parser.context.cur_codeblock.content.items.len, parser.context.cur_codeblock.content.items });
            try context.rules_action_cbs.append(context.cur_codeblock);
            context.cur_codeblock = Context.CodeBlock.init(&context);
        }
        // std.debug.print("rule pattern without action:{s}, {d},{d} {d},{d}\n", .{ line, parser.context.cur_loc.line, parser.context.cur_loc.col, parser.context.cur_codeblock.start.line, parser.context.cur_codeblock.start.col });
    }

    // std.debug.print("rule line:{s}, {d},{d}\n", .{ line, parser.context.cur_loc.line, parser.context.cur_loc.col });
    context.cur_loc.col = yyg.yyleng_r;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }


<rule>\n {
    try context.cur_codeblock.content.append('\n');
    // std.debug.print("rule new line:\n", .{});
    context.cur_loc.line += 1;
    context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<user_block>(.|\n)* {}

<*>.|\n {
    if (yyg.yyleng_r == 1 and yyg.yytext_r[0] == '\n') {
        context.cur_loc.line += 1;
        context.cur_loc.col = 0;
    } else {
        context.cur_loc.col += 1;
    }
    // std.debug.print("default now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

%%

// user code
