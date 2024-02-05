                                                            -*- Autoconf -*-

# C M4 Macros for Bison.

# Copyright (C) 2002, 2004-2015, 2018-2021 Free Software Foundation,
# Inc.

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

m4_include(b4_skeletonsdir/[c-like.m4])

# b4_tocpp(STRING)
# ----------------
# Convert STRING into a valid C macro name.
m4_define([b4_tocpp],
[m4_toupper(m4_bpatsubst(m4_quote($1), [[^a-zA-Z0-9]+], [_]))])


# b4_cpp_guard(FILE)
# ------------------
# A valid C macro name to use as a CPP header guard for FILE.
m4_define([b4_cpp_guard],
[[YY_]b4_tocpp(m4_defn([b4_prefix])/[$1])[_INCLUDED]])


# b4_cpp_guard_open(FILE)
# b4_cpp_guard_close(FILE)
# ------------------------
# If FILE does not expand to nothing, open/close CPP inclusion guards for FILE.
m4_define([b4_cpp_guard_open],
[m4_ifval(m4_quote($1),
[#ifndef b4_cpp_guard([$1])
# define b4_cpp_guard([$1])])])

m4_define([b4_cpp_guard_close],
[m4_ifval(m4_quote($1),
[#endif b4_comment([!b4_cpp_guard([$1])])])])


## ---------------- ##
## Identification.  ##
## ---------------- ##

# b4_identification
# -----------------
# Depends on individual skeletons to define b4_pure_flag, b4_push_flag, or
# b4_pull_flag if they use the values of the %define variables api.pure or
# api.push-pull.
m4_define([b4_identification],
[[// /* Identify Bison output, and Bison version.  */
pub const YYBISON = ]b4_version[;

// /* Bison version string.  */
pub const YYBISON_VERSION = "]b4_version_string[";

// /* Skeleton name.  */
pub const YYSKELETON_NAME = ]b4_skeleton[;]m4_ifdef([b4_pure_flag], [[

// /* Pure parsers.  */
pub const YYPURE = ]b4_pure_flag])[;]m4_ifdef([b4_push_flag], [[

// /* Push parsers.  */
pub const YYPUSH = ]b4_push_flag])[;]m4_ifdef([b4_pull_flag], [[

// /* Pull parsers.  */
pub const YYPULL = ]b4_pull_flag])[;
]])


## ---------------- ##
## Default values.  ##
## ---------------- ##

# b4_api_prefix, b4_api_PREFIX
# ----------------------------
# Corresponds to %define api.prefix
b4_percent_define_default([[api.prefix]], [[yy]])
m4_define([b4_api_prefix],
[b4_percent_define_get([[api.prefix]])])
m4_define([b4_api_PREFIX],
[m4_toupper(b4_api_prefix)])


# b4_prefix
# ---------
# If the %name-prefix is not given, it is api.prefix.
m4_define_default([b4_prefix], [b4_api_prefix])

# If the %union is not named, its name is YYSTYPE.
b4_percent_define_default([[api.value.union.name]],
                          [b4_api_PREFIX[][STYPE]])

b4_percent_define_default([[api.symbol.prefix]], [[YYSYMBOL_]])

## ------------------------ ##
## Pure/impure interfaces.  ##
## ------------------------ ##

# b4_yylex_formals
# ----------------
# All the yylex formal arguments.
# b4_lex_param arrives quoted twice, but we want to keep only one level.
m4_define([b4_yylex_formals],
[b4_pure_if([[[b4_api_PREFIX[STYPE *yylvalp]], [[&yyctx.yylval]]][]dnl
b4_locations_if([, [b4_api_PREFIX[LTYPE *yyllocp], [&yyctx.yylloc]]])])dnl
])


# b4_yylex
# --------
# Call yylex.
m4_define([b4_yylex],
[b4_function_call([yylex], [int], b4_yylex_formals)])


# b4_user_args
# ------------
m4_define([b4_user_args],
[m4_ifset([b4_parse_param], [, b4_user_args_no_comma])])

# b4_user_args_no_comma
# ---------------------
m4_define([b4_user_args_no_comma],
[m4_ifset([b4_parse_param], [b4_args(b4_parse_param)])])


# b4_user_formals
# ---------------
# The possible parse-params formal arguments preceded by a comma.
m4_define([b4_user_formals],
[m4_ifset([b4_parse_param], [, b4_formals(b4_parse_param)])])


# b4_parse_param
# --------------
# If defined, b4_parse_param arrives double quoted, but below we prefer
# it to be single quoted.
m4_define([b4_parse_param],
b4_parse_param)


# b4_parse_param_for(DECL, FORMAL, BODY)
# ---------------------------------------
# Iterate over the user parameters, binding the declaration to DECL,
# the formal name to FORMAL, and evaluating the BODY.
m4_define([b4_parse_param_for],
[m4_foreach([$1_$2], m4_defn([b4_parse_param]),
[m4_pushdef([$1], m4_unquote(m4_car($1_$2)))dnl
m4_pushdef([$2], m4_shift($1_$2))dnl
$3[]dnl
m4_popdef([$2])dnl
m4_popdef([$1])dnl
])])


# b4_use(EXPR)
# ------------
# Pacify the compiler about some maybe unused value.
m4_define([b4_use],
[// YY_USE ($1)])

# b4_parse_param_use([VAL], [LOC])
# --------------------------------
# 'YY_USE' VAL, LOC if locations are enabled, and all the parse-params.
m4_define([b4_parse_param_use],
[m4_ifvaln([$1], [  b4_use([$1]);])dnl
b4_locations_if([m4_ifvaln([$2], [  b4_use([$2]);])])dnl
b4_parse_param_for([Decl], [Formal], [  b4_use(Formal);
])dnl
])


## ------------ ##
## Data Types.  ##
## ------------ ##

# b4_int_type(MIN, MAX)
# ---------------------
# Return a narrow int type able to handle integers ranging from MIN
# to MAX (included) in portable C code.  Assume MIN and MAX fall in
# 'int' range.
m4_define([b4_int_type],
[m4_if(b4_ints_in($@,   [-127],   [127]), [1], [signed char],
       b4_ints_in($@,      [0],   [255]), [1], [unsigned char],

       b4_ints_in($@, [-32767], [32767]), [1], [short],
       b4_ints_in($@,      [0], [65535]), [1], [unsigned short],

                                               [int])])

# b4_c99_int_type(MIN, MAX)
# -------------------------
# Like b4_int_type, but for C99.
# b4_c99_int_type_define replaces b4_int_type with this.
m4_define([b4_c99_int_type],
[m4_if(b4_ints_in($@,   [-127],   [127]), [1], [yytype_int8],
       b4_ints_in($@,      [0],   [255]), [1], [yytype_uint8],

       b4_ints_in($@, [-32767], [32767]), [1], [yytype_int16],
       b4_ints_in($@,      [0], [65535]), [1], [yytype_uint16],

                                               [int])])

# b4_c99_int_type_define
# ----------------------
# Define private types suitable for holding small integers in C99 or later.
m4_define([b4_c99_int_type_define],
[m4_copy_force([b4_c99_int_type], [b4_int_type])dnl
[]])


# b4_sizes_types_define
# ---------------------
# Define YYPTRDIFF_T/YYPTRDIFF_MAXIMUM, YYSIZE_T/YYSIZE_MAXIMUM,
# and YYSIZEOF.
m4_define([b4_sizes_types_define],
[[]])


# b4_int_type_for(NAME)
# ---------------------
# Return a narrow int type able to handle numbers ranging from
# 'NAME_min' to 'NAME_max' (included).
m4_define([b4_int_type_for],
[b4_int_type($1_min, $1_max)])


# b4_table_value_equals(TABLE, VALUE, LITERAL, SYMBOL)
# ----------------------------------------------------
# Without inducing a comparison warning from the compiler, check if the
# literal value LITERAL equals VALUE from table TABLE, which must have
# TABLE_min and TABLE_max defined.  SYMBOL denotes
m4_define([b4_table_value_equals],
[m4_if(m4_eval($3 < m4_indir([b4_]$1[_min])
               || m4_indir([b4_]$1[_max]) < $3), [1],
       [[0]],
       [(($2) == $4)])])


## ----------------- ##
## Compiler issues.  ##
## ----------------- ##

# b4_attribute_define([noreturn])
# -------------------------------
# Provide portable compiler "attributes".  If "noreturn" is passed, define
# _Noreturn.
m4_define([b4_attribute_define],
[[
]m4_bmatch([$1], [\bnoreturn\b], [[/* The _Noreturn keyword of C11.  */
]dnl This is close to lib/_Noreturn.h, except that we do enable
dnl the use of [[noreturn]], because _Noreturn is used in places
dnl where [[noreturn]] works in C++.  We need this in particular
dnl because of glr.cc which compiles code from glr.c in C++.
dnl And the C++ compiler chokes on _Noreturn.  Also, we do not
dnl use C' _Noreturn in C++, to avoid -Wc11-extensions warnings.
[#ifndef _Noreturn
# if (defined __cplusplus \
      && ((201103 <= __cplusplus && !(__GNUC__ == 4 && __GNUC_MINOR__ == 7)) \
          || (defined _MSC_VER && 1900 <= _MSC_VER)))
#  define _Noreturn [[noreturn]]
# elif ((!defined __cplusplus || defined __clang__) \
        && (201112 <= (defined __STDC_VERSION__ ? __STDC_VERSION__ : 0) \
            || (!defined __STRICT_ANSI__ \
                && (4 < __GNUC__ + (7 <= __GNUC_MINOR__) \
                    || (defined __apple_build_version__ \
                        ? 6000000 <= __apple_build_version__ \
                        : 3 < __clang_major__ + (5 <= __clang_minor__))))))
   /* _Noreturn works as-is.  */
# elif (2 < __GNUC__ + (8 <= __GNUC_MINOR__) || defined __clang__ \
        || 0x5110 <= __SUNPRO_C)
#  define _Noreturn __attribute__ ((__noreturn__))
# elif 1200 <= (defined _MSC_VER ? _MSC_VER : 0)
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn
# endif
#endif

]])[
]])


# b4_cast_define
# --------------
m4_define([b4_cast_define], [])


# b4_null_define
# --------------
# Portability issues: define a YY_NULLPTR appropriate for the current
# language (C, C++98, or C++11).
#
# In C++ pre C++11 it is standard practice to use 0 (not NULL) for the
# null pointer.  In C, prefer ((void*)0) to avoid having to include stdlib.h.
m4_define([b4_null_define], [])


# b4_null
# -------
# Return a null pointer constant.
m4_define([b4_null], [YY_NULLPTR])



## ---------##
## Values.  ##
## ---------##

# b4_integral_parser_table_define(TABLE-NAME, CONTENT, COMMENT)
# -------------------------------------------------------------
# Define "yy<TABLE-NAME>" whose contents is CONTENT.
m4_define([b4_integral_parser_table_define],
[m4_ifvaln([$3], [b4_comment([$3])])dnl
pub const yy$1[] = [[_]]isize{
  $2
};dnl
])


## ------------- ##
## Token kinds.  ##
## ------------- ##

# Because C enums are not scoped, because tokens are exposed in the
# header, and because these tokens are common to all the parsers, we
# need to make sure their names don't collide: use the api.prefix.
# YYEOF is special, since the user may give it a different name.
m4_define([b4_symbol(-2, id)],  [b4_api_PREFIX[][EMPTY]])
m4_define([b4_symbol(-2, tag)], [[No symbol.]])

m4_if(b4_symbol(eof, id), [YYEOF],
     [m4_define([b4_symbol(0, id)],  [b4_api_PREFIX[][EOF]])])
m4_define([b4_symbol(1, id)],  [b4_api_PREFIX[][error]])
m4_define([b4_symbol(2, id)],  [b4_api_PREFIX[][UNDEF]])


# b4_token_define(TOKEN-NUM)
# --------------------------
# Output the definition of this token as #define.
m4_define([b4_token_define],
[b4_token_format([#define %s %s], [$1])])

# b4_token_defines
# ----------------
# Output the definition of the tokens.
m4_define([b4_token_defines],
[[/* Token kinds.  */
#define ]b4_symbol(empty, [id])[ -2
]m4_join([
], b4_symbol_map([b4_token_define]))
])


# b4_token_enum(TOKEN-NUM)
# ------------------------
# Output the definition of this token as an enum.
m4_define([b4_token_enum],
[b4_token_visible_if([$1],
    [m4_format([    %-30s %s],
               m4_format([[%s = %s%s%s]],
                         b4_symbol([$1], [id]),
                         b4_symbol([$1], b4_api_token_raw_if([[number]], [[code]])),
                         m4_if([$1], b4_last_enum_token, [], [[,]])),
               [b4_symbol_tag_comment([$1])])])])


# b4_token_enums
# --------------
# The definition of the token kinds.
m4_define([b4_token_enums],
[b4_any_token_visible_if([[// /* Token kinds.  */
pub const ]b4_api_prefix[token_kind_t = enum(i32) {
    ]b4_symbol(empty, [id])[ = -2,
]b4_symbol_foreach([b4_token_enum])dnl
[  };
]])])


# b4_token_enums_defines
# ----------------------
# The definition of the tokens (if there are any) as enums and,
# if POSIX Yacc is enabled, as #defines.
m4_define([b4_token_enums_defines],
[b4_token_enums[]b4_yacc_if([b4_token_defines])])


# b4_symbol_translate(STRING)
# ---------------------------
# Used by "bison" in the array of symbol names to mark those that
# require translation.
m4_define([b4_symbol_translate],
[[N_($1)]])



## -------------- ##
## Symbol kinds.  ##
## -------------- ##

# b4_symbol_enum(SYMBOL-NUM)
# --------------------------
# Output the definition of this symbol as an enum.
m4_define([b4_symbol_enum],
[m4_format([  %-40s %s],
           m4_format([[%s = %s%s%s]],
                     b4_symbol([$1], [kind_base]),
                     [$1],
                     m4_if([$1], b4_last_symbol, [], [[,]])),
           [b4_symbol_tag_comment([$1])])])


# b4_declare_symbol_enum
# ----------------------
# The definition of the symbol internal numbers as an enum.
# Defining YYEMPTY here is important: it forces the compiler
# to use a signed type, which matters for yytoken.
m4_define([b4_declare_symbol_enum],
[[// /* Symbol kind.  */
pub const yysymbol_kind_t = enum(i32)
{
  ]b4_symbol(empty, [kind_base])[ = -2,
]b4_symbol_foreach([b4_symbol_enum])dnl
[};]])])


## ----------------- ##
## Semantic Values.  ##
## ----------------- ##


# b4_symbol_value(VAL, [SYMBOL-NUM], [TYPE-TAG])
# ----------------------------------------------
# See README.
m4_define([b4_symbol_value],
[m4_ifval([$3],
          [($1.$3)],
          [m4_ifval([$2],
                    [b4_symbol_if([$2], [has_type],
                                  [($1.b4_symbol([$2], [type]))],
                                  [$1])],
                    [$1])])])


## ---------------------- ##
## Defining C functions.  ##
## ---------------------- ##


# b4_formals([DECL1, NAME1], ...)
# -------------------------------
# The formal arguments of a C function definition.
m4_define([b4_formals],
[m4_if([$#], [0], [void],
       [$#$1], [1], [void],
               [m4_map_sep([b4_formal], [, ], [$@])])])

m4_define([b4_formal],
[$1])


m4_define([b4_formals_struct],
[m4_if([$#], [0], [void],
       [$#$1], [1], [void],
               [m4_map_sep([b4_formal_struct], [, ], [$@])])])

m4_define([b4_formal_struct],
[$1 = undefined])


# b4_function_declare(NAME, RETURN-VALUE, [DECL1, NAME1], ...)
# ------------------------------------------------------------
# Declare the function NAME.
m4_define([b4_function_declare],
[$2 $1 (b4_formals(m4_shift2($@)));[]dnl
])



## --------------------- ##
## Calling C functions.  ##
## --------------------- ##


# b4_function_call(NAME, RETURN-VALUE, [DECL1, NAME1], ...)
# -----------------------------------------------------------
# Call the function NAME with arguments NAME1, NAME2 etc.
m4_define([b4_function_call],
[$1 (b4_args(m4_shift2($@)))[]dnl
])


# b4_args([DECL1, NAME1], ...)
# ----------------------------
# Output the arguments NAME1, NAME2...
m4_define([b4_args],
[m4_map_sep([b4_arg], [, ], [$@])])

m4_define([b4_arg],
[$2])


## ----------- ##
## Synclines.  ##
## ----------- ##

# b4_sync_start(LINE, FILE)
# -------------------------
m4_define([b4_sync_start], [[#]line $1 $2])


## -------------- ##
## User actions.  ##
## -------------- ##

# b4_case(LABEL, STATEMENTS, [COMMENTS])
# --------------------------------------
m4_define([b4_case],
[  $1=>]{[m4_ifval([$3], [ b4_comment([$3])])
$2
b4_syncline([@oline@], [@ofile@])dnl
    ]}[,])


# b4_predicate_case(LABEL, CONDITIONS)
# ------------------------------------
m4_define([b4_predicate_case],
[  case $1:
    if (! (
$2)) YYERROR;
b4_syncline([@oline@], [@ofile@])dnl
    break;])


# b4_yydestruct_define
# --------------------
# Define the "yydestruct" function.
m4_define_default([b4_yydestruct_define],
[[// /*-----------------------------------------------.
// | Release the memory associated to this symbol.  |
// `-----------------------------------------------*/

pub fn yydestruct (yyctx: *yyparse_context_t, yymsg: []const u8,
            yykind: isize, yyvaluep: *YYSTYPE]b4_locations_if(dnl
[[, yylocationp: *YYLTYPE]])[][)
void {
][_ = yylocationp;
    YY_SYMBOL_PRINT(yyctx, yymsg, @@enumFromInt(yykind));

  ]b4_symbol_actions([destructor])[
}]dnl
])


# b4_yy_symbol_print_define
# -------------------------
# Define the "yy_symbol_print" function.
m4_define_default([b4_yy_symbol_print_define],
[[
// /*-----------------------------------.
// | Print this symbol's value on YYO.  |
// `-----------------------------------*/

pub fn yy_symbol_value_print (
  yyo: std.fs.File,
  yykind: isize,
  yyvaluep: *const YYSTYPE]b4_locations_if(dnl
[[, yylocationp: *const YYLTYPE]])[][) !void {
   ]b4_locations_if([[_ = yylocationp;]])[
   ][  // if (yyvaluep == null) return;]
   b4_percent_code_get([[pre-printer]])dnl
   b4_symbol_actions([printer])
   b4_percent_code_get([[post-printer]])dnl
[}


// /*---------------------------.
// | Print this symbol on YYO.  |
// `---------------------------*/

pub fn yy_symbol_print (yyo: std.fs.File,
                  yykind: isize, yyvaluep: *const YYSTYPE]b4_locations_if(dnl
[[, yylocationp: *const YYLTYPE]])[][) !void {
  try yyo.writer().print("{s} {s} (", .{
      if (yykind < YYNTOKENS) "token" else "nterm",
      yysymbol_name(@@enumFromInt(yykind)),
  });
]b4_locations_if([  try yy_location_print_(yyo, yylocationp);
  try yyo.writer().print(": ", .{});
])dnl
[  try yy_symbol_value_print (yyo, yykind, yyvaluep]dnl
b4_locations_if([, yylocationp])[][);
  try yyo.writer().print(")", .{});
}]dnl
])


## ---------------- ##
## api.value.type.  ##
## ---------------- ##


# ---------------------- #
# api.value.type=union.  #
# ---------------------- #

# b4_symbol_type_register(SYMBOL-NUM)
# -----------------------------------
# Symbol SYMBOL-NUM has a type (for variant) instead of a type-tag.
# Extend the definition of %union's body (b4_union_members) with a
# field of that type, and extend the symbol's "type" field to point to
# the field name, instead of the type name.
m4_define([b4_symbol_type_register],
[m4_define([b4_symbol($1, type_tag)],
           [b4_symbol_if([$1], [has_id],
                         [b4_symbol([$1], [id])],
                         [yykind_[]b4_symbol([$1], [number])])])dnl
m4_append([b4_union_members],
m4_expand([m4_format([  %-40s ,%s],
                     m4_expand([b4_symbol([$1], [type_tag]): b4_symbol([$1], [type])]),
                     [b4_symbol_tag_comment([$1])])]))
])


# b4_type_define_tag(SYMBOL1-NUM, ...)
# ------------------------------------
# For the batch of symbols SYMBOL1-NUM... (which all have the same
# type), enhance the %union definition for each of them, and set
# there "type" field to the field tag name, instead of the type name.
m4_define([b4_type_define_tag],
[b4_symbol_if([$1], [has_type],
              [m4_map([b4_symbol_type_register], [$@])])
])


# b4_symbol_value_union(VAL, SYMBOL-NUM, [TYPE])
# ----------------------------------------------
# Same of b4_symbol_value, but when api.value.type=union.
m4_define([b4_symbol_value_union],
[m4_ifval([$3],
          [(*($3*)(&$1))],
          [m4_ifval([$2],
                    [b4_symbol_if([$2], [has_type],
                                  [($1.b4_symbol([$2], [type_tag]))],
                                  [$1])],
                    [$1])])])


# b4_value_type_setup_union
# -------------------------
# Setup support for api.value.type=union.  Symbols are defined with a
# type instead of a union member name: build the corresponding union,
# and give the symbols their tag.
m4_define([b4_value_type_setup_union],
[m4_define([b4_union_members])
b4_type_foreach([b4_type_define_tag])
m4_copy_force([b4_symbol_value_union], [b4_symbol_value])
])


# -------------------------- #
# api.value.type = variant.  #
# -------------------------- #

# b4_value_type_setup_variant
# ---------------------------
# Setup support for api.value.type=variant.  By default, fail, specialized
# by other skeletons.
m4_define([b4_value_type_setup_variant],
[b4_complain_at(b4_percent_define_get_loc([[api.value.type]]),
                [['%s' does not support '%s']],
                [b4_skeleton],
                [%define api.value.type variant])])


# _b4_value_type_setup_keyword
# ----------------------------
# api.value.type is defined with a keyword/string syntax.  Check if
# that is properly defined, and prepare its use.
m4_define([_b4_value_type_setup_keyword],
[b4_percent_define_check_values([[[[api.value.type]],
                                  [[none]],
                                  [[union]],
                                  [[union-directive]],
                                  [[variant]],
                                  [[yystype]]]])dnl
m4_case(b4_percent_define_get([[api.value.type]]),
        [union],   [b4_value_type_setup_union],
        [variant], [b4_value_type_setup_variant])])


# b4_value_type_setup
# -------------------
# Check if api.value.type is properly defined, and possibly prepare
# its use.
b4_define_silent([b4_value_type_setup],
[# Define default value.
b4_percent_define_ifdef([[api.value.type]], [],
[# %union => api.value.type=union-directive
m4_ifdef([b4_union_members],
[m4_define([b4_percent_define_kind(api.value.type)], [keyword])
m4_define([b4_percent_define(api.value.type)], [union-directive])],
[# no tag seen => api.value.type={int}
m4_if(b4_tag_seen_flag, 0,
[m4_define([b4_percent_define_kind(api.value.type)], [code])
m4_define([b4_percent_define(api.value.type)], [int])],
[# otherwise api.value.type=yystype
m4_define([b4_percent_define_kind(api.value.type)], [keyword])
m4_define([b4_percent_define(api.value.type)], [yystype])])])])

# Set up.
m4_bmatch(b4_percent_define_get_kind([[api.value.type]]),
   [keyword\|string], [_b4_value_type_setup_keyword])
])


## -------------- ##
## Declarations.  ##
## -------------- ##


# b4_value_type_define
# --------------------
m4_define([b4_value_type_define],
[b4_value_type_setup[]dnl
// /* Value type.  */
m4_bmatch(b4_percent_define_get_kind([[api.value.type]]),
[code],
[[#if ! defined ]b4_api_PREFIX[STYPE && ! defined ]b4_api_PREFIX[STYPE_IS_DECLARED
typedef ]b4_percent_define_get([[api.value.type]])[ ]b4_api_PREFIX[STYPE;
# define ]b4_api_PREFIX[STYPE_IS_TRIVIAL 1
# define ]b4_api_PREFIX[STYPE_IS_DECLARED 1
#endif
]],
[m4_bmatch(b4_percent_define_get([[api.value.type]]),
[union\|union-directive],
[dnl
[pub const ]b4_percent_define_get([[api.value.union.name]])[ = YYLexer.YYSTYPE;
]dnl
])])])

# [pub const ]b4_percent_define_get([[api.value.union.name]])[ = union ][
# {
# ]b4_user_union_members[
# };

# b4_location_type_define
# -----------------------
m4_define([b4_location_type_define],
[[// /* Location type.  */
]b4_percent_define_ifdef([[api.location.type]],
[[const YYLTYPE =]b4_percent_define_get([[api.location.type]])[;
]],
[[const YYLTYPE =]b4_percent_define_get([[api.location.type]])[;
]])])


# b4_declare_yylstype
# -------------------
# Declarations that might either go into the header (if --header) or
# in the parser body.  Declare YYSTYPE/YYLTYPE, and yylval/yylloc.
m4_define([b4_declare_yylstype],
[b4_value_type_define[]b4_locations_if([
b4_location_type_define])

b4_pure_if([], [[extern ]b4_api_PREFIX[STYPE ]b4_prefix[lval;
]b4_locations_if([[extern ]b4_api_PREFIX[LTYPE ]b4_prefix[lloc;]])])[]dnl
])


# b4_YYDEBUG_define
# -----------------
m4_define([b4_YYDEBUG_define],
[[// /* Debug traces.  */
]m4_if(b4_api_prefix, [yy],
[[const YYDEBUG = ]b4_parse_trace_if([1], [0])[;
]],
[[const YYDEBUG = ]b4_parse_trace_if([1], [0])[;
]])[]dnl
])

# b4_declare_yydebug
# ------------------
m4_define([b4_declare_yydebug],
[b4_YYDEBUG_define[]b4_parse_trace_if([
pub var ]b4_prefix[debug: bool = YYDEBUG == 1;
], [])[]dnl
])

# b4_yylloc_default_define
# ------------------------
# Define YYLLOC_DEFAULT.
m4_define([b4_yylloc_default_define],
[[// /* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
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
]])

# b4_yylocation_print_define
# --------------------------
# Define YYLOCATION_PRINT.
m4_define([b4_yylocation_print_define],
[b4_locations_if([[
// /* Print *YYLOCP on YYO.  Private, do not rely on its existence. */
fn yy_location_print_ (yyo: std.fs.File, yylocp: *const YYLTYPE) !void {
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
        }
      else if (0 <= end_col and yylocp.first_column < end_col) {
        try yyo.writer().print("-{d}", .{end_col});
      }
    }
  }
}
]])])

# b4_yyloc_default
# ----------------
# Expand to a possible default value for yylloc.
m4_define([b4_yyloc_default],
[[{ .first_line = 1, .first_column = 1, .last_line = 1, .last_column = 1, }]])
