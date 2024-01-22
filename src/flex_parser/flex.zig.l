%{
const Context = struct {
    pub const Error = error{
        LexSyntaxError,
    };

    const Scope = enum {
        CodeBlock,
        Comment,
        Flex,
    };
    const Section = enum {
        BeforeRules,
        Rule,
        AfterRules,
        UserCode,
    };
    const Loc = struct {
        line: usize = 0,
        col: usize = 0,
    };
    const CodeBlock = struct {
        allocator: std.mem.Allocator,
        content: std.ArrayList(u8),
        start: Loc = Loc{},
        end: Loc = Loc{},
    };

    allocator: std.mem.Allocator,
    code_blocks_before_rules: std.ArrayList(CodeBlock),
    rule_actions: std.ArrayList(CodeBlock),
    code_block_after_rules: ?CodeBlock,
    user_block: ?CodeBlock,
    scope_stack: std.ArrayList(Scope),
    cur_section: Section = .BeforeRule,
    cur_scope: Scope = .Flex,
    cur_loc: Loc = Loc{},

    fn ensureLastCodeBlock(this: *Context, arr: *std.ArrayList(CodeBlock)) !*CodeBlock {
        if (arr.items.len == 0) {
            try arr.append(CodeBlock{
                .allocator = this.allocator,
                .content = std.ArrayList(u8).init(this.allocator),
                .start = this.cur_loc,
                .end = this.cur_loc,
            });
        }
        return &arr.items[arr.items.len - 1];
    }

    fn ensureBlock(this: *Context, which: Section) *CodeBlock {
        switch(which) {
            .AfterRules => {
                if (this.code_block_after_rules == null) {
                    this.code_block_after_rules = CodeBlock{
                        .allocator = this.allocator,
                        .content = std.ArrayList(u8).init(this.allocator),
                        .start = this.cur_loc,
                        .end = this.cur_loc,
                    };
                }
                return &(this.code_block_after_rules.?);
            },
            .UserCode => {
                if (this.user_block == null) {
                    this.user_block = CodeBlock{
                        .allocator = this.allocator,
                        .content = std.ArrayList(u8).init(this.allocator),
                        .start = this.cur_loc,
                        .end = this.cur_loc,
                    };
                }
                return &(this.user_block.?);
            },
            else => unreachable,
        }
    }
};
%}

  const std = @import("std");

ws [ \t]
nl [\r\n]

%%

%{
    // code block before rules
%}

"\ "

[\ 123]+  {}

{ws}+    {
            switch(parser.context.cur_scope) {
                .Flex, .Comment => {},
                .CodeBlock => switch (parser.context.cur_section) {
                    .BeforeRules => {
                        const block_ = try parser.context.ensureLastCodeBlock(parser.context.code_blocks_before_rules);
                        try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                    },
                    .Rule => {
                        const block_ = try parser.context.ensureLastCodeBlock(parser.context.rule_actions);
                        try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                    },
                    .AfterRules => {
                        const block_ = parser.context.ensureBlock(.AfterRules);
                        try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                    },
                    .UserCode => {
                        const block_ = parser.context.ensureBlock(.UserCode);
                        try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                    },
                },
            }
            parser.context.cur_loc.col += parser.yy.leng;
        }

{nl}     {
            switch(parser.context.cur_scope) {
                .Flex => {},
                .Comment => {
                    parser.context.cur_scope = parser.context.scope_stack.pop();
                },
                .CodeBlock => switch (parser.context.cur_section) {
                    .BeforeRules => {
                        const block_ = try parser.context.ensureLastCodeBlock(parser.context.code_blocks_before_rules);
                        try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                    },
                    .Rule => {
                        const block_ = try parser.context.ensureLastCodeBlock(parser.context.rule_actions);
                        try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                    },
                    .AfterRules => {
                        const block_ = parser.context.ensureBlock(.AfterRules);
                        try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                    },
                    .UserCode => {
                        const block_ = parser.context.ensureBlock(.UserCode);
                        try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                    },
                },
            }
            parser.context.cur_loc.line += 1;
            parser.context.cur_loc.col = 0;
        }

\/\/    {
            switch(parser.context.cur_scope) {
                .Flex, .Comment => {},
                .CodeBlock => {
                    switch (parser.context.cur_section) {
                        .BeforeRules => {
                            const block_ = try parser.context.ensureLastCodeBlock(parser.context.code_blocks_before_rules);
                            try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                        },
                        .Rule => {
                            const block_ = try parser.context.ensureLastCodeBlock(parser.context.rule_actions);
                            try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                        },
                        .AfterRules => {
                            const block_ = parser.context.ensureBlock(.AfterRules);
                            try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                        },
                        .UserCode => {
                            const block_ = parser.context.ensureBlock(.UserCode);
                            try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                        },
                    }
                    parser.context.scope_stack.append(parser.context.cur_scope);
                    parser.context.cur_scope = .Comment;
                },
            }
            parser.context.cur_loc.col += 2;
        }

\%\%     {
            switch(parser.context.section) {
                .BeforeRules => { parser.context.cur_section = .Rule; },
                .Rule => { parser.conetxt.cur_section = .AfterRules; },
                .AfterRules => { parser.context.cur_section = .UserCode; },
                .UserCode =>{ return Context.Error.LexSyntaxError; },
            }
            parser.context.cur_loc.col += 2;
        }

\{z    {
            switch(parser.context.cur_scope) {
                .Flex => {
                    parser.context.scope_stack.append(parser.context.cur_scope);
                    parser.context.cur_scope = .CodeBlock;
                },
                .Comment => {},
                .CodeBlock => {
                    return Context.Error.LexSyntaxError;
                },
            }
            parser.context.cur_loc.col += 2;
        }

z\}    {
            switch(parser.context.cur_scope) {
                .Flex => {
                    const maybe_last_scope = parser.context.scope_stack.popOrNull();
                    if (maybe_last_scope) |last_scope| {
                        if (last_scope == .CodeBlock) {
                        parser.context.cur_scope = parser.context.scope_stack.pop();
                        } else return Context.Error.LexSyntaxError;
                    } else {
                        return Context.Error.LexSyntaxError;
                    }
                },
                .Comment => {},
                .CodeBlock => {
                    return Context.Error.LexSyntaxError;
                },
            }
            parser.context.cur_loc.col += 2;
        }

.     {
            switch(parser.context.cur_scope) {
                .Flex, .Comment => {},
                .CodeBlock => {
                    switch (parser.context.cur_section) {
                        .BeforeRules => {
                            const block_ = try parser.context.ensureLastCodeBlock(parser.context.code_blocks_before_rules);
                            try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                        },
                        .Rule => {
                            const block_ = try parser.context.ensureLastCodeBlock(parser.context.rule_actions);
                            try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                        },
                        .AfterRules => {
                            const block_ = parser.context.ensureBlock(.AfterRules);
                            try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                        },
                        .UserCode => {
                            const block_ = parser.context.ensureBlock(.UserCode);
                            try block_.appendSlice(parser.yy.text[0..parser.yy.leng]);
                        },
                    }
                    parser.context.scope_stack.append(parser.context.cur_scope);
                    parser.context.cur_scope = .Comment;
                },
            }
            parser.context.cur_loc.col += 1;
        }

%{
    // code block after rules
%}

%%

// user code
