#                                                             -*- C -*-

# GLR skeleton for Bison

# Copyright (C) 2002-2015, 2018-2021 Free Software Foundation, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


# If we are loaded by glr.cc, do not override c++.m4 definitions by
# those of c.m4.
m4_if(b4_skeleton, ["zig-glr.m4"],
      [m4_include(b4_skeletonsdir/[c.m4])])


## ---------------- ##
## Default values.  ##
## ---------------- ##

# Stack parameters.
m4_define_default([b4_stack_depth_max], [10000])
m4_define_default([b4_stack_depth_init],  [200])

# Included header.
b4_percent_define_default([[api.header.include]],
                          [["@basename(]b4_spec_header_file[@)"]])

## ------------------------ ##
## Pure/impure interfaces.  ##
## ------------------------ ##

b4_define_flag_if([pure])
# If glr.cc is including this file and thus has already set b4_pure_flag,
# do not change the value of b4_pure_flag, and do not record a use of api.pure.
m4_ifndef([b4_pure_flag],
[b4_percent_define_default([[api.pure]], [[true]])
 m4_define([b4_pure_flag],
           [b4_percent_define_flag_if([[api.pure]], [[1]], [[1]])])])

# b4_yyerror_args
# ---------------
# Optional effective arguments passed to yyerror: user args plus yylloc, and
# a trailing comma.
m4_define([b4_yyerror_args],
[b4_pure_if([b4_locations_if([yylocp, ])])dnl
m4_ifset([b4_parse_param], [b4_args(b4_parse_param), ])])


m4_define([b4_yyerror_zig_args],
[b4_pure_if([b4_locations_if([yylocp, ])])dnl
m4_ifset([b4_parse_param], [b4_zig_args(b4_parse_param), ])])


# b4_lyyerror_args
# ----------------
# Same as above, but on the lookahead, hence &yylloc instead of yylocp.
# m4_ifset([b4_parse_param], [b4_args(b4_parse_param), ])])
m4_define([b4_lyyerror_args],
[b4_pure_if([b4_locations_if([&yystackp.yylloc, ])])dnl
])


# b4_pure_args
# ------------
# Same as b4_yyerror_args, but with a leading comma.
m4_define([b4_pure_args],
[b4_pure_if([b4_locations_if([, yylocp])])[]b4_user_args])


m4_define([b4_zig_pure_args],
[b4_pure_if([b4_locations_if([, yylocp])])[]b4_zig_user_args])


# b4_lpure_args
# -------------
# Same as above, but on the lookahead, hence &yylloc instead of yylocp.
m4_define([b4_lpure_args],
[b4_pure_if([b4_locations_if([, &yylloc])])[]b4_user_args])


m4_define([b4_zig_lpure_args],
[b4_pure_if([b4_locations_if([, &yystackp.yylloc])])[]b4_zig_user_args])


m4_define([b4_zig_lpure_args_yyctx],
[b4_pure_if([b4_locations_if([, &yyctx.yystackp.yylloc])])[]b4_zig_user_args_yyctx])


# b4_pure_formals
# ---------------
# Arguments passed to yyerror: user formals plus yylocp with leading comma.
m4_define([b4_pure_formals],
[b4_pure_if([b4_locations_if([, yylocp: *YYLTYPE])])[]b4_user_formals])


# b4_locuser_formals(LOC = yylocp)
# --------------------------------
# User formal arguments, possibly preceded by location argument.
m4_define([b4_locuser_formals],
[b4_locations_if([, m4_default([$1], [yylocp]): *YYLTYPE])[]b4_user_formals])


# b4_locuser_args(LOC = yylocp)
# -----------------------------
m4_define([b4_locuser_args],
[b4_locations_if([, m4_default([$1], [yylocp])])[]b4_user_args])


m4_define([b4_zig_locuser_args],
[b4_locations_if([, m4_default([$1], [yylocp])])[]b4_zig_user_args])



## ----------------- ##
## Semantic Values.  ##
## ----------------- ##


# b4_lhs_value(SYMBOL-NUM, [TYPE])
# --------------------------------
# See README.
m4_define([b4_lhs_value],
[b4_symbol_value([(*yyvalp)], [$1], [$2])])


# b4_rhs_data(RULE-LENGTH, POS)
# -----------------------------
# See README.
m4_define([b4_rhs_data],
[yyvsp@{yyfill(yyvsp, &yylow, b4_subtract([$2], [$1]), yynormal)@}.yystate])


# b4_rhs_value(RULE-LENGTH, POS, SYMBOL-NUM, [TYPE])
# --------------------------------------------------
# Expansion of $$ or $<TYPE>$, for symbol SYMBOL-NUM.
m4_define([b4_rhs_value],
[b4_symbol_value([b4_rhs_data([$1], [$2]).yysemantics.yyval], [$3], [$4])])



## ----------- ##
## Locations.  ##
## ----------- ##

# b4_lhs_location()
# -----------------
# Expansion of @$.
m4_define([b4_lhs_location],
[(*yylocp)])


# b4_rhs_location(RULE-LENGTH, NUM)
# ---------------------------------
# Expansion of @NUM, where the current rule has RULE-LENGTH symbols
# on RHS.
m4_define([b4_rhs_location],
[(b4_rhs_data([$1], [$2]).yyloc)])


# b4_call_merger(MERGER-NUM, MERGER-NAME, SYMBOL-SUM)
# ---------------------------------------------------
m4_define([b4_call_merger],
[b4_case([$1],
         [    b4_symbol_if([$3], [has_type],
                           [yy0.b4_symbol($3, slot) = $2 (*yy0, *yy1);],
                           [*yy0 = $2 (*yy0, *yy1);])])])


## -------------- ##
## Declarations.  ##
## -------------- ##

# b4_shared_declarations
# ----------------------
# Declaration that might either go into the header (if --header)
# or open coded in the parser body.  glr.cc has its own definition.
m4_if(b4_skeleton, ["zig-glr.m4"],
[m4_define([b4_shared_declarations],
[b4_declare_yydebug[
]b4_token_enums[
]b4_declare_yylstype[
]b4_percent_code_get([[provides]])[]dnl
])
])

## -------------- ##
## Output files.  ##
## -------------- ##

b4_percent_define_use([api.location.type])
b4_percent_define_use([parse.trace])
b4_percent_defnie_use([api.header.include])
m4_pushdef([b4_percent_code_bison_qualifiers(requires)], [0])


# Unfortunately the order of generation between the header and the
# implementation file matters (for glr.c) because of the current
# implementation of api.value.type=union.  In that case we still use a
# union for YYSTYPE, but we generate the contents of this union when
# setting up YYSTYPE.  This is needed for other aspects, such as
# defining yy_symbol_value_print, since we need to now the name of the
# members of this union.
#
# To avoid this issue, just generate the header before the
# implementation file.  But we should also make them more independent.

# ----------------- #
# The header file.  #
# ----------------- #

# glr.cc produces its own header.
b4_glr_cc_if([],
[b4_header_if(
[b4_output_begin([b4_spec_header_file])
b4_copyright([Skeleton interface for Bison GLR parsers in C],
             [2002-2015, 2018-2021])[
]b4_cpp_guard_open([b4_spec_mapped_header_file])[
]b4_shared_declarations[
]b4_cpp_guard_close([b4_spec_mapped_header_file])[
]b4_output_end[
]])])


# ------------------------- #
# The implementation file.  #
# ------------------------- #

