// /* A Bison parser, made by Zison (v1) through GNU Bison 3.8.2.//  */
// /* zison is part of zlexison: https://github.com/liyu1981/zlexison//  */

// /* C GLR parser skeleton written by Paul Hilfinger.  */

// /* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
//    especially those whose name start with YY_ or yy_.  They are
//    private implementation details that can be changed or removed.//  */

// zison version
const ZISON_VERSION = "1";

// /* Identify Bison output, and Bison version.  */
const YYBISON = 30802;

// /* Bison version string.  */
const YYBISON_VERSION = "3.8.2";

// /* Skeleton name.  */
const YYSKELETON_NAME = "zig-glr.m4";

// /* Pure parsers.  */
// in zison, no matter set or not set %define api.pure, it will always be "pure"
const YYPURE = 1;

const std = @import("std");
const Self = @This();
const YYParser = @This();
const YY_ASSERT = std.debug.assert;

/// utils for pointer operations.
// inline fn cPtrDistance(comptime T: type, p1: [*c]T, p2: [*c]T) usize {
//     return (@intFromPtr(p2) - @intFromPtr(p1)) / @sizeOf(T);
// }

inline fn ptrEq(p1: anytype, p2: anytype) bool {
    return @intFromPtr(p1) == @intFromPtr(p2);
}

inline fn ptrDistance(comptime T: type, p1: *allowzero T, p2: *allowzero T) usize {
    return (@intFromPtr(p2) - @intFromPtr(p1)) / @sizeOf(T);
}

inline fn ptrLessThan(p1: anytype, p2: anytype) bool {
    return @intFromPtr(p1) < @intFromPtr(p2);
}

inline fn ptrLessThanEql(comptime T: type, p1: [*]allowzero T, p2: [*]allowzero T) bool {
    return @intFromPtr(p1) <= @intFromPtr(p2);
}

inline fn ptrWithOffset(comptime T: type, p: [*]allowzero T, offset: isize) *allowzero T {
    const v = arrPtrWithOffset(T, p, offset)[0];
    switch (@typeInfo(T)) {
        .Pointer => {
            if (@intFromPtr(v) == 0) {
                return @ptrFromInt(0);
            } else {
                return &(arrPtrWithOffset(T, p, offset)[0]);
            }
        },
        else => {
            return &(arrPtrWithOffset(T, p, offset)[0]);
        },
    }
}

inline fn valueWithOffset(comptime T: type, p: [*]allowzero T, offset: isize) T {
    return arrPtrWithOffset(T, p, offset)[0];
}

inline fn arrPtrWithOffset(comptime T: type, p: [*]allowzero T, offset: isize) [*]allowzero T {
    if (@intFromPtr(p) == 0) {
        return @ptrFromInt(0);
    } else {
        return @as([*]allowzero T, @ptrFromInt(@as(usize, @intCast(@as(isize, @intCast(@intFromPtr(p))) + offset * @sizeOf(T)))));
    }
}

inline fn movePtr(p: anytype, offset: isize) @TypeOf(p) {
    const PType = @typeInfo(@TypeOf(p)).Pointer.child;
    return @ptrFromInt(@as(usize, @intCast((@as(isize, @intCast(@intFromPtr(p))) + offset * @sizeOf(PType)))));
}

// /* "%code top" blocks.//  */
// #line 101 "parser.y"

const YYLexer = @import("scan.zig");
const zlexison = @import("zlexison.zig");
const Node = zlexison.Node;

// #line 60 "parser.zig"

// /* Debug traces.  */
const YYDEBUG = 1;

pub var yydebug: bool = YYDEBUG == 1;

// /* Token kinds. eq isize */
pub const yytoken_kind_t = struct {
    pub const YYEMPTY = -2;
    pub const YYEOF = 0; // /* "end of file"//  */
    pub const YYerror = 256; // /* error//  */
    pub const YYUNDEF = 257; // /* "invalid token"//  */
    pub const TYPENAME = 258; // /* "typename"//  */
    pub const ID = 259; // /* "identifier"//  */

    pub fn value2name(v: isize) []const u8 {
        switch (v) {
            -2 => return "YYEMPTY",
            0 => return "YYEOF",
            256 => return "YYerror",
            257 => return "YYUNDEF",
            258 => return "TYPENAME",
            259 => return "ID",
            else => unreachable,
        }
    }
};

// /* Value type.  */
pub const YYSTYPE = YYLexer.YYSTYPE;

// /* Location type.  */
const YYLTYPE = YYLexer.YYLTYPE;

// /* Symbol kind. eq isize */
pub const yysymbol_kind_t = struct {
    pub const YYSYMBOL_YYEMPTY = -2;
    pub const YYSYMBOL_YYEOF = 0; // /* "end of file"//  */
    pub const YYSYMBOL_YYerror = 1; // /* error//  */
    pub const YYSYMBOL_YYUNDEF = 2; // /* "invalid token"//  */
    pub const YYSYMBOL_TYPENAME = 3; // /* "typename"//  */
    pub const YYSYMBOL_ID = 4; // /* "identifier"//  */
    pub const YYSYMBOL_5_ = 5; // /* '='//  */
    pub const YYSYMBOL_6_ = 6; // /* '+'//  */
    pub const YYSYMBOL_7_ = 7; // /* ';'//  */
    pub const YYSYMBOL_8_ = 8; // /* '('//  */
    pub const YYSYMBOL_9_ = 9; // /* ')'//  */
    pub const YYSYMBOL_YYACCEPT = 10; // /* $accept//  */
    pub const YYSYMBOL_prog = 11; // /* prog//  */
    pub const YYSYMBOL_stmt = 12; // /* stmt//  */
    pub const YYSYMBOL_expr = 13; // /* expr//  */
    pub const YYSYMBOL_decl = 14; // /* decl//  */
    pub const YYSYMBOL_declarator = 15; // /* declarator//  */
};

// /* Default (constant) value used for initialization for null
//    right-hand sides.  Unlike the standard yacc.c template, here we set
//    the default value of $$ to a zeroed-out value.  Since the default
//    value is undefined, this behavior is technically correct.  */
const yyval_default: YYSTYPE = undefined;
const yyloc_default: YYLTYPE = YYLTYPE{
    .first_line = 0,
    .first_column = 0,
    .last_line = 0,
    .last_column = 0,
};

// /* YYFINAL -- State number of the termination state.  */
const YYFINAL = 2;

// /* YYLAST -- Last index in YYTABLE.  */
const YYLAST = 35;

// /* YYNTOKENS -- Number of terminals.  */
const YYNTOKENS = 10;

// /* YYNNTS -- Number of nonterminals.  */
const YYNNTS = 6;

// /* YYNRULES -- Number of rules.  */
const YYNRULES = 14;

// /* YYNSTATES -- Number of states.  */
const YYNSTATES = 30;

// /* YYMAXRHS -- Maximum number of symbols on right-hand side of rule.  */
const YYMAXRHS = 5;

// /* YYMAXLEFT -- Maximum number of symbols to the left of a handle
//    accessed by $0, $-1, etc., in any rule.  */
const YYMAXLEFT = 0;

// /* YYMAXUTOK -- Last valid token kind.  */
const YYMAXUTOK = 259;

// /* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex, with out-of-bounds checking.  */
inline fn YYTRANSLATE(YYX: anytype) isize {
    return if (0 <= YYX and YYX <= YYMAXUTOK)
        yytranslate[@intCast(YYX)]
    else
        yysymbol_kind_t.YYSYMBOL_YYUNDEF;
}

// /* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex.  */
const yytranslate = [_]isize{ 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 8, 9, 2, 6, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 7, 2, 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 3, 4 };

// /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
const yyrline = [_]isize{ 0, 130, 130, 131, 141, 142, 143, 146, 147, 149, 150, 153, 155, 160, 161 };

const YYPACT_NINF = -5;
const YYTABLE_NINF = -8;

// /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
//    STATE-NUM.//  */
const yypact = [_]isize{ -5, 4, -5, -4, 11, -5, -5, 17, -5, -5, -5, -2, 23, 28, 28, -5, 1, 7, 13, 5, 9, 28, -5, 29, -5, 28, -5, -5, 20, -5 };

// /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
//    Performed when YYTABLE does not specify something else to do.  Zero
//    means the default is an error.//  */
const yydefact = [_]isize{ 2, 0, 1, 0, 0, 7, 3, 0, 5, 6, 13, 0, 0, 0, 0, 4, 0, 7, 0, 0, 0, 0, 11, 10, 9, 0, 8, 14, 0, 12 };

// /* YYPGOTO[NTERM-NUM].//  */
const yypgoto = [_]isize{ -5, -5, -5, -1, -5, 25 };

// /* YYDEFGOTO[NTERM-NUM].//  */
const yydefgoto = [_]isize{ 0, 1, 6, 19, 8, 20 };

// /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
//    positive, shift that token.  If negative, reduce the rule whose
//    number is the opposite.  If YYTABLE_NINF, syntax error.//  */
const yytable = [_]isize{ 7, 16, 17, 9, 2, 3, 18, 4, 5, 25, 13, 14, 23, 24, 26, 10, -7, 10, 27, 11, 28, 18, 13, 14, 15, 13, 14, 29, 21, 12, 22, 16, 5, 0, 13, 14 };

const yycheck = [_]isize{ 1, 3, 4, 7, 0, 1, 8, 3, 4, 8, 5, 6, 13, 14, 9, 4, 9, 4, 9, 8, 21, 8, 5, 6, 7, 5, 6, 7, 5, 4, 7, 3, 4, -1, 5, 6 };

// /* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
//    state STATE-NUM.//  */
const yystos = [_]isize{ 0, 11, 0, 1, 3, 4, 12, 13, 14, 7, 4, 8, 15, 5, 6, 7, 3, 4, 8, 13, 15, 5, 7, 13, 13, 8, 9, 9, 13, 7 };

// /* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.//  */
const yyr1 = [_]isize{ 0, 10, 11, 11, 12, 12, 12, 13, 13, 13, 13, 14, 14, 15, 15 };

// /* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.//  */
const yyr2 = [_]isize{ 0, 2, 0, 2, 2, 1, 2, 1, 4, 3, 3, 3, 5, 1, 3 };

