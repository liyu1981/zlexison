// /* A Bison parser, made by GNU Bison 3.8.2.1-118cd-dirty.//  */

// /* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
//    especially those whose name start with YY_ or yy_.  They are
//    private implementation details that can be changed or removed.//  */

// /* Identify Bison output, and Bison version.  */
pub const YYBISON = 30802;

// /* Bison version string.  */
pub const YYBISON_VERSION = "3.8.2.1-118cd-dirty";

// /* Skeleton name.  */
pub const YYSKELETON_NAME = "zig.m4";

// /* Pure parsers.  */
pub const YYPURE = 2;

// /* Push parsers.  */
pub const YYPUSH = 0;

// /* Pull parsers.  */
pub const YYPULL = 1;

const std = @import("std");
const Self = @This();
const YYParser = @This();

pub var with_yyoverflow: bool = false;

pub var allocator: std.mem.Allocator = undefined;

/// util for calculate c pointer distance.
inline fn cPtrDistance(comptime T: type, p1: [*c]T, p2: [*c]T) usize {
    return (@intFromPtr(p2) - @intFromPtr(p1)) / @sizeOf(T);
}

inline fn ptrLessThan(comptime T: type, p1: [*]T, p2: [*]T) bool {
    return @as([*c]T, @ptrCast(p1)) < @as([*c]T, @ptrCast(p2));
}

inline fn ptrLessThanEql(comptime T: type, p1: [*]T, p2: [*]T) bool {
    return @as([*c]T, @ptrCast(p1)) <= @as([*c]T, @ptrCast(p2));
}

inline fn ptrWithOffset(comptime T: type, p: [*]T, offset: isize) [*]T {
    return @as(
        [*]T,
        @ptrFromInt(@as(usize, @intCast(@as(isize, @intCast(@intFromPtr(p))) + offset * @sizeOf(T)))),
    );
}

inline fn ptrRhsWithOffset(comptime T: type, p: [*]T, offset: isize) T {
    return ptrWithOffset(T, p, offset)[0];
}

inline fn ptrLhsWithOffset(comptime T: type, p: [*]T, offset: isize) *T {
    return &(ptrWithOffset(T, p, offset)[0]);
}

// /* "%code top" blocks.//  */

// /* Debug traces.  */
const YYDEBUG = 1;

pub var yydebug: bool = YYDEBUG == 1;

// /* "%code requires" blocks.//  */

const YYLexer = @import("scan.zig");

pub const Result = struct {
    // Whether to print the intermediate results.
    verbose: bool = true,
    // Value of the last computation.
    value: i64 = -1,
    // Number of errors.
    nerrs: usize = 0,
};

// /* Token kinds.  */
pub const yytoken_kind_t = enum(i32) {
    TOK_YYEMPTY = -2,
    TOK_EOF = 0, // /* "end-of-file"//  */
    TOK_YYerror = 256, // /* error//  */
    TOK_YYUNDEF = 257, // /* "invalid token"//  */
    TOK_PLUS = 258, // /* "+"//  */
    TOK_MINUS = 259, // /* "-"//  */
    TOK_STAR = 260, // /* "*"//  */
    TOK_SLASH = 261, // /* "/"//  */
    TOK_EOL = 262, // /* "end-of-line"//  */
    TOK_NUM = 263, // /* "number"//  */
    TOK_STR = 264, // /* "string"//  */
    TOK_UNARY = 265, // /* UNARY//  */
};

// /* Value type.  */
pub const YYSTYPE = YYLexer.YYSTYPE;

// /* Location type.  */
const YYLTYPE = YYLexer.YYLTYPE;

// /* "%code provides" blocks.//  */

// /* Symbol kind.  */
pub const yysymbol_kind_t = enum(i32) {
    YYSYMBOL_YYEMPTY = -2,
    YYSYMBOL_YYEOF = 0, // /* "end-of-file"//  */
    YYSYMBOL_YYerror = 1, // /* error//  */
    YYSYMBOL_YYUNDEF = 2, // /* "invalid token"//  */
    YYSYMBOL_PLUS = 3, // /* "+"//  */
    YYSYMBOL_MINUS = 4, // /* "-"//  */
    YYSYMBOL_STAR = 5, // /* "*"//  */
    YYSYMBOL_SLASH = 6, // /* "/"//  */
    YYSYMBOL_EOL = 7, // /* "end-of-line"//  */
    YYSYMBOL_NUM = 8, // /* "number"//  */
    YYSYMBOL_STR = 9, // /* "string"//  */
    YYSYMBOL_UNARY = 10, // /* UNARY//  */
    YYSYMBOL_YYACCEPT = 11, // /* $accept//  */
    YYSYMBOL_input = 12, // /* input//  */
    YYSYMBOL_line = 13, // /* line//  */
    YYSYMBOL_eol = 14, // /* eol//  */
    YYSYMBOL_exp = 15, // /* exp//  */
};

// /* Unqualified %code blocks.//  */

pub const YYSIZE_MAXIMUM = std.math.maxInt(usize);
pub const YYSTACK_ALLOC_MAXIMUM = YYSIZE_MAXIMUM;

// /* Stored state numbers (used for stacks). */
pub const yy_state_t = isize;

// /* State numbers in computations.  */
pub const yy_state_fast_t = isize;

// #define YY_ASSERT(E) ((void) (0 && (E)))
pub const YY_ASSERT = std.debug.assert;

// /* A type that is properly aligned for any stack member.  */
pub const yyalloc = union {
    yyss_alloc: yy_state_t,
    yyvs_alloc: YYSTYPE,
    yyls_alloc: YYLTYPE,
};

fn YYSTACK_ALLOC(size: usize) ![*]yyalloc {
    var yyalloc_array = try allocator.alloc(yyalloc, size);
    _ = &yyalloc_array;
    return yyalloc_array.ptr;
}

// /* The size of the maximum gap between one aligned stack and the next.  */
// # define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)
pub const YYSTACK_GAP_MAXIMUM = @sizeOf(yyalloc) - 1;

// /* The size of an array large to enough to hold all stacks, each with
//    N elements.  */
pub fn YYSTACK_BYTES(N: usize) usize {
    return N + @sizeOf(yy_state_t) + @sizeOf(YYSTYPE) + @sizeOf(YYLTYPE) + 2 * YYSTACK_GAP_MAXIMUM;
}

const WITH_YYSTACK_RELOCATE = true;

// /* Relocate STACK from its old location to the new one.  The
//    local variables YYSIZE and YYSTACKSIZE give the old and new number of
//    elements in the stack, and YYPTR gives the new location of the
//    stack.  Advance YYPTR to a properly aligned location for the next
//    stack.  */
fn YYSTACK_RELOCATE(
    yyctx: *yyparse_context_t,
    comptime field: enum { yyss, yyvs, yyls },
    yyptr_: *[*]yyalloc,
    yysize: usize,
) void {
    const yyptr = yyptr_.*;
    var yynewbytes: usize = 0;
    switch (field) {
        .yyss => {
            YYCOPY(yy_state_t, .yyss, yyptr, yyctx.yyss, yysize);
            yyctx.yyss[0] = yyptr[0].yyss_alloc;
            yynewbytes = yyctx.yystacksize * @sizeOf(yyalloc) + YYSTACK_GAP_MAXIMUM;
        },
        .yyvs => {
            YYCOPY(YYSTYPE, .yyvs, yyptr, yyctx.yyvs, yysize);
            yyctx.yyvs[0] = yyptr[0].yyvs_alloc;
            yynewbytes = yyctx.yystacksize * @sizeOf(yyalloc) + YYSTACK_GAP_MAXIMUM;
        },
        .yyls => {},
    }
    yyptr_.* = @ptrCast(yyptr + yynewbytes / @sizeOf(*yyalloc));
}

