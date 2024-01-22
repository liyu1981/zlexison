%{
pub const Context = struct {
    pub const Error = error{
        LexSyntaxError,
    };

    const Section = enum {
        Definitions,
        Rules,
        UserCode,
    };
    const Loc = struct {
        line: usize = 0,
        col: usize = 0,
    };
    pub const CodeBlock = struct {
        allocator: std.mem.Allocator,
        content: std.ArrayList(u8),
        start: Loc = Loc{},
        end: Loc = Loc{},

        pub fn init(context: *const Context) CodeBlock {
            return CodeBlock{
                .allocator = context.allocator,
                .content = std.ArrayList(u8).init(context.allocator),
                .start = context.cur_loc,
                .end = context.cur_loc,
            };
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

    allocator: std.mem.Allocator,

    definitions_cbs: std.ArrayList(CodeBlock),
    rules_cbs_1: std.ArrayList(CodeBlock),
    rules_action_cbs: std.ArrayList(CodeBlock),
    rules_cbs_2: std.ArrayList(CodeBlock),
    user_cbs: std.ArrayList(CodeBlock),

    cur_codeblock: CodeBlock = undefined,
    cur_section: Section = .Definitions,
    cur_loc: Loc = Loc{},
    last_sc: usize = SC_INITIAL,

    pub fn init(allocator: std.mem.Allocator) Context {
        var c = Context{
            .allocator = allocator,
            .definitions_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_1 = std.ArrayList(CodeBlock).init(allocator),
            .rules_action_cbs = std.ArrayList(CodeBlock).init(allocator),
            .rules_cbs_2 = std.ArrayList(CodeBlock).init(allocator),
            .user_cbs = std.ArrayList(CodeBlock).init(allocator),
        };
        c.cur_codeblock = Parser.Context.CodeBlock.init(&c);
        return c;
    }
};
%}

%{
pub const ParserError = error{
    InlineCodeBlockInDefinitionSection,
    NoCodeBlockAllowed,
} || ZA.YYError;
%}

%x rule
%x user_block
%x code_block

%%

%{
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
%}

<*>^\%\%$    {
    switch (parser.context.cur_section) {
        .Definitions => {
            parser.context.cur_section = .Rules;
            parser.startCondition.BEGIN(SC_rule);
        },
        .Rules => {
            parser.context.cur_section = .UserCode;
            parser.startCondition.BEGIN(SC_user_block);
        },
        else => {},
    }
    // std.debug.print("\nsection: {any}, line{d}\n", .{ parser.context.cur_section, parser.context.cur_loc.line });
    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<INITIAL>^[ \t]+.*$ {
    parser.context.cur_codeblock.start = .{
        .line = parser.context.cur_loc.line,
        .col = 0,
    };
    parser.context.cur_codeblock.end = .{
        .line = parser.context.cur_loc.line,
        .col = parser.yy.leng,
    };
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);

    switch (parser.context.cur_section) {
        .Definitions => {
            try parser.context.definitions_cbs.append(parser.context.cur_codeblock);
        },
        .Rules => {
            return ParserError.InlineCodeBlockInDefinitionSection;
        },
        else => {},
    }

    // std.debug.print("code block inline:{s} {d},{d}\n", .{ parser.yy.text[0..parser.yy.leng], parser.context.cur_loc.line, parser.context.cur_loc.col });

    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
  }

<INITIAL>^\%\{[ \t]*$ {
    switch (parser.context.cur_section) {
        .Definitions => {
            parser.context.last_sc = SC_INITIAL;
        },
        .Rules => {
            if (!parser.context.cur_codeblock.isEmpty()) {
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
            }
            parser.context.last_sc = SC_rule;
        },
        else => {
            return ParserError.NoCodeBlockAllowed;
        },
    }
    parser.startCondition.BEGIN(SC_code_block);

    // std.debug.print("code block start:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.context.cur_codeblock.start.line = parser.context.cur_loc.line;
    parser.context.cur_codeblock.start.col = parser.yy.leng;
    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<INITIAL,code_block>^\%\}[ \t]*$ {
    switch (parser.context.cur_section) {
        .Definitions => {
            try parser.context.definitions_cbs.append(parser.context.cur_codeblock);
        },
        .Rules => {
            if (parser.context.rules_action_cbs.items.len > 0) {
                try parser.context.rules_cbs_2.append(parser.context.cur_codeblock);
            } else {
                try parser.context.rules_cbs_1.append(parser.context.cur_codeblock);
            }
        },
        else => {
            return ParserError.NoCodeBlockAllowed;
        },
    }

    // std.debug.print("code block stop:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.startCondition.BEGIN(parser.context.last_sc);

    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
  }

<code_block>.* {
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);
    parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
    parser.context.cur_codeblock.end.col = parser.yy.leng;
    // std.debug.print("code block content:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.context.cur_loc.col += parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<code_block>\n {
    try parser.context.cur_codeblock.content.append('\n');
    parser.context.cur_codeblock.end.line += 1;
    parser.context.cur_codeblock.end.col = 0;
    // std.debug.print("code block newline at: {d},{d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<rule>^\%\{[ \t]*$ {
    switch (parser.context.cur_section) {
        .Definitions => {
            parser.context.last_sc = SC_INITIAL;
        },
        .Rules => {
            if (!parser.context.cur_codeblock.isEmpty()) {
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
            }
            parser.context.last_sc = SC_rule;
        },
        else => {
            return ParserError.NoCodeBlockAllowed;
        },
    }
    parser.startCondition.BEGIN(SC_code_block);

    // std.debug.print("code block start:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.context.cur_codeblock.start.line = parser.context.cur_loc.line;
    parser.context.cur_codeblock.start.col = parser.yy.leng;
    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<rule>.* {
    const line = parser.yy.text[0..parser.yy.leng];
    const maybe_pattern_stop = findRulePatternStop(line);
    if (maybe_pattern_stop) |pattern_stop| {
        if (pattern_stop == 0) {
            //std.debug.print("rule action line:{s}, {d},{d}\n", .{ line, parser.context.cur_loc.line, parser.context.cur_loc.col });
            try parser.context.cur_codeblock.content.appendSlice(line);
            parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
            parser.context.cur_codeblock.end.col = parser.yy.leng;
        } else {
            const trimed_action_line = std.mem.trimLeft(u8, line[pattern_stop..], " \t");
            const action_line_start = pattern_stop + (line.len - trimed_action_line.len);
            if (!parser.context.cur_codeblock.isEmpty()) {
                // std.debug.print("append last cur_codeblock: {d},{any}\n", .{ parser.context.cur_codeblock.content.items.len, parser.context.cur_codeblock.content.items });
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
                parser.context.cur_codeblock.start.col = action_line_start;
            }
            // std.debug.print("rule pattern with action:{s},{s}, {d},{d} {d},{d}\n", .{ line[0..pattern_stop], line[pattern_stop..], parser.context.cur_loc.line, parser.context.cur_loc.col, parser.context.cur_codeblock.start.line, parser.context.cur_codeblock.start.col });
            try parser.context.cur_codeblock.content.appendSlice(trimed_action_line);
            parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
            parser.context.cur_codeblock.end.col = parser.yy.leng;
        }
    } else {
        if (!parser.context.cur_codeblock.isEmpty()) {
            // std.debug.print("append last cur_codeblock: {d},{any}\n", .{ parser.context.cur_codeblock.content.items.len, parser.context.cur_codeblock.content.items });
            try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
            parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
        }
        // std.debug.print("rule pattern without action:{s}, {d},{d} {d},{d}\n", .{ line, parser.context.cur_loc.line, parser.context.cur_loc.col, parser.context.cur_codeblock.start.line, parser.context.cur_codeblock.start.col });
    }

    // std.debug.print("rule line:{s}, {d},{d}\n", .{ line, parser.context.cur_loc.line, parser.context.cur_loc.col });
    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }


<rule>\n {
    try parser.context.cur_codeblock.content.append('\n');
    // std.debug.print("rule new line:\n", .{});
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

<user_block>(.|\n)* {
    _ = parser;
  }

<*>.|\n {
    if (parser.yy.leng == 1 and parser.yy.text[0] == '\n') {
        parser.context.cur_loc.line += 1;
        parser.context.cur_loc.col = 0;
    } else {
        parser.context.cur_loc.col += 1;
    }
    // std.debug.print("default now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
  }

%%

// user code