// /* YYDPREC[RULE-NUM] -- Dynamic precedence of rule #RULE-NUM (0 if none).  */
const yydprec = [_]isize{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

// /* YYMERGER[RULE-NUM] -- Index of merging function for rule #RULE-NUM.  */
const yymerger = [_]isize{ 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

// /* YYIMMEDIATE[RULE-NUM] -- True iff rule #RULE-NUM is not to be deferred, as
//    in the case of predicates.  */
const yyimmediate = [_]isize{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

// /* YYCONFLP[YYPACT[STATE-NUM]] -- Pointer into YYCONFL of start of
//    list of conflicting reductions corresponding to action entry for
//    state STATE-NUM in yytable.  0 means no conflicts.  The list in
//    yyconfl is terminated by a rule number of 0.  */
const yyconflp = [_]isize{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

// /* YYCONFL[I] -- lists of conflicting rule numbers, each terminated by
//    0, pointed into by YYCONFLP.  */
const yyconfl = [_]isize{ 0, 13, 0 };

// /* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
//    If N is 0, then set CURRENT to the empty location which ends
//    the previous symbol: RHS[0] (always defined).  */

fn YYLLOC_DEFAULT(current: *YYLTYPE, rhs: [*]YYLTYPE, N: usize) void {
    if (N > 0) {
        current.first_line = rhs[1].first_line;
        current.first_column = rhs[1].first_column;
        current.last_line = rhs[N].last_line;
        current.last_column = rhs[N].last_column;
    } else {
        current.first_line = rhs[0].last_line;
        current.last_line = current.first_line;
        current.first_column = rhs[0].last_column;
        current.last_column = current.last_column;
    }
}

inline fn YYRHSLOC(Rhs: anytype, K: anytype) YYLTYPE {
    return (Rhs)[@intCast(K)].yystate.yyloc;
}

// #define yynerrs (yystackp->yyerrcnt)
// #define yychar (yystackp->yyrawchar)
// #define yylval (yystackp->yyval)
// #define yylloc (yystackp->yyloc)

const YYENOMEM = -2;

// YYRESULTTAG, eq isize
const YYRESULTTAG = struct {
    pub const yyok = 0;
    pub const yyaccept = 1;
    pub const yyabort = 2;
    pub const yyerr = 3;
    pub const yynomem = 4;
};

// inline fn YYCHK(YYE: usize) usize {
//     if (YYE != YYRESULTTAG.yyok) {
//         return YYE;
//     }
//     return YYRESULTTAG.yyok;
// }

// /* YYINITDEPTH -- initial size of the parser's stacks.  */
const YYINITDEPTH = 200;

// /* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
//    if the built-in stack extension method is used).
//
//    Do not make this value too large; the results are undefined if
//    SIZE_MAX < YYMAXDEPTH * sizeof (GLRStackItem)
//    evaluated with infinite-precision integer arithmetic.  */

const YYMAXDEPTH = 10000;

// /* Minimum number of free items on the stack allowed after an
//    allocation.  This is to allow allocation and initialization
//    to be completed by functions that call yyexpandGLRStack before the
//    stack is expanded, thus insuring that all necessary pointers get
//    properly redirected to new data.  */
const YYHEADROOM = 2;

inline fn YYSTACKEXPANDABLE(yystack: anytype) !void {
    if (yystack.yyspaceLeft < YYHEADROOM) {
        try yyexpandGLRStack(yystack);
    }
}

inline fn YY_RESERVE_GLRSTACK(yystackp: *yyGLRStack) !void {
    if (yystackp.yyspaceLeft < YYHEADROOM) {
        return error.yyMemoryExhausted;
    }
}

const YYSIZE_MAXIMUM = std.math.maxInt(usize);
const YYSTACK_ALLOC_MAXIMUM = YYSIZE_MAXIMUM;

// /** State numbers. */
// const yy_state_t = usize;

// /** Rule numbers. */
// const yyRuleNum = usize;

// /** Item references. */
// const yyItemNum = usize;

// const YYPTRDIFF_T = isize;

const yyGLRState = struct {
    pub const YYSemantics = extern union {
        // /** First in a chain of alternative reductions producing the
        //  *  nonterminal corresponding to this state, threaded through
        //  *  yynext.  */
        yyfirstVal: *allowzero yySemanticOption,
        // /** Semantic value for this state.  */
        yyval: YYSTYPE,
    };

    // /** Type tag: always true.  */
    // yyisState: bool = true,
    // /** Type tag for yysemantics.  If true, yyval applies, otherwise
    //  *  yyfirstVal applies.  */
    yyresolved: bool = false,
    // /** Number of corresponding LALR(1) machine state.  */
    yylrState: usize = 0,
    // /** Preceding state in this stack */
    yypred: *allowzero yyGLRState = @ptrFromInt(0),
    // /** Source position of the last token produced by my symbol */
    yyposn: isize = 0,
    yysemantics: YYSemantics = undefined,
    // /** Source location for this state.  */
    yyloc: YYLTYPE = undefined,
};

const yyGLRStateSet = struct {
    yystates_arr: []*allowzero yyGLRState = undefined,
    yystates: [*]allowzero *allowzero yyGLRState = undefined,
    // /** During nondeterministic operation, yylookaheadNeeds tracks which
    //  *  stacks have actually needed the current lookahead.  During deterministic
    //  *  operation, yylookaheadNeeds[0] is not maintained since it would merely
    //  *  duplicate yychar != YYEMPTY.  */
    yylookaheadNeeds: []bool = undefined,
    yysize: usize = 0,
    yycapacity: usize = 0,
};

const yySemanticOption = struct {
    // /** Type tag: always false.  */
    // yyisState: bool = false,
    // /** Rule number for this reduction */
    yyrule: usize = 0,
    // /** The last RHS state in the list of states to be reduced.  */
    yystate: *allowzero yyGLRState = @ptrFromInt(0),
    // /** The lookahead for this reduction.  */
    yyrawchar: i8 = 0,
    yyval: YYSTYPE = undefined,
    yyloc: YYLTYPE = undefined,
    // /** Next sibling in chain of options.  To facilitate merging,
    //  *  options are chained in decreasing order by address.  */
    yynext: *allowzero yySemanticOption = @ptrFromInt(0),
};

// /** Type of the items in the GLR stack.  The yyisState field
//  *  indicates which item of the union is valid.  */
const yyGLRStackItem = extern union {
    yystate: *allowzero yyGLRState,
    yyoption: *allowzero yySemanticOption,
};

const yyGLRStack = struct {
    yyerrState: isize,
    // /* To compute the location of the error token.  */
    yyerror_range: [3]yyGLRStackItem = undefined,

    yyerrcnt: usize = 0,
    yyrawchar: i8 = 0,
    yyval: YYSTYPE = undefined,
    yyloc: YYLTYPE = undefined,

    yyitems_arr: []yyGLRStackItem = undefined,
    yystate_arr: []yyGLRState = undefined,
    yystate_next: usize = 0,
    yyoption_arr: []yySemanticOption = undefined,
    yyoption_next: usize = 0,

    // yyexception_buffer: YYJMP_BUF,
    yyitems: [*]allowzero yyGLRStackItem,
    yynextFree: *allowzero yyGLRStackItem,
    yyspaceLeft: usize,
    yysplitPoint: *allowzero yyGLRState,
    yylastDeleted: *allowzero yyGLRState,
    yytops: yyGLRStateSet,
};

inline fn yyerror(loc: *YYLTYPE, msg: []const u8) void {
    std.debug.print("{s}: {s}\n", .{ loc.*, msg });
}

const YY_NULLPTR = "";

fn yyFail(yystackp: *yyGLRStack, yylocp: *YYLTYPE, scanner: *YYLexer, yymsg: []const u8) usize {
    _ = yystackp;
    _ = scanner;
    if (yymsg.len > 0) {
        yyerror(yylocp, yymsg);
    }
    // TODO: this is a long jump
    return 0;
}

fn yyMemoryExhausted(yystackp: *yyGLRStack) void {
    _ = yystackp;
    // YYLONGJMP (yystackp->yyexception_buffer, 2);
    // TODO: another long jump
    return 0;
}

// /** Accessing symbol of state YYSTATE.  */
inline fn yy_accessing_symbol(yystate: usize) isize {
    return yystos[yystate];
}

// /* The user-facing name of the symbol whose (internal) number is
//    YYSYMBOL.  No bounds checking.  */
// static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

fn yysymbol_name(yysymbol: isize) []const u8 {
    const yy_sname = [_][]const u8{ "end of file", "error", "invalid token", "typename", "identifier", "'='", "'+'", "';'", "'('", "')'", "$accept", "prog", "stmt", "expr", "decl", "declarator", YY_NULLPTR };
    return yy_sname[@intCast(yysymbol)];
}

// /** Left-hand-side symbol for rule #YYRULE.  */
inline fn yylhsNonterm(yyrule: usize) isize {
    return yyr1[yyrule];
}

// /* Print *YYLOCP on YYO.  Private, do not rely on its existence. */
fn yy_location_print_(yyo: std.fs.File, yylocp: *const YYLTYPE) !void {
    const end_col = if (0 != yylocp.last_column) yylocp.last_column - 1 else 0;
    if (yydebug) {
        if (0 <= yylocp.first_line) {
            try yyo.writer().print("{d}", .{yylocp.first_line});
            if (0 <= yylocp.first_column) {
                try yyo.writer().print(".{d}", .{yylocp.first_column});
            }
        }
        if (0 <= yylocp.last_line) {
            if (yylocp.first_line < yylocp.last_line) {
                try yyo.writer().print("-{d}", .{yylocp.last_line});
                if (0 <= end_col) {
                    try yyo.writer().print(".{d}", .{end_col});
                }
            } else if (0 <= end_col and yylocp.first_column < end_col) {
                try yyo.writer().print("-{d}", .{end_col});
            }
        }
    }
}

// /*-----------------------------------.
// | Print this symbol's value on YYO.  |
// `-----------------------------------*/

fn yy_symbol_value_print(yyo: std.fs.File, yykind: isize, yyvaluep: *const YYSTYPE, yylocationp: *const YYLTYPE) !void {
    _ = yylocationp;
    // if (yyvaluep == null) return;
    switch (yykind) {
        yysymbol_kind_t.YYSYMBOL_TYPENAME => { // /* "typename"//  */
            // #line 122 "parser.y"
            {
                const s = try ((yyvaluep).TYPENAME).toString(std.heap.page_allocator);
                defer std.heap.page_allocator.free(s);
                try yyo.writer().print("{s}", .{s});
            }
            // #line 568 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_ID => { // /* "identifier"//  */
            // #line 122 "parser.y"
            {
                const s = try ((yyvaluep).ID).toString(std.heap.page_allocator);
                defer std.heap.page_allocator.free(s);
                try yyo.writer().print("{s}", .{s});
            }
            // #line 576 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_stmt => { // /* stmt//  */
            // #line 122 "parser.y"
            {
                const s = try ((yyvaluep).stmt).toString(std.heap.page_allocator);
                defer std.heap.page_allocator.free(s);
                try yyo.writer().print("{s}", .{s});
            }
            // #line 584 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_expr => { // /* expr//  */
            // #line 122 "parser.y"
            {
                const s = try ((yyvaluep).expr).toString(std.heap.page_allocator);
                defer std.heap.page_allocator.free(s);
                try yyo.writer().print("{s}", .{s});
            }
            // #line 592 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_decl => { // /* decl//  */
            // #line 122 "parser.y"
            {
                const s = try ((yyvaluep).decl).toString(std.heap.page_allocator);
                defer std.heap.page_allocator.free(s);
                try yyo.writer().print("{s}", .{s});
            }
            // #line 600 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_declarator => { // /* declarator//  */
            // #line 122 "parser.y"
            {
                const s = try ((yyvaluep).declarator).toString(std.heap.page_allocator);
                defer std.heap.page_allocator.free(s);
                try yyo.writer().print("{s}", .{s});
            }
            // #line 608 "parser.zig"
        },

        else => {},
    }
}

// /*---------------------------.
// | Print this symbol on YYO.  |
// `---------------------------*/

fn yy_symbol_print(yyo: std.fs.File, yykind: isize, yyvaluep: *const YYSTYPE, yylocationp: *const YYLTYPE) !void {
    try yyo.writer().print("{s} {s} (", .{
        if (yykind < YYNTOKENS) "token" else "nterm",
        yysymbol_name(yykind),
    });
    try yy_location_print_(yyo, yylocationp);
    try yyo.writer().print(": ", .{});
    try yy_symbol_value_print(yyo, yykind, yyvaluep, yylocationp);
    try yyo.writer().print(")", .{});
}

fn YY_SYMBOL_PRINT(title: []const u8, kind: anytype, value: anytype, locationp: *const YYLTYPE) !void {
    std.debug.print("{s}", .{title});
    try yy_symbol_print(std.io.getStdErr(), kind, value, locationp);
    std.debug.print("\n", .{});
}

// static inline void
// yy_reduce_print (yybool yynormal, yyGLRStackItem* yyvsp, YYPTRDIFF_T yyk,
//                  yyRuleNum yyrule, scanner: *YYLexer);

// /* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
//    YYDEST.  */
fn yystpcpy(yydest: [*]u8, yysrc: [*]u8) [*]u8 {
    var yyd = yydest;
    var yys = yysrc;
    while (yys[0] != 0) {
        yyd[0] = yys[0];
        yyd += 1;
        yys += 1;
    }
    return yyd - 1;
}

// /** Fill in YYVSP[YYLOW1 .. YYLOW0-1] from the chain of states starting
//  *  at YYVSP[YYLOW0].yystate.yypred.  Leaves YYVSP[YYLOW1].yystate.yypred
//  *  containing the pointer to the next state in the chain.  */
fn yyfillin(yyvsp: *allowzero yyGLRStackItem, yylow0: isize, yylow1: isize) void {
    var i: isize = yylow0 - 1;
    var s = movePtr(yyvsp, yylow0).yystate.yypred;
    while (i >= yylow1) : (i -= 1) {
        const yyvsp_item = movePtr(yyvsp, i);
        const yystatep = yyvsp_item.yystate;
        if (yydebug) {
            yystatep.yylrState = s.yylrState;
        }
        yystatep.yyresolved = s.yyresolved;
        if (s.yyresolved) {
            yystatep.yysemantics.yyval = s.yysemantics.yyval;
        } else {
            // /* The effect of using yyval or yyloc (in an immediate rule) is
            //  * undefined.  */
            yystatep.yysemantics.yyfirstVal = @ptrFromInt(0);
        }
        yystatep.yyloc = s.yyloc;
        yystatep.yypred = s.yypred;
        s = yystatep.yypred;
    }
}

// /** If yychar is empty, fetch the next token.  */
inline fn yygetToken(yycharp: *i8, yystackp: *yyGLRStack, scanner: *YYLexer) !isize {
    var yytoken: isize = undefined;
    if (yycharp.* == yytoken_kind_t.YYEMPTY) {
        if (yydebug) {
            std.debug.print("Reading a token\n", .{});
        }
        yycharp.* = @intCast(try scanner.yylex(&yystackp.yyval, &yystackp.yyloc));
        // yycharp.* = scanner.yylex (&yyctx.yylval, &yyctx.yylloc);
    }
    if (yycharp.* <= yytoken_kind_t.YYEOF) {
        yycharp.* = yytoken_kind_t.YYEOF;
        yytoken = yysymbol_kind_t.YYSYMBOL_YYEOF;
        if (yydebug) {
            std.debug.print("Now at end of input.\n", .{});
        }
    } else {
        yytoken = YYTRANSLATE(yycharp.*);
        try YY_SYMBOL_PRINT("Next token is", yytoken, &yystackp.yyval, &yystackp.yyloc);
    }
    return yytoken;
}

// /* Do nothing if YYNORMAL or if *YYLOW <= YYLOW1.  Otherwise, fill in
//  * YYVSP[YYLOW1 .. *YYLOW-1] as in yyfillin and set *YYLOW = YYLOW1.
//  * For convenience, always return YYLOW1.  */
inline fn yyfill(yyvsp: *allowzero yyGLRStackItem, yylow_: *isize, yylow1: isize, yynormal: bool) isize {
    if (!yynormal and yylow1 < yylow_.*) {
        yyfillin(yyvsp, yylow_.*, yylow1);
        yylow_.* = yylow1;
    }
    return yylow1;
}

fn yyerrok(yystackp: *yyGLRStack) void {
    yystackp.yyerrState = 0;
}

// use YYACCEPT as
//   return YYRESULTTAG.yyaccept;

// use YYABORT as
//   retrun YYRESULTTAG.yyabort;

// use YYNOMEM as
//   return YYRESULTTAG.yynomem;

// use YYERROR as
fn YYERROR(yystackp: *yyGLRStack) usize {
    yyerrok(yystackp);
    return YYRESULTTAG.yyerr;
}

// YYRECOVERING
inline fn YYRECOVERING(yystackp: *yyGLRStack) bool {
    return yystackp.yyerrState != 0;
}

// yyclearin
inline fn yyclearin(yychar_: *u8) void {
    yychar_.* = yytoken_kind_t.YYEMPTY;
    yyclearin(yychar_.*);
}

// # define YYFILL(N) yyfill (yyvsp, &yylow, (N), yynormal)
// inline fn YYFILL(N: usize) usize {
//   return yyfill(yyvsp, yylow_, N, yynormal);
// }

// # define YYBACKUP(Token, Value)                                              \
//   return yyerror (yylocp, YYLexer, YY_("syntax error: cannot back up")),     \
//          yyerrok, yyerr

fn yyGLRStackItem2Locs(yyvsp: *allowzero yyGLRStackItem, N: usize, yyvsp_locs: []YYLTYPE) void {
    if (N == 0) {
        yyvsp_locs[0] = yyvsp.yystate.yyloc;
    } else {
        yyvsp_locs[1] = movePtr(yyvsp, 1).yystate.yyloc;
        yyvsp_locs[N] = movePtr(yyvsp, @intCast(N)).yystate.yyloc;
    }
}

// /** Perform user action for rule number YYN, with RHS length YYRHSLEN,
//  *  and top stack item YYVSP.  YYLVALP points to place to put semantic
//  *  value ($$), and yylocp points to place for location information
//  *  (@$).  Returns yyok for normal return, yyaccept for YYACCEPT,
//  *  yyerr for YYERROR, yyabort for YYABORT, yynomem for YYNOMEM.  */
fn yyuserAction(yyctx: *yyparse_context_t, yyrule: usize, yyrhslen: usize, yyvsp: *allowzero yyGLRStackItem, yystackp: *allowzero yyGLRStack, yyk: isize, yyvalp: *YYSTYPE, yylocp: *YYLTYPE) !usize {
    const yynormal: bool = @intFromPtr(yystackp.yysplitPoint) == 0;
    var yylow: isize = 1;

    if (yyrhslen == 0) {
        yyvalp.* = yyval_default;
    } else {
        const yylow1 = 1 - @as(isize, @intCast(yyrhslen));
        const yyvspi = yyfill(yyvsp, &yylow, yylow1, yynormal);
        yyvalp.* = movePtr(yyvsp, yyvspi).yystate.yysemantics.yyval;
    }
    // /* Default location. */
    {
        var yyvsp_locs: [YYMAXRHS + YYMAXLEFT + 1]YYLTYPE = undefined;
        yyGLRStackItem2Locs(yyvsp, yyrhslen, &yyvsp_locs);
        YYLLOC_DEFAULT(yylocp, &yyvsp_locs, yyrhslen);
    }
    yystackp.yyerror_range[1].yystate.yyloc = yylocp.*;
    // /* If yyk == -1, we are running a deferred action on a temporary
    //    stack.  In that case, YY_REDUCE_PRINT must not play with YYFILL,
    //    so pretend the stack is "normal". */
    if (yydebug) {
        try yy_reduce_print(yynormal or yyk == -1, yyvsp, yyk, yyrule);
    }
    switch (yyrule) {
        3 => { // /* prog: prog stmt//  */
            // #line 131 "parser.y"
            {
                const stdout_writer = std.io.getStdOut().writer();
                try stdout_writer.print("{s}", .{&(movePtr(yyvsp, yyfill(yyvsp, &yylow, 0, yynormal)).yystate.yyloc)});
                try stdout_writer.print(": ", .{});
                try stdout_writer.print("{s}", .{(movePtr(yyvsp, yyfill(yyvsp, &yylow, 0, yynormal)).yystate.yysemantics.yyval.stmt)});
                try stdout_writer.print("\n", .{});
                (movePtr(yyvsp, yyfill(yyvsp, &yylow, 0, yynormal)).yystate.yysemantics.yyval.stmt).free(yyctx.allocator);
            }
            // #line 804 "parser.zig"
        },

        4 => { // /* stmt: expr ';'//  */
            // #line 141 "parser.y"
            {
                ((yyvalp).stmt) = (movePtr(yyvsp, yyfill(yyvsp, &yylow, -1, yynormal)).yystate.yysemantics.yyval.expr);
            }
            // #line 810 "parser.zig"
        },

        6 => { // /* stmt: error ';'//  */
            // #line 143 "parser.y"
            {
                ((yyvalp).stmt) = try Node.newNterm(yyctx.allocator, "<error>", null, null, null);
            }
            // #line 816 "parser.zig"
        },

        8 => { // /* expr: "typename" '(' expr ')'//  */
            // #line 148 "parser.y"
            {
                ((yyvalp).expr) = try Node.newNterm(yyctx.allocator, "<cast>(%s, %s)", (movePtr(yyvsp, yyfill(yyvsp, &yylow, -1, yynormal)).yystate.yysemantics.yyval.expr), (movePtr(yyvsp, yyfill(yyvsp, &yylow, -3, yynormal)).yystate.yysemantics.yyval.TYPENAME), null);
            }
            // #line 822 "parser.zig"
        },

        9 => { // /* expr: expr '+' expr//  */
            // #line 149 "parser.y"
            {
                ((yyvalp).expr) = try Node.newNterm(yyctx.allocator, "+(%s, %s)", (movePtr(yyvsp, yyfill(yyvsp, &yylow, -2, yynormal)).yystate.yysemantics.yyval.expr), (movePtr(yyvsp, yyfill(yyvsp, &yylow, 0, yynormal)).yystate.yysemantics.yyval.expr), null);
            }
            // #line 828 "parser.zig"
        },

        10 => { // /* expr: expr '=' expr//  */
            // #line 150 "parser.y"
            {
                ((yyvalp).expr) = try Node.newNterm(yyctx.allocator, "=(%s, %s)", (movePtr(yyvsp, yyfill(yyvsp, &yylow, -2, yynormal)).yystate.yysemantics.yyval.expr), (movePtr(yyvsp, yyfill(yyvsp, &yylow, 0, yynormal)).yystate.yysemantics.yyval.expr), null);
            }
            // #line 834 "parser.zig"
        },

        11 => { // /* decl: "typename" declarator ';'//  */
            // #line 154 "parser.y"
            {
                ((yyvalp).decl) = try Node.newNterm(yyctx.allocator, "<declare>(%s, %s)", (movePtr(yyvsp, yyfill(yyvsp, &yylow, -2, yynormal)).yystate.yysemantics.yyval.TYPENAME), (movePtr(yyvsp, yyfill(yyvsp, &yylow, -1, yynormal)).yystate.yysemantics.yyval.declarator), null);
            }
            // #line 840 "parser.zig"
        },

        12 => { // /* decl: "typename" declarator '=' expr ';'//  */
            // #line 156 "parser.y"
            {
                ((yyvalp).decl) = try Node.newNterm(yyctx.allocator, "<init-declare>(%s, %s, %s)", (movePtr(yyvsp, yyfill(yyvsp, &yylow, -4, yynormal)).yystate.yysemantics.yyval.TYPENAME), (movePtr(yyvsp, yyfill(yyvsp, &yylow, -3, yynormal)).yystate.yysemantics.yyval.declarator), (movePtr(yyvsp, yyfill(yyvsp, &yylow, -1, yynormal)).yystate.yysemantics.yyval.expr));
            }
            // #line 846 "parser.zig"
        },

        14 => { // /* declarator: '(' declarator ')'//  */
            // #line 161 "parser.y"
            {
                ((yyvalp).declarator) = (movePtr(yyvsp, yyfill(yyvsp, &yylow, -1, yynormal)).yystate.yysemantics.yyval.declarator);
            }
            // #line 852 "parser.zig"
        },

        // #line 856 "parser.zig"

        else => {},
    }
    try YY_SYMBOL_PRINT("-> $$ =", yylhsNonterm(yyrule), yyvalp, yylocp);
    return YYRESULTTAG.yyok;
}

fn yyuserMerge(yyctx: *yyparse_context_t, yyn: isize, yy0: *YYSTYPE, yy1: *YYSTYPE) !void {
    switch (yyn) {
        1 => {
            yy0.stmt = try stmtMerge(yyctx, yy0, yy1);
            // #line 869 "parser.zig"
        },

        else => {},
    }
}

//                               /* Bison grammar-table manipulation.  */

// /*-----------------------------------------------.
// | Release the memory associated to this symbol.  |
// `-----------------------------------------------*/

fn yydestruct(yyctx: *yyparse_context_t, yymsg: []const u8, yykind: isize, yyvaluep: *const YYSTYPE, yylocationp: *const YYLTYPE) !void {
    {
        _ = &yyctx;
        _ = &yylocationp;
    }

    try YY_SYMBOL_PRINT(yymsg, yykind, yyvaluep, yylocationp);

    switch (yykind) {
        yysymbol_kind_t.YYSYMBOL_TYPENAME => { // /* "typename"//  */
            // #line 121 "parser.y"
            {
                ((yyvaluep).TYPENAME).free(yyctx.allocator);
            }
            // #line 895 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_ID => { // /* "identifier"//  */
            // #line 121 "parser.y"
            {
                ((yyvaluep).ID).free(yyctx.allocator);
            }
            // #line 901 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_stmt => { // /* stmt//  */
            // #line 121 "parser.y"
            {
                ((yyvaluep).stmt).free(yyctx.allocator);
            }
            // #line 907 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_expr => { // /* expr//  */
            // #line 121 "parser.y"
            {
                ((yyvaluep).expr).free(yyctx.allocator);
            }
            // #line 913 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_decl => { // /* decl//  */
            // #line 121 "parser.y"
            {
                ((yyvaluep).decl).free(yyctx.allocator);
            }
            // #line 919 "parser.zig"
        },

        yysymbol_kind_t.YYSYMBOL_declarator => { // /* declarator//  */
            // #line 121 "parser.y"
            {
                ((yyvaluep).declarator).free(yyctx.allocator);
            }
            // #line 925 "parser.zig"
        },

        else => {},
    }
}

// /** Number of symbols composing the right hand side of rule #RULE.  */
inline fn yyrhsLength(yyrule: usize) isize {
    return yyr2[yyrule];
}

fn yydestroyGLRState(yyctx: *yyparse_context_t, yymsg: []const u8, yys: *allowzero yyGLRState, scanner: *YYLexer) !void {
    if (yys.yyresolved) {
        try yydestruct(yyctx, yymsg, yy_accessing_symbol(yys.yylrState), &yys.yysemantics.yyval, &yys.yyloc);
    } else {
        if (yydebug) {
            if (@intFromPtr(yys.yysemantics.yyfirstVal) != 0) {
                std.debug.print("{s} unresolved", .{yymsg});
            } else {
                std.debug.print("{s} incomplete", .{yymsg});
            }
            try YY_SYMBOL_PRINT("", yy_accessing_symbol(yys.yylrState), &YYSTYPE.default(), &yys.yyloc);
        }

        if (@intFromPtr(yys.yysemantics.yyfirstVal) != 0) {
            const yyoption = yys.yysemantics.yyfirstVal;
            var yyrh = yyoption.yystate;
            var yyn = yyrhsLength(yyoption.yyrule);
            while (yyn > 0) {
                try yydestroyGLRState(yyctx, yymsg, @ptrCast(yyrh), scanner);
                yyrh = @ptrCast(@as(*allowzero yyGLRState, @ptrCast(yyrh)).yypred);
                yyn -= 1;
            }
        }
    }
}

inline fn yypact_value_is_default(yyn: anytype) bool {
    return ((yyn) == YYPACT_NINF);
}

// /** True iff LR state YYSTATE has only a default reduction (regardless
//  *  of token).  */
inline fn yyisDefaultedState(yystate: usize) bool {
    return yypact_value_is_default(yypact[yystate]);
}

// /** The default reduction for YYSTATE, assuming it has one.  */
inline fn yydefaultAction(yystate: usize) usize {
    return @intCast(yydefact[yystate]);
}

inline fn yytable_value_is_error(yyn: anytype) bool {
    {
        _ = yyn;
    }
    return false;
}

// /** The action to take in YYSTATE on seeing YYTOKEN.
//  *  Result R means
//  *    R < 0:  Reduce on rule -R.
//  *    R = 0:  Error.
//  *    R > 0:  Shift to state R.
//  *  Set *YYCONFLICTS to a pointer into yyconfl to a 0-terminated list
//  *  of conflicting reductions.
//  */
inline fn yygetLRActions(yystate: usize, yytoken: isize, yyconflicts: *[]const isize) isize {
    const yyindex: isize = yypact[yystate] + yytoken;
    if (yytoken == yysymbol_kind_t.YYSYMBOL_YYerror) {
        // This is the error token.
        yyconflicts.* = &yyconfl;
        return 0;
    } else if (yyisDefaultedState(yystate) or yyindex < 0 or YYLAST < yyindex or yycheck[@intCast(yyindex)] != yytoken) {
        yyconflicts.* = @constCast(&yyconfl);
        return -yydefact[yystate];
    } else if (!yytable_value_is_error(yytable[@intCast(yyindex)])) {
        yyconflicts.* = @constCast(yyconfl[@as(usize, @intCast(yyconflp[@intCast(yyindex)]))..]);
        return yytable[@intCast(yyindex)];
    } else {
        yyconflicts.* = yyconfl + yyconflp[yyindex];
        return 0;
    }
}

// /** Compute post-reduction state.
//  * \param yystate   the current state
//  * \param yysym     the nonterminal to push on the stack
//  */
inline fn yyLRgotoState(yystate: usize, yysym: isize) usize {
    const yyr = @as(usize, @intCast(yypgoto[@intCast(yysym - YYNTOKENS)])) + yystate;
    if (0 <= yyr and yyr <= YYLAST and yycheck[yyr] == yystate) {
        return @as(usize, @intCast(yytable[yyr]));
    } else {
        return @as(usize, @intCast(yydefgoto[@intCast(yysym - YYNTOKENS)]));
    }
}

inline fn yyisShiftAction(yyaction: isize) bool {
    return 0 < yyaction;
}

inline fn yyisErrorAction(yyaction: isize) bool {
    return yyaction == 0;
}

//                                                         /* GLRStates */

// /** Return a fresh GLRStackItem in YYSTACKP.  The item is an LR state
//  *  if YYISSTATE, and otherwise a semantic option.  Callers should call
//  *  YY_RESERVE_GLRSTACK afterwards to make sure there is sufficient
//  *  headroom.  */

inline fn yynewGLRStackItem(yystackp: *yyGLRStack, yyisState: bool) *allowzero yyGLRStackItem {
    const yynewItem: *allowzero yyGLRStackItem = yystackp.yynextFree;
    yystackp.yyspaceLeft -= 1;
    yystackp.yynextFree = movePtr(yystackp.yynextFree, 1);
    yynewItem.* = brk: {
        if (yyisState) {
            const item = yyGLRStackItem{ .yystate = &yystackp.yystate_arr[yystackp.yystate_next] };
            yystackp.yystate_next += 1;
            break :brk item;
        } else {
            const item = yyGLRStackItem{ .yyoption = &yystackp.yyoption_arr[yystackp.yyoption_next] };
            yystackp.yyoption_next += 1;
            break :brk item;
        }
    };
    return yynewItem;
}

// /** Add a new semantic action that will execute the action for rule
//  *  YYRULE on the semantic values in YYRHS to the list of
//  *  alternative actions for YYSTATE.  Assumes that YYRHS comes from
//  *  stack #YYK of *YYSTACKP. */
fn yyaddDeferredAction(yystackp: *yyGLRStack, yyk: isize, yystate: *allowzero yyGLRState, yyrhs: *allowzero yyGLRState, yyrule: usize) !void {
    var yynewOption = yynewGLRStackItem(yystackp, false).yyoption;
    // YY_ASSERT(!yynewOption.yyisState);
    yynewOption.yystate = @ptrCast(yyrhs);
    yynewOption.yyrule = yyrule;
    if (yystackp.yytops.yylookaheadNeeds[@intCast(yyk)]) {
        yynewOption.yyrawchar = yystackp.yyrawchar;
        yynewOption.yyval = yystackp.yyval;
        yynewOption.yyloc = yystackp.yyloc;
    } else {
        yynewOption.yyrawchar = yytoken_kind_t.YYEMPTY;
    }
    yynewOption.yynext = yystate.yysemantics.yyfirstVal;
    yystate.yysemantics.yyfirstVal = yynewOption;

    try YY_RESERVE_GLRSTACK(yystackp);
}

//                                                     /* GLRStacks */

// /** Initialize YYSET to a singleton set containing an empty stack.  */
fn yyinitStateSet(allocator: std.mem.Allocator, yyset: *yyGLRStateSet) !void {
    yyset.yysize = 1;
    yyset.yycapacity = 16;
    yyset.yystates_arr = try allocator.alloc(?*yyGLRState, yyset.yycapacity);
    errdefer allocator.free(yyset.yystates_arr);
    yyset.yystates = yyset.yystates_arr.ptr;
    yyset.yystates[0] = @ptrFromInt(0);
    yyset.yylookaheadNeeds = try allocator.alloc(bool, yyset.yycapacity);
    @memset(yyset.yylookaheadNeeds, false);
}

fn yyfreeStateSet(allocator: std.mem.Allocator, yyset: *yyGLRStateSet) void {
    allocator.free(yyset.yystates_arr);
    allocator.free(yyset.yylookaheadNeeds);
}

// /** Initialize *YYSTACKP to a single empty stack, with total maximum
//  *  capacity for all stacks of YYSIZE.  */
fn yyinitGLRStack(allocator: std.mem.Allocator, yystackp: *yyGLRStack, yysize: usize) !void {
    yystackp.yyerrState = 0;
    yystackp.yyerrcnt = 0;
    yystackp.yyspaceLeft = yysize;
    yystackp.yystate_arr = try allocator.alloc(yyGLRState, yysize);
    yystackp.yyoption_arr = try allocator.alloc(yySemanticOption, yysize);
    yystackp.yyitems_arr = try allocator.alloc(yyGLRStackItem, yysize);
    yystackp.yyitems = yystackp.yyitems_arr.ptr;
    yystackp.yynextFree = &yystackp.yyitems[0];
    yystackp.yysplitPoint = @ptrFromInt(0);
    yystackp.yylastDeleted = @ptrFromInt(0);
    try yyinitStateSet(allocator, &yystackp.yytops);
}

// # define YYRELOC(YYFROMITEMS, YYTOITEMS, YYX, YYTYPE)                   \
//   &((YYTOITEMS)                                                         \
//     - ((YYFROMITEMS) - YY_REINTERPRET_CAST (yyGLRStackItem*, (YYX))))->YYTYPE

// /** If *YYSTACKP is expandable, extend it.  WARNING: Pointers into the
//     stack from outside should be considered invalid after this call.
//     We always expand when there are 1 or fewer items left AFTER an
//     allocation, so that we can avoid having external pointers exist
//     across an allocation.  */
fn yyexpandGLRStack(allocator: std.mem.Allocator, yystackp: *yyGLRStack) !void {
    var yynewItems: *yyGLRStackItem = undefined;
    var yyp0: *yyGLRStackItem = undefined;
    var yyp1: [*]*yyGLRStackItem = undefined;
    var yynewSize: isize = 0;
    var yyn: isize = 0;
    const yysize: isize = yystackp.yynextFree - yystackp.yyitems;
    if (YYMAXDEPTH - YYHEADROOM < yysize) {
        yyMemoryExhausted(yystackp);
    }
    yynewSize = 2 * yysize;
    if (YYMAXDEPTH < yynewSize) {
        yynewSize = YYMAXDEPTH;
    }
    yynewItems = try allocator.alloc(yynewSize * @sizeOf(yynewItems[0]));
    // if (! yynewItems) {
    //   yyMemoryExhausted (yystackp);
    // }

    yyp0 = yystackp.yyitems;
    yyp1 = yynewItems;
    yyn = yysize;

    while (0 < yyn) {
        yyp1.* = yyp0.*;
        if (yyp0.*) {
            const yys0: *yyGLRState = &yyp0.yystate;
            var yys1: *yyGLRState = &yyp1.yystate;
            if (yys0.yypred != YY_NULLPTR) {
                yys1.yyperd = (yyp1 - yyp0 - yys0.yypred).yystate;
            }
            if (!yys0.yyresolved and yys0.yysemantics.yyfirstVal != YY_NULLPTR) {
                yys1.yysemantics.yyfirstVal =
                    (yyp1 - yyp0 - yys0.yysemantics.yyfirstVal).yyoption;
            }
        } else {
            const yyv0: *yySemanticOption = &yyp0.yyoption;
            var yyv1: *yySemanticOption = &yyp1.yyoption;
            if (yyv0.yystate != YY_NULLPTR) {
                yyv1.yystate = (yyp1 - yyp0 - yyv0.yystate).yystate;
            }
            if (yyv0.yynext != YY_NULLPTR) {
                yyv1.yynext = (yyp1 - yyp0 - yyv0.yynext).yyoption;
            }
        }

        yyn -= 1;
        yyp0 += 1;
        yyp1 += 1;
    }
    if (yystackp.yysplitPoint != YY_NULLPTR) {
        yystackp.yysplitPoint = (yynewItems - yystackp.yyitems - yystackp.yysplitPoint).yystate;
    }

    yyn = 0;
    while (yyn < yystackp.yytops.yysize) : (yyn += 1) {
        if (yystackp.yytops.yystates[yyn] != YY_NULLPTR) {
            yystackp.yytops.yystates[yyn] = (yynewItems - yystackp.yyitems - yystackp.yytops.yystates[yyn]).yystate;
        }
    }
    allocator.free(yystackp.yyitems);
    yystackp.yyitems = yynewItems;
    yystackp.yynextFree = yynewItems + yysize;
    yystackp.yyspaceLeft = yynewSize - yysize;
}

fn yyfreeGLRStack(allocator: std.mem.Allocator, yystackp: *yyGLRStack) void {
    allocator.free(yystackp.yyitems_arr);
    yyfreeStateSet(allocator, &yystackp.yytops);
}

// /** Assuming that YYS is a GLRState somewhere on *YYSTACKP, update the
//  *  splitpoint of *YYSTACKP, if needed, so that it is at least as deep as
//  *  YYS.  */
inline fn yyupdateSplit(yystackp: *allowzero yyGLRStack, yys: *allowzero yyGLRState) void {
    if (@intFromPtr(yystackp.yysplitPoint) != 0 and ptrLessThan(yys, yystackp.yysplitPoint)) {
        yystackp.yysplitPoint = yys;
    }
}

// /** Invalidate stack #YYK in *YYSTACKP.  */
inline fn yymarkStackDeleted(yystackp: *yyGLRStack, yyk: isize) void {
    if (@intFromPtr(yystackp.yytops.yystates[@intCast(yyk)]) != 0) {
        yystackp.yylastDeleted = valueWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyk);
    }
    yystackp.yytops.yystates[@intCast(yyk)] = @ptrFromInt(0);
}

// /** Undelete the last stack in *YYSTACKP that was marked as deleted.  Can
//     only be done once after a deletion, and only when all other stacks have
//     been deleted.  */
fn yyundeleteLastStack(yystackp: *yyGLRStack) void {
    if (@intFromPtr(yystackp.yylastDeleted) == 0 or yystackp.yytops.yysize != 0)
        return;
    yystackp.yytops.yystates[0] = yystackp.yylastDeleted;
    yystackp.yytops.yysize = 1;
    std.debug.print("Restoring last deleted stack as stack #0.\n", .{});
    yystackp.yylastDeleted = @ptrFromInt(0);
}

inline fn yyremoveDeletes(yystackp: *yyGLRStack) void {
    var yyi: usize = 0;
    var yyj: usize = 0;
    while (yyj < yystackp.yytops.yysize) {
        if (@intFromPtr(yystackp.yytops.yystates[yyi]) != 0) {
            if (yyi == yyj) {
                if (yydebug) {
                    std.debug.print("Removing dead stacks.\n", .{});
                }
            }
            yystackp.yytops.yysize -= 1;
        } else {
            yystackp.yytops.yystates[yyj] = yystackp.yytops.yystates[yyi];
            // /* In the current implementation, it's unnecessary to copy
            //    yystackp->yytops.yylookaheadNeeds[yyi] since, after
            //    yyremoveDeletes returns, the parser immediately either enters
            //    deterministic operation or shifts a token.  However, it doesn't
            //    hurt, and the code might evolve to need it.  */
            yystackp.yytops.yylookaheadNeeds[yyj] =
                yystackp.yytops.yylookaheadNeeds[yyi];
            if (yyj != yyi) {
                if (yydebug) {
                    std.debug.print("Rename stack {d} -> {d}.\n", .{ yyi, yyj });
                }
            }
            yyj += 1;
        }
        yyi += 1;
    }
}

// /** Shift to a new state on stack #YYK of *YYSTACKP, corresponding to LR
//  * state YYLRSTATE, at input position YYPOSN, with (resolved) semantic
//  * value *YYVALP and source location *YYLOCP.  */
inline fn yyglrShift(yystackp: *yyGLRStack, yyk: isize, yylrState: usize, yyposn: isize, yyvalp: *YYSTYPE, yylocp: *YYLTYPE) !void {
    const yynewStackItem = yynewGLRStackItem(yystackp, true);
    var yynewState = yynewStackItem.yystate;
    yynewState.yylrState = yylrState;
    yynewState.yyposn = yyposn;
    yynewState.yyresolved = true;
    yynewState.yypred = valueWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyk);
    yynewState.yysemantics.yyval = yyvalp.*;
    yynewState.yyloc = yylocp.*;
    yystackp.yytops.yystates[@intCast(yyk)] = yynewStackItem.yystate;
    try YY_RESERVE_GLRSTACK(yystackp);
}

// /** Shift stack #YYK of *YYSTACKP, to a new state corresponding to LR
//  *  state YYLRSTATE, at input position YYPOSN, with the (unresolved)
//  *  semantic value of YYRHS under the action for YYRULE.  */
inline fn yyglrShiftDefer(yystackp: *yyGLRStack, yyk: isize, yylrState: usize, yyposn: isize, yyrhs: ?*yyGLRState, yyrule: usize) !void {
    var yynewState = yynewGLRStackItem(yystackp, true).yystate;
    // YY_ASSERT(yynewState.yyisState);
    yynewState.yylrState = yylrState;
    yynewState.yyposn = yyposn;
    yynewState.yyresolved = false;
    yynewState.yypred = valueWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyk);
    yynewState.yysemantics.yyfirstVal = @ptrFromInt(0);
    ptrWithOffset(?*yyGLRState, yystackp.yytops.yystates, yyk).* = yynewState;

    // /* Invokes YY_RESERVE_GLRSTACK.  */
    try yyaddDeferredAction(yystackp, yyk, valueWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyk), yyrhs, yyrule);
}