// /* Copy COUNT objects from SRC to DST.  The source and destination do
//    not overlap.  */
pub fn YYCOPY(comptime T: type, comptime field: enum { yyss, yyvs, yyls }, dst: [*]yyalloc, src: [*]T, count: usize) void {
    switch (field) {
        .yyss => {
            for (0..count) |i| dst[i].yyss_alloc = src[i];
        },
        .yyvs => {
            for (0..count) |i| dst[i].yyvs_alloc = src[i];
        },
        .yyls => {},
    }
}

// /* YYFINAL -- State number of the termination state.  */
pub const YYFINAL = 14;
// /* YYLAST -- Last index in YYTABLE.  */
pub const YYLAST = 38;

// /* YYNTOKENS -- Number of terminals.  */
pub const YYNTOKENS = 11;
// /* YYNNTS -- Number of nonterminals.  */
pub const YYNNTS = 5;
// /* YYNRULES -- Number of rules.  */
pub const YYNRULES = 15;
// /* YYNSTATES -- Number of states.  */
pub const YYNSTATES = 25;

// /* YYMAXUTOK -- Last valid token kind.  */
pub const YYMAXUTOK = 265;

// /* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex, with out-of-bounds checking.  */
pub fn YYTRANSLATE(YYX: anytype) yysymbol_kind_t {
    if (YYX >= 0 and YYX <= YYMAXUTOK) {
        return @as(yysymbol_kind_t, @enumFromInt(yytranslate[YYX]));
    } else {
        return yysymbol_kind_t.YYSYMBOL_YYUNDEF;
    }
}

