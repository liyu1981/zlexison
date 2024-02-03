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

// /* "%code top" blocks.//  */

// /* Debug traces.  */
pub const YYDEBUG = 1;

pub extern var yydebug: bool;

// /* "%code requires" blocks.//  */

const lexer = @import("scan.zig");

pub const result = struct {
    // Whether to print the intermediate results.
    verbose: bool,
    // Value of the last computation.
    value: i64,
    // Number of errors.
    nerrs: usize,
};

// /* Token kinds.  */
pub const yytoken_kind_t = enum {
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
pub const YYSTYPE = union {
    TOK_STR: []const u8, // /* "string"//  */
    TOK_NUM: c_int, // /* "number"//  */
    TOK_exp: c_int, // /* exp//  */

};

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

// /* Stored state numbers (used for stacks). */
pub const yy_state_t = isize;

// /* State numbers in computations.  */
pub const yy_state_fast_t = c_int;

// #define YY_ASSERT(E) ((void) (0 && (E)))
pub const YY_ASSERT = std.debug.assert;

// /* A type that is properly aligned for any stack member.  */
pub const yyalloc = union {
    yyss_alloc: yy_state_t,
    yyvs_alloc: YYSTYPE,
};

// /* The size of the maximum gap between one aligned stack and the next.  */
// # define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)
pub const YYSTACK_GAP_MAXIMUM = @sizeOf(yyalloc) - 1;

// /* The size of an array large to enough to hold all stacks, each with
//    N elements.  */
pub fn YYSTACK_BYTES(comptime N: usize) usize {
    return N + @sizeOf(yy_state_t) + @sizeOf(YYSTYPE) + YYSTACK_GAP_MAXIMUM;
}

// /* Relocate STACK from its old location to the new one.  The
//    local variables YYSIZE and YYSTACKSIZE give the old and new number of
//    elements in the stack, and YYPTR gives the new location of the
//    stack.  Advance YYPTR to a properly aligned location for the next
//    stack.  */
pub fn YYSTACK_RELOCATE(Stack_alloc: yyalloc, Stack_: **yyalloc, yysize: usize, yystacksize: usize, yyptr_: **yyptr_t) void {
    var yynewbytes: usize = 0;
    YYCOPY(yyptr_.*.Stack_alloc, Stack_.*.*, yysize);
    Stack_.* = yyptr_.*.Stack_alloc;
    yynewbytes = yystacksize * @sizeOf(yyalloc) + YYSTACK_GAP_MAXIMUM;
    yyptr_.* = yyptr_.*.* + yynewbytes / @sizeOf(yyptr_t);
}

// /* Copy COUNT objects from SRC to DST.  The source and destination do
//    not overlap.  */
pub inline fn YYCOPY(comptime T: type, dst: [*c]T, src: [*c]T, count: usize) void {
    for (0..count) |yyi| {
        dst[yyi] = src[yyi];
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
        return yytranslate[YYX];
    } else {
        return YYSYMBOL_YYUNDEF;
    }
}

// /* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex.  */
pub const yytranslate = [_]isize{ 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

// /* YYRLINE[YYN] -- Source line where rule number YYN was defined.//  */
pub const yyrline = [_]isize{ 0, 83, 83, 84, 88, 94, 101, 102, 106, 107, 108, 109, 110, 120, 121, 122 };

// /** Accessing symbol of state STATE.  */
pub inline fn YY_ACCESSING_SYMBOL(index: usize) isize {
    return yystos[index];
}

// /* The user-facing name of the symbol whose (internal) number is
//    YYSYMBOL.  No bounds checking.  */
pub fn yysymbol_name(yysymbol: yysymbol_kind_t) []const u8 {
    comptime const YY_NULLPTR = "";
    const yy_sname = [_][]const u8{ "end-of-file", "error", "invalid token", "+", "-", "*", "/", "end-of-line", "number", "string", "UNARY", "$accept", "input", "line", "eol", "exp", YY_NULLPTR };
    return yy_sname[yysymbol];
}

pub const YYPACT_NINF = -5;

pub inline fn yypact_value_is_default(Yyn: anytype) bool {
    // TODO: check for all case
    // #define yypact_value_is_default(Yyn) \
    //  ((Yyn) == YYPACT_NINF)
    _ = Yyn;
    return false;
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

pub fn YYBACKUP(yyctx: *yypareser_context_t, token: u8, value: c_int) void {
    if (yyctx.yychar == yytoken_kind_t.TOK_YYEMPTY) {
        yyctx.yychar = token;
        yyctx.yylval = value;
        YYPOPSTACK(yyctx, yylen);
        yyctx.yystate = yyctx.yyssp.*;
        // TODO: goto!
        // goto yybackup;
    } else {
        yyerror(yyscan_t, result, YY_("syntax error: cannot back up"));
        // TODO: goto!
        // goto errorlab;
    }
}

pub fn YY_SYMBOL_PRINT(Title: []const u8, Kind: anytype, Value: anytype, Location: anytype) void {
    std.debug.print("%s", .{Title});
    std.debug.print("{any}{any}{any}", .{ Kind, Value, yyscan_t, result });
}

//
// /*-----------------------------------.
// | Print this symbol's value on YYO.  |
// `-----------------------------------*/

pub fn yy_symbol_value_print(yyo: std.fs.File, yykind: isize, yyvaluep: *const YYSTYPE, scanner: yyscan_t, res: *result) !void {
    var yyoutput = yyo;
    // YY_USE (yyoutput);
    // YY_USE (yyscan_t);
    // YY_USE (result);
    if (yyvaluep == null) return;
    switch (yykind) {
        YYSYMBOL_NUM => { // /* "number"//  */
            {
                try yyo.writer().print("{d}", ((*yyvaluep).TOK_NUM));
            }
        },

        YYSYMBOL_STR => { // /* "string"//  */
            {
                try yyo.writer().print("{s}", ((*yyvaluep).TOK_STR));
            }
        },

        YYSYMBOL_exp => { // /* exp//  */
            {
                try yyo.writer().print("{d}", ((*yyvaluep).TOK_exp));
            }
        },

        else => {},
    }
}

// /*---------------------------.
// | Print this symbol on YYO.  |
// `---------------------------*/

pub fn yy_symbol_print(yyo: std.fs.File, yykind: usize, yyvaluep: *const YYSTYPE, scanner: yyscan_t, res: *result) !void {
    try yyo.writer().print("{s} {s} (", .{
        if (yykind < YYNTOKENS) "token" else "nterm",
        yysymbol_name(yykind),
    });
    try yy_symbol_value_print(yyo, yykind, yyvaluep, yyscan_t, result);
    try yyo.writer().print(")", .{});
}

// /*------------------------------------------------------------------.
// | yy_stack_print -- Print the state stack from its BOTTOM up to its |
// | TOP (included).                                                   |
// `------------------------------------------------------------------*/

pub fn yy_stack_print(yybottom: [*c]yy_state_t, yytop: [*c]yy_state_t) void {
    if (yydebug) {
        std.debug.print("Stack now", .{});
        var yyb = yybottom;
        var yyt = yytop;
        while (yyb <= yyt) : (yyb += 1) {
            std.debug.print(" {d}", .{yyb.*});
        }
        std.debug.print("\n", .{});
    }
}

// /*------------------------------------------------.
// | Report that the YYRULE is going to be reduced.  |
// `------------------------------------------------*/

pub fn yy_reduce_print(yyssp: [*c]yy_state_t, yyvsp: [*c]YYSTYPE, yyrule: usize, scanner: yyscan_t, res: *result) void {
    var yylno = yyrline[yyrule];
    var yynrhs = yyr2[yyrule];
    if (yydebug) {
        std.debug.print("Reducing stack by rule {d} (line {d}):\n", .{ yyrule - 1, yylno });
    }
    // /* The symbols being reduced.  */
    for (0..@intCast(yynrhs)) |yyi| {
        if (yydebug) {
            std.debug.print("   ${d} = ", .{yyi + 1});
        }
        yy_symbol_print(std.io.getStdErr(), YY_ACCESSING_SYMBOL(yyssp[yyi + 1 - yynrhs]), &yyvsp[(yyi + 1) - (yynrhs)], yyscan_t, result);
        if (yydebug) {
            std.debug.print("\n", .{});
        }
    }

    // # define YY_REDUCE_PRINT(Rule)          \
    // do {                                    \
    //   if (yydebug)                          \
    //     yy_reduce_print (yyssp, yyvsp, Rule, yyscan_t, result); \
    // } while (0)
}

// /* Nonzero means print parse trace.  It is left uninitialized so that
//   multiple parsers can coexist.  */
pub var yydebug: bool = false;

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
    yyssp: [*c]yy_state_t,
    yytoken: yysymbol_kind_t,
};

// /* Put in YYARG at most YYARGN of the expected tokens given the
//    current YYCTX, and return the number of tokens stored in YYARG.  If
//    YYARG is null, return the number of expected tokens (guaranteed to
//    be less than YYNTOKENS).  Return YYENOMEM on memory exhaustion.
//    Return 0 if there are more than YYARGN expected tokens, yet fill
//    YYARG up to YYARGN. */
pub fn yypcontext_expected_tokens(yyctx: *yypcontext_t, yyarg: [*c]yysymbol_kind_t, yyargn: unsize) usize {
    // /* Actual size of YYARG. */
    var yycount: usize = 0;

    var yyn = yypact[yyctx.yyssp];
    if (!yypact_value_is_default(yyn)) {
        // /* Start YYX at -YYN if negative to avoid negative indexes in
        //    YYCHECK.  In other words, skip the first -YYN actions for
        //    this state because they are default actions.  */
        var yyxbegin = if (yyn < 0) -yyn else 0;
        // /* Stay within bounds of both yycheck and yytname.  */
        var yychecklim = YYLAST - yyn + 1;
        var yyxend = if (yychecklim < YYNTOKENS) yychecklim else YYNTOKENS;
        var yyx = yyxbegin;
        while (yyx < yyxend) : (yyx += 1) {
            if (yycheck[yyx + yyn] == yyx and yyx != YYSYMBOL_YYerror and !yytable_value_is_error(yytable[yyx + yyn])) {
                if (yyarg == null) {
                    yycount += 1;
                } else if (yycount == yyargn) {
                    return 0;
                } else {
                    yyarg[yycount] = YY_CAST(yysymbol_kind_t, yyx);
                    yycount += 1;
                }
            }
        }
        // TODO: need confirm this with c source
        if (yyarg and yycount == 0 and yyargn > 0)
            yyarg[0] = YYSYMBOL_YYEMPTY;
        return yycount;
    }
}

pub fn yy_syntax_error_arguments(yyctx: *yypcontext_t, yyarg: [*c]yysymbol_kind_t, yyargn: usize) c_int {
    //   /* Actual size of YYARG. */
    var yycount: usize = 0;
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
    if (yyctx.yytoken != YYSYMBOL_YYEMPTY) {
        var yyn: c_int = 0;
        if (yyarg)
            yyarg[yycount] = yyctx.yytoken;
        yycount += 1;
        yyn = yypcontext_expected_tokens(yyctx, if (yyarg > 0) yyarg + 1 else yyarg, yyargn - 1);
        if (yyn == YYENOMEM)
            return YYENOMEM;
    } else {
        yycount += yyn;
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
pub fn yysyntax_error(yymsg_alloc: *usize, yymsg: *[*c]u8, yyctx: *yypcontext_t) c_int {
    const YYARGS_MAX = 5;
    // /* Internationalized format string. */
    var yyformat: []char = undefined;
    // /* Arguments of yyformat: reported tokens (one for the "unexpected",
    //    one per "expected"). */
    var yyarg: [YYARGS_MAX]yysymbol_kind_t = undefined;
    // /* Cumulated lengths of YYARG.  */
    var yysize: usize = 0;

    // /* Actual size of YYARG. */
    var yycount = yy_syntax_error_arguments(yyctx, yyarg, YYARGS_MAX);
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
    yysize = yyformat.len - 2 * yycount + 1;
    {
        var yyi: usize = 0;
        while (yyi < yycount) : (yyi += 1) {
            var yysize1: usize = yysize + yystrlen(yysymbol_name(yyarg[yyi]));
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
    {
        var yyp: [*c]u8 = yymsg.*;
        var yyi: usize = 0;
        yyp.* = yyformat.*;
        while (yyp.* != '\0') : (yyp.* = yyformat.*) {
            if (yyp.* == '%' and yyformat[1] == 's' and yyi < yycount) {
                yyi += 1;
                yyp = yystpcpy(yyp, yysymbol_name(yyarg[yyi]));
                yyi += 1;
                yyformat += 2;
            } else {
                yyp += 1;
                yyformat += 1;
            }
        }
    }
    return 0;
}

// /*-----------------------------------------------.
// | Release the memory associated to this symbol.  |
// `-----------------------------------------------*/

pub fn yydestruct(yymsg: [*c]u8, yykind: yysymbol_kind_t, yyvaluep: *YYSTYPE, scanner: yyscan_t, res: *result) void {
    if (yymsg == null) {
        yymsg = "Deleting";
    }
    YY_SYMBOL_PRINT(yymsg, yykind, yyvaluep, yylocationp);

    switch (yykind) {
        YYSYMBOL_STR => { // /* "string"//  */
            {
                allocator.free(((*yyvaluep).TOK_STR));
            }
        },

        else => {},
    }
}

// collect all yyparse loop variables into one struct so that when we deal with
// gotos, we will be with easier life
const yyparse_context_t = struct {

    // /* Lookahead token kind.  */
    yychar: c_int = TOK_YYEMPTY, // /* Cause a token to be read.  */

    // /* The semantic value of the lookahead symbol.  */
    // /* Default value used for initialization, for pacifying older GCCs
    //    or non-GCC compilers.  */
    // YY_INITIAL_VALUE (static YYSTYPE yyval_default;)
    // YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);
    yyval_default: YYSTYPE,
    yylval: YYSTYPE,

    // /* Number of syntax errors so far.  */
    yynerrs: usize = 0,

    yystate: yy_state_fast_t = 0,
    // /* Number of tokens to shift before error messages enabled.  */
    yyerrstatus: int = 0,

    // /* Refer to the stacks through separate pointers, to allow yyoverflow
    //    to reallocate them elsewhere.  */

    // /* Their size.  */
    yystacksize: usize = YYINITDEPTH,

    // /* The state stack: array, bottom, top.  */
    yyssa: [YYINITDEPTH]yy_state_t,
    yyss: [*c]yy_state_t, // need init to  = yyssa;
    yyssp: [*c]yy_state_t, // need init to  = yyss;

    // /* The semantic value stack: array, bottom, top.  */
    yyvsa: YYSTYPE[YYINITDEPTH],
    yyvs: [*c]YYSTYPE, // need init to  = yyvsa;
    yyvsp: [*c]YYSTYPE, // need init to  = yyvs;

    yyn: c_int,
    // /* The return value of yyparse.  */
    yyresult: c_int,
    // /* Lookahead symbol kind.  */
    yytoken: yysymbol_kind_t = YYSYMBOL_YYEMPTY,
    // /* The variables used to return semantic value and location from the
    //    action routines.  */
    yyval: YYSTYPE,

    // /* Buffer for error messages, and its allocated size.  */
    yymsgbuf: [128]u8,
    yymsg: [*c]u8, // need init to = yymsgbuf;
    yymsg_alloc: usize = 128,

    // /* The number of symbols on the RHS of the reduced rule.
    //    Keep to zero when no symbol should be popped.  */
    yylen: c_int = 0,

    pub fn YYPOPSTACK(this: *yyparse_registers, N: usize) void {
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
fn label_yynewstate(yyctx: *yypareser_context_t) usize {
    // /* In all cases, when you get here, the value and location stacks
    //    have just been pushed.  So pushing a state here evens the stacks.  */
    yyctx.yyssp += 1;
    return LABEL_YYSETSTATE;
}

// /*--------------------------------------------------------------------.
// | yysetstate -- set current state (the top of the stack) to yystate.  |
// `--------------------------------------------------------------------*/
fn label_yysetstate(yyctx: *yypareser_context_t) usize {
    if (yydebug) {
        std.debug.print("Entering state {d}\n", .{yyctx.yystate});
    }
    YY_ASSERT(0 <= yyctx.yystate and yyctx.yystate < YYNSTATES);
    yyctx.yyssp.* = yyctx.yystate;
    YY_STACK_PRINT(yyss, yyssp);

    if (yyctx.yyss + yyctx.yystacksize - 1 <= yyctx.yyssp) {
        if (!with_yyoverflow and !WITH_YYSTACK_RELOCATE) {
            return LABEL_YYEXHAUSTEDLAB;
        } else {
            // /* Get the current used size of the three stacks, in elements.  */
            var yysize: usize = yyctx.yyssp - yyctx.yyss + 1;

            if (with_yyoverflow) {
                // /* Give user a chance to reallocate the stack.  Use copies of
                //    these so that the &'s don't force the real ones into
                //    memory.  */
                var yyss1 = yyctx.yyss;
                var yyvs1 = yyctx.yyvs;

                // /* Each stack pointer address is followed by the size of the
                //    data in use in that stack, in bytes.  This used to be a
                //    conditional around just the two extra args, but that might
                //    be undefined if yyoverflow is a macro.  */
                yyoverflow(YY_("memory exhausted"), &yyss1, yysize * YYSIZEOF(*yyssp), &yyvs1, yysize * YYSIZEOF(*yyvsp), &yystacksize);
                yyctx.yyss = yyss1;
                yyctx.yyvs = yyvs1;
            } else if (WITH_YYSTACK_RELOCATE) {
                // /* Extend the stack our own way.  */
                if (YYMAXDEPTH <= yyctx.yystacksize) {
                    return LABEL_YYEXHAUSTEDLAB;
                }
                yyctx.yystacksize *= 2;
                if (YYMAXDEPTH < yystacksize) {
                    yyctx.yystacksize = YYMAXDEPTH;
                }

                {
                    var yyss1 = yyss;
                    var yyptr: [*c]yyalloc = YYSTACK_BYTES(yyctx.yystacksize);
                    if (yyptr == null) {
                        return LABEL_YYEXHAUSTEDLAB;
                    }
                    YYSTACK_RELOCATE(yyps, .yyss);
                    YYSTACK_RELOCATE(yyps, .yyvs);
                    YYSTACK_RELOCATE = false;
                    // TODO: why undef?
                    // #  undef YYSTACK_RELOCATE
                    if (yyss1 != yyctx.yyssa) {
                        YYSTACK_FREE(yyss1);
                    }
                }
            }

            yyctx.yyssp = yyctx.yyss + yyctx.yysize - 1;
            yyctx.yyvsp = yyctx.yyvs + yyctx.yysize - 1;

            if (yydebug) {
                std.debug.print("Stack size increased to {d}\n", .{yyctx.yystacksize});
            }

            if (yyctx.yyss + yyctx.yystacksize - 1 <= yyctx.yyssp) {
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
    yyctx.yyn = yypact[yyctx.yystate];
    if (yypact_value_is_default(yyctx.yyn)) {
        return LABEL_YYDEFAULT;
    }

    // /* Not known => get a lookahead token if don't already have one.  */

    // /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
    if (yyctx.yychar == TOK_YYEMPTY) {}
    return LABEL_YYREAD_PUSHED_TOKEN;
}

fn label_yyread_pushed_token(yyctx: *yypareser_context_t) usize {
    if (yydebug) {
        std.debug.print("Reading a token\n");
    }

    yyctx.yychar = yylex(&yylval, yyscan_t, result);

    if (yyctx.yychar <= TOK_EOF) {
        yyctx.yychar = TOK_EOF;
        yyctx.yytoken = YYSYMBOL_YYEOF;
        if (yydebug) {
            std.debug.print("Now at end of input.\n");
        }
    } else if (yyctx.yychar == TOK_YYerror) {
        // /* The scanner already issued an error message, process directly
        //    to error recovery.  But do not keep the error token as
        //    lookahead, it is too special and may lead us to an endless
        //    loop in error recovery. */
        yyctx.yychar = TOK_YYUNDEF;
        yyctx.yytoken = YYSYMBOL_YYerror;
        return LABEL_YYERRLAB1;
    } else {
        yyctx.yytoken = YYTRANSLATE(yyctx.yychar);
        YY_SYMBOL_PRINT("Next token is", yytoken, &yylval, &yylloc);
    }

    // /* If the proper action on seeing token YYTOKEN is to reduce or to
    //    detect an error, take that action.  */
    yyctx.yyn += yyctx.yytoken;
    if (yyctx.yyn < 0 or YYLAST < yyctx.yyn or yyctx.yycheck[yyctx.yyn] != yyctx.yytoken)
        return LABEL_YYDEFAULT;

    yyctx.yyn = yytable[yyctx.yyn];
    if (yyctx.yyn <= 0) {
        if (yytable_value_is_error(yyctx.yyn)) {
            return LABEL_YYERRLAB;
        }
        yyctx.yyn = -yyctx.yyn;
        return LABEL_YYREDUCE;
    }

    // /* Count tokens shifted since error; after three, turn off error
    //    status.  */
    if (yyctx.yyerrstatus) {
        yyctx.yyerrstatus -= 1;
    }

    // /* Shift the lookahead token.  */
    YY_SYMBOL_PRINT("Shifting", yytoken, &yylval, &yylloc);
    yyctx.yystate = yyctx.yyn;
    yyctx.yyvsp += 1;
    yyctx.yyvsp.* = yyctx.yylval;

    // /* Discard the shifted token.  */
    yyctx.yychar = TOK_YYEMPTY;
    return LABEL_YYNEWSTATE;
}

// /*-----------------------------------------------------------.
// | yydefault -- do the default action for the current state.  |
// `-----------------------------------------------------------*/
fn label_yydefault(yyctx: *yypareser_context_t) usize {
    yyctx.yyn = yydefact[yyctx.yystate];
    if (yyctx.yyn == 0) {
        return LABEL_YYERRLAB;
    }
    return LABEL_YYREDUCE;
}

// /*-----------------------------.
// | yyreduce -- do a reduction.  |
// `-----------------------------*/
fn label_yyreduce(yyctx: *yypareser_context_t) usize {
    // /* yyn is the number of a rule to reduce with.  */
    yyctx.yylen = yyr2[yyctx.yyn];

    // /* If YYLEN is nonzero, implement the default value of the action:
    //    '$$ = $1'.
    //
    //    Otherwise, the following line sets YYVAL to garbage.
    //    This behavior is undocumented and Bison
    //    users should not rely upon it.  Assigning to YYVAL
    //    unconditionally makes the parser a bit smaller, and it avoids a
    //    GCC warning that YYVAL may be used uninitialized.  */
    yyctx.yyval = yyctx.yyvsp[1 - yyctx.yylen];

    YY_REDUCE_PRINT(yyctx.yyn);
    switch (yyctx.yyn) {
        4 => { // /* line: exp eol//  */
            {
                res.value = (yyvsp[-1].TOK_exp);
                if (res.verbose)
                    printf("%d\n", (yyvsp[-1].TOK_exp));
            }
        },

        5 => { // /* line: error eol//  */
            {
                yyerrok;
            }
        },

        8 => { // /* exp: "number"//  */
            {
                (yyval.TOK_exp) = (yyvsp[0].TOK_NUM);
            }
        },

        9 => { // /* exp: exp "+" exp//  */
            {
                (yyval.TOK_exp) = (yyvsp[-2].TOK_exp) + (yyvsp[0].TOK_exp);
            }
        },

        10 => { // /* exp: exp "-" exp//  */
            {
                (yyval.TOK_exp) = (yyvsp[-2].TOK_exp) - (yyvsp[0].TOK_exp);
            }
        },

        11 => { // /* exp: exp "*" exp//  */
            {
                (yyval.TOK_exp) = (yyvsp[-2].TOK_exp) * (yyvsp[0].TOK_exp);
            }
        },

        12 => { // /* exp: exp "/" exp//  */
            {
                if ((yyvsp[0].TOK_exp) == 0) {
                    yyerror(scanner, res, "invalid division by zero");
                    YYERROR;
                } else (yyval.TOK_exp) = (yyvsp[-2].TOK_exp) / (yyvsp[0].TOK_exp);
            }
        },

        13 => { // /* exp: "+" exp//  */
            {
                (yyval.TOK_exp) = (yyvsp[0].TOK_exp);
            }
        },

        14 => { // /* exp: "-" exp//  */
            {
                (yyval.TOK_exp) = -(yyvsp[0].TOK_exp);
            }
        },

        15 => { // /* exp: "string"//  */
            {
                var r = parse_string((yyvsp[0].TOK_STR));
                free((yyvsp[0].TOK_STR));
                if (r.nerrs) {
                    res.nerrs += r.nerrs;
                    YYERROR;
                } else (yyval.TOK_exp) = r.value;
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
    YY_SYMBOL_PRINT("-> $$ =", YY_CAST(yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

    YYPOPSTACK(yyctx.yylen);
    yyctx.yylen = 0;

    yyctx.yyvsp += 1;
    yyctx.yyvsp.* = yyctx.yyval;

    // /* Now 'shift' the result of the reduction.  Determine what state
    //    that goes to, based on the state we popped back to and the rule
    //    number reduced by.  */
    {
        const yylhs = yyr1[yyctx.yyn] - YYNTOKENS;
        const yyi = yypgoto[yyctx.yylhs] + yyctx.yyssp.*;
        yyctx.yystate = if (0 <= yyctx.yyi and yyctx.yyi <= YYLAST and yycheck[yyctx.yyi] == yyctx.yyssp.*)
            yytable[yyctx.yyi]
        else
            yydefgoto[yyctx.yylhs];
    }

    return LABEL_YYNEWSTATE;
}

// /*--------------------------------------.
// | yyerrlab -- here on detecting error.  |
// `--------------------------------------*/
fn label_yyerrlab(yyctx: *yyparse_context_t) usize {
    // /* Make sure we have latest lookahead translation.  See comments at
    //    user semantic actions for why this is necessary.  */
    yyctx.yytoken = if (yyctx.yychar == TOK_YYEMPTY) YYSYMBOL_YYEMPTY else YYTRANSLATE(yyctx.yychar);
    // /* If not already recovering from an error, report this error.  */
    if (!yyerrstatus) {
        yyctx.yynerrs += 1;
        {
            var yypctx = yypcontext_t{ .yyssp = yyctx.yyssp, .yytoken = yyctx.yytoken };
            var yymsgp: []const u8 = "syntax error";
            var yysyntax_error_status: c_int = 0;
            yysyntax_error_status = yysyntax_error(&yyctx.yymsg_alloc, &yyctx.yymsg, &yypctx);
            if (yysyntax_error_status == 0) {
                yymsgp = yyctx.yymsg;
            } else if (yysyntax_error_status == -1) {
                if (yyctx.yymsg != yyctx.yymsgbuf)
                    YYSTACK_FREE(yyctx.yymsg);
                yyctx.yymsg = yyctx.yymsg_alloc;
                if (yyctx.yymsg != null) {
                    yysyntax_error_status = yysyntax_error(&yyctx.yymsg_alloc, &yyctx.yymsg, &yypctx);
                    yymsgp = yyctx.yymsg;
                } else {
                    yymsg = yyctx.yymsgbuf;
                    yyctx.yymsg_alloc = yyctx.yymsgbuf.len;
                    yysyntax_error_status = YYENOMEM;
                }
            }
            yyerror(yyscan_t, result, yymsgp);
            if (yysyntax_error_status == YYENOMEM) {
                return LABEL_YYEXHAUSTEDLAB;
            }
        }
    }

    if (yyerrstatus == 3) {
        // /* If just tried and failed to reuse lookahead token after an
        //    error, discard it.  */

        if (yyctx.yychar <= TOK_EOF) {
            // /* Return failure if at end of input.  */
            if (yychar == TOK_EOF) {
                return LABEL_YYABORTLAB;
            }
        } else {
            yydestruct("Error: discarding", yyctx.yytoken, &yyctx.yylval, yyscan_t, result);
            yyctx.yychar = TOK_YYEMPTY;
        }
    }

    // /* Else will try to reuse lookahead token after shifting the error
    //    token.  */
    return LABEL_YYERRLAB1;
}

// /*---------------------------------------------------.
// | yyerrorlab -- error raised explicitly by YYERROR.  |
// `---------------------------------------------------*/
fn label_yyerrorlab(yyctx: *yypareser_context_t) usize {
    // /* Pacify compilers when the user code never invokes YYERROR and the
    //    label yyerrorlab therefore never appears in user code.  */
    yyctx.yynerrs ++ 1;

    // /* Do not reclaim the symbols of the rule whose action triggered
    //    this YYERROR.  */
    YYPOPSTACK(yyctx.yylen);
    yyctx.yylen = 0;
    YY_STACK_PRINT(yyctx.yyss, yyctx.yyssp);
    yyctx.yystate = yyctx.yyssp.*;
    return LABEL_YYERRLAB1;
}

// /*-------------------------------------------------------------.
// | yyerrlab1 -- common code for both syntax error and YYERROR.  |
// `-------------------------------------------------------------*/
fn label_yyerrlab1(yyctx: *yypareser_context_t) usize {
    yyctx.yyerrstatus = 3; // /* Each real token shifted decrements this.  */

    // /* Pop stack until we find a state that shifts the error token.  */
    while (true) {
        yyctx.yyn = yypact[yyctx.yystate];
        if (!yypact_value_is_default(yyctx.yyn)) {
            yyctx.yyn += YYSYMBOL_YYerror;
            if (0 <= yyctx.yyn and yyctx.yyn <= YYLAST and yycheck[yyctx.yyn] == YYSYMBOL_YYerror) {
                yyctx.yyn = yytable[yyctx.yyn];
                if (0 < yyctx.yyn)
                    break;
            }
        }

        // /* Pop the current state because it cannot handle the error token.  */
        if (yyctx.yyssp == yyctx.yyss) {
            return LABEL_YYABORTLAB;
        }

        yydestruct("Error: popping", YY_ACCESSING_SYMBOL(yyctx.yystate), yyctx.yyvsp, yyscan_t, result);
        YYPOPSTACK(1);
        yyctx.yystate = yyctx.yyssp.*;
        YY_STACK_PRINT(yyctx.yyss, yyctx.yyssp);
    }

    // YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
    yyctx.yyvsp += 1;
    yyctx.yyvsp = yyctx.yylval;
    // YY_IGNORE_MAYBE_UNINITIALIZED_END

    // /* Shift the error token.  */
    YY_SYMBOL_PRINT("Shifting", YY_ACCESSING_SYMBOL(yyctx.yyn), yyctx.yyvsp, yyctx.yylsp);

    yyctx.yystate = yyctx.yyn;
    return LABEL_YYNEWSTATE;
}

// /*-------------------------------------.
// | yyacceptlab -- YYACCEPT comes here.  |
// `-------------------------------------*/
fn label_yyacceptlab(yyctx: *yypareser_context_t) usize {
    yyctx.yyresult = 0;
    return LABEL_YYRETURNLAB;
}

// /*-----------------------------------.
// | yyabortlab -- YYABORT comes here.  |
// `-----------------------------------*/
fn label_yyabortlab(yyctx: *yypareser_context_t) usize {
    yyctx.yyresult = 1;
    return LABEL_YYRETURNLAB;
}

// /*-----------------------------------------------------------.
// | yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
// `-----------------------------------------------------------*/
fn label_yyexhaustedlab(yyctx: *yypareser_context_t) usize {
    yyerror(yyscan_t, result, YY_("memory exhausted"));
    yyctx.yyresult = 2;
    return LABEL_YYRETURNLAB;
}

// /*----------------------------------------------------------.
// | yyreturnlab -- parsing is finished, clean up and return.  |
// `----------------------------------------------------------*/
fn label_yyreturnlab(yyctx: *yypareser_context_t) usize {
    if (yyctx.yychar != TOK_YYEMPTY) {
        // /* Make sure we have latest lookahead translation.  See comments at
        //   user semantic actions for why this is necessary.  */
        yyctx.yytoken = YYTRANSLATE(yyctx.yychar);
        yydestruct("Cleanup: discarding lookahead", yyctx.yytoken, &yyctx.yylval, yyscan_t, result);
    }
    // /* Do not reclaim the symbols of the rule whose action triggered
    //    this YYABORT or YYACCEPT.  */
    YYPOPSTACK(yyctx.yylen);
    YY_STACK_PRINT(yyctx.yyss, yyctx.yyssp);
    while (yyctx.yyssp != yyctx.yyss) {
        yydestruct("Cleanup: popping", YY_ACCESSING_SYMBOL(yyctx.yyssp.*), yyctx.yyvsp, yyscan_t, result);
        YYPOPSTACK(1);
    }
    return LABEL_YYPUSHRETURN;
}

// /*----------.
// | yyparse.  |
// `----------*/

pub fn yyparse(scanner: yyscan_t, res: *result) c_int {
    // replace all local variables with yyps, so later when access should use yyps
    var yyctx = yyparse_context_t{};
    yyctx.yyss = yyctx.yyssa.ptr;
    yyctx.yyssp = yyctx.yyss;
    yyctx.yyvs = yyctx.yyvsa.ptr;
    yyctx.yyvsp = yyctx.yyvs;
    yyctx.yymsg = yyctx.yymsgbuf;

    if (yydebug) {
        std.debug.print("Starting parse\n");
    }

    yyctx.yychar = TOK_YYEMPTY; // /* Cause a token to be read.  */

    // goto yysetstate;
    var loop_control: usize = LABEL_YYSETSTATE;

    while (true) {
        switch (loop_control) {
            LABEL_YYNEWSTATE => {
                loop_control = label_yynewstate(&yyctx);
            },

            LABEL_YYSETSTATE => {
                loop_control = label_yysetstate(&yyctx);
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
                loop_control = label_yyread_pushed_token(&yyctx);
            },

            LABEL_YYERRLAB1 => {
                loop_control = label_yyerrlab1(&yyctx);
            },

            LABEL_YYERRLAB => {
                loop_control = label_yyerrlab(&yyctx);
            },

            LABEL_YYREDUCE => {
                loop_control = label_yyreduce(&yyctx);
            },

            LABEL_YYERRORLAB => {
                loop_control = label_yyerrorlab(&yyctx);
            },

            LABEL_YYRETURNLAB => {
                loop_control = label_yyreturnlab(&yyctx);
            },

            else => {},
        }
    }

    // /*-------------------------.
    // | yypushreturn -- return.  |
    // `-------------------------*/
    if (yyoverflow) {
        if (yyctx.yyss != yyctx.yyssa)
            YYSTACK_FREE(yyctx.yyss);
    }
    if (yyctx.yymsg != yyctx.yymsgbuf)
        YYSTACK_FREE(yyctx.yymsg);
    return yyctx.yyresult;
}

// Epilogue (C code).
// #include "scan.h"

// result
// parse (void)
// {
//   yyscan_t scanner;
//   yylex_init (&scanner);
//   result res = {1, 0, 0};
//   yyparse (scanner, &res);
//   yylex_destroy (scanner);
//   return res;
// }

// result
// parse_string (const char *str)
// {
//   yyscan_t scanner;
//   yylex_init (&scanner);
//   YY_BUFFER_STATE buf = yy_scan_string (str ? str : "", scanner);
//   result res = {0, 0, 0};
//   yyparse (scanner, &res);
//   yy_delete_buffer (buf, scanner);
//   yylex_destroy (scanner);
//   return res;
// }

// void
// yyerror (yyscan_t scanner, result *res,
//          const char *msg, ...)
// {
//   (void) scanner;
//   va_list args;
//   va_start (args, msg);
//   vfprintf (stderr, msg, args);
//   va_end (args);
//   fputc ('\n', stderr);
//   res->nerrs += 1;
// }

// int
// main (void)
// {
//   // Possibly enable parser runtime debugging.
//   yydebug = !!getenv ("YYDEBUG");
//   result res = parse ();
//   // Exit on failure if there were errors.
//   return !!res.nerrs;
// }