// /*----------------------------------------------------------------------.
// | Report that stack #YYK of *YYSTACKP is going to be reduced by YYRULE. |
// `----------------------------------------------------------------------*/

inline fn yy_reduce_print(yynormal: bool, yyvsp: *allowzero yyGLRStackItem, yyk: isize, yyrule: usize) !void {
    const yynrhs: isize = yyrhsLength(yyrule);
    var yylow: isize = 1;
    var yyi: isize = 0;
    if (yydebug) {
        std.debug.print("Reducing stack {d} by rule {d} (line {d}):\n", .{ yyk, yyrule - 1, yyrline[yyrule] });
    }
    if (!yynormal) {
        yyfillin(yyvsp, 1, -yynrhs);
    }
    // /* The symbols being reduced.  */
    while (yyi < yynrhs) : (yyi += 1) {
        std.debug.print("   ${d} = ", .{yyi + 1});
        try yy_symbol_print(
            std.io.getStdErr(),
            yy_accessing_symbol(movePtr(yyvsp, yyi - yynrhs + 1).yystate.yylrState),
            &(movePtr(yyvsp, yyi - yynrhs + 1).yystate.yysemantics.yyval),
            &(movePtr(yyvsp, yyfill(yyvsp, &yylow, (yyi + 1) - (yynrhs), yynormal)).yystate.yyloc),
        );
        if (!movePtr(yyvsp, yyi - yynrhs + 1).yystate.yyresolved) {
            std.debug.print(" (unresolved)", .{});
        }
        std.debug.print("\n", .{});
    }
}

