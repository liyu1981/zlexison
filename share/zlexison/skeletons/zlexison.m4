#                                                            -*- C -*-
# Yacc compatible skeleton for Bison

# Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software
# Foundation, Inc.

m4_pushdef([b4_zison_version], [z4_zison_version])

m4_pushdef([b4_copyright_years],
            [1984, 1989-1990, 2000-2015, 2018-2021])

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

m4_include(b4_skeletonsdir/[c.m4])


# redefine b4_api_prefix so it has no effect even used in .y
m4_define(b4_api_prefix, [])


## ---------- ##
## api.pure.  ##
## ---------- ##

b4_percent_define_default([[api.pure]], [[false]])
b4_percent_define_check_values([[[[api.pure]],
                                 [[false]], [[true]], [[]], [[full]]]])

m4_define([b4_pure_flag], [[0]])
m4_case(b4_percent_define_get([[api.pure]]),
        [false], [m4_define([b4_pure_flag], [[2]])],
        [true],  [m4_define([b4_pure_flag], [[2]])],
        [],      [m4_define([b4_pure_flag], [[2]])],
        [full],  [m4_define([b4_pure_flag], [[2]])])

m4_define([b4_pure_if],
[m4_case(b4_pure_flag,
         [0], [$2],
         [1], [$1],
         [2], [$1])])
         [m4_fatal([invalid api.pure value: ]$1)])])

## --------------- ##
## api.push-pull.  ##
## --------------- ##

# b4_pull_if, b4_push_if
# ----------------------
# Whether the pull/push APIs are needed.  Both can be enabled.

b4_percent_define_default([[api.push-pull]], [[pull]])
b4_percent_define_check_values([[[[api.push-pull]],
                                 [[pull]], [[push]], [[both]]]])
b4_define_flag_if([pull]) m4_define([b4_pull_flag], [[1]])
b4_define_flag_if([push]) m4_define([b4_push_flag], [[1]])
m4_case(b4_percent_define_get([[api.push-pull]]),
        [pull], [m4_define([b4_push_flag], [[0]])],
        [push], [m4_define([b4_pull_flag], [[0]])])

# Handle BISON_USE_PUSH_FOR_PULL for the test suite.  So that push parsing
# tests function as written, do not let BISON_USE_PUSH_FOR_PULL modify the
# behavior of Bison at all when push parsing is already requested.
b4_define_flag_if([use_push_for_pull])
b4_use_push_for_pull_if([
  b4_push_if([m4_define([b4_use_push_for_pull_flag], [[0]])],
             [m4_define([b4_push_flag], [[1]])])])

## ----------- ##
## parse.lac.  ##
## ----------- ##

b4_percent_define_default([[parse.lac]], [[none]])
b4_percent_define_default([[parse.lac.es-capacity-initial]], [[20]])
b4_percent_define_default([[parse.lac.memory-trace]], [[failures]])
b4_percent_define_check_values([[[[parse.lac]], [[full]], [[none]]]],
                               [[[[parse.lac.memory-trace]],
                                 [[failures]], [[full]]]])
b4_define_flag_if([lac])
m4_define([b4_lac_flag],
          [m4_if(b4_percent_define_get([[parse.lac]]),
                 [none], [[0]], [[1]])])

## ---------------- ##
## Default values.  ##
## ---------------- ##

# Stack parameters.
m4_define_default([b4_stack_depth_max], [10000])
m4_define_default([b4_stack_depth_init],  [200])


# b4_yyerror_arg_loc_if(ARG)
# --------------------------
# Expand ARG iff yyerror is to be given a location as argument.
m4_define([b4_yyerror_arg_loc_if],
[b4_locations_if([m4_case(b4_pure_flag,
                          [1], [m4_ifset([b4_parse_param], [$1])],
                          [2], [$1])])])

# b4_yyerror_formals
# ------------------
m4_define([b4_yyerror_formals],
[b4_pure_if([b4_locations_if([, [[const ]b4_api_PREFIX[LTYPE *yyllocp], [&yylloc]]])[]dnl
m4_ifdef([b4_parse_param], [, b4_parse_param])[]dnl
,])dnl
[[const char *msg], [msg]]])