// /* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex.  */
pub const yytranslate = [_]isize{ 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

// /* YYRLINE[YYN] -- Source line where rule number YYN was defined.//  */
pub const yyrline = [_]isize{ 0, 85, 85, 86, 90, 97, 104, 105, 109, 110, 111, 112, 113, 123, 124, 125 };

// /** Accessing symbol of state STATE.  */
pub inline fn YY_ACCESSING_SYMBOL(index: usize) isize {
    return yystos[index];
}

// /* The user-facing name of the symbol whose (internal) number is
//    YYSYMBOL.  No bounds checking.  */
pub fn yysymbol_name(yysymbol: yysymbol_kind_t) []const u8 {
    const YY_NULLPTR = "";
    const yy_sname = [_][]const u8{ "end-of-file", "error", "invalid token", "+", "-", "*", "/", "end-of-line", "number", "string", "UNARY", "$accept", "input", "line", "eol", "exp", YY_NULLPTR };
    return yy_sname[@as(usize, @intCast(@intFromEnum(yysymbol)))];
}

const YYPACT_NINF = -5;

inline fn yypact_value_is_default(yyn: anytype) bool {
    // TODO: check for all case
    // #define yypact_value_is_default(Yyn) \
    //  ((Yyn) == YYPACT_NINF)
    return yyn == YYPACT_NINF;
}

pub const YYTABLE_NINF = -1;

pub fn yytable_value_is_error(Yyn: anytype) bool {
    // TODO: check for all case
    // #define yytable_value_is_error(Yyn) \
    //   0
    _ = Yyn;
    return false;
}

// /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
//    STATE-NUM.//  */
pub const yypact = [_]isize{ 17, 12, 29, 29, -5, -5, 2, -5, 24, -5, -5, -5, -5, -5, -5, -5, 29, 29, 29, 29, -5, 3, 3, -5, -5 };

// /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
//    Performed when YYTABLE does not specify something else to do.  Zero
//    means the default is an error.//  */
pub const yydefact = [_]isize{ 0, 0, 0, 0, 8, 15, 0, 2, 0, 6, 7, 5, 13, 14, 1, 3, 0, 0, 0, 0, 4, 9, 10, 11, 12 };

// /* YYPGOTO[NTERM-NUM].//  */
pub const yypgoto = [_]isize{ -5, -5, 1, -4, -2 };

// /* YYDEFGOTO[NTERM-NUM].//  */
pub const yydefgoto = [_]isize{ 0, 6, 7, 11, 8 };

// /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
//    positive, shift that token.  If negative, reduce the rule whose
//    number is the opposite.  If YYTABLE_NINF, syntax error.//  */
pub const yytable = [_]isize{ 12, 13, 14, 1, 20, 2, 3, 15, 18, 19, 4, 5, 9, 0, 21, 22, 23, 24, 1, 10, 2, 3, 0, 0, 9, 4, 5, 16, 17, 18, 19, 10, 2, 3, 0, 0, 0, 4, 5 };

pub const yycheck = [_]isize{ 2, 3, 0, 1, 8, 3, 4, 6, 5, 6, 8, 9, 0, -1, 16, 17, 18, 19, 1, 7, 3, 4, -1, -1, 0, 8, 9, 3, 4, 5, 6, 7, 3, 4, -1, -1, -1, 8, 9 };

// /* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
//    state STATE-NUM.//  */
pub const yystos = [_]isize{ 0, 1, 3, 4, 8, 9, 12, 13, 15, 0, 7, 14, 15, 15, 0, 13, 3, 4, 5, 6, 14, 15, 15, 15, 15 };

// /* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.//  */
pub const yyr1 = [_]isize{ 0, 11, 12, 12, 13, 13, 14, 14, 15, 15, 15, 15, 15, 15, 15, 15 };

// /* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.//  */
pub const yyr2 = [_]isize{ 0, 2, 1, 2, 2, 2, 1, 1, 1, 3, 3, 3, 3, 2, 2, 1 };

pub const YYENOMEM = -2;

// #define yyerrok         (yyerrstatus = 0)
// #define yyclearin       (yychar = TOK_YYEMPTY)

// #define YYRECOVERING()  (!!yyerrstatus)

// TODO: a case really YYBACKUP?
pub fn YYBACKUP(yyctx: *yyparse_context_t, token: u8, value: c_int) usize {
    if (yyctx.yychar == yytoken_kind_t.TOK_YYEMPTY) {
        yyctx.yychar = token;
        yyctx.yylval = value;
        yyctx.YYPOPSTACK(yyctx.yylen);
        yyctx.yystate = yyctx.yyssp.*;
        return LABEL_YYBACKUP;
    } else {
        std.debug.print("syntax error: cannot back up", .{});
        yyctx.result.nerrs += 1;
        return LABEL_YYERRORLAB;
    }
}

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

pub fn YY_SYMBOL_PRINT(yyctx: *yyparse_context_t, title: []const u8, kind: anytype, value: anytype, location: anytype) void {
    if (yydebug) {
        std.debug.print("{s}", .{title});
    }
    std.debug.print("{any}{any}{any} {any}\n", .{ kind, value, location, yyctx.res });
    if (yydebug) {
        std.debug.print("\n", .{});
    }
}

//
// /*-----------------------------------.
// | Print this symbol's value on YYO.  |
// `-----------------------------------*/

pub fn yy_symbol_value_print(yyo: std.fs.File, yykind: isize, yyvaluep: *const YYSTYPE, yylocationp: *const YYLTYPE) !void {
    _ = yylocationp;
    // if (yyvaluep == null) return;
    switch (@as(yysymbol_kind_t, @enumFromInt(yykind))) {
        yysymbol_kind_t.YYSYMBOL_NUM => { // /* "number"//  */
            {
                try yyo.writer().print("{d}", .{(yyvaluep.TOK_NUM)});
            }
        },

        yysymbol_kind_t.YYSYMBOL_STR => { // /* "string"//  */
            {
                try yyo.writer().print("{s}", .{(yyvaluep.TOK_STR)});
            }
        },

        yysymbol_kind_t.YYSYMBOL_exp => { // /* exp//  */
            {
                try yyo.writer().print("{d}", .{(yyvaluep.TOK_exp)});
            }
        },

        else => {},
    }
}

// /*---------------------------.
// | Print this symbol on YYO.  |
// `---------------------------*/

pub fn yy_symbol_print(yyo: std.fs.File, yykind: isize, yyvaluep: *const YYSTYPE, yylocationp: *const YYLTYPE) !void {
    try yyo.writer().print("{s} {s} (", .{
        if (yykind < YYNTOKENS) "token" else "nterm",
        yysymbol_name(@enumFromInt(yykind)),
    });
    try yy_location_print_(yyo, yylocationp);
    try yyo.writer().print(": ", .{});
    try yy_symbol_value_print(yyo, yykind, yyvaluep, yylocationp);
    try yyo.writer().print(")", .{});
}

// /*------------------------------------------------------------------.
// | yy_stack_print -- Print the state stack from its BOTTOM up to its |
// | TOP (included).                                                   |
// `------------------------------------------------------------------*/

pub fn yy_stack_print(yybottom: [*]yy_state_t, yytop: [*]yy_state_t) void {
    if (yydebug) {
        std.debug.print("Stack now", .{});
        var yyb = yybottom;
        const yyt = yytop;
        while (ptrLessThanEql(yy_state_t, yyb, yyt)) : (yyb += 1) {
            std.debug.print(" {d}", .{yyb[0]});
        }
        std.debug.print("\n", .{});
    }
}

// /*------------------------------------------------.
// | Report that the YYRULE is going to be reduced.  |
// `------------------------------------------------*/

pub fn yy_reduce_print(yyctx: *yyparse_context_t, yyrule: usize) !void {
    const yylno = yyrline[yyrule];
    const yynrhs: usize = @intCast(yyr2[yyrule]);
    if (yydebug) {
        std.debug.print("Reducing stack by rule {d} (line {d}):\n", .{ yyrule - 1, yylno });
    }
    // /* The symbols being reduced.  */
    for (0..yynrhs) |yyi| {
        if (yydebug) {
            std.debug.print("   ${d} = ", .{yyi + 1});
        }
        try yy_symbol_print(
            std.io.getStdErr(),
            @intCast(YY_ACCESSING_SYMBOL(@intCast(yyctx.yyssp[yyi + 1 - yynrhs]))),
            &yyctx.yyvsp[(yyi + 1) - (yynrhs)],
            &(yyctx.yylsp[(yyi + 1) - (yynrhs)]),
        );
        if (yydebug) {
            std.debug.print("\n", .{});
        }
    }
}

// /* YYINITDEPTH -- initial size of the parser's stacks.  */
pub const YYINITDEPTH = 200;

// /* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
//    if the built-in stack extension method is used).

//    Do not make this value too large; the results are undefined if
//    YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
//    evaluated with infinite-precision integer arithmetic.  */

pub const YYMAXDEPTH = 10000;

// /* Context of a parse error.  */
pub const yypcontext_t = struct {
    yyssp: [*]yy_state_t,
    yytoken: yysymbol_kind_t,
    yylloc: *YYLTYPE,
};

// /* Put in YYARG at most YYARGN of the expected tokens given the
//    current YYCTX, and return the number of tokens stored in YYARG.  If
//    YYARG is null, return the number of expected tokens (guaranteed to
//    be less than YYNTOKENS).  Return YYENOMEM on memory exhaustion.
//    Return 0 if there are more than YYARGN expected tokens, yet fill
//    YYARG up to YYARGN. */
pub fn yypcontext_expected_tokens(yypctx: *yypcontext_t, yyarg: [*]allowzero yysymbol_kind_t, yyargn: usize) isize {
    // /* Actual size of YYARG. */
    var yycount: isize = 0;

    const yyn = yypact[@intCast(yypctx.yyssp[0])];
    if (!yypact_value_is_default(yyn)) {
        // /* Start YYX at -YYN if negative to avoid negative indexes in
        //    YYCHECK.  In other words, skip the first -YYN actions for
        //    this state because they are default actions.  */
        const yyxbegin: isize = if (yyn < 0) -yyn else 0;
        // /* Stay within bounds of both yycheck and yytname.  */
        const yychecklim: isize = YYLAST - yyn + 1;
        const yyxend: isize = if (yychecklim < YYNTOKENS) yychecklim else YYNTOKENS;
        var yyx: isize = yyxbegin;
        while (yyx < yyxend) : (yyx += 1) {
            if (yycheck[@intCast(yyx + yyn)] == yyx and
                yyx != @as(isize, @intFromEnum(yysymbol_kind_t.YYSYMBOL_YYerror)) and
                !yytable_value_is_error(yytable[@intCast(yyx + yyn)]))
            {
                if (@intFromPtr(yyarg) == 0) {
                    yycount += 1;
                } else if (yycount == yyargn) {
                    return 0;
                } else {
                    yyarg[@intCast(yycount)] = @enumFromInt(yyx);
                    yycount += 1;
                }
            }
        }
        // TODO: need confirm this with c source
        if (@intFromPtr(yyarg) != 0 and yycount == 0 and yyargn > 0)
            yyarg[0] = yysymbol_kind_t.YYSYMBOL_YYEMPTY;
        return yycount;
    }

    return yycount;
}

pub fn yy_syntax_error_arguments(yypctx: *yypcontext_t, yyarg: [*]allowzero yysymbol_kind_t, yyargn: usize) isize {
    //   /* Actual size of YYARG. */
    var yycount: isize = 0;
    //   /* There are many possibilities here to consider:
    //      - If this state is a consistent state with a default action, then
    //        the only way this function was invoked is if the default action
    //        is an error action.  In that case, don't check for expected
    //        tokens because there are none.
    //      - The only way there can be no lookahead present (in yychar) is if
    //        this state is a consistent state with a default action.  Thus,
    //        detecting the absence of a lookahead is sufficient to determine
    //        that there is no unexpected or expected token to report.  In that
    //        case, just report a simple "syntax error".
    //      - Don't assume there isn't a lookahead just because this state is a
    //        consistent state with a default action.  There might have been a
    //        previous inconsistent state, consistent state with a non-default
    //        action, or user semantic action that manipulated yychar.
    //      - Of course, the expected token list depends on states to have
    //        correct lookahead information, and it depends on the parser not
    //        to perform extra reductions after fetching a lookahead from the
    //        scanner and before detecting a syntax error.  Thus, state merging
    //        (from LALR or IELR) and default reductions corrupt the expected
    //        token list.  However, the list is correct for canonical LR with
    //        one exception: it will still contain any token that will not be
    //        accepted due to an error action in a later state.
    //   */
    if (yypctx.yytoken != yysymbol_kind_t.YYSYMBOL_YYEMPTY) {
        if (@intFromPtr(yyarg) != 0) {
            yyarg[@intCast(yycount)] = yypctx.yytoken;
        }
        yycount += 1;
        const yyn = yypcontext_expected_tokens(yypctx, if (@intFromPtr(yyarg) != 0) @ptrCast(yyarg + 1) else @ptrCast(yyarg), yyargn - 1);
        if (yyn == YYENOMEM) {
            return YYENOMEM;
        } else {
            yycount += yyn;
        }
    }
    return yycount;
}

// /* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
//    about the unexpected token YYTOKEN for the state stack whose top is
//    YYSSP.

//    Return 0 if *YYMSG was successfully written.  Return -1 if *YYMSG is
//    not large enough to hold the message.  In that case, also set
//    *YYMSG_ALLOC to the required number of bytes.  Return YYENOMEM if the
//    required number of bytes is too large to store.  */
pub fn yysyntax_error(yymsg_alloc: *usize, yymsg: *[]const u8, yypctx: *yypcontext_t) isize {
    _ = yymsg;
    const YYARGS_MAX = 5;
    // /* Internationalized format string. */
    var yyformat: []const u8 = undefined;
    // /* Arguments of yyformat: reported tokens (one for the "unexpected",
    //    one per "expected"). */
    var yyarg: [YYARGS_MAX]yysymbol_kind_t = undefined;
    // /* Cumulated lengths of YYARG.  */
    var yysize: usize = 0;

    // /* Actual size of YYARG. */
    const yycount = yy_syntax_error_arguments(yypctx, yyarg[0..].ptr, YYARGS_MAX);
    if (yycount == YYENOMEM)
        return YYENOMEM;

    switch (yycount) {
        0 => yyformat = "syntax error",
        1 => yyformat = "syntax error, unexpected {s}",
        2 => yyformat = "syntax error, unexpected {s}, expecting {s}",
        3 => yyformat = "syntax error, unexpected {s}, expecting {s} or {s}",
        4 => yyformat = "syntax error, unexpected {s}, expecting {s} or {s} or {s}",
        5 => yyformat = "syntax error, unexpected {s}, expecting {s} or {s} or {s} or {s}",
        else => {},
    }

    // /* Compute error message size.  Don't count the "%s"s, but reserve
    //    room for the terminator.  */
    yysize = yyformat.len - @as(usize, @intCast(2 * yycount)) + 1;
    {
        var yyi: usize = 0;
        while (yyi < yycount) : (yyi += 1) {
            const yysize1: usize = yysize + yysymbol_name(yyarg[yyi]).len;
            if (yysize <= yysize1 and yysize1 <= YYSTACK_ALLOC_MAXIMUM) {
                yysize = yysize1;
            } else {
                return YYENOMEM;
            }
        }
    }

    if (yymsg_alloc.* < yysize) {
        yymsg_alloc.* = 2 * yysize;
        if (!(yysize <= yymsg_alloc.* and yymsg_alloc.* <= YYSTACK_ALLOC_MAXIMUM))
            yymsg_alloc.* = YYSTACK_ALLOC_MAXIMUM;
        return -1;
    }

    // TODO: there must be issue, fix it :)
    // /* Avoid sprintf, as that infringes on the user's name space.
    //    Don't have undefined behavior even if the translation
    //    produced a string with the wrong number of "%s"s.  */
    // {
    //     var yyp: [*c]u8 = yymsg.*;
    //     var yyi: usize = 0;
    //     yyp.* = yyformat.*;
    //     while (yyp.* != 0) : (yyp.* = yyformat.*) {
    //         if (yyp.* == '%' and yyformat[1] == 's' and yyi < yycount) {
    //             yyi += 1;
    //             yyp = @memcpy(
    //                 yyp[0..yysymbol_name(yyarg[yyi]).len],
    //                 yysymbol_name(yyarg[yyi]),
    //             );
    //             yyi += 1;
    //             yyformat += 2;
    //         } else {
    //             yyp += 1;
    //             yyformat += 1;
    //         }
    //     }
    // }
    return 0;
}

// /*-----------------------------------------------.
// | Release the memory associated to this symbol.  |
// `-----------------------------------------------*/

pub fn yydestruct(yyctx: *yyparse_context_t, yymsg: []const u8, yykind: yysymbol_kind_t, yyvaluep: *YYSTYPE, yylocationp: *YYLTYPE) void {
    _ = yylocationp;
    // if (yymsg == null) {
    //     yymsg = "Deleting";
    // }
    YY_SYMBOL_PRINT(yyctx, yymsg, yykind, yyvaluep, null);

    switch (yykind) {
        yysymbol_kind_t.YYSYMBOL_STR => { // /* "string"//  */
            {
                allocator.free(yyvaluep.*.TOK_STR);
            }
        },

        else => {},
    }
}

// collect all yyparse loop variables into one struct so that when we deal with
// gotos, we will be with easier life
const yyparse_context_t = struct {
    scanner: *YYLexer = undefined,
    res: *Result = undefined,

    // /* Lookahead token kind.  */
    yychar: isize = @intFromEnum(yytoken_kind_t.TOK_YYEMPTY), // /* Cause a token to be read.  */

    // /* The semantic value of the lookahead symbol.  */
    // /* Default value used for initialization, for pacifying older GCCs
    //    or non-GCC compilers.  */
    // YY_INITIAL_VALUE (static YYSTYPE yyval_default;)
    // YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);
    yyval_default: YYSTYPE = undefined,
    yylval: YYSTYPE = undefined,

    // /* Location data for the lookahead symbol.  */
    yyloc_default: YYLTYPE = YYLTYPE{},
    yylloc: YYLTYPE = YYLTYPE{},

    // /* Number of syntax errors so far.  */
    yynerrs: usize = 0,

    yystate: yy_state_fast_t = 0,
    // /* Number of tokens to shift before error messages enabled.  */
    yyerrstatus: usize = 0,

    // /* Refer to the stacks through separate pointers, to allow yyoverflow
    //    to reallocate them elsewhere.  */

    // /* Their size.  */
    yystacksize: usize = YYINITDEPTH,

    // /* The state stack: array, bottom, top.  */
    yyssa: [YYINITDEPTH]yy_state_t = undefined,
    yyss: [*]yy_state_t = undefined, // need init to  = yyssa;
    yyssp: [*]yy_state_t = undefined, // need init to  = yyss;

    // /* The semantic value stack: array, bottom, top.  */
    yyvsa: [YYINITDEPTH]YYSTYPE = undefined,
    yyvs: [*]YYSTYPE = undefined, // need init to  = yyvsa;
    yyvsp: [*]YYSTYPE = undefined, // need init to  = yyvs;

    // /* The location stack: array, bottom, top.  */
    yylsa: [YYINITDEPTH]YYLTYPE = undefined,
    yyls: [*]YYLTYPE = undefined, // need init to  = yylsa;
    yylsp: [*]YYLTYPE = undefined, // need init to  = yyls;

    yyn: isize = 0,
    // /* The return value of yyparse.  */
    yyresult: usize = 0,
    // /* Lookahead symbol kind.  */
    yytoken: yysymbol_kind_t = yysymbol_kind_t.YYSYMBOL_YYEMPTY,
    // /* The variables used to return semantic value and location from the
    //    action routines.  */
    yyval: YYSTYPE = undefined,
    yyloc: YYLTYPE = undefined,

    // /* The locations where the error started and ended.  */
    yyerror_range: [3]YYLTYPE = undefined,

    // /* Buffer for error messages, and its allocated size.  */
    yymsgbuf: [128]u8 = undefined,
    yymsg: []u8 = undefined, // need init to = yymsgbuf;
    yymsg_alloc: usize = 128,

    // /* The number of symbols on the RHS of the reduced rule.
    //    Keep to zero when no symbol should be popped.  */
    yylen: usize = 0,

    pub fn YYPOPSTACK(this: *yyparse_context_t, N: usize) void {
        this.yyvsp -= N;
        this.yyssp -= N;
    }
};

const LABEL_YYNEWSTATE = 0x0000000000000001;
const LABEL_YYSETSTATE = 0x0000000000000002;
const LABEL_YYEXHAUSTEDLAB = 0x0000000000000004;
const LABEL_YYABORTLAB = 0x0000000000000008;
const LABEL_YYACCEPTLAB = 0x0000000000000010;
const LABEL_YYBACKUP = 0x0000000000000020;
const LABEL_YYDEFAULT = 0x0000000000000040;
const LABEL_YYPUSHRETURN = 0x0000000000000080;
const LABEL_YYREAD_PUSHED_TOKEN = 0x0000000000000100;
const LABEL_YYERRLAB1 = 0x0000000000000200;
const LABEL_YYERRLAB = 0x0000000000000400;
const LABEL_YYREDUCE = 0x0000000000000800;
const LABEL_YYERRORLAB = 0x0000000000001000;
const LABEL_YYRETURNLAB = 0x0000000000002000;

// /*------------------------------------------------------------.
// | yynewstate -- push a new state, which is found in yystate.  |
// `------------------------------------------------------------*/
fn label_yynewstate(yyctx: *yyparse_context_t) usize {
    // /* In all cases, when you get here, the value and location stacks
    //    have just been pushed.  So pushing a state here evens the stacks.  */
    yyctx.yyssp += 1;
    return LABEL_YYSETSTATE;
}

// /*--------------------------------------------------------------------.
// | yysetstate -- set current state (the top of the stack) to yystate.  |
// `--------------------------------------------------------------------*/
fn label_yysetstate(yyctx: *yyparse_context_t) !usize {
    if (yydebug) {
        std.debug.print("Entering state {d}\n", .{yyctx.yystate});
    }
    YY_ASSERT(0 <= yyctx.yystate and yyctx.yystate < YYNSTATES);
    yyctx.yyssp[0] = @as(yy_state_t, @intCast(yyctx.yystate));
    yy_stack_print(yyctx.yyss, yyctx.yyssp);

    if (ptrLessThan(isize, yyctx.yyss + yyctx.yystacksize - 1, yyctx.yyssp)) {
        if (!with_yyoverflow and !WITH_YYSTACK_RELOCATE) {
            return LABEL_YYEXHAUSTEDLAB;
        } else {
            // /* Get the current used size of the three stacks, in elements.  */
            const yysize: usize = @intCast(cPtrDistance(isize, yyctx.yyss, yyctx.yyssp) + 1);

            if (with_yyoverflow) {
                // /* Give user a chance to reallocate the stack.  Use copies of
                //    these so that the &'s don't force the real ones into
                //    memory.  */
                var yyss1 = yyctx.yyss;
                {
                    _ = &yyss1;
                }
                var yyvs1 = yyctx.yyvs;
                {
                    _ = &yyvs1;
                }

                const yyls1 = yyctx.yyls;

                // /* Each stack pointer address is followed by the size of the
                //    data in use in that stack, in bytes.  This used to be a
                //    conditional around just the two extra args, but that might
                //    be undefined if yyoverflow is a macro.  */
                // TODO: revisit this later;
                // yyoverflow (YY_("memory exhausted"),
                //            &yyss1, yysize * YYSIZEOF (*yyssp),
                //            &yyvs1, yysize * YYSIZEOF (*yyvsp),
                //            &yyls1, yysize * YYSIZEOF (*yylsp),
                //            &yystacksize);
                yyctx.yyss = yyss1;
                yyctx.yyvs = yyvs1;
                yyctx.yyls = yyls1;
            } else if (WITH_YYSTACK_RELOCATE) {
                // /* Extend the stack our own way.  */
                if (YYMAXDEPTH <= yyctx.yystacksize) {
                    return LABEL_YYEXHAUSTEDLAB;
                }
                yyctx.yystacksize *= 2;
                if (YYMAXDEPTH < yyctx.yystacksize) {
                    yyctx.yystacksize = YYMAXDEPTH;
                }

                {
                    const yyss1 = yyctx.yyss;
                    var yyptr: [*]yyalloc = try YYSTACK_ALLOC(YYSTACK_BYTES(yyctx.yystacksize));
                    // TODO: really necessary in zig as we have try?
                    // if (yyptr == null) {
                    //     return LABEL_YYEXHAUSTEDLAB;
                    // }
                    YYSTACK_RELOCATE(yyctx, .yyss, &yyptr, yysize);
                    YYSTACK_RELOCATE(yyctx, .yyvs, &yyptr, yysize);
                    YYSTACK_RELOCATE(yyctx, .yyls, &yyptr, yysize);
                    // YYSTACK_RELOCATE = false;
                    // TODO: why undef?
                    // #  undef YYSTACK_RELOCATE
                    if (yyss1 != yyctx.yyssa[0..].ptr) {
                        // TODO: rethink
                        // allocator.free(yyss1);
                    }
                }
            }

            yyctx.yyssp = yyctx.yyss + yysize - 1;
            yyctx.yyvsp = yyctx.yyvs + yysize - 1;
            yyctx.yylsp = yyctx.yyls + yysize - 1;

            if (yydebug) {
                std.debug.print("Stack size increased to {d}\n", .{yyctx.yystacksize});
            }

            if (ptrLessThan(isize, yyctx.yyss + yyctx.yystacksize - 1, yyctx.yyssp)) {
                return LABEL_YYABORTLAB;
            }
        }
    }

    if (yyctx.yystate == YYFINAL) {
        return LABEL_YYACCEPTLAB;
    }

    return LABEL_YYBACKUP;
}

// /*-----------.
// | yybackup.  |
// `-----------*/
fn label_yybackup(yyctx: *yyparse_context_t) usize {
    // /* Do appropriate processing given the current state.  Read a
    //    lookahead token if we need one and don't already have one.  */

    // /* First try to decide what to do without reference to lookahead token.  */
    yyctx.yyn = yypact[@intCast(yyctx.yystate)];
    if (yypact_value_is_default(yyctx.yyn)) {
        return LABEL_YYDEFAULT;
    }

    // /* Not known => get a lookahead token if don't already have one.  */

    // /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
    if (yyctx.yychar == @intFromEnum(yytoken_kind_t.TOK_YYEMPTY)) {}
    return LABEL_YYREAD_PUSHED_TOKEN;
}

fn label_yyread_pushed_token(yyctx: *yyparse_context_t) !usize {
    if (yydebug) {
        std.debug.print("Reading a token\n", .{});
    }

    yyctx.yychar = @intCast(try yyctx.scanner.yylex(&yyctx.yylval, &yyctx.yylloc));

    if (yyctx.yychar <= @as(isize, @intFromEnum(yytoken_kind_t.TOK_EOF))) {
        yyctx.yychar = @intFromEnum(yytoken_kind_t.TOK_EOF);
        yyctx.yytoken = yysymbol_kind_t.YYSYMBOL_YYEOF;
        if (yydebug) {
            std.debug.print("Now at end of input.\n", .{});
        }
    } else if (yyctx.yychar == @as(isize, @intFromEnum(yytoken_kind_t.TOK_YYerror))) {
        // /* The scanner already issued an error message, process directly
        //    to error recovery.  But do not keep the error token as
        //    lookahead, it is too special and may lead us to an endless
        //    loop in error recovery. */
        yyctx.yychar = @intFromEnum(yytoken_kind_t.TOK_YYUNDEF);
        yyctx.yytoken = yysymbol_kind_t.YYSYMBOL_YYerror;
        yyctx.yyerror_range[1] = yyctx.yylloc;
        return LABEL_YYERRLAB1;
    } else {
        yyctx.yytoken = YYTRANSLATE(@as(usize, @intCast(yyctx.yychar)));
        YY_SYMBOL_PRINT(yyctx, "Next token is", yyctx.yytoken, &yyctx.yylval, &yyctx.yylloc);
    }

    // /* If the proper action on seeing token YYTOKEN is to reduce or to
    //    detect an error, take that action.  */
    yyctx.yyn += @as(isize, @intFromEnum(yyctx.yytoken));
    if (yyctx.yyn < 0 or YYLAST < yyctx.yyn or yycheck[@intCast(yyctx.yyn)] != @intFromEnum(yyctx.yytoken))
        return LABEL_YYDEFAULT;

    yyctx.yyn = yytable[@intCast(yyctx.yyn)];
    if (yyctx.yyn <= 0) {
        if (yytable_value_is_error(yyctx.yyn)) {
            return LABEL_YYERRLAB;
        }
        yyctx.yyn = -yyctx.yyn;
        return LABEL_YYREDUCE;
    }

    // /* Count tokens shifted since error; after three, turn off error
    //    status.  */
    if (yyctx.yyerrstatus > 0) {
        yyctx.yyerrstatus -= 1;
    }

    // /* Shift the lookahead token.  */
    YY_SYMBOL_PRINT(yyctx, "Shifting", yyctx.yytoken, &yyctx.yylval, &yyctx.yylloc);
    yyctx.yystate = yyctx.yyn;
    yyctx.yyvsp += 1;
    yyctx.yyvsp[0] = yyctx.yylval;

    yyctx.yylsp += 1;
    yyctx.yylsp[0] = yyctx.yylloc;

    // /* Discard the shifted token.  */
    yyctx.yychar = @intFromEnum(yytoken_kind_t.TOK_YYEMPTY);
    return LABEL_YYNEWSTATE;
}

// /*-----------------------------------------------------------.
// | yydefault -- do the default action for the current state.  |
// `-----------------------------------------------------------*/
fn label_yydefault(yyctx: *yyparse_context_t) usize {
    yyctx.yyn = yydefact[yyctx.yystate];
    if (yyctx.yyn == 0) {
        return LABEL_YYERRLAB;
    }
    return LABEL_YYREDUCE;
}

// /*-----------------------------.
// | yyreduce -- do a reduction.  |
// `-----------------------------*/
fn label_yyreduce(yyctx: *yyparse_context_t) !usize {
    // /* yyn is the number of a rule to reduce with.  */
    yyctx.yylen = @intCast(yyr2[@intCast(yyctx.yyn)]);

    // /* If YYLEN is nonzero, implement the default value of the action:
    //    '$$ = $1'.
    //
    //    Otherwise, the following line sets YYVAL to garbage.
    //    This behavior is undocumented and Bison
    //    users should not rely upon it.  Assigning to YYVAL
    //    unconditionally makes the parser a bit smaller, and it avoids a
    //    GCC warning that YYVAL may be used uninitialized.  */
    yyctx.yyval = yyctx.yyvsp[1 - yyctx.yylen];
    // /* Default location. */
    YYLLOC_DEFAULT(&yyctx.yyloc, (yyctx.yylsp - yyctx.yylen), yyctx.yylen);
    yyctx.yyerror_range[1] = yyctx.yyloc;
    try yy_reduce_print(yyctx, @intCast(yyctx.yyn));
    switch (yyctx.yyn) {
        4 => { // /* line: exp eol//  */
            {
                yyctx.res.value = (ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, -1).TOK_exp);
                if (yyctx.res.verbose) {
                    std.debug.print("{d}\n", .{ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, -1).TOK_exp});
                }
            }
        },

        5 => { // /* line: error eol//  */
            {
                std.debug.print("yyerrok!", .{});
            }
        },

        8 => { // /* exp: "number"//  */
            {
                yyctx.yyval.TOK_exp = ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_NUM;
            }
        },

        9 => { // /* exp: exp "+" exp//  */
            {
                yyctx.yyval.TOK_exp = ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, -2).TOK_exp + ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_exp;
            }
        },

        10 => { // /* exp: exp "-" exp//  */
            {
                yyctx.yyval.TOK_exp = ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, -2).TOK_exp - ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_exp;
            }
        },

        11 => { // /* exp: exp "*" exp//  */
            {
                yyctx.yyval.TOK_exp = ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, -2).TOK_exp * ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_exp;
            }
        },

        12 => { // /* exp: exp "/" exp//  */
            {
                if (ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_exp == 0) {
                    std.debug.print("invalid division by zero", .{});
                    unreachable;
                } else {
                    yyctx.yyval.TOK_exp = @divTrunc(ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, -2).TOK_exp, ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_exp);
                }
            }
        },

        13 => { // /* exp: "+" exp//  */
            {
                yyctx.yyval.TOK_exp = ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_exp;
            }
        },

        14 => { // /* exp: "-" exp//  */
            {
                yyctx.yyval.TOK_exp = -ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_exp;
            }
        },

        15 => { // /* exp: "string"//  */
            {
                const int_value = try std.fmt.parseInt(c_int, ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_STR, 10);
                allocator.free(ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, 0).TOK_STR);
                yyctx.yyval.TOK_exp = int_value;
            }
        },

        else => {},
    }
    // /* User semantic actions sometimes alter yychar, and that requires
    //    that yytoken be updated with the new translation.  We take the
    //    approach of translating immediately before every use of yytoken.
    //    One alternative is translating here after every semantic action,
    //    but that translation would be missed if the semantic action invokes
    //    YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
    //    if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
    //    incorrect destructor might then be invoked immediately.  In the
    //    case of YYERROR or YYBACKUP, subsequent parser actions might lead
    //    to an incorrect destructor call or verbose syntax error message
    //    before the lookahead is translated.  */
    YY_SYMBOL_PRINT(yyctx, "-> $$ =", yyr1[@intCast(yyctx.yyn)], &yyctx.yyval, &yyctx.yyloc);

    yyctx.YYPOPSTACK(yyctx.yylen);
    yyctx.yylen = 0;

    yyctx.yyvsp += 1;
    yyctx.yyvsp[0] = yyctx.yyval;
    yyctx.yylsp += 1;
    yyctx.yylsp[0] = yyctx.yyloc;

    // /* Now 'shift' the result of the reduction.  Determine what state
    //    that goes to, based on the state we popped back to and the rule
    //    number reduced by.  */
    {
        const yylhs = yyr1[@intCast(yyctx.yyn)] - YYNTOKENS;
        const yyi = yypgoto[@intCast(yylhs)] + yyctx.yyssp[0];
        yyctx.yystate = if (0 <= yyi and yyi <= YYLAST and yycheck[@intCast(yyi)] == yyctx.yyssp[0])
            yytable[@intCast(yyi)]
        else
            yydefgoto[@intCast(yylhs)];
    }

    return LABEL_YYNEWSTATE;
}