// /** Pop the symbols consumed by reduction #YYRULE from the top of stack
//  *  #YYK of *YYSTACKP, and perform the appropriate semantic action on their
//  *  semantic values.  Assumes that all ambiguities in semantic values
//  *  have been previously resolved.  Set *YYVALP to the resulting value,
//  *  and *YYLOCP to the computed location (if any).  Return value is as
//  *  for userAction.  */
inline fn yydoAction(yyctx: *yyparse_context_t, yystackp: *yyGLRStack, yyk: isize, yyrule: usize, yyvalp: *YYSTYPE, yylocp: *YYLTYPE) !usize {
    const yynrhs: usize = @intCast(yyrhsLength(yyrule));
    if (@intFromPtr(yystackp.yysplitPoint) == 0) {
        // /* Standard special case: single stack.  */
        YY_ASSERT(yyk == 0);
        yystackp.yynextFree = movePtr(yystackp.yynextFree, -@as(isize, @intCast(yynrhs)));
        yystackp.yyspaceLeft += yynrhs;
        yystackp.yytops.yystates[0] = movePtr(yystackp.yynextFree, -1).yystate;
        return yyuserAction(yyctx, yyrule, yynrhs, @ptrCast(valueWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyk)), yystackp, yyk, yyvalp, yylocp);
    } else {
        var yyrhsStates: [YYMAXRHS + YYMAXLEFT + 1]yyGLRState = undefined;
        var yyrhsVals: [YYMAXRHS + YYMAXLEFT + 1]yyGLRStackItem = undefined;
        var yyrhsVsp: [YYMAXRHS + YYMAXLEFT + 1]*allowzero yyGLRStackItem = undefined;
        for (0..YYMAXRHS + YYMAXLEFT + 1) |i| {
            yyrhsVals[i] = yyGLRStackItem{ .yystate = &yyrhsStates[i] };
            yyrhsVsp[i] = &yyrhsVals[i];
        }
        yyrhsVals[YYMAXRHS + YYMAXLEFT].yystate.yypred = valueWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyk);
        var yys = yyrhsVals[YYMAXRHS + YYMAXLEFT].yystate.yypred;
        if (yynrhs == 0) {
            // /* Set default location.  */
            yyrhsVals[YYMAXRHS + YYMAXLEFT - 1].yystate.yyloc = yys.yyloc;
        }
        var yyi: usize = 0;
        while (yyi < yynrhs) : (yyi += 1) {
            yys = yys.yypred;
            YY_ASSERT(@intFromPtr(yys) != 0);
        }
        yyupdateSplit(yystackp, @ptrCast(yys));
        yystackp.yytops.yystates[@intCast(yyk)] = yys;
        return yyuserAction(yyctx, yyrule, yynrhs, yyrhsVsp[YYMAXRHS + YYMAXLEFT - 1], yystackp, yyk, yyvalp, yylocp);
    }
}