# b4_yyerror_args
# ---------------
# Arguments passed to yyerror: user args plus yylloc.
m4_define([b4_yyerror_args],
[b4_yyerror_arg_loc_if([&yylloc, ])dnl
m4_ifset([b4_parse_param], [b4_args(b4_parse_param), ])])



## ----------------- ##
## Semantic Values.  ##
## ----------------- ##


# b4_accept([SYMBOL-NUM])
# -----------------------
# Used in actions of the rules of accept, the initial symbol, to call
# YYACCEPT.  If SYMBOL-NUM is specified, run "yyvalue->SLOT = $2;"
# before, using the slot of SYMBOL-NUM.
m4_define([b4_accept],
[m4_ifval([$1],
          [b4_symbol_value(yyimpl->yyvalue, [$1]) = b4_rhs_value(2, 1, [$1]); ]) YYACCEPT])


# b4_lhs_value(SYMBOL-NUM, [TYPE])
# --------------------------------
# See README.
m4_define([b4_lhs_value],
[b4_symbol_value(yyctx.yyval, [$1], [$2])])


# b4_rhs_value(RULE-LENGTH, POS, [SYMBOL-NUM], [TYPE])
# ----------------------------------------------------
# See README.
m4_define([b4_rhs_value],
[b4_symbol_value([ptrRhsWithOffset(YYSTYPE, yyctx.yyvsp, b4_subtract([$2], [$1]))], [$3], [$4])])


## ----------- ##
## Locations.  ##
## ----------- ##

# b4_lhs_location()
# -----------------
# Expansion of @$.
# Overparenthetized to avoid obscure problems with "foo$$bar = foo$1bar".
m4_define([b4_lhs_location],
[(yyctx.yyloc)])


# b4_rhs_location(RULE-LENGTH, POS)
# ---------------------------------
# Expansion of @POS, where the current rule has RULE-LENGTH symbols
# on RHS.
# Overparenthetized to avoid obscure problems with "foo$$bar = foo$1bar".
m4_define([b4_rhs_location],
[(yyctx.yylsp@{b4_subtract([$2], [$1])@})])


## -------------- ##
## Declarations.  ##
## -------------- ##

# _b4_declare_sub_yyparse(START-SYMBOL-NUM, SWITCHING-TOKEN-SYMBOL-NUM)
# ---------------------------------------------------------------------
# Define the return type of the parsing function for SYMBOL-NUM, and
# declare its parsing function.
m4_define([_b4_declare_sub_yyparse],
[[]])


# _b4_first_switching_token
# -------------------------
m4_define([b4_first], [$1])
m4_define([b4_second], [$2])
m4_define([_b4_first_switching_token],
[b4_second(b4_first(b4_start_symbols))])


# _b4_define_sub_yyparse(START-SYMBOL-NUM, SWITCHING-TOKEN-SYMBOL-NUM)
# --------------------------------------------------------------------
# Define the parsing function for START-SYMBOL-NUM.
m4_define([_b4_define_sub_yyparse],
[[]])


# b4_declare_scanner_communication_variables
# ------------------------------------------
# Declare the variables that are global, or local to YYPARSE if
# pure-parser.
m4_define([b4_declare_scanner_communication_variables], [[
]m4_ifdef([b4_start_symbols], [],
[[]])[]])


# b4_declare_parser_state_variables([INIT])
# -----------------------------------------
# Declare all the variables that are needed to maintain the parser state
# between calls to yypush_parse.
# If INIT is non-null, initialize these variables.
m4_define([b4_declare_parser_state_variables],
[b4_pure_if([[
]])[]])