// /*--------------------------------------.
// | yyerrlab -- here on detecting error.  |
// `--------------------------------------*/
fn label_yyerrlab(yyctx: *yyparse_context_t) usize {
    // /* Make sure we have latest lookahead translation.  See comments at
    //    user semantic actions for why this is necessary.  */
    yyctx.yytoken = if (yyctx.yychar == @intFromEnum(yytoken_kind_t.TOK_YYEMPTY)) yysymbol_kind_t.YYSYMBOL_YYEMPTY else YYTRANSLATE(@as(usize, @intCast(yyctx.yychar)));
    // /* If not already recovering from an error, report this error.  */
    if (yyctx.yyerrstatus == 0) {
        yyctx.yynerrs += 1;
        {
            var yypctx = yypcontext_t{ .yyssp = yyctx.yyssp, .yytoken = yyctx.yytoken, .yylloc = &yyctx.yylloc };
            var yymsgp: []const u8 = "syntax error";
            var yysyntax_error_status = yysyntax_error(&yyctx.yymsg_alloc, &yyctx.yymsg, &yypctx);
            if (yysyntax_error_status == 0) {
                yymsgp = yyctx.yymsg;
            } else if (yysyntax_error_status == -1) {
                if (yyctx.yymsg.ptr != yyctx.yymsgbuf[0..].ptr) {
                    allocator.free(yyctx.yymsg);
                }
                yyctx.yymsg = brk: {
                    yyctx.yymsg = allocator.alloc(u8, yyctx.yymsg_alloc) catch {
                        yymsgp = yyctx.yymsgbuf[0..];
                        yyctx.yymsg_alloc = yyctx.yymsgbuf.len;
                        yysyntax_error_status = YYENOMEM;
                        break :brk yyctx.yymsgbuf[0..];
                    };
                    yymsgp = yyctx.yymsg;
                    yysyntax_error_status = yysyntax_error(&yyctx.yymsg_alloc, &yyctx.yymsg, &yypctx);
                    break :brk yyctx.yymsg;
                };
            }
            // yyerror (&yylloc, YYLexer, Result, yymsgp);
            if (yysyntax_error_status == YYENOMEM) {
                return LABEL_YYEXHAUSTEDLAB;
            }
        }
    }

    yyctx.yyerror_range[1] = yyctx.yylloc;
    if (yyctx.yyerrstatus == 3) {
        // /* If just tried and failed to reuse lookahead token after an
        //    error, discard it.  */

        if (yyctx.yychar <= @intFromEnum(yytoken_kind_t.TOK_EOF)) {
            // /* Return failure if at end of input.  */
            if (yyctx.yychar == @intFromEnum(yytoken_kind_t.TOK_EOF)) {
                return LABEL_YYABORTLAB;
            }
        } else {
            yydestruct(yyctx, "Error: discarding", yyctx.yytoken, &yyctx.yylval, &yyctx.yylloc);
            yyctx.yychar = @intFromEnum(yytoken_kind_t.TOK_YYEMPTY);
        }
    }

    // /* Else will try to reuse lookahead token after shifting the error
    //    token.  */
    return LABEL_YYERRLAB1;
}