// /** Pop items off stack #YYK of *YYSTACKP according to grammar rule YYRULE,
//  *  and push back on the resulting nonterminal symbol.  Perform the
//  *  semantic action associated with YYRULE and store its value with the
//  *  newly pushed state, if YYFORCEEVAL or if *YYSTACKP is currently
//  *  unambiguous.  Otherwise, store the deferred semantic action with
//  *  the new state.  If the new state would have an identical input
//  *  position, LR state, and predecessor to an existing state on the stack,
//  *  it is identified with that existing state, eliminating stack #YYK from
//  *  *YYSTACKP.  In this case, the semantic value is
//  *  added to the options for the existing state's semantic value.
//  */
inline fn yyglrReduce(yyctx: *yyparse_context_t, yystackp: *yyGLRStack, yyk: isize, yyrule: usize, yyforceEval: bool) !usize {
    const yyposn = ptrWithOffset(?*yyGLRState, yystackp.yytops.yystates, yyk).*.?.yyposn;

    if (yyforceEval or @intFromPtr(yystackp.yysplitPoint) == 0) {
        var yyval: YYSTYPE = undefined;
        var yyloc: YYLTYPE = undefined;

        const yyflag = try yydoAction(yyctx, yystackp, yyk, yyrule, &yyval, &yyloc);
        if (yyflag == YYRESULTTAG.yyerr and @intFromPtr(yystackp.yysplitPoint) != 0) {
            if (yydebug) {
                std.debug.print("Parse on stack {d} rejected by rule {d} (line {d}).\n", .{ yyk, yyrule - 1, yyrline[yyrule] });
            }
        }
        if (yyflag != YYRESULTTAG.yyok) {
            return yyflag;
        }
        try yyglrShift(yystackp, yyk, yyLRgotoState(ptrWithOffset(?*yyGLRState, yystackp.yytops.yystates, yyk).*.?.yylrState, yylhsNonterm(yyrule)), yyposn, &yyval, &yyloc);
    } else {
        var yyi: isize = 0;
        var yyn: isize = yyrhsLength(yyrule);
        var yys = valueWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyk);
        const yys0: *allowzero yyGLRState = yys;
        var yynewLRState: usize = 0;

        while (0 < yyn) : (yyn -= 1) {
            yys = yys.yypred;
            YY_ASSERT(@intFromPtr(yys) != 0);
        }
        yyupdateSplit(yystackp, yys);
        yynewLRState = yyLRgotoState(yys.yylrState, yylhsNonterm(yyrule));
        if (yydebug) {
            std.debug.print("Reduced stack {d} by rule {d} (line {d}); action deferred.  Now in state {d}.\n", .{ yyk, yyrule - 1, yyrline[yyrule], yynewLRState });
        }

        yyi = 0;
        while (yyi < yystackp.yytops.yysize) : (yyi += 1) {
            if (yyi != yyk and @intFromPtr(valueWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyi)) != 0) {
                const yysplit = yystackp.yysplitPoint;
                var yyp = valueWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyi);
                while (!ptrEq(yyp, yys) and !ptrEq(yyp, yysplit) and yyp.yyposn >= yyposn) {
                    if (yyp.yylrState == yynewLRState and yyp.yypred == yys) {
                        try yyaddDeferredAction(yystackp, yyk, yyp, yys0, yyrule);
                        yymarkStackDeleted(yystackp, yyk);
                        if (yydebug) {
                            std.debug.print("Merging stack {d} into stack {d}.\n", .{ yyk, yyi });
                        }
                        return YYRESULTTAG.yyok;
                    }
                    yyp = yyp.yypred;
                }
            }
        }
        ptrWithOffset(*allowzero yyGLRState, yystackp.yytops.yystates, yyk).* = yys;
        try yyglrShiftDefer(yystackp, yyk, yynewLRState, @intCast(yyposn), yys0, yyrule);
    }
    return YYRESULTTAG.yyok;
}

fn yysplitStack(allocator: std.mem.Allocator, yystackp: *yyGLRStack, yyk: isize) !isize {
    if (@intFromPtr(yystackp.yysplitPoint) == 0) {
        YY_ASSERT(yyk == 0);
        yystackp.yysplitPoint = @ptrCast(arrPtrWithOffset(?*yyGLRState, yystackp.yytops.yystates, yyk));
    }
    if (yystackp.yytops.yycapacity <= yystackp.yytops.yysize) {
        const state_size: isize = @sizeOf(?*yyGLRState);
        const half_max_capacity: isize = YYSIZE_MAXIMUM / 2 / state_size;
        if (half_max_capacity < yystackp.yytops.yycapacity) {
            return error.yyMemoryExhausted;
        }
        yystackp.yytops.yycapacity *= 2;

        {
            const yynewStates: []?*yyGLRState = try allocator.realloc(yystackp.yytops.yystates_arr, yystackp.yytops.yycapacity);
            yystackp.yytops.yystates_arr = yynewStates;
        }

        {
            const yynewLookaheadNeeds: []bool = try allocator.realloc(yystackp.yytops.yylookaheadNeeds, yystackp.yytops.yycapacity);
            yystackp.yytops.yylookaheadNeeds = yynewLookaheadNeeds;
        }
    }
    yystackp.yytops.yystates[yystackp.yytops.yysize] = yystackp.yytops.yystates[@intCast(yyk)];
    yystackp.yytops.yylookaheadNeeds[yystackp.yytops.yysize] = yystackp.yytops.yylookaheadNeeds[@intCast(yyk)];
    yystackp.yytops.yysize += 1;
    return @intCast(yystackp.yytops.yysize - 1);
}

// /** True iff YYY0 and YYY1 represent identical options at the top level.
//  *  That is, they represent the same rule applied to RHS symbols
//  *  that produce the same terminal symbols.  */
fn yyidenticalOptions(yyy0: *allowzero yySemanticOption, yyy1: *allowzero yySemanticOption) bool {
    if (yyy0.yyrule == yyy1.yyrule) {
        var yys0 = yyy0.yystate;
        var yys1 = yyy1.yystate;
        var yyn = yyrhsLength(yyy0.yyrule);
        while (yyn > 0) {
            if (yys0.yyposn != yys1.yyposn) {
                return false;
            }
            yys0 = yys0.yypred;
            yys1 = yys1.yypred;
            yyn -= 1;
        }
        return true;
    } else {
        return false;
    }
}

// /** Assuming identicalOptions (YYY0,YYY1), destructively merge the
//  *  alternative semantic values for the RHS-symbols of YYY1 and YYY0.  */
fn yymergeOptionSets(yyy0: *allowzero yySemanticOption, yyy1: *allowzero yySemanticOption) void {
    var yys0 = yyy0.yystate;
    var yys1 = yyy1.yystate;
    var yyn = yyrhsLength(yyy0.yyrule);
    while (0 < yyn) {
        if (yys0 == yys1) {
            break;
        } else if (yys0.yyresolved) {
            yys1.yyresolved = true;
            yys1.yysemantics.yyval = yys0.yysemantics.yyval;
        } else if (yys1.yyresolved) {
            yys0.yyresolved = true;
            yys0.yysemantics.yyval = yys1.yysemantics.yyval;
        } else {
            var yyz0p = &yys0.yysemantics.yyfirstVal;
            var yyz1 = yys1.yysemantics.yyfirstVal;
            while (true) {
                if (ptrEq(yyz1, yyz0p.*) or @intFromPtr(yyz1) == 0) {
                    break;
                } else if (@intFromPtr(yyz0p.*) == 0) {
                    yyz0p.* = yyz1;
                    break;
                } else if (ptrLessThan(yyz0p.*, yyz1)) {
                    const yyz = yyz0p.*;
                    yyz0p.* = yyz1;
                    yyz1 = yyz1.yynext;
                    yyz0p.*.yynext = yyz;
                }
                yyz0p = &(yyz0p.*.yynext);
            }
            yys1.yysemantics.yyfirstVal = yys0.yysemantics.yyfirstVal;
        }
        yys0 = yys0.yypred;
        yys1 = yys1.yypred;
        yyn -= 1;
    }
}

// /** Y0 and Y1 represent two possible actions to take in a given
//  *  parsing state; return 0 if no combination is possible,
//  *  1 if user-mergeable, 2 if Y0 is preferred, 3 if Y1 is preferred.  */
fn yypreference(y0: *allowzero yySemanticOption, y1: *allowzero yySemanticOption) isize {
    const r0 = y0.yyrule;
    const r1 = y1.yyrule;
    const p0 = yydprec[r0];
    const p1 = yydprec[r1];

    if (p0 == p1) {
        if (yymerger[r0] == 0 or yymerger[r0] != yymerger[r1]) {
            return 0;
        } else {
            return 1;
        }
    }
    if (p0 == 0 or p1 == 0) {
        return 0;
    }
    if (p0 < p1) {
        return 3;
    }
    if (p1 < p0) {
        return 2;
    }
    return 0;
}

// static YYRESULTTAG
// yyresolveValue (yyGLRState* yys, yyGLRStack* yystackp, scanner: *YYLexer);

// /** Resolve the previous YYN states starting at and including state YYS
//  *  on *YYSTACKP. If result != yyok, some states may have been left
//  *  unresolved possibly with empty semantic option chains.  Regardless
//  *  of whether result = yyok, each state has been left with consistent
//  *  data so that yydestroyGLRState can be invoked if necessary.  */
fn yyresolveStates(yyctx: *yyparse_context_t, yys: *allowzero yyGLRState, yyn: isize, yystackp: *allowzero yyGLRStack, scanner: *YYLexer) !isize {
    var ret: isize = undefined;
    if (0 < yyn) {
        YY_ASSERT(@intFromPtr(yys.yypred) != 0);
        ret = try yyresolveStates(yyctx, yys.yypred, yyn - 1, yystackp, scanner);
        if (ret != YYRESULTTAG.yyok) {
            return ret;
        }
        if (!yys.yyresolved) {
            ret = try yyresolveValue(yyctx, yys, yystackp, scanner);
            if (ret != YYRESULTTAG.yyok) {
                return ret;
            }
        }
    }
    return YYRESULTTAG.yyok;
}

const yyresolveActionError = error{OutOfMemory} || std.fs.File.WriteError;

// /** Resolve the states for the RHS of YYOPT on *YYSTACKP, perform its
//  *  user action, and return the semantic value and location in *YYVALP
//  *  and *YYLOCP.  Regardless of whether result = yyok, all RHS states
//  *  have been destroyed (assuming the user action destroys all RHS
//  *  semantic values if invoked).  */
fn yyresolveAction(yyctx: *yyparse_context_t, yyopt: *allowzero yySemanticOption, yystackp: *allowzero yyGLRStack, yyvalp: *YYSTYPE, yylocp: *YYLTYPE, scanner: *YYLexer) yyresolveActionError!isize {
    var yyrhsVals: [YYMAXRHS + YYMAXLEFT + 1]yyGLRStackItem = undefined;
    var yynrhs = yyrhsLength(yyopt.yyrule);
    var yyflag = try yyresolveStates(yyctx, yyopt.yystate, yynrhs, yystackp, scanner);
    if (yyflag != YYRESULTTAG.yyok) {
        var yys = yyopt.yystate;
        while (yynrhs > 0) {
            try yydestroyGLRState(yyctx, "Cleanup: popping", yys, scanner);
            yys = yys.yypred;
            yynrhs -= 1;
        }
        return yyflag;
    }

    yyrhsVals[YYMAXRHS + YYMAXLEFT].yystate.yypred = yyopt.yystate;
    if (yynrhs == 0) {
        // /* Set default location.  */
        yyrhsVals[YYMAXRHS + YYMAXLEFT - 1].yystate.yyloc = yyopt.yystate.yyloc;
    }
    {
        const yychar_current = yystackp.yyrawchar;
        const yylval_current = yystackp.yyval;
        const yylloc_current = yystackp.yyloc;
        yystackp.yyrawchar = yyopt.yyrawchar;
        yystackp.yyval = yyopt.yyval;
        yystackp.yyloc = yyopt.yyloc;
        yyflag = @intCast(try yyuserAction(yyctx, yyopt.yyrule, @intCast(yynrhs), &yyrhsVals[YYMAXRHS + YYMAXLEFT - 1], yystackp, -1, yyvalp, yylocp));
        yystackp.yyrawchar = yychar_current;
        yystackp.yyval = yylval_current;
        yystackp.yyloc = yylloc_current;
    }
    return yyflag;
}

