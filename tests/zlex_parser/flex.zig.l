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

        pub fn init(context: *const Context) CodeBlock {
            return CodeBlock{
                .allocator = context.allocator,
                .content = std.ArrayList(u8).init(context.allocator),
                .start = context.cur_loc,
                .end = context.cur_loc,
            };
        }

        pub fn reset(this: *CodeBlock, context: *const Context) void {
            this.content.clearAndFree();
            this.start = context.cur_loc;
            this.end = context.cur_loc;
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
    last_sc: usize = SC_INITIAL,

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
        c.cur_codeblock = Parser.Context.CodeBlock.init(&c);
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
} || ZA.YYError;
%}

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
    switch (parser.context.cur_section) {
        .Definitions => {
            parser.context.cur_codeblock.reset(&parser.context);
            parser.context.cur_section = .Rules;
            parser.startCondition.BEGIN(SC_rule);
        },
        .Rules => {
            if (!parser.context.cur_codeblock.isEmpty()) {
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
            }
            parser.context.cur_section = .UserCode;
            parser.startCondition.BEGIN(SC_user_block);
        },
        else => {},
    }
    // std.debug.print("\nsection: {any}, line{d}\n", .{ parser.context.cur_section, parser.context.cur_loc.line });
    parser.context.cur_loc.col = parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    try ZA.CONTINUE();
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
    try ZA.CONTINUE();
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
    try ZA.CONTINUE();
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
    try ZA.CONTINUE();
  }

<INITIAL>^%(s|x) {
    std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    const line = try parser.readRestLine();
    const condition_name = try extractStartConditionName(line);
    std.debug.print("start condition line: {s}, {s}\n", .{ line, condition_name });
    const s = parser.context.start_conditions.name_buf.items.len;
    try parser.context.start_conditions.name_buf.appendSlice(condition_name);
    const e = parser.context.start_conditions.name_buf.items.len;
    try parser.context.start_conditions.names.append(parser.context.start_conditions.name_buf.items[s..e]);
    try parser.context.start_conditions.locs.append(parser.context.cur_loc);
    std.debug.print("start condition line: {s}, {s}, {d}\n", .{ line, condition_name, parser.context.start_conditions.names.items.len });
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col = 0;
    std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    try ZA.CONTINUE();
  }

<code_block>.* {
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);
    parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
    parser.context.cur_codeblock.end.col = parser.yy.leng;
    // std.debug.print("code block content:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.context.cur_loc.col += parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    try ZA.CONTINUE();
  }

<code_block>\n {
    try parser.context.cur_codeblock.content.appendSlice(parser.yy.text[0..parser.yy.leng]);
    parser.context.cur_codeblock.end.line = parser.context.cur_loc.line;
    parser.context.cur_codeblock.end.col = parser.yy.leng;
    // std.debug.print("code block content:{s}\n", .{parser.yy.text[0..parser.yy.leng]});
    parser.context.cur_loc.col += parser.yy.leng;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    try ZA.CONTINUE();
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
    try ZA.CONTINUE();
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
            const action_line_start = line.len - trimed_action_line.len + 1;
            // std.debug.print("action_line_start: {d}\n", .{action_line_start});
            if (!parser.context.cur_codeblock.isEmpty()) {
                // std.debug.print("append last cur_codeblock: {d},{any}\n", .{ parser.context.cur_codeblock.content.items.len, parser.context.cur_codeblock.content.items });
                try parser.context.rules_action_cbs.append(parser.context.cur_codeblock);
                parser.context.cur_codeblock = Parser.Context.CodeBlock.init(&parser.context);
                parser.context.cur_codeblock.start.col = action_line_start;
            }
            // std.debug.print("rule pattern with action:{s},{s}, {d},{d} {d},{d}\n", .{ line[0..pattern_stop], line[pattern_stop..], parser.context.cur_loc.line, parser.context.cur_loc.col, parser.context.cur_codeblock.start.line, parser.context.cur_codeblock.start.col });
            parser.context.cur_codeblock.content.clearAndFree();
            try parser.context.cur_codeblock.content.appendSlice(trimed_action_line);
            parser.context.cur_codeblock.start = .{
                .line = parser.context.cur_loc.line,
                .col = action_line_start,
            };
            parser.context.cur_codeblock.end = .{
                .line = parser.context.cur_loc.line,
                .col = line.len,
            };
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
    try ZA.CONTINUE();
  }


<rule>\n {
    try parser.context.cur_codeblock.content.append('\n');
    // std.debug.print("rule new line:\n", .{});
    parser.context.cur_loc.line += 1;
    parser.context.cur_loc.col = 0;
    // std.debug.print("now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    try ZA.CONTINUE();
  }

<user_block>(.|\n)* {
    _ = parser;
    try ZA.CONTINUE();
  }

<*>.|\n {
    if (parser.yy.leng == 1 and parser.yy.text[0] == '\n') {
        parser.context.cur_loc.line += 1;
        parser.context.cur_loc.col = 0;
    } else {
        parser.context.cur_loc.col += 1;
    }
    // std.debug.print("default now loc: line={d} col={d}\n", .{ parser.context.cur_loc.line, parser.context.cur_loc.col });
    try ZA.CONTINUE();
  }

%%

// user code