b4_output_begin([b4_parser_file_name])
b4_copyright([Skeleton implementation for Bison GLR parsers in C],
             [2002-2015, 2018-2021])[
// /* C GLR parser skeleton written by Paul Hilfinger.  */

]b4_disclaimer[
]b4_identification[

][
const std = @@import("std");
const Self = @@This();
const YYParser = @@This();
const YY_ASSERT = std.debug.assert;

/// utils for pointer operations.
inline fn cPtrDistance(comptime T: type, p1: [*c]T, p2: [*c]T) usize {
    return (@@intFromPtr(p2) - @@intFromPtr(p1)) / @@sizeOf(T);
}

inline fn ptrLessThan(comptime T: type, p1: [*]T, p2: [*]T) bool {
    return @@as([*c]T, @@ptrCast(p1)) < @@as([*c]T, @@ptrCast(p2));
}

inline fn ptrLessThanEql(comptime T: type, p1: [*]T, p2: [*]T) bool {
    return @@as([*c]T, @@ptrCast(p1)) <= @@as([*c]T, @@ptrCast(p2));
}

inline fn ptrWithOffset(comptime T: type, p: [*]T, offset: isize) *T {
    return &(@@as(
        [*]T,
        @@ptrFromInt(@@as(usize, @@intCast(@@as(isize, @@intCast(@@intFromPtr(p))) + offset * @@sizeOf(T)))),
    )[0]);
}
]b4_percent_code_get([[top]])[
]b4_user_pre_prologue[
]b4_cast_define[
]b4_null_define[

]b4_header_if([],
              [b4_shared_declarations])[

]b4_glr_cc_if([b4_glr_cc_setup],
              [b4_declare_symbol_enum])[

// /* Default (constant) value used for initialization for null
//    right-hand sides.  Unlike the standard yacc.c template, here we set
//    the default value of $$ to a zeroed-out value.  Since the default
//    value is undefined, this behavior is technically correct.  */
const yyval_default: YYSTYPE = undefined;]b4_locations_if([[
const yyloc_default: YYLTYPE = YYLTYPE][]b4_yyloc_default;])[

]b4_user_post_prologue[
]b4_percent_code_get[]dnl
[
// /* YYFINAL -- State number of the termination state.  */
const YYFINAL = ]b4_final_state_number[;

// /* YYLAST -- Last index in YYTABLE.  */
const YYLAST = ]b4_last[;

// /* YYNTOKENS -- Number of terminals.  */
const YYNTOKENS = ]b4_tokens_number[;

// /* YYNNTS -- Number of nonterminals.  */
const YYNNTS = ]b4_nterms_number[;

// /* YYNRULES -- Number of rules.  */
const YYNRULES = ]b4_rules_number[;

// /* YYNSTATES -- Number of states.  */
const YYNSTATES = ]b4_states_number[;

// /* YYMAXRHS -- Maximum number of symbols on right-hand side of rule.  */
const YYMAXRHS = ]b4_r2_max[;

// /* YYMAXLEFT -- Maximum number of symbols to the left of a handle
//    accessed by $0, $-1, etc., in any rule.  */
const YYMAXLEFT = ]b4_max_left_semantic_context[;

// /* YYMAXUTOK -- Last valid token kind.  */
const YYMAXUTOK = ]b4_code_max[;

// /* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex, with out-of-bounds checking.  */
]b4_api_token_raw_if(dnl
[[inline fn YYTRANSLATE(YYX: anytype) yysymbol_kind_t {
  return @@enumFromInt(@@intCast(YYX));
}
]],
[[inline fn YYTRANSLATE(YYX: anytype) yysymbol_kind_t {
  return if (0 <= YYX and YYX <= YYMAXUTOK)
    @@enumFromInt(@@as(i32, @@intCast(yytranslate[YYX])))
  else
    yysymbol_kind_t.YYSYMBOL_YYUNDEF;
}

// /* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex.  */
const][ yytranslate = [_]isize
{
  ]b4_translate[
};]])[

// /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
const][ yyrline = [_]isize
{
  ]b4_rline[
};

const YYPACT_NINF = ]b4_pact_ninf[;
const YYTABLE_NINF = ]b4_table_ninf[;

]b4_parser_tables_define[

// /* YYDPREC[RULE-NUM] -- Dynamic precedence of rule #RULE-NUM (0 if none).  */
const][ yydprec = [_]isize
{
  ]b4_dprec[
};

// /* YYMERGER[RULE-NUM] -- Index of merging function for rule #RULE-NUM.  */
const][ yymerger = [_]isize
{
  ]b4_merger[
};

// /* YYIMMEDIATE[RULE-NUM] -- True iff rule #RULE-NUM is not to be deferred, as
//    in the case of predicates.  */
const yyimmediate = [_]isize
{
  ]b4_immediate[
};

// /* YYCONFLP[YYPACT[STATE-NUM]] -- Pointer into YYCONFL of start of
//    list of conflicting reductions corresponding to action entry for
//    state STATE-NUM in yytable.  0 means no conflicts.  The list in
//    yyconfl is terminated by a rule number of 0.  */
const][ yyconflp = [_]isize
{
  ]b4_conflict_list_heads[
};

// /* YYCONFL[I] -- lists of conflicting rule numbers, each terminated by
//    0, pointed into by YYCONFLP.  */
]dnl Do not use b4_int_type_for here, since there are places where
dnl pointers onto yyconfl are taken, whose type is "short*".
dnl We probably ought to introduce a type for confl.
[const yyconfl = [_]isize
{
  ]b4_conflicting_rules[
};

]b4_locations_if([[
]b4_yylloc_default_define[
inline fn YYRHSLOC(Rhs: anytype, K: anytype) YYLTYPE {
  return (Rhs)[@@intCast(K)].yystate.yyloc;
}
]])[

]b4_pure_if(
[
// #define yynerrs (yystackp->yyerrcnt)
// #define yychar (yystackp->yyrawchar)
// #define yylval (yystackp->yyval)
// #define yylloc (yystackp->yyloc)
m4_if(b4_prefix[], [yy], [],
[#define b4_prefix[]nerrs yynerrs
#define b4_prefix[]char yychar
#define b4_prefix[]lval yylval
#define b4_prefix[]lloc yylloc])],
[YYSTYPE yylval;]b4_locations_if([[
YYLTYPE yylloc;]])[

int yynerrs;
int yychar;])[

const YYENOMEM = -2;

const YYRESULTTAG = enum(i32) {yyok, yyaccept, yyabort, yyerr, yynomem };

inline fn YYCHK(YYE: anytype) ?YYRESULTTAG {
  const yychk_flag = @@as(YYRESULTTAG, @@enumFromInt(YYE));
  if (yychk_flag != YYRESULTTAG.yyok) {
    return yychk_flag;
  }
  return null;
}

// /* YYINITDEPTH -- initial size of the parser's stacks.  */
const YYINITDEPTH = ]b4_stack_depth_init[;

// /* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
//    if the built-in stack extension method is used).
//
//    Do not make this value too large; the results are undefined if
//    SIZE_MAX < YYMAXDEPTH * sizeof (GLRStackItem)
//    evaluated with infinite-precision integer arithmetic.  */

const YYMAXDEPTH = ]b4_stack_depth_max[;

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

inline fn YY_RESERVE_GLRSTACK(yystack: anytype) !void {
  if (yystack.yyspaceLeft < YYHEADROOM) {
    try yyMemoryExhausted(yystack);
  }
}

const YYSIZE_MAXIMUM = std.math.maxInt(usize);
const YYSTACK_ALLOC_MAXIMUM = YYSIZE_MAXIMUM;

// /** State numbers. */
const yy_state_t = usize;

// /** Rule numbers. */
const yyRuleNum = usize;

// /** Item references. */
const yyItemNum = usize;

const YYPTRDIFF_T = isize;

const yyGLRState = struct
{
  pub const YYSemantics = extern union {
    // /** First in a chain of alternative reductions producing the
    //  *  nonterminal corresponding to this state, threaded through
    //  *  yynext.  */
    yyfirstVal: *yySemanticOption,
    // /** Semantic value for this state.  */
    yyval: *YYSTYPE,
  };

  // /** Type tag: always true.  */
  yyisState: bool = true,
  // /** Type tag for yysemantics.  If true, yyval applies, otherwise
  //  *  yyfirstVal applies.  */
  yyresolved: bool = false,
  // /** Number of corresponding LALR(1) machine state.  */
  yylrState: yy_state_t = 0,
  // /** Preceding state in this stack */
  yypred: ?*yyGLRState = null,
  // /** Source position of the last token produced by my symbol */
  yyposn: YYPTRDIFF_T = 0,
  yysemantics: YYSemantics = undefined,]b4_locations_if([[
  // /** Source location for this state.  */
  yyloc: YYLTYPE = undefined,]])[
};

const yyGLRStateSet = struct
{
  yystates: [*]*yyGLRState = undefined,
  // /** During nondeterministic operation, yylookaheadNeeds tracks which
  //  *  stacks have actually needed the current lookahead.  During deterministic
  //  *  operation, yylookaheadNeeds[0] is not maintained since it would merely
  //  *  duplicate yychar != ]b4_symbol(empty, id)[.  */
  yylookaheadNeeds: *bool = undefined,
  yysize: YYPTRDIFF_T = 0,
  yycapacity: YYPTRDIFF_T = 0,
};

const yySemanticOption = struct
{
  // /** Type tag: always false.  */
  yyisState: bool = false,
  // /** Rule number for this reduction */
  yyrule: yyRuleNum = 0,
  // /** The last RHS state in the list of states to be reduced.  */
  yystate: *yyGLRState = undefined,
  // /** The lookahead for this reduction.  */
  yyrawchar: u8 = 0,
  yyval: YYSTYPE = undefined,]b4_locations_if([[
  yyloc: YYLTYPE = undefined,]])[
  // /** Next sibling in chain of options.  To facilitate merging,
  //  *  options are chained in decreasing order by address.  */
  yynext: ?*yySemanticOption = null,
};

// /** Type of the items in the GLR stack.  The yyisState field
//  *  indicates which item of the union is valid.  */
const yyGLRStackItem = extern union {
  yystate: *yyGLRState,
  yyoption: *yySemanticOption,
};

const yyGLRStack = struct {
  yyerrState: isize,
]b4_locations_if([[  // /* To compute the location of the error token.  */
  yyerror_range: [3]yyGLRStackItem = undefined,]])[
]b4_pure_if(
[
  yyerrcnt: isize = 0,
  yyrawchar: u8 = 0,
  yyval: YYSTYPE = undefined,]b4_locations_if([[
  yyloc: YYLTYPE = undefined,]])[
])[
  // yyexception_buffer: YYJMP_BUF,
  yyitems: [*]yyGLRStackItem,
  yynextFree: *yyGLRStackItem,
  yyspaceLeft: YYPTRDIFF_T,
  yysplitPoint: *yyGLRState,
  yylastDeleted: *yyGLRState,
  yytops: yyGLRStateSet,
};

inline fn yyerror (loc: *YYLTYPE, msg: []const u8) void {
  std.debug.print("{s}: {s}\n", .{loc.*, msg});
}

const YY_NULLPTR = "";

fn yyFail (yystackp: *yyGLRStack]b4_pure_formals[, yymsg: []const u8) usize {
  _ = yystackp;
  _ = scanner;
  if (yymsg != YY_NULLPTR) {
    yyerror (]b4_yyerror_args[yymsg);
  }
  // TODO: this is a long jump
  return 0;
}

fn yyMemoryExhausted (yystackp: *yyGLRStack) void {
  _ = yystackp;
  // YYLONGJMP (yystackp->yyexception_buffer, 2);
  // TODO: another long jump
  return 0;
}

// /** Accessing symbol of state YYSTATE.  */
inline fn yy_accessing_symbol (yystate: yy_state_t) yysymbol_kind_t {
  return @@as(yysymbol_kind_t, @@enumFromInt(yystos[yystate]));
}

// /* The user-facing name of the symbol whose (internal) number is
//    YYSYMBOL.  No bounds checking.  */
// static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

]b4_parse_error_bmatch([simple\|verbose],
[[// /* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
//    First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
const yytname = [_][]const u8 {
  ]b4_tname[
};

fn yysymbol_name (yysymbol: yysymbol_kind_t) []const u8{
  return yytname[@@intFromEnum(yysymbol)];
}]],
[[fn yysymbol_name (yysymbol: yysymbol_kind_t) []const u8{
  const yy_sname = [_][]const u8
  {
  ]b4_symbol_names[
  };]b4_has_translations_if([[
  /* YYTRANSLATABLE[SYMBOL-NUM] -- Whether YY_SNAME[SYMBOL-NUM] is
     internationalizable.  */
  static ]b4_int_type_for([b4_translatable])[ yytranslatable[] =
  {
  ]b4_translatable[
  };
  return (yysymbol < YYNTOKENS && yytranslatable[@@intFromEnum(yysymbol)]
          ? _(yy_sname[@@intFromEnum(yysymbol)])
          : yy_sname[@@intFromEnum(yysymbol)]);]], [[
  return yy_sname[@@intFromEnum(yysymbol)];]])[
}]])[

// /** Left-hand-side symbol for rule #YYRULE.  */
inline fn yylhsNonterm (yyrule: yyRuleNum) yysymbol_kind_t {
  return @@enumFromInt(yyr1[@@intCast(yyrule)]);
}

]b4_yylocation_print_define[

]b4_yy_symbol_print_define[

fn YY_SYMBOL_PRINT(title: []const u8, kind: anytype, value: anytype, location: YYLTYPE) void {
  std.debug.print("{s}", .{title});
  yy_symbol_print(std.io.getStdErr(), kind, value]b4_locuser_args(location)[);
  std.debug.print("\n", .{});
}

// static inline void
// yy_reduce_print (yybool yynormal, yyGLRStackItem* yyvsp, YYPTRDIFF_T yyk,
//                  yyRuleNum yyrule]b4_user_formals[);

]b4_parse_error_case(
         [simple],
[[]],
[[
]b4_parse_error_bmatch(
           [detailed\|verbose],
[[// /* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
//    YYDEST.  */
fn yystpcpy (yydest: [*]u8, yysrc: [*]u8) [*]u8
{
  var yyd = yydest;
  var yys = yysrc;
  while (yys[0] != 0) {
      yyd[0] = yys[0];
      yyd += 1;
      yys += 1;
  }
  return yyd - 1;
}
]])[

]b4_parse_error_case(
         [verbose],
[[#ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
#endif
]])])[

// /** Fill in YYVSP[YYLOW1 .. YYLOW0-1] from the chain of states starting
//  *  at YYVSP[YYLOW0].yystate.yypred.  Leaves YYVSP[YYLOW1].yystate.yypred
//  *  containing the pointer to the next state in the chain.  */
fn yyfillin (yyvsp: *yyGLRStackItem, yylow0: usize, yylow1: usize) void {
  var i: usize = 0;
  var s: *yyGLRState = yyvsp[yylow0].yystate.yypred;
  while (i >= yylow1): (i -= 1) {
    if (yydebug) {
      yyvsp[i].yystate.yylrState = s.yylrState;
    }
    yyvsp[i].yystate.yyresolved = s.yyresolved;
    if (s.yyresolved) {
      yyvsp[i].yystate.yysemantics.yyval = s.yysemantics.yyval;
    } else {
      // /* The effect of using yyval or yyloc (in an immediate rule) is
      //  * undefined.  */
      yyvsp[i].yystate.yysemantics.yyfirstVal = YY_NULLPTR;
    }]b4_locations_if([[
      yyvsp[i].yystate.yyloc = s.yyloc;]])[
      yyvsp[i].yystate.yypred = s.yypred;
      s = yyvsp[i].yystate.yypred;
    }
}

]
m4_define([b4_yygetToken_call],
           [[yygetToken (&yystackp.yyrawchar][]b4_pure_if([, yystackp])[]b4_zig_user_args[)]])
m4_define([b4_yygetToken_call_yyctx],
           [[yygetToken (&yyctx.yystackp.yyrawchar][]b4_pure_if([, yyctx.yystackp])[]b4_zig_user_args_yyctx[)]])
[
// /** If yychar is empty, fetch the next token.  */
inline fn yygetToken (yycharp: *u8][]b4_pure_if([, yystackp: *yyGLRStack])[]b4_user_formals[) yysymbol_kind_t {
  var yytoken: yysymbol_kind_t = undefined;
][  if (yycharp.* == yytoken_kind_t.]b4_symbol(empty, id)[)
    {
      if (yydebug) {
        std.debug.print("Reading a token\n", .{});
      }
      yycharp.* = scanner.yylex(&yystackp.yylval, &yystackp.yylloc);
      // yycharp.* = scanner.]b4_yylex[;
    }
  if (yycharp.* <= yytoken_kind_t.]b4_symbol(eof, [id])[)
    {
      yycharp.* = yytoken_kind_t.]b4_symbol(eof, [id])[;
      yytoken = yysymbol_kind_t.]b4_symbol_prefix[YYEOF;
      if (yydebug) {
        std.debug.print("Now at end of input.\n", .{});
      }
    }
  else
    {
      yytoken = YYTRANSLATE (yycharp.*);
      YY_SYMBOL_PRINT("Next token is", yytoken, &yystackp.yylval, &yystackp.yylloc);
    }
  return yytoken;
}

// /* Do nothing if YYNORMAL or if *YYLOW <= YYLOW1.  Otherwise, fill in
//  * YYVSP[YYLOW1 .. *YYLOW-1] as in yyfillin and set *YYLOW = YYLOW1.
//  * For convenience, always return YYLOW1.  */
inline fn yyfill (yyvsp: *yyGLRStackItem, yylow_: *usize, yylow1: usize,  yynormal: bool) usize {
  if (!yynormal and yylow1 < yylow_.*)
    {
      yyfillin (yyvsp, yylow_.*, yylow1);
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
fn YYERROR(yystackp: *yyGLRStack) YYRESULTTAG {
  yyerrok(yystackp);
  return YYRESULTTAG.yyerr;
}

// YYRECOVERING
inline fn YYRECOVERING(yystackp: *yyGLRStack) bool {
  return yystackp.yyerrState != 0;
}

// yyclearin
inline fn yyclearin(yychar_: *u8) void {
  yychar_.* = yytoken_kind_t.]b4_symbol(empty, id)[;
  yyclearin (yychar_.*);
}

// # define YYFILL(N) yyfill (yyvsp, &yylow, (N), yynormal)
// inline fn YYFILL(N: usize) usize {
//   return yyfill(yyvsp, yylow_, N, yynormal);
// }

// # define YYBACKUP(Token, Value)                                              \
//   return yyerror (]b4_yyerror_args[YY_("syntax error: cannot back up")),     \
//          yyerrok, yyerr

// /** Perform user action for rule number YYN, with RHS length YYRHSLEN,
//  *  and top stack item YYVSP.  YYLVALP points to place to put semantic
//  *  value ($$), and yylocp points to place for location information
//  *  (@@$).  Returns yyok for normal return, yyaccept for YYACCEPT,
//  *  yyerr for YYERROR, yyabort for YYABORT, yynomem for YYNOMEM.  */
fn yyuserAction (yyctx: yyparse_context_t, yyrule: yyRuleNum, yyrhslen: usize, yyvsp: *yyGLRStackItem,
              yystackp: *yyGLRStack, yyk: YYPTRDIFF_T,
              yyvalp: *YYSTYPE]b4_locuser_formals[)
YYRESULTTAG {
  const yynormal: bool = yystackp.yysplitPoint == YY_NULLPTR;
  var yylow: usize = 1;
]dnl
[
  if (yyrhslen == 0) {
    yyvalp.* = yyval_default;
  } else {
    yyvalp.* = yyvsp[yyfill(yyvsp, &yylow, 1 - yyrhslen, yynormal)].yystate.yysemantics.yyval;
  }]b4_locations_if([[
  // /* Default location. */
  YYLLOC_DEFAULT ((yylocp.*), (yyvsp - yyrhslen), yyrhslen);
  yystackp.yyerror_range[1].yystate.yyloc = yylocp.*;]])[
  // /* If yyk == -1, we are running a deferred action on a temporary
  //    stack.  In that case, YY_REDUCE_PRINT must not play with YYFILL,
  //    so pretend the stack is "normal". */
  if (yydebug) {
    yy_reduce_print(yynormal or yyk == -1, yyvsp, yyk, yyrule]b4_zig_user_args[);
  }
  switch (yyrule)
    {
]b4_user_actions[
      else => {},
    }][
  YY_SYMBOL_PRINT ("-> $$ =", yylhsNonterm (yyrule), yyvalp, yylocp);
  return YYRESULTTAG.yyok;
}

fn yyuserMerge (yyn: usize, yy0: *YYSTYPE, yy1: *YYSTYPE) void {
  switch (yyn)
    {
]b4_mergers[
      else => {},
    }
}

//                               /* Bison grammar-table manipulation.  */

]b4_yydestruct_define[

// /** Number of symbols composing the right hand side of rule #RULE.  */
inline fn yyrhsLength (yyrule: yyRuleNum) isize {
  return yyr2[yyrule];
}

fn yydestroyGLRState (yymsg: []const u8, yys: *yyGLRState]b4_user_formals[)
void {
  if (yys.yyresolved) {
    yydestruct (yymsg, yy_accessing_symbol (yys.yylrState),
                &yys.yysemantics.yyval]b4_locuser_args([&yys.yyloc])[);
  } else
    {
      if (yydebug)
        {
          if (yys.yysemantics.yyfirstVal) {
            std.debug.print("{s} unresolved", .{yymsg});
          } else {
            std.debug.print("{s} incomplete", .{yymsg});
          }
          YY_SYMBOL_PRINT ("", yy_accessing_symbol (yys.yylrState), YY_NULLPTR, &yys.yyloc);
        }

      if (yys.yysemantics.yyfirstVal)
        {
          const yyoption: *yySemanticOption = yys.yysemantics.yyfirstVal;
          const yyrh: *yyGLRState = yyoption.yystate;
          var yyn: usize = yyrhsLength (yyoption.yyrule);
          while (yyn > 0) {
            yydestroyGLRState (yymsg, yyrh]b4_zig_user_args[);
            yyrh = yyrh.yypred;
            yyn -= 1;
          }
        }
    }
}

inline fn yypact_value_is_default(yyn: anytype) bool {
  return ]b4_table_value_equals([[pact]], [[yyn]], [b4_pact_ninf], [YYPACT_NINF])[;
}

// /** True iff LR state YYSTATE has only a default reduction (regardless
//  *  of token).  */
inline fn yyisDefaultedState (yystate: yy_state_t) bool {
  return yypact_value_is_default (yypact[yystate]);
}

// /** The default reduction for YYSTATE, assuming it has one.  */
inline fn yydefaultAction (yystate: yy_state_t) yyRuleNum {
  return yydefact[yystate];
}

inline fn yytable_value_is_error(yyn: anytype) bool {
  { _ = yyn; }
  return ]b4_table_value_equals([[table]], [[yyn]], [b4_table_ninf], [YYTABLE_NINF])[;
}

// /** The action to take in YYSTATE on seeing YYTOKEN.
//  *  Result R means
//  *    R < 0:  Reduce on rule -R.
//  *    R = 0:  Error.
//  *    R > 0:  Shift to state R.
//  *  Set *YYCONFLICTS to a pointer into yyconfl to a 0-terminated list
//  *  of conflicting reductions.
//  */
inline fn yygetLRActions (yystate: yy_state_t, yytoken: yysymbol_kind_t, yyconflicts: [*]*isize) isize {
  const yyindex: isize = yypact[yystate] + yytoken;
  if (yytoken == yysymbol_kind_t.]b4_symbol(error, kind)[)
    {
      // This is the error token.
      yyconflicts[0].* = yyconfl;
      return 0;
    }
  else if (yyisDefaultedState (yystate)
           or yyindex < 0 or YYLAST < yyindex or yycheck[yyindex] != yytoken)
    {
      yyconflicts[0].* = yyconfl;
      return -yydefact[yystate];
    }
  else if (! yytable_value_is_error (yytable[yyindex]))
    {
      yyconflicts[0].* = yyconfl + yyconflp[yyindex];
      return yytable[yyindex];
    }
  else
    {
      yyconflicts[0].* = yyconfl + yyconflp[yyindex];
      return 0;
    }
}

// /** Compute post-reduction state.
//  * \param yystate   the current state
//  * \param yysym     the nonterminal to push on the stack
//  */
inline fn yyLRgotoState (yystate: yy_state_t, yysym: yysymbol_kind_t)
yy_state_t {
  const yyr: isize = yypgoto[yysym - YYNTOKENS] + yystate;
  if (0 <= yyr and yyr <= YYLAST and yycheck[yyr] == yystate) {
    return yytable[yyr];
  } else {
    return yydefgoto[yysym - YYNTOKENS];
  }
}

inline fn yyisShiftAction (yyaction: isize) bool {
  return 0 < yyaction;
}

inline fn yyisErrorAction (yyaction: isize) bool {
  return yyaction == 0;
}

//                                                         /* GLRStates */

// /** Return a fresh GLRStackItem in YYSTACKP.  The item is an LR state
//  *  if YYISSTATE, and otherwise a semantic option.  Callers should call
//  *  YY_RESERVE_GLRSTACK afterwards to make sure there is sufficient
//  *  headroom.  */

inline fn yynewGLRStackItem (yystackp: *yyGLRStack, yyisState: bool)
*yyGLRStackItem {
  const yynewItem: *yyGLRStackItem = yystackp.yynextFree;
  yystackp.yyspaceLeft -= 1;
  yystackp.yynextFree += 1;
  yynewItem.yystate.yyisState = yyisState;
  return yynewItem;
}

// /** Add a new semantic action that will execute the action for rule
//  *  YYRULE on the semantic values in YYRHS to the list of
//  *  alternative actions for YYSTATE.  Assumes that YYRHS comes from
//  *  stack #YYK of *YYSTACKP. */
fn yyaddDeferredAction (yystackp: *yyGLRStack, yyk: YYPTRDIFF_T, yystate: *yyGLRState, yyrhs: *yyGLRState, yyrule: yyRuleNum) void {
  var yynewOption: *yySemanticOption =
    &yynewGLRStackItem (yystackp, false).yyoption;
  YY_ASSERT (!yynewOption.yyisState);
  yynewOption.yystate = yyrhs;
  yynewOption.yyrule = yyrule;
  if (yystackp.yytops.yylookaheadNeeds[yyk])
    {
      yynewOption.yyrawchar = yystackp.yyrawchar;
      yynewOption.yyval = yystackp.yylval;]b4_locations_if([
      yynewOption.yyloc = yystackp.yylloc;])[
    }
  else {
    yynewOption.yyrawchar = yytoken_kind_t.]b4_symbol(empty, id)[;
    }
  yynewOption.yynext = yystate.yysemantics.yyfirstVal;
  yystate.yysemantics.yyfirstVal = yynewOption;

  YY_RESERVE_GLRSTACK (yystackp);
}

//                                                     /* GLRStacks */

// /** Initialize YYSET to a singleton set containing an empty stack.  */
fn yyinitStateSet (allocator: std.mem.Allocator, yyset: *yyGLRStateSet) !void {
  yyset.yysize = 1;
  yyset.yycapacity = 16;
  yyset.yystates = try allocator.alloc(yyset.yycapacity * @@sizeOf(yyset.yystates[0]));
  errdefer allocator.free(yyset.yystates);

  // if (! yyset.yystates)
  //   return false;

  yyset.yystates[0] = YY_NULLPTR;
  yyset.yylookaheadNeeds = try allocator.alloc(yyset.yycapacity * @@sizeOf(yyset.yylookaheadNeeds[0]));

  // if (! yyset.yylookaheadNeeds)
  //  {
  //     YYFREE (yyset.yystates);
  //     return false;
  //  }

  @@memset(yyset.yylookaheadNeeds, 0);
}

fn yyfreeStateSet (allocator: std.mem.Allocator, yyset: *yyGLRStateSet) void {
  allocator.free(yyset.yystates);
  allocator.free(yyset.yylookaheadNeeds);
}

// /** Initialize *YYSTACKP to a single empty stack, with total maximum
//  *  capacity for all stacks of YYSIZE.  */
fn yyinitGLRStack (allocator: std.mem.Allocator, yystackp: *yyGLRStack, yysize: YYPTRDIFF_T) !bool {
  yystackp.yyerrState = 0;
  yystackp.yynerrs = 0;
  yystackp.yyspaceLeft = yysize;
  yystackp.yyitems = try allocator.alloc(yysize * @@sizeOf(yystackp.yynextFree[0]));

  // if (!yystackp.yyitems) {
  //   return false;
  // }

  yystackp.yynextFree = yystackp.yyitems;
  yystackp.yysplitPoint = YY_NULLPTR;
  yystackp.yylastDeleted = YY_NULLPTR;
  return yyinitStateSet (&yystackp.yytops);
}


// # define YYRELOC(YYFROMITEMS, YYTOITEMS, YYX, YYTYPE)                   \
//   &((YYTOITEMS)                                                         \
//     - ((YYFROMITEMS) - YY_REINTERPRET_CAST (yyGLRStackItem*, (YYX))))->YYTYPE

// /** If *YYSTACKP is expandable, extend it.  WARNING: Pointers into the
//     stack from outside should be considered invalid after this call.
//     We always expand when there are 1 or fewer items left AFTER an
//     allocation, so that we can avoid having external pointers exist
//     across an allocation.  */
fn yyexpandGLRStack (allocator: std.mem.Allocator, yystackp: *yyGLRStack) !void {
  var yynewItems: *yyGLRStackItem = undefined;
  var yyp0: *yyGLRStackItem = undefined;
  var yyp1: [*]*yyGLRStackItem = undefined;
  var yynewSize: YYPTRDIFF_T = 0;
  var yyn: YYPTRDIFF_T = 0;
  const yysize: YYPTRDIFF_T = yystackp.yynextFree - yystackp.yyitems;
  if (YYMAXDEPTH - YYHEADROOM < yysize) {
    yyMemoryExhausted (yystackp);
  }
  yynewSize = 2*yysize;
  if (YYMAXDEPTH < yynewSize) {
    yynewSize = YYMAXDEPTH;
  }
  yynewItems = try allocator.alloc(yynewSize * @@sizeOf(yynewItems[0]));
  // if (! yynewItems) {
  //   yyMemoryExhausted (yystackp);
  // }

  yyp0 = yystackp.yyitems;
  yyp1 = yynewItems;
  yyn = yysize;

  while (0 < yyn) {
      yyp1.* = yyp0.*;
      if (yyp0.*)
        {
          const yys0: *yyGLRState = &yyp0.yystate;
          var yys1: *yyGLRState = &yyp1.yystate;
          if (yys0.yypred != YY_NULLPTR) {
            yys1.yyperd = (yyp1 - yyp0 - yys0.yypred).yystate;
          }
          if (! yys0.yyresolved and yys0.yysemantics.yyfirstVal != YY_NULLPTR) {
            yys1.yysemantics.yyfirstVal =
              (yyp1 - yyp0 - yys0.yysemantics.yyfirstVal).yyoption;
          }
        }
      else
        {
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

fn yyfreeGLRStack (allocator: std.mem.Allocator, yystackp: *yyGLRStack) void {
  allocator.free(yystackp.yyitems);
  yyfreeStateSet (&yystackp.yytops);
}

// /** Assuming that YYS is a GLRState somewhere on *YYSTACKP, update the
//  *  splitpoint of *YYSTACKP, if needed, so that it is at least as deep as
//  *  YYS.  */
inline fn yyupdateSplit (yystackp: *yyGLRStack, yys: *yyGLRState) void {
  if (yystackp.yysplitPoint != YY_NULLPTR and yystackp.yysplitPoint > yys)
    yystackp.yysplitPoint = yys;
}

// /** Invalidate stack #YYK in *YYSTACKP.  */
inline fn yymarkStackDeleted (yystackp: *yyGLRStack, yyk: YYPTRDIFF_T) void {
  if (yystackp.yytops.yystates[yyk] != YY_NULLPTR)
    yystackp.yylastDeleted = yystackp.yytops.yystates[yyk];
  yystackp.yytops.yystates[yyk] = YY_NULLPTR;
}

// /** Undelete the last stack in *YYSTACKP that was marked as deleted.  Can
//     only be done once after a deletion, and only when all other stacks have
//     been deleted.  */
fn yyundeleteLastStack (yystackp: *yyGLRStack) void {
  if (yystackp.yylastDeleted == YY_NULLPTR or yystackp.yytops.yysize != 0)
    return;
  yystackp.yytops.yystates[0] = yystackp.yylastDeleted;
  yystackp.yytops.yysize = 1;
  std.debug.print("Restoring last deleted stack as stack #0.\n", .{});
  yystackp.yylastDeleted = YY_NULLPTR;
}

inline fn yyremoveDeletes (yystackp: *yyGLRStack) void {
  var yyi: YYPTRDIFF_T = 0;
  var yyj: YYPTRDIFF_T = 0;
  while (yyj < yystackp.yytops.yysize) {
      if (yystackp.yytops.yystates[yyi] == YY_NULLPTR)
        {
          if (yyi == yyj) {
            if (yydebug) {
              std.debug.print("Removing dead stacks.\n", .{});
            }
          }
          yystackp.yytops.yysize -= 1;
        }
      else
        {
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
              std.debug.print("Rename stack {d} -> {d}.\n", .{yyi, yyj});
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
inline fn yyglrShift (yystackp: *yyGLRStack, yyk: YYPTRDIFF_T, yylrState: yy_state_t, yyposn: YYPTRDIFF_T, yyvalp: *YYSTYPE]b4_locations_if([, yylocp: *YYLTYPE])[) void {
  var yynewState: *yyGLRState = &yynewGLRStackItem (yystackp, true).yystate;

  yynewState.yylrState = yylrState;
  yynewState.yyposn = yyposn;
  yynewState.yyresolved = true;
  yynewState.yypred = yystackp.yytops.yystates[yyk];
  yynewState.yysemantics.yyval = *yyvalp;]b4_locations_if([
  yynewState.yyloc = *yylocp;])[
  yystackp.yytops.yystates[yyk] = yynewState;

  YY_RESERVE_GLRSTACK (yystackp);
}

// /** Shift stack #YYK of *YYSTACKP, to a new state corresponding to LR
//  *  state YYLRSTATE, at input position YYPOSN, with the (unresolved)
//  *  semantic value of YYRHS under the action for YYRULE.  */
inline fn yyglrShiftDefer (yystackp: *yyGLRStack, yyk: YYPTRDIFF_T, yylrState: yy_state_t, yyposn: YYPTRDIFF_T, yyrhs: *yyGLRState, yyrule: yyRuleNum) void {
  var yynewState: *yyGLRState = &yynewGLRStackItem (yystackp, true).yystate;
  YY_ASSERT (yynewState.yyisState);

  yynewState.yylrState = yylrState;
  yynewState.yyposn = yyposn;
  yynewState.yyresolved = false;
  yynewState.yypred = yystackp.yytops.yystates[yyk];
  yynewState.yysemantics.yyfirstVal = YY_NULLPTR;
  yystackp.yytops.yystates[yyk] = yynewState;

  // /* Invokes YY_RESERVE_GLRSTACK.  */
  yyaddDeferredAction (yystackp, yyk, yynewState, yyrhs, yyrule);
}

// /*----------------------------------------------------------------------.
// | Report that stack #YYK of *YYSTACKP is going to be reduced by YYRULE. |
// `----------------------------------------------------------------------*/

inline fn yy_reduce_print (yynormal: bool, yyvsp: *yyGLRStackItem, yyk: YYPTRDIFF_T, yyrule: yyRuleNum]b4_user_formals[) void {
  const yynrhs: usize = yyrhsLength (yyrule);]b4_locations_if([
  var yylow: usize = 1;])[
  var yyi = 0;
  if (yydebug) {
    std.debug.print("Reducing stack {d} by rule {d} (line {d}):\n",
                .{ yyk, yyrule - 1, yyrline[yyrule] });
  }
  if (! yynormal) {
    yyfillin (yyvsp, 1, -yynrhs);
  }
  // /* The symbols being reduced.  */
  while (yyi < yynrhs) : (yyi += 1) {
      std.debug.print("   ${d} = ", .{yyi + 1});
      yy_symbol_print (std.io.getStdErr(),
                       yy_accessing_symbol (yyvsp[yyi - yynrhs + 1].yystate.yylrState),
                       &yyvsp[yyi - yynrhs + 1].yystate.yysemantics.yyval]b4_locations_if([,
                       &]b4_rhs_location(yynrhs, yyi + 1))[]dnl
                       b4_zig_user_args[);
      if (!yyvsp[yyi - yynrhs + 1].yystate.yyresolved) {
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
inline fn yydoAction (yyctx: *yyparse_context_t, yystackp: *yyGLRStack, yyk: YYPTRDIFF_T, yyrule: yyRuleNum,
            yyvalp: *YYSTYPE]b4_locuser_formals[) YYRESULTTAG {
  const yynrhs: usize = yyrhsLength (yyrule);

  if (yystackp.yysplitPoint == YY_NULLPTR)
    {
      // /* Standard special case: single stack.  */
      const yyrhs: *yyGLRStackItem
        = yystackp.yytops.yystates[yyk];
      YY_ASSERT (yyk == 0);
      yystackp.yynextFree -= yynrhs;
      yystackp.yyspaceLeft += yynrhs;
      yystackp.yytops.yystates[0] = & yystackp.yynextFree[-1].yystate;
      return yyuserAction (yyctx, yyrule, yynrhs, yyrhs, yystackp, yyk,
                           yyvalp]b4_zig_locuser_args[);
    }
  else
    {
      var yyrhsVals: yyGLRStackItem[YYMAXRHS + YYMAXLEFT + 1] = undefined;
      yyrhsVals[YYMAXRHS + YYMAXLEFT].yystate.yypred
        = yystackp.yytops.yystates[yyk];
      var yys: *yyGLRState =  yyrhsVals[YYMAXRHS + YYMAXLEFT].yystate.yypred;
      var yyi: isize = 0;]b4_locations_if([[
      if (yynrhs == 0)
        // /* Set default location.  */
        yyrhsVals[YYMAXRHS + YYMAXLEFT - 1].yystate.yyloc = yys.yyloc;]])[
      while(yyi < yynrhs): (yyi += 1) {
          yys = yys.yypred;
          YY_ASSERT (yys);
      }
      yyupdateSplit (yystackp, yys);
      yystackp.yytops.yystates[yyk] = yys;
      return yyuserAction (yyctx, yyrule, yynrhs, yyrhsVals + YYMAXRHS + YYMAXLEFT - 1,
                           yystackp, yyk, yyvalp]b4_zig_locuser_args[);
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
inline fn
yyglrReduce (yystackp: *yyGLRStack, yyk: YYPTRDIFF_T, yyrule: yyRuleNum,
             yyforceEval: bool]b4_user_formals[) YYRESULTTAG {
  const yyposn: YYPTRDIFF_T = yystackp.yytops.yystates[yyk].yyposn;

  if (yyforceEval || yystackp.yysplitPoint == YY_NULLPTR)
    {
      var yyval: YYSTYPE = undefined;]b4_locations_if([[
      var yyloc: YYLTYPE = undefined;]])[

      const yyflag: YYRESULTTAG = yydoAction (yystackp, yyk, yyrule, &yyval]b4_zig_locuser_args([&yyloc])[);
      if (yyflag == YYRESULTTAG.yyerr and yystackp.yysplitPoint != YY_NULLPTR) {
        if (yydebug) {
            std.debug.print("Parse on stack {d} rejected by rule {d} (line {d}).\n",
            .{yyk, yyrule - 1, yyrline[yyrule]});
        }
      }
      if (yyflag != YYRESULTTAG.yyok) {
        return yyflag;
      }
      yyglrShift (yystackp, yyk,
                  yyLRgotoState (yystackp.yytops.yystates[yyk].yylrState,
                                 yylhsNonterm (yyrule)),
                  yyposn, &yyval]b4_locations_if([, &yyloc])[);
    }
  else
    {
      var yyi: YYPTRDIFF_T = 0;
      var yyn: isize = yyrhsLength (yyrule);
      var yys: *yyGLRState = yystackp.yytops.yystates[yyk];
      const yys0: *yyGLRState = yystackp.yytops.yystates[yyk];
      var yynewLRState: yy_state_t = 0;

      while (0 < yyn): (yyn -= 1) {
          yys = yys.yypred;
          YY_ASSERT (yys);
      }
      yyupdateSplit (yystackp, yys);
      yynewLRState = yyLRgotoState (yys.yylrState, yylhsNonterm (yyrule));
      if (yydebug) {
        std.debug.print("Reduced stack %ld by rule {d} (line {d}); action deferred.  Now in state {d}.\n", .{yyk, yyrule - 1, yyrline[yyrule],yynewLRState});
      }

      yyi = 0;
      while (yyi < yystackp.yytops.yysize) :(yyi += 1) {
        if (yyi != yyk and yystackp.yytops.yystates[yyi] != YY_NULLPTR) {
            const yysplit: *yyGLRState = yystackp.yysplitPoint;
            var yyp: *yyGLRState = yystackp.yytops.yystates[yyi];
            while (yyp != yys and yyp != yysplit and yyp.yyposn >= yyposn) {
                if (yyp.yylrState == yynewLRState and yyp.yypred == yys) {
                    yyaddDeferredAction (yystackp, yyk, yyp, yys0, yyrule);
                    yymarkStackDeleted (yystackp, yyk);
                    if (yydebug) {
                      std.debug.print("Merging stack %ld into stack {d}.\n", .{yyk, yyi});
                    }
                    return YYRESULTTAG.yyok;
                }
                yyp = yyp.yypred;
            }
        }
      }
      yystackp.yytops.yystates[yyk] = yys;
      yyglrShiftDefer (yystackp, yyk, yynewLRState, yyposn, yys0, yyrule);
    }
  return YYRESULTTAG.yyok;
}

fn yysplitStack (allocator: std.mem.Allocator, yystackp: *yyGLRStack, yyk: YYPTRDIFF_T) !YYPTRDIFF_T {
  if (yystackp.yysplitPoint == YY_NULLPTR)
    {
      YY_ASSERT (yyk == 0);
      yystackp.yysplitPoint = yystackp.yytops.yystates[yyk];
    }
  if (yystackp.yytops.yycapacity <= yystackp.yytops.yysize)
    {
      const state_size: YYPTRDIFF_T = @@sizeOf (yystackp.yytops.yystates[0]);
      const half_max_capacity: YYPTRDIFF_T = YYSIZE_MAXIMUM / 2 / state_size;
      if (half_max_capacity < yystackp.yytops.yycapacity)
        yyMemoryExhausted (yystackp);
      yystackp.yytops.yycapacity *= 2;

      {
        const yynewStates: [*]*yyGLRState
          = try allocator.realloc(yystackp.yytops.yystates, yystackp.yytops.yycapacity * @@sizeOf(*yyGLRState));
        // if (yynewStates == YY_NULLPTR)
        //   yyMemoryExhausted (yystackp);
        yystackp.yytops.yystates = yynewStates;
      }

      {
        const yynewLookaheadNeeds: *bool
          = try allocator.realloc(yystackp.yytops.yylookaheadNeeds, yystackp.yytops.yycapacity * @@sizeOf(*bool));
        // if (yynewLookaheadNeeds == YY_NULLPTR)
        //   yyMemoryExhausted (yystackp);
        yystackp.yytops.yylookaheadNeeds = yynewLookaheadNeeds;
      }
    }
  yystackp.yytops.yystates[yystackp.yytops.yysize]
    = yystackp.yytops.yystates[yyk];
  yystackp.yytops.yylookaheadNeeds[yystackp.yytops.yysize]
    = yystackp.yytops.yylookaheadNeeds[yyk];
  yystackp.yytops.yysize += 1;
  return yystackp.yytops.yysize - 1;
}

// /** True iff YYY0 and YYY1 represent identical options at the top level.
//  *  That is, they represent the same rule applied to RHS symbols
//  *  that produce the same terminal symbols.  */
fn yyidenticalOptions (yyy0: *yySemanticOption, yyy1: *yySemanticOption) bool {
  if (yyy0.yyrule == yyy1.yyrule)
    {
      var yys0: *yyGLRState = yyy0.yystate;
      var yys1: *yyGLRState = yyy1.yystate;
      var yyn = yyrhsLength (yyy0.yyrule);
      while (yyn > 0) {
        if (yys0.yyposn != yys1.yyposn)
          return false;
        yys0 = yys0.yypred;
        yys1 = yys1.yypred;
        yyn -= 1;
      }
      return true;
    }
  else {
    return false;
  }
}

// /** Assuming identicalOptions (YYY0,YYY1), destructively merge the
//  *  alternative semantic values for the RHS-symbols of YYY1 and YYY0.  */
fn yymergeOptionSets (yyy0: *yySemanticOption, yyy1: *yySemanticOption) void {
  var yys0: *yyGLRState = yyy0.yystate;
  var yys1: *yyGLRState = yyy1.yystate;
  var yyn = yyrhsLength (yyy0.yyrule);
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
          var yyz0p: [*]*yySemanticOption = &yys0.yysemantics.yyfirstVal;
          var yyz1: *yySemanticOption = yys1.yysemantics.yyfirstVal;
          while (true) {
              if (yyz1 == yyz0p[0].* or yyz1 == YY_NULLPTR) {
                break;
              } else if (yyz0p[0].* == YY_NULLPTR) {
                  yyz0p[0].* = yyz1;
                  break;
              } else if (*yyz0p < yyz1) {
                  const yyz: *yySemanticOption = yyz0p[0].*;
                  yyz0p[0].* = yyz1;
                  yyz1 = yyz1.yynext;
                  yyz0p[0].*.yynext = yyz;
                }
              yyz0p = &(yyz0p[0].*).yynext;
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
fn yypreference (y0: *yySemanticOption, y1: *yySemanticOption) isize {
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
  if (p0 == 0 or p1 == 0)
    return 0;
  if (p0 < p1)
    return 3;
  if (p1 < p0)
    return 2;
  return 0;
}

// static YYRESULTTAG
// yyresolveValue (yyGLRState* yys, yyGLRStack* yystackp]b4_user_formals[);


// /** Resolve the previous YYN states starting at and including state YYS
//  *  on *YYSTACKP. If result != yyok, some states may have been left
//  *  unresolved possibly with empty semantic option chains.  Regardless
//  *  of whether result = yyok, each state has been left with consistent
//  *  data so that yydestroyGLRState can be invoked if necessary.  */
fn yyresolveStates (yys: *yyGLRState, yyn: isize,
                 yystackp: *yyGLRStack]b4_user_formals[) YYRESULTTAG {
  if (0 < yyn)
    {
      YY_ASSERT (yys.yypred);
      YYCHK (yyresolveStates (yys.yypred, yyn-1, yystackp]b4_zig_user_args[));
      if (! yys.yyresolved)
        YYCHK (yyresolveValue (yys, yystackp]b4_zig_user_args[));
    }
  return YYRESULTTAG.yyok;
}

// /** Resolve the states for the RHS of YYOPT on *YYSTACKP, perform its
//  *  user action, and return the semantic value and location in *YYVALP
//  *  and *YYLOCP.  Regardless of whether result = yyok, all RHS states
//  *  have been destroyed (assuming the user action destroys all RHS
//  *  semantic values if invoked).  */
fn yyresolveAction (yyopt: *yySemanticOption, yystackp: *yyGLRStack,
                 yyvalp: *YYSTYPE]b4_locuser_formals[) YYRESULTTAG {
  var yyrhsVals: yyGLRStackItem[YYMAXRHS + YYMAXLEFT + 1] = undefined;
  var yynrhs = yyrhsLength (yyopt.yyrule);
  const yyflag: YYRESULTTAG =
    yyresolveStates (yyopt.yystate, yynrhs, yystackp]b4_zig_user_args[);
  if (yyflag != YYRESULTTAG.yyok)
    {
      var yys: *yyGLRState = yyopt.yystate;
      while (yynrhs > 0) {
        yydestroyGLRState ("Cleanup: popping", yys]b4_zig_user_args[);
        yys = yys.yypred;
        yynrhs -= 1;
      }
      return yyflag;
    }

  yyrhsVals[YYMAXRHS + YYMAXLEFT].yystate.yypred = yyopt.yystate;]b4_locations_if([[
  if (yynrhs == 0) {
    // /* Set default location.  */
    yyrhsVals[YYMAXRHS + YYMAXLEFT - 1].yystate.yyloc = yyopt.yystate.yyloc;]])[
  }
  {
    const yychar_current = yystackp.yyrawchar;
    const yylval_current = yystackp.yylval;]b4_locations_if([
    const yylloc_current = yystackp.yylloc;])[
    yystackp.yyrawchar = yyopt.yyrawchar;
    yystackp.yylval = yyopt.yyval;]b4_locations_if([
    yystackp.yylloc = yyopt.yyloc;])[
    yystackp.yyflag = yyuserAction (yyopt.yyrule, yynrhs,
                           yyrhsVals + YYMAXRHS + YYMAXLEFT - 1,
                           yystackp, -1, yyvalp]b4_zig_locuser_args[);
    yystackp.yyrawchar = yychar_current;
    yystackp.yylval = yylval_current;]b4_locations_if([
    yystackp.yylloc = yylloc_current;])[
  }
  return yyflag;
}

fn yyreportTree (yyx: *yySemanticOption, yyindent: usize) void {
  const yynrhs = yyrhsLength (yyx.yyrule);
  var yyi = yynrhs;
  var yys: *yyGLRState = yyx.yystate;
  var yystates: [1 + YYMAXRHS]yyGLRState = undefined;
  var yyleftmost_state: yyGLRState = undefined;

  while (0 < yyi) {
    yystates[yyi] = yys;
    yyi -= 1;
    yys = yys.yypred;
  }

  if (yys == YY_NULLPTR) {
      yyleftmost_state.yyposn = 0;
      yystates[0] = &yyleftmost_state;
  } else {
    yystates[0] = yys;
  }

  if (yyx.yystate.yyposn < yys.yyposn + 1) {
    std.debug.print("{s}{s} -> <Rule {d}, empty>\n", .{yyindent, "", yysymbol_name (yylhsNonterm (yyx.yyrule)), yyx.yyrule - 1});
  } else {
    std.debug.print("{s}{s} -> <Rule {d}, tokens {d} .. {d}>\n", .{
      yyindent, "", yysymbol_name (yylhsNonterm (yyx.yyrule)),
      yyx.yyrule - 1, yys.yyposn + 1,
      yyx.yystate.yyposn
    });
  }

  yyi = 1;
  while (yyi <= yynrhs) : (yyi += 1) {
    if (yystates[yyi].yyresolved) {
        if (yystates[yyi-1].yyposn+1 > yystates[yyi].yyposn) {
          std.debug.print("{s}{s} <empty>\n", .{yyindent+2, "", yysymbol_name (yy_accessing_symbol (yystates[yyi].yylrState))});
        } else {
          std.debug.print("{s}{s} <tokens {d} .. {d}>\n", .{yyindent+2, "",
                        yysymbol_name (yy_accessing_symbol (yystates[yyi].yylrState)),
                        yystates[yyi-1].yyposn + 1,
                        yystates[yyi].yyposn});
        }
    } else {
      yyreportTree (yystates[yyi].yysemantics.yyfirstVal, yyindent+2);
    }
  }
}

fn yyreportAmbiguity (yyx0: *yySemanticOption,
                   yyx1: *yySemanticOption]b4_pure_formals[)
YYRESULTTAG {
  if (yydebug) {
    std.debug.print("Ambiguity detected.\n", .{});
    std.debug.print("Option 1,\n", .{});
    yyreportTree (yyx0, 2);
    std.debug.print("\nOption 2,\n", .{});
    yyreportTree (yyx1, 2);
    std.debug.print("\n", .{});
  }

  yyerror (]b4_yyerror_zig_args["syntax is ambiguous");
  return YYRESULTTAG.yyabort;
}]b4_locations_if([[

// /** Resolve the locations for each of the YYN1 states in *YYSTACKP,
//  *  ending at YYS1.  Has no effect on previously resolved states.
//  *  The first semantic option of a state is always chosen.  */
fn yyresolveLocations (yys1: *yyGLRState, yyn1: isize,
                    yystackp: *yyGLRStack]b4_user_formals[) void {
  if (0 < yyn1)
    {
      yyresolveLocations (yys1.yypred, yyn1 - 1, yystackp]b4_user_args[);
      if (!yys1.yyresolved)
        {
          var yyrhsloc: [1 + YYMAXRHS]yyGLRStackItem = undefined;
          const yynrhs: isize = yyrhsLength (yystackp.yyoption.yyrule);
          const yyoption: *yySemanticOption = yys1.yysemantics.yyfirstVal;
          YY_ASSERT (yyoption);
          if (0 < yynrhs)
            {
              var yys: *yyGLRState = yyoption.yystate;
              var yyn: isize = yynrhs;
              yyresolveLocations (yyoption.yystate, yynrhs,
                                  yystackp]b4_zig_user_args[);
              while (yyn > 0) {
                yyrhsloc[yyn].yystate.yyloc = yys.yyloc;
                yys = yys.yypred;
                yyn -= 1;
              }
            }
          else
            {
              // /* Both yyresolveAction and yyresolveLocations traverse the GSS
              //    in reverse rightmost order.  It is only necessary to invoke
              //    yyresolveLocations on a subforest for which yyresolveAction
              //    would have been invoked next had an ambiguity not been
              //    detected.  Thus the location of the previous state (but not
              //    necessarily the previous state itself) is guaranteed to be
              //    resolved already.  */
              const yyprevious: *yyGLRState = yyoption.yystate;
              yyrhsloc[0].yystate.yyloc = yyprevious.yyloc;
            }
          YYLLOC_DEFAULT ((yys1.yyloc), yyrhsloc, yynrhs);
        }
    }
}]])[

// /** Resolve the ambiguity represented in state YYS in *YYSTACKP,
//  *  perform the indicated actions, and set the semantic value of YYS.
//  *  If result != yyok, the chain of semantic options in YYS has been
//  *  cleared instead or it has been left unmodified except that
//  *  redundant options may have been removed.  Regardless of whether
//  *  result = yyok, YYS has been left with consistent data so that
//  *  yydestroyGLRState can be invoked if necessary.  */
fn yyresolveValue (yys: *yyGLRState, yystackp: *yyGLRStack]b4_user_formals[) YYRESULTTAG {
  var yyoptionList: *yySemanticOption = yys.yysemantics.yyfirstVal;
  var yybest: *yySemanticOption = yyoptionList;
  var yypp: [*]*yySemanticOption = &yyoptionList.yynext;
  var yymerge: bool = false;
  const yyval: YYSTYPE = undefined;
  var yyflag: YYRESULTTAG = undefined;]b4_locations_if([
  const yylocp: *YYLTYPE = &yys.yyloc;])[

  while (*yypp != YY_NULLPTR) {
      var yyp: *yySemanticOption = yypp[0];
      if (yyidenticalOptions (yybest, yyp)) {
          yymergeOptionSets (yybest, yyp);
          yypp[0] = yyp.yynext;
      } else {
          switch (yypreference (yybest, yyp)) {
            0 => {]b4_locations_if([[
              yyresolveLocations (yys, 1, yystackp]b4_user_args[);]])[
              return yyreportAmbiguity (yybest, yyp]b4_pure_args[);
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
      yyflag = yyresolveAction (yybest, yystackp, &yyval]b4_zig_locuser_args[);
      if (yyflag == YYRESULTTAG.yyok) {
        while (yyp != YY_NULLPTR) : (yyp = yyp.yynext) {
          if (yyprec == yydprec[yyp.yyrule]) {
              var yyval_other: YYSTYPE = undefined;]b4_locations_if([
              var yydummy: YYLTYPE = undefined;])[
              yyflag = yyresolveAction (yyp, yystackp, &yyval_other]b4_zig_locuser_args([&yydummy])[);
              if (yyflag != YYRESULTTAG.yyok)
                {
                  yydestruct ("Cleanup: discarding incompletely merged value for",
                              yy_accessing_symbol (yys.yylrState),
                              &yyval]b4_zig_locuser_args[);
                  break;
                }
              yyuserMerge (yymerger[yyp.yyrule], &yyval, &yyval_other);
          }
        }
      }
  } else {
    yyflag = yyresolveAction (yybest, yystackp, &yyval]b4_zig_locuser_args([yylocp])[);
  }

  if (yyflag == YYRESULTTAG.yyok) {
      yys.yyresolved = true;
      yys.yysemantics.yyval = yyval;
  } else {
    yys.yysemantics.yyfirstVal = YY_NULLPTR;
  }
  return yyflag;
}

fn yyresolveStack (yystackp: *yyGLRStack]b4_user_formals[) YYRESULTTAG {
  if (yystackp.yysplitPoint != YY_NULLPTR)
    {
      var yys: *yyGLRState = yystackp.yytops.yystates[0];
      var yyn: usize = 0;

      while (yys != yystackp.yysplitPoint) {
        yys = yys.yypred;
        yyn += 1;
      }

      YYCHK (yyresolveStates (yystackp.yytops.yystates[0], yyn, yystackp
                             ]b4_zig_user_args[));
    }
  return YYRESULTTAG.yyok;
}

// /** Called when returning to deterministic operation to clean up the extra
//  * stacks. */
fn yycompressStack (yystackp: *yyGLRStack) void {
  // /* yyr is the state after the split point.  */
  var yyr: *yyGLRState = undefined;

  if (yystackp.yytops.yysize != 1 or yystackp.yysplitPoint == YY_NULLPTR) {
    return;
  }

  {
    var yyp: *yyGLRState = yystackp.yytops.yystates[0];
    var yyq: *yyGLRState = yyp.yypred;
    yyr = YY_NULLPTR;
    while (yyp != yystackp.yysplitPoint) {
      yyp.yypred = yyr;
      yyr = yyp; yyp = yyq; yyq = yyp.yypred;
    }
  }

  yystackp.yyspaceLeft += yystackp.yynextFree - yystackp.yyitems;
  yystackp.yynextFree = yystackp.yysplitPoint + 1;
  yystackp.yyspaceLeft -= yystackp.yynextFree - yystackp.yyitems;
  yystackp.yysplitPoint = YY_NULLPTR;
  yystackp.yylastDeleted = YY_NULLPTR;

  while (yyr != YY_NULLPTR) {
    yystackp.yynextFree.yystate = *yyr;
    yyr = yyr.yypred;
    yystackp.yynextFree.yystate.yypred = &yystackp.yynextFree[-1].yystate;
    yystackp.yytops.yystates[0] = &yystackp.yynextFree.yystate;
    yystackp.yynextFree += 1;
    yystackp.yyspaceLeft -= 1;
  }
}

fn yyprocessOneStack (yystackp: *yyGLRStack, yyk: YYPTRDIFF_T,
                  yyposn: YYPTRDIFF_T]b4_pure_formals[) YYRESULTTAG {
  while (yystackp.yytops.yystates[yyk] != YY_NULLPTR)
    {
      const yystate = yystackp.yytops.yystates[yyk].yylrState;
      if (yydebug) {
        std.debug.print("Stack {d} Entering state {d}\n", .{yyk, yystate});
      }

      YY_ASSERT (yystate != YYFINAL);

      if (yyisDefaultedState (yystate)) {
          var yyflag: YYRESULTTAG = undefined;
          const yyrule: yyRuleNum = yydefaultAction (yystate);
          if (yyrule == 0) {
              if (yydebug) {
                std.debug.print("Stack {d} dies.\n", .{yyk});
              }
              yymarkStackDeleted (yystackp, yyk);
              return YYRESULTTAG.yyok;
          }
          yyflag = yyglrReduce (yystackp, yyk, yyrule, yyimmediate[yyrule]]b4_zig_user_args[);
          if (yyflag == YYRESULTTAG.yyerr) {
            std.debug.print("Stack {d} dies (predicate failure or explicit user error).\n", .{yyk});
            yymarkStackDeleted (yystackp, yyk);
            return YYRESULTTAG.yyok;
          }
          if (yyflag != YYRESULTTAG.yyok)
            return YYRESULTTAG.yyflag;
      } else {
          const yytoken = ]b4_yygetToken_call[;
          var yyconflicts: [*]isize = undefined;
          const yyaction = yygetLRActions (yystate, yytoken, &yyconflicts);
          yystackp.yytops.yylookaheadNeeds[yyk] = true;

          while (yyconflicts[0] != 0): (yyconflicts += 1) {
              var yyflag: YYRESULTTAG = undefined;
              const yynewStack: YYPTRDIFF_T = yysplitStack (yystackp, yyk);
              if (yydebug) {
                std.debug.print("Splitting off stack {d} from {d}.\n", .{yynewStack, yyk});
              }
              yyflag = yyglrReduce (yystackp, yynewStack,
                                    yyconflicts[0],
                                    yyimmediate[yyconflicts[0]]]b4_zig_user_args[);
              if (yyflag == YYRESULTTAG.yyok) {
                YYCHK (yyprocessOneStack (yystackp, yynewStack,
                                          yyposn]b4_zig_pure_args[));
              } else if (yyflag == YYRESULTTAG.yyerr) {
                if (yydebug) {
                  std.debug.print("Stack {d} dies.\n", .{yynewStack});
                }
                yymarkStackDeleted (yystackp, yynewStack);
              } else {
                return yyflag;
              }
          }

          if (yyisShiftAction (yyaction)) {
            break;
          } else if (yyisErrorAction (yyaction)) {
            if (yydebug) {
              std.debug.print("Stack {d} dies.\n", .{yyk});
              yymarkStackDeleted (yystackp, yyk);
            }
            break;
          } else {
              const yyflag = yyglrReduce (yystackp, yyk, -yyaction,
                                                yyimmediate[-yyaction]]b4_zig_user_args[);
              if (yyflag == YYRESULTTAG.yyerr) {
                if (yydebug) {
                  std.debug.print("Stack {d} dies (predicate failure or explicit user error).\n", .{yyk});
                }
                yymarkStackDeleted (yystackp, yyk);
                break;
              } else if (yyflag != YYRESULTTAG.yyok) {
                return yyflag;
              }
            }
        }
    }
  return YYRESULTTAG.yyok;
}

]b4_parse_error_case([simple], [],
[[// /* Put in YYARG at most YYARGN of the expected tokens given the
//    current YYSTACKP, and return the number of tokens stored in YYARG.  If
//    YYARG is null, return the number of expected tokens (guaranteed to
//    be less than YYNTOKENS).  */
fn yypcontext_expected_tokens (yystackp: *yyGLRStack,
                            yyarg: []yysymbol_kind_t, yyargn: isize)
usize {
  // /* Actual size of YYARG. */
  var yycount: isize = 0;
  const yyn = yypact[yystackp.yytops.yystates[0].yylrState];
  if (!yypact_value_is_default (yyn)) {
      // /* Start YYX at -YYN if negative to avoid negative indexes in
      //    YYCHECK.  In other words, skip the first -YYN actions for
      //    this state because they are default actions.  */
      const yyxbegin: isize = if(yyn < 0) -yyn else 0;
      // /* Stay within bounds of both yycheck and yytname.  */
      const yychecklim = YYLAST - yyn + 1;
      const yyxend = if (yychecklim < YYNTOKENS) yychecklim else YYNTOKENS;
      var yyx: isize = yyxbegin;
      while (yyx < yyxend) : (yyx += 1) {
        if (yycheck[yyx + yyn] == yyx and yyx != yysymbol_kind_t.]b4_symbol(error, kind)[
            and !yytable_value_is_error (yytable[yyx + yyn])) {
            if (!yyarg) {
              yycount += 1;
            } else if (yycount == yyargn) {
              return 0;
            } else {
              yyarg[yycount] = yyx;
              yycount += 1;
            }
        }
      }
  }
  if (yyarg and yycount == 0 and 0 < yyargn) {
    yyarg[0] = yysymbol_kind_t.]b4_symbol(empty, kind)[;
  }
  return yycount;
}]])[

]b4_parse_error_bmatch(
         [custom],
[[/* User defined function to report a syntax error.  */
typedef yyGLRStack yypcontext_t;
static int
yyreport_syntax_error (const yyGLRStack* yystackp]b4_user_formals[);

/* The kind of the lookahead of this context.  */
static yysymbol_kind_t
yypcontext_token (const yyGLRStack *yystackp) YY_ATTRIBUTE_UNUSED;

static yysymbol_kind_t
yypcontext_token (const yyGLRStack *yystackp)
{
  YY_USE (yystackp);
  yysymbol_kind_t yytoken = yychar == ]b4_symbol(empty, id)[ ? ]b4_symbol(empty, kind)[ : YYTRANSLATE (yychar);
  return yytoken;
}

]b4_locations_if([[/* The location of the lookahead of this context.  */
static const YYLTYPE *
yypcontext_location (const yyGLRStack *yystackp) YY_ATTRIBUTE_UNUSED;

static const YYLTYPE *
yypcontext_location (const yyGLRStack *yystackp)
{
  YY_USE (yystackp);
  return &yylloc;
}]])],
         [detailed\|verbose],
[[fn yy_syntax_error_arguments (yystackp: *yyGLRStack,
                          yyarg: []yysymbol_kind_t, yyargn: isize) isize {
  const yytoken: yysymbol_kind_t = if (yystackp.yyrawchar == yytoken_kind_t.]b4_symbol(empty, id)[) yysymbol_kind_t.]b4_symbol(empty, kind)[ else YYTRANSLATE (yystackp.yyrawchar);
  // /* Actual size of YYARG. */
  var yycount: isize = 0;
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
  if (yytoken != yysymbol_kind_t.]b4_symbol(empty, kind)[) {
    var yyn: isize = 0;
    if (yyarg) {
      yyarg[yycount] = yytoken;
    }
    yycount += 1;
    yyn = yypcontext_expected_tokens (yystackp,
                                      if (yyarg) yyarg + 1 else yyarg, yyargn - 1);
    if (yyn == YYENOMEM) {
      return YYENOMEM;
    } else {
      yycount += yyn;
    }
  }
  return yycount;
}
]])[

fn yyreportSyntaxError (allocator: std.mem.Allocator, yystackp: *yyGLRStack) !void {
  if (yystackp.yyerrState != 0) {
    return;
  }
]b4_parse_error_case(
         [custom],
[[  if (yyreport_syntax_error (yystackp]b4_user_args[))
    yyMemoryExhausted (yystackp);]],
         [simple],
[[  yyerror (]b4_lyyerror_args["syntax error");]],
[[  {
  var yysize_overflow: bool = false;
  var yymsg: []const u8 = YY_NULLPTR;
  const YYARGS_MAX = 5;
  // /* Internationalized format string. */
  var yyformat: []const u8 = YY_NULLPTR;
  // /* Arguments of yyformat: reported tokens (one for the "unexpected",
  //    one per "expected"). */
  const yyarg: [YYARGS_MAX]yysymbol_kind_t = undefined;
  // /* Cumulated lengths of YYARG.  */
  var yysize: YYPTRDIFF_T = 0;

  // /* Actual size of YYARG. */
  const yycount
    = yy_syntax_error_arguments (yystackp, yyarg, YYARGS_MAX);
  if (yycount == YYENOMEM) {
    yyMemoryExhausted (yystackp);
  }

  switch (yycount) {
      0 => { yyformat = "syntax error"; },
      1 => { yyformat = "syntax error, unexpected {s}"; },
      2 => { yyformat = "syntax error, unexpected {s}, expecting {s}"; },
      3 => { yyformat = "syntax error, unexpected {s}, expecting {s} or {s}"; },
      4 => { yyformat = "syntax error, unexpected {s}, expecting {s} or {s} or {s}"; },
      5 => { yyformat = "syntax error, unexpected {s}, expecting {s} or {s} or {s} or {s}"; },
      else => {},
  }

  // /* Compute error message size.  Don't count the "%s"s, but reserve
  //    room for the terminator.  */
  yysize = yyformat.len - 2 * yycount + 1;
  {
    var yyi: isize = 0;
    while (yyi < yycount) : (yyi += 1) {
        const yysz: YYPTRDIFF_T
          = ]b4_parse_error_case(
                     [verbose], [[yytnamerr (YY_NULLPTR, yytname[yyarg[yyi]])]],
                     [[yysymbol_name (yyarg[yyi]).len]]);[
        if (YYSIZE_MAXIMUM - yysize < yysz) {
          yysize_overflow = true;
        } else {
          yysize += yysz;
        }
    }
  }

  if (!yysize_overflow) {
    yymsg = try allocator.alloc(yysize);
  }
  defer {
      if (!yysize_overflow) {
          allocator.free(yymsg);
      }
  }

  // if (yymsg) {
      var yyp: [*]const u8 = yymsg.ptr;
      var yyi: isize = 0;
      yyp[0] = yyformat[0];
      while (yyp[0] != 0): (yyp[0] = yyformat[0]) {
        if (yyp[0] == '%' and yyformat[1] == 's' and yyi < yycount) {]b4_parse_error_case([verbose], [[
            yyp += yytnamerr (yyp, yytname[yyarg[yyi]]); yyi += 1;]], [[
            yyp = yystpcpy (yyp, yysymbol_name (yyarg[yyi])); yyi += 1;]])[
            yyformat += 2;
        } else {
            yyp += 1;
            yyformat += 1;
        }
      }
      yyerror (]b4_lyyerror_args[yymsg);
      // YYFREE (yymsg);
  // } else {
  //     yyerror (]b4_lyyerror_args["syntax error");
  //     yyMemoryExhausted (yystackp);
  // }
  }]])[
  yystackp.yynerrs += 1;
}

// /* Recover from a syntax error on *YYSTACKP, assuming that *YYSTACKP->YYTOKENP,
//    yylval, and yylloc are the syntactic category, semantic value, and location
//    of the lookahead.  */
fn yyrecoverSyntaxError (yyctx: yyparse_context_t, yystackp: *yyGLRStack]b4_user_formals[) void {
  if (yystackp.yyerrState == 3) {
    // /* We just shifted the error token and (perhaps) took some
    //    reductions.  Skip tokens until we can proceed.  */
    while (true) {
      var yytoken: yysymbol_kind_t = undefined;
      var yyj: isize = 0;
      if (yystackp.yyrawchar == yytoken_kind_t.]b4_symbol(eof, [id])[) {
        yyFail (yystackp][]b4_zig_lpure_args[, YY_NULLPTR);
      }
      if (yystackp.yyrawchar != yytoken_kind_t.]b4_symbol(empty, id)[) {]b4_locations_if([[
          // /* We throw away the lookahead, but the error range
          //    of the shifted error token must take it into account.  */
          const yys: *yyGLRState = yystackp.yytops.yystates[0];
          var yyerror_range: [3]yyGLRStackItem = undefined;
          yyerror_range[1].yystate.yyloc = yys.yyloc;
          yyerror_range[2].yystate.yyloc = yystackp.yylloc;
          YYLLOC_DEFAULT ((yys.yyloc), yyerror_range, 2);]])[
          yytoken = YYTRANSLATE (yystackp.yyrawchar);
          yydestruct (yyctx, "Error: discarding",
                      yytoken, &yystackp.yylval]b4_zig_locuser_args([&yystackp.yylloc])[);
          yystackp.yyrawchar = yytoken_kind_t.]b4_symbol(empty, id)[;
      }
      yytoken = ]b4_yygetToken_call[;
      yyj = yypact[yystackp.yytops.yystates[0].yylrState];
      if (yypact_value_is_default (yyj)) {
        return;
      }
      yyj += yytoken;
      if (yyj < 0 or YYLAST < yyj or yycheck[yyj] != yytoken) {
          if (yydefact[yystackp.yytops.yystates[0].yylrState] != 0)
            return;
      } else if (! yytable_value_is_error (yytable[yyj])) {
        return;
      }
    }
  }

  // /* Reduce to one stack.  */
  {
    var yyk: yyGLRStackItem = 0;
    while (yyk < yystackp.yytops.yysize) : (yyk += 1) {
      if (yystackp.yytops.yystates[yyk] != YY_NULLPTR)
        break;
    }
    if (yyk >= yystackp.yytops.yysize) {
      yyFail (yystackp][]b4_zig_lpure_args[, YY_NULLPTR);
    }
    yyk += 1;
    while (yyk < yystackp.yytops.yysize) : (yyk += 1) {
      yymarkStackDeleted (yystackp, yyk);
    }
    yyremoveDeletes (yystackp);
    yycompressStack (yystackp);
  }

  // /* Pop stack until we find a state that shifts the error token.  */
  yystackp.yyerrState = 3;
  while (yystackp.yytops.yystates[0] != YY_NULLPTR) {
      var yys: *yyGLRState = yystackp.yytops.yystates[0];
      var yyj: isize = yypact[yys.yylrState];
      if (! yypact_value_is_default (yyj)) {
        yyj += yysymbol_kind_t.]b4_symbol(error, kind)[;
        if (0 <= yyj and yyj <= YYLAST and yycheck[yyj] == yysymbol_kind_t.]b4_symbol(error, kind)[
            and yyisShiftAction (yytable[yyj])) {
            // /* Shift the error token.  */
            const yyaction: isize = yytable[yyj];]b4_locations_if([[
            // /* First adjust its location.*/
            var yyerrloc: YYLTYPE = undefined;
            yystackp.yyerror_range[2].yystate.yyloc = yystackp.yylloc;
            YYLLOC_DEFAULT (yyerrloc, (yystackp.yyerror_range), 2);]])[
            YY_SYMBOL_PRINT ("Shifting", yy_accessing_symbol (yyaction),
                              &yystackp.yylval, &yyerrloc);
            yyglrShift (yystackp, 0, yyaction,
                        yys.yyposn, &yystackp.yylval]b4_locations_if([, &yyerrloc])[);
            yys = yystackp.yytops.yystates[0];
            break;
          }
      }]b4_locations_if([[
      yystackp.yyerror_range[1].yystate.yyloc = yys.yyloc;]])[
      if (yys.yypred != YY_NULLPTR)
        yydestroyGLRState ("Error: popping", yys]b4_zig_user_args[);
      yystackp.yytops.yystates[0] = yys.yypred;
      yystackp.yynextFree -= 1;
      yystackp.yyspaceLeft += 1;
  }
  if (yystackp.yytops.yystates[0] == YY_NULLPTR) {
    yyFail (yystackp][]b4_zig_lpure_args[, YY_NULLPTR);
  }
}

fn YYCHK1(YYE: YYRESULTTAG) usize {
    switch (YYE) {
      .yyok => { return 0; },
      .yyabort => { return LABEL_YYABORTLAB; },
      .yyaccept => { return LABEL_YYACCEPTLAB; },
      .yyerr => { return LABEL_YYUSER_ERROR; },
      .yynomem => {return LABEL_YYEXHAUSTEDLAB; },
      else => { return LABEL_YYBUGLAB; },
    }
}

const yyparse_context_t = struct {
  allocator: std.mem.Allocator,
  ]m4_ifset([b4_user_formals], [b4_formals_struct(b4_user_formals)])[,
  yyresult: isize = 0,
  yystack: yyGLRStack = undefined,
  yystackp: *yyGLRStack = undefined,
  yyposn: YYPTRDIFF_T = 0,

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
  std.debug.print("bug");
  return LABEL_YYABORTLAB;
}

fn label_yyabortlab(yyctx: *yyparse_context_t) usize {
  yyctx.yyresult = 1;
  return LABEL_YYRETURNLAB;
}

fn label_yyexhaustedlab(yyctx: *yyparse_context_t) usize {
  const yystackp = yyctx.yystackp;
  yyerror (]b4_lyyerror_args["memory exhausted");
  yyctx.yyresult = 2;
  return LABEL_YYRETURNLAB;
}

fn label_yyuser_error(yyctx: *yyparse_context_t) usize {
  const yystack = yyctx.yystack;
  const yystackp = yyctx.yystackp;
  yyrecoverSyntaxError (&yystack, yystackp);
  yyctx.yyposn = yystack.yytops.yystates[0].yyposn;
  return LABEL_YYPARSE_IMPL;
}

fn label_yyparse_impl(yyctx: *yyparse_context_t) usize {
  var ret: usize = 0;
  while (true)
    {
      // /* For efficiency, we have two loops, the first of which is
      //    specialized to deterministic operation (single stack, no
      //    potential ambiguity).  */

      // /* Standard mode. */
      while (true) {
        const yystate: yy_state_t = yyctx.yystack.yytops.yystates[0].yylrState;
        if (yydebug) {
          std.debug.print("Entering state {d}\n", .{yystate});
        }
        if (yystate == YYFINAL) {
          return LABEL_YYACCEPTLAB;
        }
        if (yyisDefaultedState (yystate)) {
            const yyrule: yyRuleNum = yydefaultAction (yystate);
            if (yyrule == 0)
              {]b4_locations_if([[
                yyctx.yystack.yyerror_range[1].yystate.yyloc = yyctx.yystackp.yylloc;]])[
                yyreportSyntaxError (yyctx.allocator, &yyctx.yystack);
                return LABEL_YYUSER_ERROR;
              }
            ret = YYCHK1 (yyglrReduce (&yyctx.yystack, 0, yyrule, true]b4_zig_user_args_yyctx[));
            if (ret != 0) {
              return ret;
            }
        } else {
            const yytoken: yysymbol_kind_t = ]b4_yygetToken_call_yyctx;[
            var yyconflicts: *isize = undefined;
            const yyaction = yygetLRActions (yystate, yytoken, &yyconflicts);
            if (yyconflicts.* > 0) {
              // /* Enter nondeterministic mode.  */
              break;
            }
            if (yyisShiftAction (yyaction)) {
                YY_SYMBOL_PRINT ("Shifting", yytoken, &yyctx.yystackp.yylval, &yyctx.yystackp.yylloc);
                yyctx.yystackp.yyrawchar = yytoken_kind_t.]b4_symbol(empty, id)[;
                yyctx.yyposn += 1;
                yyglrShift (&yyctx.yystack, 0, yyaction, yyctx.yyposn, &yyctx.yystackp.yylval]b4_locations_if([, &yyctx.yystackp.yylloc])[);
                if (0 < yyctx.yystack.yyerrState) {
                  yyctx.yystack.yyerrState -= 1;
                }
            } else if (yyisErrorAction (yyaction)) {]b4_locations_if([[
                yyctx.yystack.yyerror_range[1].yystate.yyloc = yyctx.yystackp.yylloc;]])[
                // /* Issue an error message unless the scanner already
                //    did. */
                if (yyctx.yystackp.yyrawchar != yysymbol_kind_t.]b4_symbol(error, id)[) {
                  yyreportSyntaxError (&yyctx.yystack]b4_zig_user_args_yyctx[);
                }
                return LABEL_YYUSER_ERROR;
            } else {
              ret = YYCHK1 (yyglrReduce (&yyctx.yystack, 0, -yyaction, true]b4_zig_user_args_yyctx[));
              if (ret != 0) {
                return ret;
              }
            }
          }
      }

      // /* Nondeterministic mode. */
      while (true) {
          var yytoken_to_shift: yysymbol_kind_t = undefined;
          var yys: YYPTRDIFF_T = 0;

          while (yys < yyctx.yystack.yytops.yysize) : (yys += 1) {
            yyctx.yystackp.yytops.yylookaheadNeeds[yys] = yyctx.yystackp.yyrawchar != yytoken_kind_t.]b4_symbol(empty, id)[;
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
            ret = YYCHK1 (yyprocessOneStack (&yyctx.yystack, yys, yyctx.yyposn]b4_zig_lpure_args_yyctx[));
            if (ret != 0) {
              return ret;
            }
          }
          yyremoveDeletes (&yyctx.yystack);
          if (yyctx.yystack.yytops.yysize == 0) {
              yyundeleteLastStack (&yyctx.yystack);
              if (yyctx.yystack.yytops.yysize == 0) {
                yyFail (&yyctx.yystack][]b4_zig_lpure_args_yyctx[, "syntax error");
              }
              ret = YYCHK1 (yyresolveStack (&yyctx.yystack]b4_zig_user_args_yyctx[));
              if (ret != 0) {
                return ret;
              }
              if (yydebug) {
                std.debug.print("Returning to deterministic operation.\n", .{});
              }
              ]b4_locations_if([[
              yyctx.yystack.yyerror_range[1].yystate.yyloc = yyctx.yystackp.yylloc;]])[
              yyreportSyntaxError (&yyctx.yystack]b4_zig_user_args_yyctx[);
              return LABEL_YYUSER_ERROR;
          }

          // /* If any yyglrShift call fails, it will fail after shifting.  Thus,
          //    a copy of yylval will already be on stack 0 in the event of a
          //    failure in the following loop.  Thus, yychar is set to ]b4_symbol(empty, id)[
          //    before the loop to make sure the user destructor for yylval isn't
          //    called twice.  */
          yytoken_to_shift = YYTRANSLATE (yyctx.yystackp.yyrawchar);
          yyctx.yystackp.yyrawchar = yytoken_kind_t.]b4_symbol(empty, id)[;
          yyctx.yyposn += 1;
          yys = 0;
          while (yys < yyctx.yystack.yytops.yysize) : (yys += 1)
            {
              const yystate: yy_state_t = yyctx.yystack.yytops.yystates[yys].yylrState;
              var yyconflicts: *isize = undefined;
              const yyaction = yygetLRActions (yystate, yytoken_to_shift,
                              &yyconflicts);
              // /* Note that yyconflicts were handled by yyprocessOneStack.  */
              if (yydebug) {
                std.debug.print("On stack {d}, ", .{yys});
              }
              YY_SYMBOL_PRINT ("shifting", yytoken_to_shift, &yyctx.yystackp.yylval, &yyctx.yystackp.yylloc);
              yyglrShift (&yyctx.yystack, yys, yyaction, yyctx.yyposn,
                          &yyctx.yystackp.yylval]b4_locations_if([, &yyctx.yystackp.yylloc])[);
              if (yydebug) {
                std.debug.print("Stack {d} now in state {d}\n", .{yys, yyctx.yystack.yytops.yystates[yys].yylrState});
              }
            }

          if (yyctx.yystack.yytops.yysize == 1)
            {
              ret = YYCHK1 (yyresolveStack (&yyctx.yystack]b4_zig_user_args_yyctx[));
              if (ret != 0) {
                return ret;
              }
              if (yydebug) {
                std.debug.print("Returning to deterministic operation.\n");
              }
              yycompressStack (&yyctx.yystack);
              break;
            }
        }
    }
    return LABEL_YYACCEPTLAB;
}

// /*----------.
// | yyparse.  |
// `----------*/

pub fn yyparse(allocator: std.mem.Allocator, ]m4_ifset([b4_parse_param], [b4_formals(b4_parse_param)], [void])[) !isize {
  var yyctx: yyparse_context_t = yyparse_context_t.init(allocator);
]m4_ifset([b4_parse_param], [b4_formals_copy(b4_parse_param);], [])
[
  if (yydebug) {
    std.debug.print("Starting parse\n", .{});
  }

  yyctx.yystackp.yyrawchar = yytoken_kind_t.]b4_symbol(empty, id)[;
  yyctx.yystackp.yylval = yyval_default;]b4_locations_if([
  yyctx.yystackp.yylloc = yyloc_default;])[
]m4_ifdef([b4_initial_action], [
b4_dollar_pushdef([yylval], [], [], [yylloc])dnl
  b4_user_initial_action
b4_dollar_popdef])[]dnl
[
  var loop_control: usize = 0;

  try yyinitGLRStack(yyctx.allocator, yyctx.yystackp, YYINITDEPTH);

  yyglrShift (&yyctx.yystack, 0, 0, 0, &yyctx.yystackp.yylval]b4_locations_if([, &yyctx.yystackp.yylloc])[);
  yyctx.yyposn = 0;
  loop_control = LABEL_YYPARSE_IMPL;

  // switch (YYSETJMP (yystack.yyexception_buffer))
  //   {
  //   case 0: break;
  //   case 1: goto yyabortlab;
  //   case 2: goto yyexhaustedlab;
  //   default: goto yybuglab;
  //   }

  while(true) {
    switch(loop_control) {
      LABEL_YYUSER_ERROR => {
        loop_control = label_yyuser_error(&yyctx);
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
        loop_control = label_yyparse_impl(&yyctx);
      },
      else => {},
    }
  }

  // yyreturnlab:
  if (yyctx.yystackp.yyrawchar != yytoken_kind_t.]b4_symbol(empty, id)[)
    yydestruct ("Cleanup: discarding lookahead",
                YYTRANSLATE (yyctx.yystackp.yyrawchar), &yyctx.yystackp.yylval]b4_locuser_args([&yyctx.yystackp.yylloc])[);

  // /* If the stack is well-formed, pop the stack until it is empty,
  //    destroying its entries as we go.  But free the stack regardless
  //    of whether it is well-formed.  */
  if (yyctx.yystack.yyitems) {
      var yystates: [*]*yyGLRState = yyctx.yystack.yytops.yystates;
      if (yystates) {
          const yysize: YYPTRDIFF_T = yyctx.yystack.yytops.yysize;
          var yyk: YYPTRDIFF_T = 0;
          while (yyk < yysize) : (yyk += 1) {
            if (yystates[yyk]) {
                while (yystates[yyk])
                  {
                    const yys: *yyGLRState = yystates[yyk];]b4_locations_if([[
                    yyctx.yystack.yyerror_range[1].yystate.yyloc = yys.yyloc;]])[
                    if (yys.yypred != YY_NULLPTR)
                      yydestroyGLRState ("Cleanup: popping", yys]b4_user_args[);
                    yystates[yyk] = yys.yypred;
                    yyctx.yystack.yynextFree -= 1;
                    yyctx.yystack.yyspaceLeft += 1;
                  }
                break;
            }
          }
      }
    yyfreeGLRStack (&yyctx.yystack);
  }

  return yyctx.yyresult;
}

// /* DEBUGGING ONLY */
// /* Print *YYS and its predecessors. */
fn yy_yypstack (yys: *yyGLRState) void {
  if (yys.yypred) {
      yy_yypstack (yys.yypred);
      std.debug.print(" -> ", .{});
  }
  std.debug.print("{d}@@{d}", .{yys.yylrState, yys.yyposn});
}

// /* Print YYS (possibly NULL) and its predecessors. */
fn yypstates (yys: *yyGLRState) void {
  if (yys == YY_NULLPTR) {
    std.debug("<null>", .{});
  } else {
    yy_yypstack (yys);
  }
  std.debug.print("\n", .{});
}

// /* Print the stack #YYK.  */
fn yypstack (yystackp: *yyGLRStack, yyk: YYPTRDIFF_T) void {
  yypstates (yystackp.yytops.yystates[yyk]);
}

// /* Print all the stacks.  */
fn yypdumpstack (yystackp: *yyGLRStack) void {
  // YY_CAST (long,                                                        \
  //          ((YYX)                                                       \
  //           ? YY_REINTERPRET_CAST (yyGLRStackItem*, (YYX)) - yystackp->yyitems \
  //           : -1))

  var yyp: *yyGLRStackItem = yystackp.yyitems;
  while (yyp < yystackp.yynextFree) : (yyp += 1) {
    std.debug.print("{d}. ", .{yyp - yystackp.yyitems});
    if (yyp.*) {
          YY_ASSERT (yyp.yystate.yyisState);
          YY_ASSERT (yyp.yyoption.yyisState);
          var yyx = yyp.yystate.yypred;
          std.debug.print("Res: {d}, LR State: {d}, posn: {d}, pred: {d}",
                       .{yyp.yystate.yyresolved, yyp.yystate.yylrState,
                       yyp.yystate.yyposn, if (yyx > 0) yyx - yystackp.yyitems else -1});
          if (! yyp.yystate.yyresolved) {
            yyx = yyp.yystate.yysemantics.yyfirstVal;
            std.debug.print(", firstVal: {d}", .{if (yyx > 0) yyx - yystackp.yyitems else -1});
          }
    } else {
          YY_ASSERT (!yyp.yystate.yyisState);
          YY_ASSERT (!yyp.yyoption.yyisState);
          const yyx1 = yyp.yyoption.yystate;
          const yyx2 = yyp.yyoption.yynext;
          std.debug.print("Option. rule: {d}, state: {d}, next: {d}",
                       .{yyp.yyoption.yyrule - 1,
                       if (yyx1 > 0) yyx1 - yystackp.yyitems else -1,
                       if (yyx2 > 0) yyx2 - yystackp.yyitems else -1,});
    }
    std.debug.print("\n", .{});
  }

  std.debug.print("Tops:", .{});
  {
    var yyi: YYPTRDIFF_T = 0;
    while(yyi < yystackp.yytops.yysize) : (yyi += 1) {
      const yyx = yystackp.yytops.yystates[yyi];
      std.debug.print("{d}: {d}; ", .{yyi, if (yyx > 0) yyx - yystackp.yyitems else -1});
    }
    std.debug.print("\n", .{});
  }
}
]b4_percent_code_get([[epilogue]])[]dnl
b4_epilogue[]dnl
b4_output_end