fn yyreportTree(yyx: *allowzero yySemanticOption, yyindent: usize) void {
    const yynrhs = yyrhsLength(yyx.yyrule);
    var yyi = yynrhs;
    var yys = yyx.yystate;
    var yystates: [1 + YYMAXRHS]*allowzero yyGLRState = undefined;
    var yyleftmost_state: yyGLRState = undefined;

    while (0 < yyi) {
        yystates[@intCast(yyi)] = yys;
        yyi -= 1;
        yys = yys.yypred;
    }

    if (@intFromPtr(yys) == 0) {
        yyleftmost_state.yyposn = 0;
        yystates[0] = &yyleftmost_state;
    } else {
        yystates[0] = yys;
    }

    if (yyx.yystate.yyposn < yys.yyposn + 1) {
        for (0..yyindent) |_| std.debug.print(" ", .{});
        std.debug.print("{s} -> <Rule {d}, empty>\n", .{ yysymbol_name(yylhsNonterm(yyx.yyrule)), yyx.yyrule - 1 });
    } else {
        for (0..yyindent) |_| std.debug.print(" ", .{});
        std.debug.print("{s} -> <Rule {d}, tokens {d} .. {d}>\n", .{ yysymbol_name(yylhsNonterm(yyx.yyrule)), yyx.yyrule - 1, yys.yyposn + 1, yyx.yystate.yyposn });
    }

    yyi = 1;
    while (yyi <= yynrhs) : (yyi += 1) {
        if (yystates[@intCast(yyi)].yyresolved) {
            if (yystates[@intCast(yyi - 1)].yyposn + 1 > yystates[@intCast(yyi)].yyposn) {
                for (0..yyindent + 2) |_| std.debug.print(" ", .{});
                std.debug.print("{s} <empty>\n", .{yysymbol_name(yy_accessing_symbol(yystates[@intCast(yyi)].yylrState))});
            } else {
                for (0..yyindent + 2) |_| std.debug.print(" ", .{});
                std.debug.print("{s} <tokens {d} .. {d}>\n", .{ yysymbol_name(yy_accessing_symbol(yystates[@intCast(yyi)].yylrState)), yystates[@intCast(yyi - 1)].yyposn + 1, yystates[@intCast(yyi)].yyposn });
            }
        } else {
            yyreportTree(yystates[@intCast(yyi)].yysemantics.yyfirstVal, yyindent + 2);
        }
    }
}

fn yyreportAmbiguity(yyx0: *allowzero yySemanticOption, yyx1: *allowzero yySemanticOption, yylocp: *YYLTYPE) isize {
    if (yydebug) {
        std.debug.print("Ambiguity detected.\n", .{});
        std.debug.print("Option 1,\n", .{});
        yyreportTree(yyx0, 2);
        std.debug.print("\nOption 2,\n", .{});
        yyreportTree(yyx1, 2);
        std.debug.print("\n", .{});
    }

    yyerror(yylocp, "syntax is ambiguous");
    return YYRESULTTAG.yyabort;
}

// /** Resolve the locations for each of the YYN1 states in *YYSTACKP,
//  *  ending at YYS1.  Has no effect on previously resolved states.
//  *  The first semantic option of a state is always chosen.  */
fn yyresolveLocations(yys1: *allowzero yyGLRState, yyn1: isize, yystackp: *allowzero yyGLRStack, scanner: *YYLexer) void {
    if (0 < yyn1) {
        yyresolveLocations(yys1.yypred, yyn1 - 1, yystackp, scanner);
        if (!yys1.yyresolved) {
            var yyrhsloc: [1 + YYMAXRHS]YYLTYPE = undefined;
            const yyoption = yys1.yysemantics.yyfirstVal;
            const yynrhs = yyrhsLength(yyoption.yyrule);
            YY_ASSERT(@intFromPtr(yyoption) != 0);
            if (0 < yynrhs) {
                var yys = yyoption.yystate;
                var yyn = yynrhs;
                yyresolveLocations(yyoption.yystate, yynrhs, yystackp, scanner);
                while (yyn > 0) {
                    yyrhsloc[@intCast(yyn)] = yys.yyloc;
                    yys = yys.yypred;
                    yyn -= 1;
                }
            } else {
                // /* Both yyresolveAction and yyresolveLocations traverse the GSS
                //    in reverse rightmost order.  It is only necessary to invoke
                //    yyresolveLocations on a subforest for which yyresolveAction
                //    would have been invoked next had an ambiguity not been
                //    detected.  Thus the location of the previous state (but not
                //    necessarily the previous state itself) is guaranteed to be
                //    resolved already.  */
                const yyprevious = yyoption.yystate;
                yyrhsloc[0] = yyprevious.yyloc;
            }
            YYLLOC_DEFAULT(&(yys1.yyloc), yyrhsloc[0..].ptr, @intCast(yynrhs));
        }
    }
}

// /** Resolve the ambiguity represented in state YYS in *YYSTACKP,
//  *  perform the indicated actions, and set the semantic value of YYS.
//  *  If result != yyok, the chain of semantic options in YYS has been
//  *  cleared instead or it has been left unmodified except that
//  *  redundant options may have been removed.  Regardless of whether
//  *  result = yyok, YYS has been left with consistent data so that
//  *  yydestroyGLRState can be invoked if necessary.  */
fn yyresolveValue(yyctx: *yyparse_context_t, yys: *allowzero yyGLRState, yystackp: *allowzero yyGLRStack, scanner: *YYLexer) !isize {
    const yyoptionList = yys.yysemantics.yyfirstVal;
    var yybest = yyoptionList;
    var yypp = &yyoptionList.yynext;
    var yymerge: bool = false;
    var yyval: YYSTYPE = undefined;
    var yyflag: isize = undefined;
    const yylocp: *YYLTYPE = &yys.yyloc;

    while (@intFromPtr(yypp.*) != 0) {
        var yyp = yypp.*;
        if (yyidenticalOptions(yybest, yyp)) {
            yymergeOptionSets(yybest, yyp);
            yypp.* = yyp.yynext;
        } else {
            switch (yypreference(yybest, yyp)) {
                0 => {
                    yyresolveLocations(yys, 1, yystackp, scanner);
                    return yyreportAmbiguity(yybest, yyp, yylocp);
                },

                1 => {
                    yymerge = true;
                },

                2 => {},

                3 => {
                    yybest = yyp;
                    yymerge = false;
                },

                else => {
                    // /* This cannot happen so it is not worth a YY_ASSERT (false),
                    //    but some compilers complain if the default case is
                    //    omitted.  */
                },
            }
            yypp = &yyp.yynext;
        }
    }

    if (yymerge) {
        var yyp = yybest.yynext;
        const yyprec = yydprec[yybest.yyrule];
        yyflag = try yyresolveAction(yyctx, yybest, yystackp, &yyval, yylocp, scanner);
        if (yyflag == YYRESULTTAG.yyok) {
            while (@intFromPtr(yyp) != 0) : (yyp = yyp.yynext) {
                if (yyprec == yydprec[yyp.yyrule]) {
                    var yyval_other: YYSTYPE = undefined;
                    var yydummy: YYLTYPE = undefined;
                    yyflag = try yyresolveAction(yyctx, yyp, yystackp, &yyval_other, &yydummy, scanner);
                    if (yyflag != YYRESULTTAG.yyok) {
                        try yydestruct(yyctx, "Cleanup: discarding incompletely merged value for", yy_accessing_symbol(yys.yylrState), &yyval, yylocp);
                        break;
                    }
                    try yyuserMerge(yyctx, yymerger[yyp.yyrule], &yyval, &yyval_other);
                }
            }
        }
    } else {
        yyflag = try yyresolveAction(yyctx, yybest, yystackp, &yyval, yylocp, scanner);
    }

    if (yyflag == YYRESULTTAG.yyok) {
        yys.yyresolved = true;
        yys.yysemantics.yyval = yyval;
    } else {
        yys.yysemantics.yyfirstVal = @ptrFromInt(0);
    }
    return yyflag;
}

fn yyresolveStack(yyctx: *yyparse_context_t, yystackp: *yyGLRStack, scanner: *YYLexer) !isize {
    if (@intFromPtr(yystackp.yysplitPoint) != 0) {
        var yys = yystackp.yytops.yystates[0];
        var yyn: usize = 0;

        while (@intFromPtr(yys) != 0) {
            yys = yys.yypred;
            yyn += 1;
        }

        const ret = try yyresolveStates(yyctx, yystackp.yytops.yystates[0], @intCast(yyn), yystackp, scanner);
        if (ret != YYRESULTTAG.yyok) {
            return ret;
        }
    }
    return YYRESULTTAG.yyok;
}

// /** Called when returning to deterministic operation to clean up the extra
//  * stacks. */
fn yycompressStack(yystackp: *yyGLRStack) void {
    // /* yyr is the state after the split point.  */
    var yyr: *allowzero yyGLRState = @ptrFromInt(0);

    if (yystackp.yytops.yysize != 1 or @intFromPtr(yystackp.yysplitPoint) == 0) {
        return;
    }

    {
        var yyp = yystackp.yytops.yystates[0];
        var yyq = yyp.yypred;
        while (ptrEq(yyp, yystackp.yysplitPoint)) {
            yyp.yypred = yyr;
            yyr = yyp;
            yyp = yyq;
            yyq = yyp.yypred;
        }
    }

    yystackp.yyspaceLeft += ptrDistance(yyGLRStackItem, &yystackp.yyitems[0], yystackp.yynextFree);
    yystackp.yynextFree = @ptrCast(movePtr(yystackp.yysplitPoint, 1));
    yystackp.yyspaceLeft -= ptrDistance(yyGLRStackItem, &yystackp.yyitems[0], yystackp.yynextFree);
    yystackp.yysplitPoint = @ptrFromInt(0);
    yystackp.yylastDeleted = @ptrFromInt(0);

    while (@intFromPtr(yyr) != 0) {
        yystackp.yynextFree.yystate = @ptrCast(yyr);
        yyr = yyr.yypred;
        yystackp.yynextFree.yystate.yypred = movePtr(yystackp.yynextFree, -1).yystate;
        yystackp.yytops.yystates[0] = yystackp.yynextFree.yystate;
        yystackp.yynextFree = movePtr(yystackp.yynextFree, 1);
        yystackp.yyspaceLeft -= 1;
    }
}

fn yyprocessOneStack(yyctx: *yyparse_context_t, yystackp: *yyGLRStack, yyk: isize, yyposn: isize, yylocp: *YYLTYPE, scanner: *YYLexer) !usize {
    while (@intFromPtr(yystackp.yytops.yystates[@intCast(yyk)]) != 0) {
        const yystate = yystackp.yytops.yystates[@intCast(yyk)].yylrState;
        if (yydebug) {
            std.debug.print("Stack {d} Entering state {d}\n", .{ yyk, yystate });
        }

        YY_ASSERT(yystate != YYFINAL);

        if (yyisDefaultedState(yystate)) {
            var yyflag: usize = undefined;
            const yyrule: usize = yydefaultAction(yystate);
            if (yyrule == 0) {
                if (yydebug) {
                    std.debug.print("Stack {d} dies.\n", .{yyk});
                }
                yymarkStackDeleted(yystackp, yyk);
                return YYRESULTTAG.yyok;
            }
            yyflag = try yyglrReduce(yyctx, yystackp, yyk, yyrule, yyimmediate[yyrule] == 0);
            if (yyflag == YYRESULTTAG.yyerr) {
                std.debug.print("Stack {d} dies (predicate failure or explicit user error).\n", .{yyk});
                yymarkStackDeleted(yystackp, yyk);
                return YYRESULTTAG.yyok;
            }
            if (yyflag != YYRESULTTAG.yyok)
                return yyflag;
        } else {
            const yytoken = try yygetToken(&yystackp.yyrawchar, yystackp, scanner);
            var yyconflicts: []isize = undefined;
            const yyaction = yygetLRActions(yystate, yytoken, &yyconflicts);
            yystackp.yytops.yylookaheadNeeds[@intCast(yyk)] = true;

            var i: usize = 0;
            while (i < yyconflicts.len and yyconflicts[i] != 0) : (i += 1) {
                var yyflag: usize = undefined;
                const yynewStack: isize = try yysplitStack(yyctx.allocator, yystackp, yyk);
                if (yydebug) {
                    std.debug.print("Splitting off stack {d} from {d}.\n", .{ yynewStack, yyk });
                }
                yyflag = try yyglrReduce(yyctx, yystackp, yynewStack, @intCast(yyconflicts[i]), yyimmediate[@intCast(yyconflicts[i])] == 0);
                if (yyflag == YYRESULTTAG.yyok) {
                    const ret = try yyprocessOneStack(yyctx, yystackp, yynewStack, yyposn, yylocp, scanner);
                    if (ret != YYRESULTTAG.yyok) {
                        return ret;
                    }
                } else if (yyflag == YYRESULTTAG.yyerr) {
                    if (yydebug) {
                        std.debug.print("Stack {d} dies.\n", .{yynewStack});
                    }
                    yymarkStackDeleted(yystackp, yynewStack);
                } else {
                    return yyflag;
                }
            }

            if (yyisShiftAction(yyaction)) {
                break;
            } else if (yyisErrorAction(yyaction)) {
                if (yydebug) {
                    std.debug.print("Stack {d} dies.\n", .{yyk});
                    yymarkStackDeleted(yystackp, yyk);
                }
                break;
            } else {
                const yyflag = try yyglrReduce(yyctx, yystackp, yyk, @intCast(-yyaction), yyimmediate[@intCast(-yyaction)] != 0);
                if (yyflag == YYRESULTTAG.yyerr) {
                    if (yydebug) {
                        std.debug.print("Stack {d} dies (predicate failure or explicit user error).\n", .{yyk});
                    }
                    yymarkStackDeleted(yystackp, yyk);
                    break;
                } else if (yyflag != YYRESULTTAG.yyok) {
                    return yyflag;
                }
            }
        }
    }
    return YYRESULTTAG.yyok;
}