// /*---------------------------------------------------.
// | yyerrorlab -- error raised explicitly by YYERROR.  |
// `---------------------------------------------------*/
fn label_yyerrorlab(yyctx: *yyparse_context_t) usize {
    // /* Pacify compilers when the user code never invokes YYERROR and the
    //    label yyerrorlab therefore never appears in user code.  */
    yyctx.yynerrs += 1;

    // /* Do not reclaim the symbols of the rule whose action triggered
    //    this YYERROR.  */
    yyctx.YYPOPSTACK(yyctx.yylen);
    yyctx.yylen = 0;
    yy_stack_print(yyctx.yyss, yyctx.yyssp);
    yyctx.yystate = yyctx.yyssp[0];
    return LABEL_YYERRLAB1;
}

// /*-------------------------------------------------------------.
// | yyerrlab1 -- common code for both syntax error and YYERROR.  |
// `-------------------------------------------------------------*/
fn label_yyerrlab1(yyctx: *yyparse_context_t) usize {
    yyctx.yyerrstatus = 3; // /* Each real token shifted decrements this.  */

    // /* Pop stack until we find a state that shifts the error token.  */
    while (true) {
        yyctx.yyn = yypact[@intCast(yyctx.yystate)];
        if (!yypact_value_is_default(yyctx.yyn)) {
            yyctx.yyn += @intFromEnum(yysymbol_kind_t.YYSYMBOL_YYerror);
            if (0 <= yyctx.yyn and yyctx.yyn <= YYLAST and yycheck[@intCast(yyctx.yyn)] == @intFromEnum(yysymbol_kind_t.YYSYMBOL_YYerror)) {
                yyctx.yyn = yytable[@intCast(yyctx.yyn)];
                if (0 < yyctx.yyn)
                    break;
            }
        }

        // /* Pop the current state because it cannot handle the error token.  */
        if (yyctx.yyssp == yyctx.yyss) {
            return LABEL_YYABORTLAB;
        }

        yyctx.yyerror_range[1] = yyctx.yylsp[0];
        yydestruct(yyctx, "Error: popping", @enumFromInt(YY_ACCESSING_SYMBOL(@intCast(yyctx.yystate))), &yyctx.yyvsp[0], &yyctx.yylsp[0]);
        yyctx.YYPOPSTACK(1);
        yyctx.yystate = yyctx.yyssp[0];
        yy_stack_print(yyctx.yyss, yyctx.yyssp);
    }

    yyctx.yyvsp += 1;
    yyctx.yyvsp[0] = yyctx.yylval;

    yyctx.yyerror_range[2] = yyctx.yylloc;
    yyctx.yylsp += 1;
    YYLLOC_DEFAULT(&yyctx.yylsp[0], yyctx.yyerror_range[0..].ptr, 2);

    // /* Shift the error token.  */
    YY_SYMBOL_PRINT(yyctx, "Shifting", YY_ACCESSING_SYMBOL(@intCast(yyctx.yyn)), yyctx.yyvsp, yyctx.yylsp);

    yyctx.yystate = yyctx.yyn;
    return LABEL_YYNEWSTATE;
}