m4_define([b4_macro_define],
[[#]define $1 $2])

m4_define([b4_macro_undef],
[[#]undef $1])

m4_define([b4_pstate_macro_define],
[b4_macro_define([$1], [yyps->$1])])

# b4_parse_state_variable_macros(b4_macro_define|b4_macro_undef)
# --------------------------------------------------------------
m4_define([b4_parse_state_variable_macros],
[b4_pure_if([$1([b4_prefix[]nerrs])])
$1([yystate])
$1([yyerrstatus])
$1([yyssa])
$1([yyss])
$1([yyssp])
$1([yyvsa])
$1([yyvs])
$1([yyvsp])[]b4_locations_if([
$1([yylsa])
$1([yyls])
$1([yylsp])])
$1([yystacksize])[]b4_lac_if([
$1([yyesa])
$1([yyes])
$1([yyes_capacity])])])




# _b4_declare_yyparse_push
# ------------------------
# Declaration of yyparse (and dependencies) when using the push parser
# (including in pull mode).
m4_define([_b4_declare_yyparse_push],[])


# _b4_declare_yyparse
# -------------------
# When not the push parser.
m4_define([_b4_declare_yyparse],[])


# b4_declare_yyparse
# ------------------
m4_define([b4_declare_yyparse],
[b4_push_if([_b4_declare_yyparse_push],
            [_b4_declare_yyparse])[]dnl
])


# b4_declare_yyerror_and_yylex
# ----------------------------
# Comply with POSIX Yacc.
# <https://austingroupbugs.net/view.php?id=1388#c5220>
m4_define([b4_declare_yyerror_and_yylex],
[b4_posix_if([[#if !defined ]b4_prefix[error && !defined ]b4_api_PREFIX[ERROR_IS_DECLARED
]b4_function_declare([b4_prefix[error]], void, b4_yyerror_formals)[
#endif
#if !defined ]b4_prefix[lex && !defined ]b4_api_PREFIX[LEX_IS_DECLARED
]b4_function_declare([b4_prefix[lex]], int, b4_yylex_formals)[
#endif
]])dnl
])


# b4_shared_declarations
# ----------------------
# Declarations that might either go into the header (if --header)
# or into the implementation file.
m4_define([b4_shared_declarations],
[b4_cpp_guard_open([b4_spec_mapped_header_file])[
]b4_declare_yydebug[
]b4_percent_code_get([[requires]])[
]b4_token_enums_defines[
]b4_declare_yylstype[
]b4_declare_yyerror_and_yylex[
]b4_declare_yyparse[
]b4_cpp_guard_close([b4_spec_mapped_header_file])[]dnl
])


# b4_header_include_if(IF-TRUE, IF-FALSE)
# ---------------------------------------
# Run IF-TRUE if we generate an output file and api.header.include
# is defined.
m4_define([b4_header_include_if],
[m4_ifval(m4_quote(b4_spec_header_file),
          [b4_percent_define_ifdef([[api.header.include]],
                                   [$1],
                                   [$2])],
          [$2])])

m4_if(b4_spec_header_file, [y.tab.h], [],
      [b4_percent_define_default([[api.header.include]],
                                 [["@basename(]b4_spec_header_file[@)"]])])

# superss unused variables

b4_percent_define_use([api.location.type])
b4_percent_define_use([parser.trace])
b4_percent_define_use([api.header.include])
m4_pushdef([b4_percent_code_bison_qualifiers(top)], [0])
m4_pushdef([b4_percent_code_bison_qualifiers(provides)], [0])
m4_pushdef([b4_percent_code_bison_qualifiers(epilogue)], [0])
m4_pushdef([b4_percent_code_bison_qualifiers(YYSTYPE_defaultValue)], [0])


## -------------- ##
## Output files.  ##
## -------------- ##

b4_output_begin([b4_parser_file_name])[
]b4_identification[
const std = @@import("std");

/// a comptime checking function to remind what type can use in YYSTYPE and what can not
fn ExternUnionType(comptime T: type) type {
    switch (@@typeInfo(T)) {
        .Bool, .Int, .Float => return T,

        .Pointer => |pinfo| {
            if (pinfo.size == .Slice) {
                @@compileError("slice is not supported, use pointer to slice instead");
            }
            return T;
        },

        .Array, .Struct, .Enum, .Union => return *allowzero T,

        .ComptimeInt, .ComptimeFloat, .Type, .Void, .NoReturn, .Undefined, .Null, .ErrorSet, .Fn, .Opaque, .Frame, .AnyFrame, .Vector, .EnumLiteral, .Optional, .ErrorUnion => {
            @@compileError("not supported type:" ++ @@typeName(T));
        },
    }
}
]b4_shared_declarations[
]b4_user_post_prologue[
]b4_attribute_define[
]b4_parse_error_bmatch([simple\|verbose],[[]],[[]])[
]b4_output_end