// /* Put in YYARG at most YYARGN of the expected tokens given the
//    current YYSTACKP, and return the number of tokens stored in YYARG.  If
//    YYARG is null, return the number of expected tokens (guaranteed to
//    be less than YYNTOKENS).  */
fn yypcontext_expected_tokens(yystackp: *yyGLRStack, yyarg: []isize, yyargn: isize) usize {
    // /* Actual size of YYARG. */
    var yycount: isize = 0;
    const yyn = yypact[yystackp.yytops.yystates[0].yylrState];
    if (!yypact_value_is_default(yyn)) {
        // /* Start YYX at -YYN if negative to avoid negative indexes in
        //    YYCHECK.  In other words, skip the first -YYN actions for
        //    this state because they are default actions.  */
        const yyxbegin: isize = if (yyn < 0) -yyn else 0;
        // /* Stay within bounds of both yycheck and yytname.  */
        const yychecklim = YYLAST - yyn + 1;
        const yyxend = if (yychecklim < YYNTOKENS) yychecklim else YYNTOKENS;
        var yyx: isize = yyxbegin;
        while (yyx < yyxend) : (yyx += 1) {
            if (yycheck[@intCast(yyx + yyn)] == yyx and yyx != yysymbol_kind_t.YYSYMBOL_YYerror and !yytable_value_is_error(yytable[@intCast(yyx + yyn)])) {
                // if (!yyarg) {
                //    yycount += 1;
                // } else
                if (yycount == yyargn) {
                    return 0;
                } else {
                    yyarg[@intCast(yycount)] = yyx;
                    yycount += 1;
                }
            }
        }
    }
    if (yycount == 0 and 0 < yyargn) {
        // if (yyarg and yycount == 0 and 0 < yyargn) {
        yyarg[0] = yysymbol_kind_t.YYSYMBOL_YYEMPTY;
    }
    return @intCast(yycount);
}

fn yy_syntax_error_arguments(yystackp: *yyGLRStack, yyarg: []isize, yyargn: isize) usize {
    const yytoken: isize = if (yystackp.yyrawchar == yytoken_kind_t.YYEMPTY) yysymbol_kind_t.YYSYMBOL_YYEMPTY else YYTRANSLATE(yystackp.yyrawchar);
    // /* Actual size of YYARG. */
    var yycount: usize = 0;
    // /* There are many possibilities here to consider:
    //    - If this state is a consistent state with a default action, then
    //      the only way this function was invoked is if the default action
    //      is an error action.  In that case, don't check for expected
    //      tokens because there are none.
    //    - The only way there can be no lookahead present (in yychar) is if
    //      this state is a consistent state with a default action.  Thus,
    //      detecting the absence of a lookahead is sufficient to determine
    //      that there is no unexpected or expected token to report.  In that
    //      case, just report a simple "syntax error".
    //    - Don't assume there isn't a lookahead just because this state is a
    //      consistent state with a default action.  There might have been a
    //      previous inconsistent state, consistent state with a non-default
    //      action, or user semantic action that manipulated yychar.
    //    - Of course, the expected token list depends on states to have
    //      correct lookahead information, and it depends on the parser not
    //      to perform extra reductions after fetching a lookahead from the
    //      scanner and before detecting a syntax error.  Thus, state merging
    //      (from LALR or IELR) and default reductions corrupt the expected
    //      token list.  However, the list is correct for canonical LR with
    //      one exception: it will still contain any token that will not be
    //      accepted due to an error action in a later state.
    // */
    if (yytoken != yysymbol_kind_t.YYSYMBOL_YYEMPTY) {
        var yyn: usize = 0;
        if (yyarg.len > 0) {
            yyarg[yycount] = yytoken;
        }
        yycount += 1;
        yyn = yypcontext_expected_tokens(yystackp, if (yyarg.len > 0) yyarg[1..] else yyarg, yyargn - 1);
        if (yyn == YYENOMEM) {
            return YYENOMEM;
        } else {
            yycount += yyn;
        }
    }
    return yycount;
}

fn yyreportSyntaxError(allocator: std.mem.Allocator, yystackp: *yyGLRStack) !void {
    if (yystackp.yyerrState != 0) {
        return;
    }
    {
        const YYARGS_MAX = 5;
        // /* Arguments of yyformat: reported tokens (one for the "unexpected",
        //    one per "expected"). */
        var yyarg: [YYARGS_MAX]isize = undefined;

        // /* Actual size of YYARG. */
        const yycount = yy_syntax_error_arguments(yystackp, &yyarg, YYARGS_MAX);
        if (yycount == YYENOMEM) {
            return error.yyMemoryExhausted;
        }

        var yymsg = std.ArrayList(u8).init(allocator);
        defer yymsg.deinit();

        switch (yycount) {
            0 => {
                try yymsg.writer().print("syntax error", .{});
            },
            1 => {
                try yymsg.writer().print("syntax error, unexpected {s}", .{yytoken_kind_t.value2name(yyarg[0])});
            },
            2 => {
                try yymsg.writer().print("syntax error, unexpected {s}, expecting {s}", .{ yytoken_kind_t.value2name(yyarg[0]), yytoken_kind_t.value2name(yyarg[1]) });
            },
            3 => {
                try yymsg.writer().print("syntax error, unexpected {s}, expecting {s} or {s}", .{ yytoken_kind_t.value2name(yyarg[0]), yytoken_kind_t.value2name(yyarg[1]), yytoken_kind_t.value2name(yyarg[2]) });
            },
            4 => {
                try yymsg.writer().print("syntax error, unexpected {s}, expecting {s} or {s} or {s}", .{ yytoken_kind_t.value2name(yyarg[0]), yytoken_kind_t.value2name(yyarg[1]), yytoken_kind_t.value2name(yyarg[2]), yytoken_kind_t.value2name(yyarg[3]) });
            },
            5 => {
                try yymsg.writer().print("syntax error, unexpected {s}, expecting {s} or {s} or {s} or {s}", .{ yytoken_kind_t.value2name(yyarg[0]), yytoken_kind_t.value2name(yyarg[1]), yytoken_kind_t.value2name(yyarg[2]), yytoken_kind_t.value2name(yyarg[3]), yytoken_kind_t.value2name(yyarg[4]) });
            },
            else => {},
        }

        yyerror(&yystackp.yyloc, yymsg.items);
    }
    yystackp.yyerrcnt += 1;
}

// /* Recover from a syntax error on *YYSTACKP, assuming that *YYSTACKP->YYTOKENP,
//    yylval, and yylloc are the syntactic category, semantic value, and location
//    of the lookahead.  */
fn yyrecoverSyntaxError(yyctx: *yyparse_context_t, yystackp: *yyGLRStack, scanner: *YYLexer) !void {
    if (yystackp.yyerrState == 3) {
        // /* We just shifted the error token and (perhaps) took some
        //    reductions.  Skip tokens until we can proceed.  */
        while (true) {
            var yytoken: isize = undefined;
            var yyj: isize = 0;
            if (yystackp.yyrawchar == yytoken_kind_t.YYEOF) {
                _ = yyFail(yystackp, &yystackp.yyloc, scanner, YY_NULLPTR);
            }
            if (yystackp.yyrawchar != yytoken_kind_t.YYEMPTY) {
                // /* We throw away the lookahead, but the error range
                //    of the shifted error token must take it into account.  */
                const yys = yystackp.yytops.yystates[0];
                var yyerror_range: [3]YYLTYPE = undefined;
                yyerror_range[1] = yys.yyloc;
                yyerror_range[2] = yystackp.yyloc;
                YYLLOC_DEFAULT(&(yys.yyloc), &yyerror_range, 2);
                yytoken = YYTRANSLATE(yystackp.yyrawchar);
                try yydestruct(yyctx, "Error: discarding", yytoken, &yystackp.yyval, &yystackp.yyloc);
                yystackp.yyrawchar = yytoken_kind_t.YYEMPTY;
            }
            yytoken = try yygetToken(&yystackp.yyrawchar, yystackp, scanner);
            yyj = yypact[yystackp.yytops.yystates[0].yylrState];
            if (yypact_value_is_default(yyj)) {
                return;
            }
            yyj += yytoken;
            if (yyj < 0 or YYLAST < yyj or yycheck[@intCast(yyj)] != yytoken) {
                if (yydefact[yystackp.yytops.yystates[0].yylrState] != 0)
                    return;
            } else if (!yytable_value_is_error(yytable[@intCast(yyj)])) {
                return;
            }
        }
    }

    // /* Reduce to one stack.  */
    {
        var yyk: usize = 0;
        while (yyk < yystackp.yytops.yysize) : (yyk += 1) {
            if (@intFromPtr(yystackp.yytops.yystates[yyk]) != 0)
                break;
        }
        if (yyk >= yystackp.yytops.yysize) {
            _ = yyFail(yystackp, &yystackp.yyloc, scanner, YY_NULLPTR);
        }
        yyk += 1;
        while (yyk < yystackp.yytops.yysize) : (yyk += 1) {
            yymarkStackDeleted(yystackp, @intCast(yyk));
        }
        yyremoveDeletes(yystackp);
        yycompressStack(yystackp);
    }

    // /* Pop stack until we find a state that shifts the error token.  */
    yystackp.yyerrState = 3;
    while (@intFromPtr(yystackp.yytops.yystates[0]) != 0) {
        var yys = yystackp.yytops.yystates[0];
        var yyj: isize = yypact[yys.yylrState];
        if (!yypact_value_is_default(yyj)) {
            yyj += yysymbol_kind_t.YYSYMBOL_YYerror;
            if (0 <= yyj and yyj <= YYLAST and yycheck[@intCast(yyj)] == yysymbol_kind_t.YYSYMBOL_YYerror and yyisShiftAction(yytable[@intCast(yyj)])) {
                // /* Shift the error token.  */
                const yyaction: isize = yytable[@intCast(yyj)];
                // /* First adjust its location.*/
                var yyerrloc: YYLTYPE = undefined;
                yystackp.yyerror_range[2].yystate.yyloc = yystackp.yyloc;
                var yyerror_range: [3]YYLTYPE = undefined;
                yyerror_range[1] = yystackp.yyerror_range[1].yystate.yyloc;
                yyerror_range[2] = yystackp.yyerror_range[2].yystate.yyloc;
                YYLLOC_DEFAULT(&yyerrloc, &yyerror_range, 2);
                try YY_SYMBOL_PRINT("Shifting", yy_accessing_symbol(@intCast(yyaction)), &yystackp.yyval, &yyerrloc);
                try yyglrShift(yystackp, 0, @intCast(yyaction), yys.yyposn, &yystackp.yyval, &yyerrloc);
                yys = yystackp.yytops.yystates[0];
                break;
            }
        }
        yystackp.yyerror_range[1].yystate.yyloc = yys.yyloc;
        if (@intFromPtr(yys.yypred) != 0) {
            try yydestroyGLRState(yyctx, "Error: popping", yys, scanner);
        }
        yystackp.yytops.yystates[0] = yys.yypred;
        yystackp.yynextFree = movePtr(yystackp.yynextFree, -1);
        yystackp.yyspaceLeft += 1;
    }
    if (@intFromPtr(yystackp.yytops.yystates[0]) == 0) {
        _ = yyFail(yystackp, &yystackp.yyloc, scanner, YY_NULLPTR);
    }
}

fn YYCHK1(YYE: anytype) usize {
    switch (YYE) {
        YYRESULTTAG.yyok => {
            return 0;
        },
        YYRESULTTAG.yyabort => {
            return LABEL_YYABORTLAB;
        },
        YYRESULTTAG.yyaccept => {
            return LABEL_YYACCEPTLAB;
        },
        YYRESULTTAG.yyerr => {
            return LABEL_YYUSER_ERROR;
        },
        YYRESULTTAG.yynomem => {
            return LABEL_YYEXHAUSTEDLAB;
        },
        else => {
            return LABEL_YYBUGLAB;
        },
    }
}

const yyparse_context_t = struct {
    allocator: std.mem.Allocator,
    scanner: *YYLexer = undefined,
    yyresult: isize = 0,
    yystack: yyGLRStack = undefined,
    yystackp: *yyGLRStack = undefined,
    yyposn: isize = 0,

    pub fn init(allocator: std.mem.Allocator) yyparse_context_t {
        var yyctx = yyparse_context_t{ .allocator = allocator };
        yyctx.yystackp = &yyctx.yystack;
        return yyctx;
    }
};

//                       0x00000000 reserved for not a label
const LABEL_YYUSER_ERROR = 0x00000001;
const LABEL_YYACCEPTLAB = 0x00000002;
const LABEL_YYBUGLAB = 0x00000004;
const LABEL_YYABORTLAB = 0x00000008;
const LABEL_YYEXHAUSTEDLAB = 0x00000010;
const LABEL_YYRETURNLAB = 0x00000020;
const LABEL_YYPARSE_IMPL = 0x00000040;

fn label_yyacceptlab(yyctx: *yyparse_context_t) usize {
    yyctx.yyresult = 0;
    return LABEL_YYRETURNLAB;
}

fn label_yybuglab(yyctx: *yyparse_context_t) usize {
    _ = yyctx;
    // TODO: bug
    std.debug.print("bug", .{});
    return LABEL_YYABORTLAB;
}

fn label_yyabortlab(yyctx: *yyparse_context_t) usize {
    yyctx.yyresult = 1;
    return LABEL_YYRETURNLAB;
}

fn label_yyexhaustedlab(yyctx: *yyparse_context_t) usize {
    const yystackp = yyctx.yystackp;
    yyerror(&yystackp.yyloc, "memory exhausted");
    yyctx.yyresult = 2;
    return LABEL_YYRETURNLAB;
}

fn label_yyuser_error(yyctx: *yyparse_context_t) !usize {
    var yystack = yyctx.yystack;
    try yyrecoverSyntaxError(yyctx, &yystack, yyctx.scanner);
    yyctx.yyposn = yystack.yytops.yystates[0].yyposn;
    return LABEL_YYPARSE_IMPL;
}