// /*-------------------------------------.
// | yyacceptlab -- YYACCEPT comes here.  |
// `-------------------------------------*/
fn label_yyacceptlab(yyctx: *yyparse_context_t) usize {
    yyctx.yyresult = 0;
    return LABEL_YYRETURNLAB;
}

// /*-----------------------------------.
// | yyabortlab -- YYABORT comes here.  |
// `-----------------------------------*/
fn label_yyabortlab(yyctx: *yyparse_context_t) usize {
    yyctx.yyresult = 1;
    return LABEL_YYRETURNLAB;
}

// /*-----------------------------------------------------------.
// | yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
// `-----------------------------------------------------------*/
fn label_yyexhaustedlab(yyctx: *yyparse_context_t) usize {
    // yyerror (&yylloc, YYLexer, Result, YY_("memory exhausted"));
    yyctx.yyresult = 2;
    return LABEL_YYRETURNLAB;
}

// /*----------------------------------------------------------.
// | yyreturnlab -- parsing is finished, clean up and return.  |
// `----------------------------------------------------------*/
fn label_yyreturnlab(yyctx: *yyparse_context_t) usize {
    if (yyctx.yychar != @intFromEnum(yytoken_kind_t.TOK_YYEMPTY)) {
        // /* Make sure we have latest lookahead translation.  See comments at
        //   user semantic actions for why this is necessary.  */
        yyctx.yytoken = YYTRANSLATE(@as(usize, @intCast(yyctx.yychar)));
        yydestruct(yyctx, "Cleanup: discarding lookahead", yyctx.yytoken, &yyctx.yylval, &yyctx.yylloc);
    }
    // /* Do not reclaim the symbols of the rule whose action triggered
    //    this YYABORT or YYACCEPT.  */
    yyctx.YYPOPSTACK(yyctx.yylen);
    yy_stack_print(yyctx.yyss, yyctx.yyssp);
    while (yyctx.yyssp != yyctx.yyss) {
        yydestruct(yyctx, "Cleanup: popping", @enumFromInt(YY_ACCESSING_SYMBOL(@intCast(yyctx.yyssp[0]))), &yyctx.yyvsp[0], &yyctx.yylsp[0]);
        yyctx.YYPOPSTACK(1);
    }
    return LABEL_YYPUSHRETURN;
}

// /*----------.
// | yyparse.  |
// `----------*/

pub fn yyparse(scanner: *YYLexer, res: *Result) !usize {
    // replace all local variables with yyps, so later when access should use yyps
    var yyctx = yyparse_context_t{};
    yyctx.scanner = scanner;
    yyctx.res = res;
    yyctx.yyss = yyctx.yyssa[0..].ptr;
    yyctx.yyssp = yyctx.yyss;
    yyctx.yyvs = yyctx.yyvsa[0..].ptr;
    yyctx.yyvsp = yyctx.yyvs;
    yyctx.yyls = yyctx.yylsa[0..].ptr;
    yyctx.yylsp = yyctx.yyls;
    yyctx.yymsg = yyctx.yymsgbuf[0..];

    if (yydebug) {
        std.debug.print("Starting parse\n", .{});
    }

    yyctx.yychar = @intFromEnum(yytoken_kind_t.TOK_YYEMPTY); // /* Cause a token to be read.  */

    // TODO: fix this
    yyctx.yylsp[0] = yyctx.yylloc;

    var loop_control: usize = LABEL_YYSETSTATE;

    while (true) {
        switch (loop_control) {
            LABEL_YYNEWSTATE => {
                loop_control = label_yynewstate(&yyctx);
            },

            LABEL_YYSETSTATE => {
                loop_control = try label_yysetstate(&yyctx);
            },

            LABEL_YYEXHAUSTEDLAB => {
                loop_control = label_yyexhaustedlab(&yyctx);
            },

            LABEL_YYABORTLAB => {
                loop_control = label_yyabortlab(&yyctx);
            },

            LABEL_YYACCEPTLAB => {
                loop_control = label_yyacceptlab(&yyctx);
            },

            LABEL_YYBACKUP => {
                loop_control = label_yybackup(&yyctx);
            },

            LABEL_YYDEFAULT => {},

            LABEL_YYPUSHRETURN => {
                break;
            },

            LABEL_YYREAD_PUSHED_TOKEN => {
                loop_control = try label_yyread_pushed_token(&yyctx);
            },

            LABEL_YYERRLAB1 => {
                loop_control = label_yyerrlab1(&yyctx);
            },

            LABEL_YYERRLAB => {
                loop_control = label_yyerrlab(&yyctx);
            },

            LABEL_YYREDUCE => {
                loop_control = try label_yyreduce(&yyctx);
            },

            LABEL_YYERRORLAB => {
                loop_control = label_yyerrorlab(&yyctx);
            },

            LABEL_YYRETURNLAB => {
                loop_control = label_yyreturnlab(&yyctx);
            },

            else => unreachable,
        }
    }

    // /*-------------------------.
    // | yypushreturn -- return.  |
    // `-------------------------*/
    if (with_yyoverflow) {
        if (yyctx.yyss != yyctx.yyssa[0..].ptr) {
            // TODO: rethink
            // allocator.free(yyctx.yyss[0..yyctx.yyss]);
        }
    }
    if (yyctx.yymsg.ptr != yyctx.yymsgbuf[0..].ptr) {
        // TODO: rethink
        // allocator.free(yyctx.yymsg);
    }
    return yyctx.yyresult;
}

pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    YYParser.allocator = allocator;
    yydebug = true;
    var res: Result = Result{};

    var scanner = YYLexer{ .allocator = arena };
    YYLexer.context = YYLexer.Context.init(arena);
    defer YYLexer.context.deinit();

    try YYLexer.yylex_init(&scanner);
    defer YYLexer.yylex_destroy(&scanner);

    _ = try YYParser.yyparse(&scanner, &res);

    std.debug.print("{any}\n", .{res});

    return 0;
}