fn label_yyparse_impl(yyctx: *yyparse_context_t) !usize {
    var ret: usize = 0;
    while (true) {
        // /* For efficiency, we have two loops, the first of which is
        //    specialized to deterministic operation (single stack, no
        //    potential ambiguity).  */

        // /* Standard mode. */
        while (true) {
            const yystate: usize = yyctx.yystack.yytops.yystates[0].yylrState;
            if (yydebug) {
                std.debug.print("Entering state {d}\n", .{yystate});
            }
            if (yystate == YYFINAL) {
                return LABEL_YYACCEPTLAB;
            }
            if (yyisDefaultedState(yystate)) {
                const yyrule: usize = yydefaultAction(yystate);
                if (yyrule == 0) {
                    yyctx.yystack.yyerror_range[1].yystate.yyloc = yyctx.yystackp.yyloc;
                    try yyreportSyntaxError(yyctx.allocator, &yyctx.yystack);
                    return LABEL_YYUSER_ERROR;
                }
                ret = YYCHK1(try yyglrReduce(yyctx, &yyctx.yystack, 0, yyrule, true));
                if (ret != 0) {
                    return ret;
                }
            } else {
                const yytoken = try yygetToken(&yyctx.yystackp.yyrawchar, yyctx.yystackp, yyctx.scanner);
                var yyconflicts: []const isize = undefined;
                const yyaction = yygetLRActions(yystate, yytoken, &yyconflicts);
                if (yyconflicts[0] > 0) {
                    // /* Enter nondeterministic mode.  */
                    break;
                }
                if (yyisShiftAction(yyaction)) {
                    try YY_SYMBOL_PRINT("Shifting", yytoken, &yyctx.yystackp.yyval, &yyctx.yystackp.yyloc);
                    yyctx.yystackp.yyrawchar = yytoken_kind_t.YYEMPTY;
                    yyctx.yyposn += 1;
                    try yyglrShift(&yyctx.yystack, 0, @intCast(yyaction), @intCast(yyctx.yyposn), &yyctx.yystackp.yyval, &yyctx.yystackp.yyloc);
                    if (0 < yyctx.yystack.yyerrState) {
                        yyctx.yystack.yyerrState -= 1;
                    }
                } else if (yyisErrorAction(yyaction)) {
                    yyctx.yystack.yyerror_range[1].yystate.yyloc = yyctx.yystackp.yyloc;
                    // /* Issue an error message unless the scanner already
                    //    did. */
                    if (yyctx.yystackp.yyrawchar != yysymbol_kind_t.YYSYMBOL_YYerror) {
                        try yyreportSyntaxError(yyctx.allocator, &yyctx.yystack);
                    }
                    return LABEL_YYUSER_ERROR;
                } else {
                    ret = YYCHK1(try yyglrReduce(yyctx, &yyctx.yystack, 0, @intCast(-yyaction), true));
                    if (ret != 0) {
                        return ret;
                    }
                }
            }
        }

        // /* Nondeterministic mode. */
        while (true) {
            var yytoken_to_shift: isize = undefined;
            var yys: isize = 0;
            while (yys < yyctx.yystack.yytops.yysize) : (yys += 1) {
                yyctx.yystackp.yytops.yylookaheadNeeds[@intCast(yys)] = yyctx.yystackp.yyrawchar != yytoken_kind_t.YYEMPTY;
            }

            // /* yyprocessOneStack returns one of three things:

            //     - An error flag.  If the caller is yyprocessOneStack, it
            //       immediately returns as well.  When the caller is finally
            //       yyparse, it jumps to an error label via YYCHK1.

            //     - yyok, but yyprocessOneStack has invoked yymarkStackDeleted
            //       (&yystack, yys), which sets the top state of yys to NULL.  Thus,
            //       yyparse's following invocation of yyremoveDeletes will remove
            //       the stack.

            //     - yyok, when ready to shift a token.

            //    Except in the first case, yyparse will invoke yyremoveDeletes and
            //    then shift the next token onto all remaining stacks.  This
            //    synchronization of the shift (that is, after all preceding
            //    reductions on all stacks) helps prevent double destructor calls
            //    on yylval in the event of memory exhaustion.  */

            yys = 0;
            while (yys < yyctx.yystack.yytops.yysize) : (yys += 1) {
                ret = YYCHK1(try yyprocessOneStack(yyctx, &yyctx.yystack, @intCast(yys), yyctx.yyposn, &yyctx.yystackp.yyloc, yyctx.scanner));
                if (ret != 0) {
                    return ret;
                }
            }
            yyremoveDeletes(&yyctx.yystack);
            if (yyctx.yystack.yytops.yysize == 0) {
                yyundeleteLastStack(&yyctx.yystack);
                if (yyctx.yystack.yytops.yysize == 0) {
                    _ = yyFail(&yyctx.yystack, &yyctx.yystackp.yyloc, yyctx.scanner, "syntax error");
                }
                ret = YYCHK1(try yyresolveStack(yyctx, &yyctx.yystack, yyctx.scanner));
                if (ret != 0) {
                    return ret;
                }
                if (yydebug) {
                    std.debug.print("Returning to deterministic operation.\n", .{});
                }

                yyctx.yystack.yyerror_range[1].yystate.yyloc = yyctx.yystackp.yyloc;
                try yyreportSyntaxError(yyctx.allocator, &yyctx.yystack);
                return LABEL_YYUSER_ERROR;
            }

            // /* If any yyglrShift call fails, it will fail after shifting.  Thus,
            //    a copy of yylval will already be on stack 0 in the event of a
            //    failure in the following loop.  Thus, yychar is set to YYEMPTY
            //    before the loop to make sure the user destructor for yylval isn't
            //    called twice.  */
            yytoken_to_shift = YYTRANSLATE(yyctx.yystackp.yyrawchar);
            yyctx.yystackp.yyrawchar = yytoken_kind_t.YYEMPTY;
            yyctx.yyposn += 1;
            yys = 0;
            while (yys < yyctx.yystack.yytops.yysize) : (yys += 1) {
                const yystate: usize = yyctx.yystack.yytops.yystates[@intCast(yys)].yylrState;
                var yyconflicts: []isize = undefined;
                const yyaction = yygetLRActions(yystate, yytoken_to_shift, &yyconflicts);
                // /* Note that yyconflicts were handled by yyprocessOneStack.  */
                if (yydebug) {
                    std.debug.print("On stack {d}, ", .{yys});
                }
                try YY_SYMBOL_PRINT("shifting", yytoken_to_shift, &yyctx.yystackp.yyval, &yyctx.yystackp.yyloc);
                try yyglrShift(&yyctx.yystack, yys, @intCast(yyaction), @intCast(yyctx.yyposn), &yyctx.yystackp.yyval, &yyctx.yystackp.yyloc);
                if (yydebug) {
                    std.debug.print("Stack {d} now in state {d}\n", .{ yys, ptrWithOffset(?*yyGLRState, yyctx.yystack.yytops.yystates, yys).*.?.yylrState });
                }
            }

            if (yyctx.yystack.yytops.yysize == 1) {
                ret = YYCHK1(try yyresolveStack(yyctx, &yyctx.yystack, yyctx.scanner));
                if (ret != 0) {
                    return ret;
                }
                if (yydebug) {
                    std.debug.print("Returning to deterministic operation.\n", .{});
                }
                yycompressStack(&yyctx.yystack);
                break;
            }
        }
    }
    return LABEL_YYACCEPTLAB;
}

// /*----------.
// | yyparse.  |
// `----------*/

pub fn yyparse(allocator: std.mem.Allocator, scanner: *YYLexer) !isize {
    var yyctx: yyparse_context_t = yyparse_context_t.init(allocator);
    yyctx.scanner = scanner;

    if (yydebug) {
        std.debug.print("Starting parse\n", .{});
    }

    yyctx.yystackp.yyrawchar = yytoken_kind_t.YYEMPTY;
    yyctx.yystackp.yyval = yyval_default;
    yyctx.yystackp.yyloc = yyloc_default;

    var loop_control: usize = 0;

    try yyinitGLRStack(yyctx.allocator, yyctx.yystackp, YYINITDEPTH);

    try yyglrShift(&yyctx.yystack, 0, 0, 0, &yyctx.yystackp.yyval, &yyctx.yystackp.yyloc);
    yyctx.yyposn = 0;
    loop_control = LABEL_YYPARSE_IMPL;

    // switch (YYSETJMP (yystack.yyexception_buffer))
    //   {
    //   case 0: break;
    //   case 1: goto yyabortlab;
    //   case 2: goto yyexhaustedlab;
    //   default: goto yybuglab;
    //   }

    while (true) {
        switch (loop_control) {
            LABEL_YYUSER_ERROR => {
                loop_control = try label_yyuser_error(&yyctx);
            },
            LABEL_YYACCEPTLAB => {
                loop_control = label_yyacceptlab(&yyctx);
            },
            LABEL_YYBUGLAB => {
                loop_control = label_yybuglab(&yyctx);
            },
            LABEL_YYABORTLAB => {
                loop_control = label_yyabortlab(&yyctx);
            },
            LABEL_YYEXHAUSTEDLAB => {
                loop_control = label_yyexhaustedlab(&yyctx);
            },
            LABEL_YYRETURNLAB => {
                break;
            },
            LABEL_YYPARSE_IMPL => {
                loop_control = try label_yyparse_impl(&yyctx);
            },
            else => {},
        }
    }

    // yyreturnlab:
    if (yyctx.yystackp.yyrawchar != yytoken_kind_t.YYEMPTY) {
        try yydestruct(&yyctx, "Cleanup: discarding lookahead", YYTRANSLATE(@as(usize, @intCast(yyctx.yystackp.yyrawchar))), &yyctx.yystackp.yyval, &yyctx.yystackp.yyloc);
    }

    // /* If the stack is well-formed, pop the stack until it is empty,
    //    destroying its entries as we go.  But free the stack regardless
    //    of whether it is well-formed.  */
    if (@intFromPtr(yyctx.yystack.yyitems) != 0) {
        const yystates = yyctx.yystack.yytops.yystates;
        if (@intFromPtr(yystates[0]) != 0) {
            const yysize = yyctx.yystack.yytops.yysize;
            var yyk: usize = 0;
            while (yyk < yysize) : (yyk += 1) {
                if (@intFromPtr(yystates[yyk]) != 0) {
                    while (@intFromPtr(yystates[yyk]) != 0) {
                        const yys = yystates[yyk];
                        yyctx.yystack.yyerror_range[1].yystate.yyloc = yys.yyloc;
                        if (@intFromPtr(yys.yypred) != 0) {
                            try yydestroyGLRState(&yyctx, "Cleanup: popping", valueWithOffset(*allowzero yyGLRState, yystates, @intCast(yyk)), yyctx.scanner);
                        }
                        if (@intFromPtr(yys.yypred) != 0) {
                            yystates[yyk] = yys.yypred;
                        }
                        yyctx.yystack.yynextFree = movePtr(yyctx.yystack.yynextFree, -1);
                        yyctx.yystack.yyspaceLeft += 1;
                    }
                    break;
                }
            }
        }
        yyfreeGLRStack(yyctx.allocator, &yyctx.yystack);
    }

    return yyctx.yyresult;
}

// /* DEBUGGING ONLY */
// /* Print *YYS and its predecessors. */
fn yy_yypstack(yys: *yyGLRState) void {
    if (yys.yypred) {
        yy_yypstack(yys.yypred);
        std.debug.print(" -> ", .{});
    }
    std.debug.print("{d}@{d}", .{ yys.yylrState, yys.yyposn });
}

// /* Print YYS (possibly NULL) and its predecessors. */
fn yypstates(yys: *yyGLRState) void {
    if (yys == YY_NULLPTR) {
        std.debug("<null>", .{});
    } else {
        yy_yypstack(yys);
    }
    std.debug.print("\n", .{});
}

// /* Print the stack #YYK.  */
fn yypstack(yystackp: *yyGLRStack, yyk: isize) void {
    yypstates(yystackp.yytops.yystates[yyk]);
}

// /* Print all the stacks.  */
fn yypdumpstack(yystackp: *yyGLRStack) void {
    // YY_CAST (long,                                                        \
    //          ((YYX)                                                       \
    //           ? YY_REINTERPRET_CAST (yyGLRStackItem*, (YYX)) - yystackp->yyitems \
    //           : -1))

    var yyp: *yyGLRStackItem = yystackp.yyitems;
    while (yyp < yystackp.yynextFree) : (yyp += 1) {
        std.debug.print("{d}. ", .{yyp - yystackp.yyitems});
        if (yyp.*) {
            YY_ASSERT(yyp.yystate.yyisState);
            YY_ASSERT(yyp.yyoption.yyisState);
            var yyx = yyp.yystate.yypred;
            std.debug.print("Res: {d}, LR State: {d}, posn: {d}, pred: {d}", .{ yyp.yystate.yyresolved, yyp.yystate.yylrState, yyp.yystate.yyposn, if (yyx > 0) yyx - yystackp.yyitems else -1 });
            if (!yyp.yystate.yyresolved) {
                yyx = yyp.yystate.yysemantics.yyfirstVal;
                std.debug.print(", firstVal: {d}", .{if (yyx > 0) yyx - yystackp.yyitems else -1});
            }
        } else {
            YY_ASSERT(!yyp.yystate.yyisState);
            YY_ASSERT(!yyp.yyoption.yyisState);
            const yyx1 = yyp.yyoption.yystate;
            const yyx2 = yyp.yyoption.yynext;
            std.debug.print("Option. rule: {d}, state: {d}, next: {d}", .{
                yyp.yyoption.yyrule - 1,
                if (yyx1 > 0) yyx1 - yystackp.yyitems else -1,
                if (yyx2 > 0) yyx2 - yystackp.yyitems else -1,
            });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("Tops:", .{});
    {
        var yyi: isize = 0;
        while (yyi < yystackp.yytops.yysize) : (yyi += 1) {
            const yyx = yystackp.yytops.yystates[yyi];
            std.debug.print("{d}: {d}; ", .{ yyi, if (yyx > 0) yyx - yystackp.yyitems else -1 });
        }
        std.debug.print("\n", .{});
    }
}
// #line 164 "parser.y"

fn stmtMerge(yyctx: *yyparse_context_t, x0: *YYSTYPE, x1: *YYSTYPE) !*Node {
    return try Node.newNterm(yyctx.allocator, "<OR>(%s, %s)", x0.stmt, x1.stmt, null);
}

pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    const stdout_writer = std.io.getStdOut().writer();

    var f: std.fs.File = brk: {
        if (args.len > 1) {
            break :brk try std.fs.cwd().openFile(args[1], .{});
        } else {
            break :brk std.io.getStdIn();
        }
    };
    defer f.close();

    const content = try f.readToEndAlloc(arena, std.math.maxInt(usize));
    defer arena.free(content);
    try stdout_writer.print("read {d}bytes\n", .{content.len});

    var scanner = YYLexer{ .allocator = arena };

    try YYLexer.yylex_init(&scanner);
    defer YYLexer.yylex_destroy(&scanner);

    _ = try YYLexer.yy_scan_string(content, scanner.yyg);

    _ = try YYParser.yyparse(arena, &scanner);

    return 0;
}
