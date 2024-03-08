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
m4_include(b4_skeletonsdir/[zig-builtin.m4])


## ---------- ##
## api.pure.  ##
## ---------- ##

b4_percent_define_default([[api.pure]], [[full]])
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
[b4_symbol_value([valueWithOffset(yyctx.yyvsp, b4_subtract([$2], [$1]))], [$3], [$4])])


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
[[
// Return type when parsing one ]_b4_symbol($1, tag)[.
typedef struct
{]b4_symbol_if([$1], [has_type], [[
  ]_b4_symbol($1, type)[ yyvalue;]])[
  int yystatus;
  int yynerrs;
} ]b4_prefix[parse_]_b4_symbol($1, id)[_t;

// Parse one ]_b4_symbol($1, tag)[.
]b4_prefix[parse_]_b4_symbol($1, id)[_t ]b4_prefix[parse_]_b4_symbol($1, id)[ (]m4_ifset([b4_parse_param], [b4_formals(b4_parse_param)], [void])[);
]])


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
[[
]b4_prefix[parse_]_b4_symbol($1, id)[_t
]b4_prefix[parse_]_b4_symbol($1, id)[ (]m4_ifset([b4_parse_param], [b4_formals(b4_parse_param)], [void])[)
{
  ]b4_prefix[parse_]_b4_symbol($1, id)[_t yyres;
  yy_parse_impl_t yyimpl;
  yyres.yystatus = yy_parse_impl (]b4_symbol($2, id)[, &yyimpl]m4_ifset([b4_parse_param],
                           [[, ]b4_args(b4_parse_param)])[);]b4_symbol_if([$1], [has_type], [[
  yyres.yyvalue = yyimpl.yyvalue.]b4_symbol($1, slot)[;]])[
  yyres.yynerrs = yyimpl.yynerrs;
  return yyres;
}
]])


# b4_declare_scanner_communication_variables
# ------------------------------------------
# Declare the variables that are global, or local to YYPARSE if
# pure-parser.
m4_define([b4_declare_scanner_communication_variables], [[
]m4_ifdef([b4_start_symbols], [],
[[// /* Lookahead token kind.  */
yychar: isize = yytoken_kind_t.]b4_symbol(empty, id)[, // /* Cause a token to be read.  */
]])[
]b4_pure_if([[
// /* The semantic value of the lookahead symbol.  */
// /* Default value used for initialization, for pacifying older GCCs
//    or non-GCC compilers.  */
yyval_default: YYSTYPE = undefined,
yylval: YYSTYPE = undefined,
]b4_locations_if([[

// /* Location data for the lookahead symbol.  */
yyloc_default: YYLTYPE = YYLTYPE]b4_yyloc_default[,
yylloc: YYLTYPE = YYLTYPE]b4_yyloc_default[,]])],
[[// /* The semantic value of the lookahead symbol.  */
yylval: YYSTYPE,]b4_locations_if([[
// /* Location data for the lookahead symbol.  */
yylloc: YYLTYPE,]b4_yyloc_default[]])[
// /* Number of syntax errors so far.  */
yynerrs: usize ,]])])


# b4_declare_parser_state_variables([INIT])
# -----------------------------------------
# Declare all the variables that are needed to maintain the parser state
# between calls to yypush_parse.
# If INIT is non-null, initialize these variables.
m4_define([b4_declare_parser_state_variables],
[b4_pure_if([[
    // /* Number of syntax errors so far.  */
    yynerrs: usize]m4_ifval([$1], [ = 0])[,
]])[
    yystate: yy_state_fast_t]m4_ifval([$1], [ = 0])[,
    // /* Number of tokens to shift before error messages enabled.  */
    yyerrstatus: usize]m4_ifval([$1], [ = 0])[,

    // /* Refer to the stacks through separate pointers, to allow yyoverflow
    //    to reallocate them elsewhere.  */

    // /* Their size.  */
    yystacksize: usize]m4_ifval([$1], [ = YYINITDEPTH])[,
    yystack_alloc_size: usize = 0,

    // /* The state stack: array, bottom, top.  */
    yyssa: [YYINITDEPTH]yy_state_t = undefined,
    yyss: [*]yy_state_t = undefined, // need init to ]m4_ifval([$1], [ = yyssa])[;
    yyssp: [*]yy_state_t = undefined, // need init to ]m4_ifval([$1], [ = yyss])[;

    // /* The semantic value stack: array, bottom, top.  */
    yyvsa: [YYINITDEPTH]YYSTYPE = undefined,
    yyvs: [*]YYSTYPE = undefined, // need init to ]m4_ifval([$1], [ = yyvsa])[;
    yyvsp: [*]YYSTYPE = undefined, // need init to ]m4_ifval([$1], [ = yyvs])[;]b4_locations_if([[

    // /* The location stack: array, bottom, top.  */
    yylsa: [YYINITDEPTH]YYLTYPE = undefined,
    yyls: [*]YYLTYPE = undefined, // need init to ]m4_ifval([$1], [ = yylsa])[;
    yylsp: [*]YYLTYPE = undefined, // need init to ]m4_ifval([$1], [ = yyls])[;]])[]b4_lac_if([[

    yyesa: @{]b4_percent_define_get([[parse.lac.es-capacity-initial]])[@}yy_state_t,
    yyes: *yy_state_t, // need init to ]m4_ifval([$1], [ = yyesa])[;
    yyes_capacity: usize = ][]m4_ifval([$1],
            [m4_do([ = b4_percent_define_get([[parse.lac.es-capacity-initial]]) < YYMAXDEPTH],
                   [ ? b4_percent_define_get([[parse.lac.es-capacity-initial]])],
                   [ : YYMAXDEPTH])])[,]])])


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
m4_define([_b4_declare_yyparse_push],
[[const YYPUSH_MORE = 4;]])


# _b4_declare_yyparse
# -------------------
# When not the push parser.
m4_define([_b4_declare_yyparse],[]m4_ifdef([b4_start_symbols],
          [m4_map([_b4_declare_sub_yyparse], m4_defn([b4_start_symbols]))]))


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
[b4_posix_if([[// #if !defined ]b4_prefix[error && !defined ]b4_api_PREFIX[ERROR_IS_DECLARED
// ]b4_function_declare([b4_prefix[error]], void, b4_yyerror_formals)[
// #endif
// #if !defined ]b4_prefix[lex && !defined ]b4_api_PREFIX[LEX_IS_DECLARED
// ]b4_function_declare([b4_prefix[lex]], int, b4_yylex_formals)[
// #endif
]])dnl
])


# b4_shared_declarations
# ----------------------
# Declarations that might either go into the header (if --header)
# or into the implementation file.
# ]b4_percent_code_get([[requires]])[
m4_define([b4_shared_declarations],
[b4_cpp_guard_open([b4_spec_mapped_header_file])[
]b4_declare_yydebug[
]m4_define([b4_percent_code_bison_qualifiers(requires)])[
pub const yytoken_kind_t = zlexison.yytoken_kind_t;

]b4_declare_yylstype[
]b4_declare_yyerror_and_yylex[
]b4_declare_yyparse[
]b4_percent_code_get([[provides]])[
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


## -------------- ##
## main fn        ##
## -------------- ##
m4_define([b4_main_fn], m4_ifdef([z4_need_main], [[
pub fn main() !u8 {
    @compileError("Please copy this function to your parser.y and adapt to your need!");

    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    var f: std.fs.File = brk: {
        if (args.len > 1) {
            break :brk try std.fs.cwd().openFile(args[[1]], .{});
        } else {
            break :brk std.io.getStdIn();
        }
    };
    defer f.close();

    const stdout_writer = std.io.getStdOut().writer();

    var line = std.ArrayList(u8).init(arena);
    defer line.deinit();
    const line_writer = line.writer();
    var buf_f_reader = std.io.bufferedReader(f.reader());
    const f_reader = buf_f_reader.reader();

    YYParser.yydebug = true;

    while (f_reader.streamUntilDelimiter(line_writer, '\n', null)) {
      defer line.clearRetainingCapacity();
      try line.append('\n');

      var res: Result = Result{};
      try stdout_writer.print("read {d}bytes\n", .{line.items.len});

      var scanner = YYLexer{ .allocator = arena };
      YYLexer.context = YYLexer.Context.init(arena);
      defer YYLexer.context.deinit();

      try YYLexer.yylex_init(&scanner);
      defer YYLexer.yylex_destroy(&scanner);

      _ = try YYLexer.yy_scan_string(line.items, scanner.yyg);

      _ = try YYParser.yyparse(arena, &scanner, &res);

      std.debug.print("{any}\n", .{res});
    } else |err| switch(err) {
      error.EndOfStream => {},
      else => return err,
    }

    return 0;
}
]], []))


## -------------- ##
## Output files.  ##
## -------------- ##


b4_header_if([[
]b4_output_begin([b4_spec_header_file])[
]b4_copyright([Bison interface for Yacc-like parsers in C])[
]b4_disclaimer[
]b4_shared_declarations[
]b4_output_end[
]])# b4_header_if

b4_output_begin([b4_parser_file_name])[
]b4_copyright([Bison implementation for Yacc-like parsers in C])[
]b4_disclaimer[
]b4_identification[
const std = @@import("std");
const Self = @@This();
const YYParser = @@This();
const zlexison = @@import("zlexison.zig");

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

inline fn valueWithOffset(p: anytype, offset: isize) @@typeInfo(@@TypeOf(p)).Pointer.child {
    const PChildType = @@typeInfo(@@TypeOf(p)).Pointer.child;
    return arrPtrWithOffset(PChildType, p, offset)[0];
}

inline fn arrPtrWithOffset(comptime T: type, p: [*]allowzero T, offset: isize) [*]allowzero T {
    if (@@intFromPtr(p) == 0) {
        return @@ptrFromInt(0);
    } else {
        return @@as([*]allowzero T, @@ptrFromInt(@@as(usize, @@intCast(@@as(isize, @@intCast(@@intFromPtr(p))) + offset * @@sizeOf(T)))));
    }
}

inline fn movePtr(p: anytype, offset: isize) @@TypeOf(p) {
    const PType = @@typeInfo(@@TypeOf(p)).Pointer.child;
    return @@ptrFromInt(@@as(usize, @@intCast((@@as(isize, @@intCast(@@intFromPtr(p))) + offset * @@sizeOf(PType)))));
}
]b4_percent_code_get([[top]])[]dnl
b4_user_pre_prologue[
]b4_cast_define[
]b4_null_define[

]b4_header_include_if([[#include ]b4_percent_define_get([[api.header.include]])],
                      [m4_ifval(m4_quote(b4_spec_header_file),
                                [/* Use api.header.include to #include this header
   instead of duplicating it here.  */
])b4_shared_declarations])[
]b4_declare_symbol_enum[

]b4_user_post_prologue[
]b4_percent_code_get[
]b4_c99_int_type_define[

]b4_sizes_types_define[

const YYSIZE_MAXIMUM = std.math.maxInt(usize);
const YYSTACK_ALLOC_MAXIMUM = YYSIZE_MAXIMUM;

// /* Stored state numbers (used for stacks). */
pub const yy_state_t = isize;

// /* State numbers in computations.  */
const yy_state_fast_t = isize;
][

]b4_attribute_define[

]b4_parse_assert_if([[
const YY_ASSERT = std.debug.assert;
]],
[[
const YY_ASSERT = std.debug.assert;]])[

][]dnl
b4_push_if([], [b4_lac_if([], [[
]])])[
]b4_lac_if([[
// # define YYCOPY_NEEDED 1]])[

// /* A type that is properly aligned for any stack member.  */
pub const yyalloc = union {
  yyss_alloc: yy_state_t,
  yyvs_alloc: YYSTYPE,]b4_locations_if([
  yyls_alloc: YYLTYPE,])[
};

fn YYSTACK_ALLOC(yyctx: *yyparse_context_t, size: usize) ![*]yyalloc {
    var yyalloc_array = try yyctx.allocator.alloc(yyalloc, size);
    yyctx.yystack_alloc_size = size;
    _ = &yyalloc_array;
    return yyalloc_array.ptr;
}

// /* The size of the maximum gap between one aligned stack and the next.  */
const YYSTACK_GAP_MAXIMUM = ]@@sizeOf[(yyalloc) - 1;

// /* The size of an array large to enough to hold all stacks, each with
//    N elements.  */
]b4_locations_if([fn YYSTACK_BYTES(N: usize) usize {
    return N * (@@sizeOf(yy_state_t) + @@sizeOf(YYSTYPE) + @@sizeOf(YYLTYPE)) + 2 * YYSTACK_GAP_MAXIMUM;
}],
[fn YYSTACK_BYTES(N: usize) usize {
    return N * (@@sizeOf(yy_state_t) + @@sizeOf(YYSTYPE)) + YYSTACK_GAP_MAXIMUM;
}])[

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
            yynewbytes = yyctx.yystacksize * @@sizeOf(yyalloc) + YYSTACK_GAP_MAXIMUM;
        },
        .yyvs => {
            YYCOPY(YYSTYPE, .yyvs, yyptr, yyctx.yyvs, yysize);
            yyctx.yyvs[0] = yyptr[0].yyvs_alloc;
            yynewbytes = yyctx.yystacksize * @@sizeOf(yyalloc) + YYSTACK_GAP_MAXIMUM;
        },
        .yyls => {
            YYCOPY(YYLTYPE, .yyls, yyptr, yyctx.yyls, yysize);
            yyctx.yyls[0] = yyptr[0].yyls_alloc;
            yynewbytes = yyctx.yystacksize * @@sizeOf(yyalloc) + YYSTACK_GAP_MAXIMUM;
        },
    }
    yyptr_.* = @@ptrCast(yyptr + yynewbytes / @@sizeOf(*yyalloc));
}

// /* Copy COUNT objects from SRC to DST.  The source and destination do
//    not overlap.  */
fn YYCOPY(comptime T: type, comptime field: enum { yyss, yyvs, yyls }, dst: [*]yyalloc, src: [*]T, count: usize) void {
    switch (field) {
        .yyss => {
            for (0..count) |i| dst[i].yyss_alloc = src[i];
        },
        .yyvs => {
            for (0..count) |i| dst[i].yyvs_alloc = src[i];
        },
        .yyls => {
            for (0..count) |i| dst[i].yyls_alloc = src[i];
        },
    }
}

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

// /* YYMAXUTOK -- Last valid token kind.  */
const YYMAXUTOK = ]b4_code_max[;


// /* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex, with out-of-bounds checking.  */
]b4_api_token_raw_if(dnl
[[// #define YYTRANSLATE(YYX) YY_CAST (yysymbol_kind_t, YYX)
fn YYTRANSLATE(YYX: anytype) isize {
    return YYX;
}
]],
[[fn YYTRANSLATE(YYX: anytype) isize {
    if (YYX >= 0 and YYX <= YYMAXUTOK) {
        return yytranslate[YYX];
    } else {
        return yysymbol_kind_t.]b4_symbol_prefix[YYUNDEF;
    }
}

// /* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex.  */
const yytranslate = [_]]isize[{
  ]b4_translate[
};]])[

]b4_integral_parser_table_define([rline], [b4_rline],
     [[YYRLINE[YYN] -- Source line where rule number YYN was defined.]])[

// /** Accessing symbol of state STATE.  */
inline fn YY_ACCESSING_SYMBOL(index: usize) isize {
    return yystos[index];
}

// /* The user-facing name of the symbol whose (internal) number is
//    YYSYMBOL.  No bounds checking.  */
]b4_parse_error_bmatch([simple\|verbose],
[[// /* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
//    First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
const YY_NULLPTR = "";

const yytname = [_][]const u8 {
  ]b4_tname[
};

fn yysymbol_name(yysymbol: isize) []const u8 {
    return yytname[@@intCast(yysymbol)];
}]],
[[
  const YY_NULLPTR = "";

  fn yysymbol_name(yysymbol: isize) []const u8 {
  const yy_sname = [_][]const u8 {
  ]b4_symbol_names[
  };]b4_has_translations_if([[
  // /* YYTRANSLATABLE[SYMBOL-NUM] -- Whether YY_SNAME[SYMBOL-NUM] is
  //    internationalizable.  */
  // TODO: find a case to test this
  static ]b4_int_type_for([b4_translatable])[ yytranslatable[] =
  {
  ]b4_translatable[
  };
  return (yysymbol < YYNTOKENS && yytranslatable[yysymbol]
          ? _(yy_sname[yysymbol])
          : yy_sname[yysymbol]);]], [[
  return yy_sname[@@intCast(yysymbol)];]])[
}]])[

const YYPACT_NINF = ]b4_pact_ninf[;

inline fn yypact_value_is_default(yyn: anytype) bool {
  // TODO: check for all case
  // #define yypact_value_is_default(Yyn) \
  //  ]b4_table_value_equals([[pact]], [[Yyn]], [b4_pact_ninf], [YYPACT_NINF])[
    return yyn == YYPACT_NINF;
}

const YYTABLE_NINF = ]b4_table_ninf[;

fn yytable_value_is_error(Yyn: anytype) bool {
  // TODO: check for all case
  // #define yytable_value_is_error(Yyn) \
  //   ]b4_table_value_equals([[table]], [[Yyn]], [b4_table_ninf], [YYTABLE_NINF])[
  _ = Yyn;
  return false;
}

]b4_parser_tables_define[

const YYENOMEM = -2;

// TODO: a case really YYBACKUP?
fn YYBACKUP(yyctx: *yyparse_context_t, token: u8, value: c_int) usize {
  if (yyctx.yychar == yytoken_kind_t.]b4_symbol(empty, id)[) {
    yyctx.yychar = token;
    yyctx.yylval = value;
    yyctx.YYPOPSTACK(yyctx.yylen);
    yyctx.yystate = yyctx.yyssp.*;]b4_lac_if([[
      YY_LAC_DISCARD ("YYBACKUP");]])[
        return LABEL_YYBACKUP;
    } else {
        std.debug.print("syntax error: cannot back up", .{});
        yyctx.result.nerrs += 1;
        return LABEL_YYERRORLAB;
    }
}

]b4_locations_if([[
]b4_yylloc_default_define[
]])[
]b4_yylocation_print_define[

fn YY_SYMBOL_PRINT(title: []const u8, token: isize, yyval: *const YYSTYPE, yyloc: *const YYLTYPE) !void {
    if (yydebug) {
        std.debug.print("{s}: ", .{title});
        try yy_symbol_print(std.io.getStdErr(), token, yyval, yyloc);
        std.debug.print("\n", .{});
    }
}

// ]b4_yy_symbol_print_define[

// /*------------------------------------------------------------------.
// | yy_stack_print -- Print the state stack from its BOTTOM up to its |
// | TOP (included).                                                   |
// `------------------------------------------------------------------*/

fn yy_stack_print(yybottom: [*]yy_state_t, yytop: [*]yy_state_t) void {
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

fn yy_reduce_print(yyctx: *yyparse_context_t,][yyrule: usize][) !void {
   if (yydebug) {
    const yylno = yyrline[yyrule];
    const yynrhs: usize = @@intCast(yyr2[yyrule]);
    const iyynrhs: isize = @@as(isize, @@intCast(yynrhs));
    std.debug.print("Reducing stack by rule {d} (line {d}):\n", .{yyrule - 1, yylno});
    // /* The symbols being reduced.  */
    for (0..yynrhs) |yyi| {
      std.debug.print("   ${d} = ", .{ yyi + 1 });
      const yysspi = @@as(isize, @@intCast(yyi)) + 1 - iyynrhs;
      try yy_symbol_print(
          std.io.getStdErr(),
          @@intCast(YY_ACCESSING_SYMBOL(@@intCast(movePtr(yyctx.yyssp, yysspi)[0]))),
          &(movePtr(yyctx.yyvsp, yysspi)[0]),]b4_locations_if([
          &(movePtr(yyctx.yylsp, yysspi)[[0]]),
          ])[
      );
      std.debug.print("\n", .{});
    }
   }
}

// /* YYINITDEPTH -- initial size of the parser's stacks.  */
const YYINITDEPTH = ]b4_stack_depth_init[;

// /* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
//    if the built-in stack extension method is used).

//    Do not make this value too large; the results are undefined if
//    YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
//    evaluated with infinite-precision integer arithmetic.  */

const YYMAXDEPTH = ]b4_stack_depth_max[;
]b4_push_if([[
// /* Parser data structure.  */
pub const yypstate = struct {
  pub const STATE = enum(u8) {
    INIT = 0,
    NEW = 1,
    FINISHED,
  };

  allocator: std.mem.Allocator,
]b4_declare_parser_state_variables([INIT])[
    // /* Whether this instance has not started parsing yet.
    //  * If 2, it corresponds to a finished parsing.  */
    yynew: STATE = .NEW,

    pub fn init(allocator: std.mem.Allocator) yypstate {
        var yyps = yypstate{ .allocator = allocator };
        yyps.yyss = &yyps.yyssa;
        yyps.yyvs = &yyps.yyvsa;
        ]b4_locations_if([yyps.yyls = &yyps.yylsa;])[
        yyps.reset();
        return yyps;
    }

    pub fn deinit(this: *yypstate) void {
        _ = this;
    }

    pub fn reset(this: *yypstate) void {
        this.yynerrs = 0;
        this.yystate = 0;
        this.yyerrstatus = 0;
        this.yyssp = &this.yyssa;
        this.yyvsp = &this.yyvsa;
        this.yylsp = &this.yylsa;
        this.yyssp[0] = 0;
        this.yynew = .NEW;
    }
};]b4_pure_if([], [[

// /* Whether the only allowed instance of yypstate is allocated.  */
// static char yypstate_allocated = 0;]])])[
]b4_lac_if([[

// TODO: get LAC done
// /* Given a state stack such that *YYBOTTOM is its bottom, such that
//    *YYTOP is either its top or is YYTOP_EMPTY to indicate an empty
//    stack, and such that *YYCAPACITY is the maximum number of elements it
//    can hold without a reallocation, make sure there is enough room to
//    store YYADD more elements.  If not, allocate a new stack using
//    YYSTACK_ALLOC, copy the existing elements, and adjust *YYBOTTOM,
//    *YYTOP, and *YYCAPACITY to reflect the new capacity and memory
//    location.  If *YYBOTTOM != YYBOTTOM_NO_FREE, then free the old stack
//    using YYSTACK_FREE.  Return 0 if successful or if no reallocation is
//    required.  Return YYENOMEM if memory is exhausted.  */
static int
yy_lac_stack_realloc (YYPTRDIFF_T *yycapacity, YYPTRDIFF_T yyadd,
#if ]b4_api_PREFIX[DEBUG
                      char const *yydebug_prefix,
                      char const *yydebug_suffix,
#endif
                      yy_state_t **yybottom,
                      yy_state_t *yybottom_no_free,
                      yy_state_t **yytop, yy_state_t *yytop_empty)
{
  YYPTRDIFF_T yysize_old =
    *yytop == yytop_empty ? 0 : *yytop - *yybottom + 1;
  YYPTRDIFF_T yysize_new = yysize_old + yyadd;
  if (*yycapacity < yysize_new)
    {
      YYPTRDIFF_T yyalloc = 2 * yysize_new;
      yy_state_t *yybottom_new;
      /* Use YYMAXDEPTH for maximum stack size given that the stack
         should never need to grow larger than the main state stack
         needs to grow without LAC.  */
      if (YYMAXDEPTH < yysize_new)
        {
          YYDPRINTF ((stderr, "%smax size exceeded%s", yydebug_prefix,
                      yydebug_suffix));
          return YYENOMEM;
        }
      if (YYMAXDEPTH < yyalloc)
        yyalloc = YYMAXDEPTH;
      yybottom_new =
        YY_CAST (yy_state_t *,
                 YYSTACK_ALLOC (YY_CAST (YYSIZE_T,
                                         yyalloc * YYSIZEOF (*yybottom_new))));
      if (!yybottom_new)
        {
          YYDPRINTF ((stderr, "%srealloc failed%s", yydebug_prefix,
                      yydebug_suffix));
          return YYENOMEM;
        }
      if (*yytop != yytop_empty)
        {
          YYCOPY (yybottom_new, *yybottom, yysize_old);
          *yytop = yybottom_new + (yysize_old - 1);
        }
      if (*yybottom != yybottom_no_free)
        YYSTACK_FREE (*yybottom);
      *yybottom = yybottom_new;
      *yycapacity = yyalloc;]m4_if(b4_percent_define_get([[parse.lac.memory-trace]]),
                                   [full], [[
      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "%srealloc to %ld%s", yydebug_prefix,
                  YY_CAST (long, yyalloc), yydebug_suffix));
      YY_IGNORE_USELESS_CAST_END]])[
    }
  return 0;
}

/* Establish the initial context for the current lookahead if no initial
   context is currently established.

   We define a context as a snapshot of the parser stacks.  We define
   the initial context for a lookahead as the context in which the
   parser initially examines that lookahead in order to select a
   syntactic action.  Thus, if the lookahead eventually proves
   syntactically unacceptable (possibly in a later context reached via a
   series of reductions), the initial context can be used to determine
   the exact set of tokens that would be syntactically acceptable in the
   lookahead's place.  Moreover, it is the context after which any
   further semantic actions would be erroneous because they would be
   determined by a syntactically unacceptable token.

   YY_LAC_ESTABLISH should be invoked when a reduction is about to be
   performed in an inconsistent state (which, for the purposes of LAC,
   includes consistent states that don't know they're consistent because
   their default reductions have been disabled).  Iff there is a
   lookahead token, it should also be invoked before reporting a syntax
   error.  This latter case is for the sake of the debugging output.

   For parse.lac=full, the implementation of YY_LAC_ESTABLISH is as
   follows.  If no initial context is currently established for the
   current lookahead, then check if that lookahead can eventually be
   shifted if syntactic actions continue from the current context.
   Report a syntax error if it cannot.  */
#define YY_LAC_ESTABLISH                                                \
do {                                                                    \
  if (!yy_lac_established)                                              \
    {                                                                   \
      YYDPRINTF ((stderr,                                               \
                  "LAC: initial context established for %s\n",          \
                  yysymbol_name (yytoken)));                            \
      yy_lac_established = 1;                                           \
      switch (yy_lac (yyesa, &yyes, &yyes_capacity, yyssp, yytoken))    \
        {                                                               \
        case YYENOMEM:                                                  \
          YYNOMEM;                                                      \
        case 1:                                                         \
          goto yyerrlab;                                                \
        }                                                               \
    }                                                                   \
} while (0)

/* Discard any previous initial lookahead context because of Event,
   which may be a lookahead change or an invalidation of the currently
   established initial context for the current lookahead.

   The most common example of a lookahead change is a shift.  An example
   of both cases is syntax error recovery.  That is, a syntax error
   occurs when the lookahead is syntactically erroneous for the
   currently established initial context, so error recovery manipulates
   the parser stacks to try to find a new initial context in which the
   current lookahead is syntactically acceptable.  If it fails to find
   such a context, it discards the lookahead.  */
#if ]b4_api_PREFIX[DEBUG
# define YY_LAC_DISCARD(Event)                                           \
do {                                                                     \
  if (yy_lac_established)                                                \
    {                                                                    \
      YYDPRINTF ((stderr, "LAC: initial context discarded due to "       \
                  Event "\n"));                                          \
      yy_lac_established = 0;                                            \
    }                                                                    \
} while (0)
#else
# define YY_LAC_DISCARD(Event) yy_lac_established = 0
#endif

/* Given the stack whose top is *YYSSP, return 0 iff YYTOKEN can
   eventually (after perhaps some reductions) be shifted, return 1 if
   not, or return YYENOMEM if memory is exhausted.  As preconditions and
   postconditions: *YYES_CAPACITY is the allocated size of the array to
   which *YYES points, and either *YYES = YYESA or *YYES points to an
   array allocated with YYSTACK_ALLOC.  yy_lac may overwrite the
   contents of either array, alter *YYES and *YYES_CAPACITY, and free
   any old *YYES other than YYESA.  */
static int
yy_lac (yy_state_t *yyesa, yy_state_t **yyes,
        YYPTRDIFF_T *yyes_capacity, yy_state_t *yyssp, yysymbol_kind_t yytoken)
{
  yy_state_t *yyes_prev = yyssp;
  yy_state_t *yyesp = yyes_prev;
  /* Reduce until we encounter a shift and thereby accept the token.  */
  YYDPRINTF ((stderr, "LAC: checking lookahead %s:", yysymbol_name (yytoken)));
  if (yytoken == ]b4_symbol_prefix[YYUNDEF)
    {
      YYDPRINTF ((stderr, " Always Err\n"));
      return 1;
    }
  while (1)
    {
      int yyrule = yypact[+*yyesp];
      if (yypact_value_is_default (yyrule)
          || (yyrule += yytoken) < 0 || YYLAST < yyrule
          || yycheck[yyrule] != yytoken)
        {
          /* Use the default action.  */
          yyrule = yydefact[+*yyesp];
          if (yyrule == 0)
            {
              YYDPRINTF ((stderr, " Err\n"));
              return 1;
            }
        }
      else
        {
          /* Use the action from yytable.  */
          yyrule = yytable[yyrule];
          if (yytable_value_is_error (yyrule))
            {
              YYDPRINTF ((stderr, " Err\n"));
              return 1;
            }
          if (0 < yyrule)
            {
              YYDPRINTF ((stderr, " S%d\n", yyrule));
              return 0;
            }
          yyrule = -yyrule;
        }
      /* By now we know we have to simulate a reduce.  */
      YYDPRINTF ((stderr, " R%d", yyrule - 1));
      {
        /* Pop the corresponding number of values from the stack.  */
        YYPTRDIFF_T yylen = yyr2[yyrule];
        /* First pop from the LAC stack as many tokens as possible.  */
        if (yyesp != yyes_prev)
          {
            YYPTRDIFF_T yysize = yyesp - *yyes + 1;
            if (yylen < yysize)
              {
                yyesp -= yylen;
                yylen = 0;
              }
            else
              {
                yyesp = yyes_prev;
                yylen -= yysize;
              }
          }
        /* Only afterwards look at the main stack.  */
        if (yylen)
          yyesp = yyes_prev -= yylen;
      }
      /* Push the resulting state of the reduction.  */
      {
        yy_state_fast_t yystate;
        {
          const int yylhs = yyr1[yyrule] - YYNTOKENS;
          const int yyi = yypgoto[yylhs] + *yyesp;
          yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyesp
                     ? yytable[yyi]
                     : yydefgoto[yylhs]);
        }
        if (yyesp == yyes_prev)
          {
            yyesp = *yyes;
            YY_IGNORE_USELESS_CAST_BEGIN
            *yyesp = YY_CAST (yy_state_t, yystate);
            YY_IGNORE_USELESS_CAST_END
          }
        else
          {
            if (yy_lac_stack_realloc (yyes_capacity, 1,
#if ]b4_api_PREFIX[DEBUG
                                      " (", ")",
#endif
                                      yyes, yyesa, &yyesp, yyes_prev))
              {
                YYDPRINTF ((stderr, "\n"));
                return YYENOMEM;
              }
            YY_IGNORE_USELESS_CAST_BEGIN
            *++yyesp = YY_CAST (yy_state_t, yystate);
            YY_IGNORE_USELESS_CAST_END
          }
        YYDPRINTF ((stderr, " G%d", yystate));
      }
    }
}]])[

]b4_parse_error_case([simple], [],
[[// /* Context of a parse error.  */
const yypcontext_t = struct {
]b4_push_if([[
  yyps: *yypstate,]], [[
  yyssp: [*]yy_state_t,]b4_lac_if([[
  yyesa: [*]yy_state_t,
  yyes: *[*]yy_state_t,
  yyes_capacity: *usize,]])])[
  yytoken: isize,]b4_locations_if([[
  yylloc: *YYLTYPE,]])[
};

// /* Put in YYARG at most YYARGN of the expected tokens given the
//    current YYCTX, and return the number of tokens stored in YYARG.  If
//    YYARG is null, return the number of expected tokens (guaranteed to
//    be less than YYNTOKENS).  Return YYENOMEM on memory exhaustion.
//    Return 0 if there are more than YYARGN expected tokens, yet fill
//    YYARG up to YYARGN. */]b4_push_if([[
fn
yypstate_expected_tokens (yyps: *yypstate,
                          yyarg: [*]allowzero isize, yyargn: usize) isize]], [[
fn
yypcontext_expected_tokens (yypctx: *yypcontext_t,
                            yyarg: [*]allowzero isize, yyargn: usize) isize]])[
{
  // /* Actual size of YYARG. */
  var yycount: isize = 0;
]b4_lac_if([[
  int yyx;
  for (yyx = 0; yyx < YYNTOKENS; ++yyx)
    {
      yysymbol_kind_t yysym = YY_CAST (yysymbol_kind_t, yyx);
      if (yysym != ]b4_symbol(error, kind)[ && yysym != ]b4_symbol_prefix[YYUNDEF)
        switch (yy_lac (]b4_push_if([[yyps->yyesa, &yyps->yyes, &yyps->yyes_capacity, yyps->yyssp, yysym]],
                                    [[yyctx->yyesa, yyctx->yyes, yyctx->yyes_capacity, yyctx->yyssp, yysym]])[))
          {
          case YYENOMEM:
            return YYENOMEM;
          case 1:
            continue;
          default:
            if (!yyarg)
              ++yycount;
            else if (yycount == yyargn)
              return 0;
            else
              yyarg[yycount++] = yysym;
          }
    }]],
[[
  const yyn = yypact@{@@intCast(]b4_push_if([yyps], [yypctx])[.yyssp[0])@};
  if (!yypact_value_is_default (yyn)) {
      // /* Start YYX at -YYN if negative to avoid negative indexes in
      //    YYCHECK.  In other words, skip the first -YYN actions for
      //    this state because they are default actions.  */
      const yyxbegin: isize = if (yyn < 0) -yyn else 0;
      // /* Stay within bounds of both yycheck and yytname.  */
      const yychecklim: isize = YYLAST - yyn + 1;
      const yyxend: isize = if (yychecklim < YYNTOKENS) yychecklim else YYNTOKENS;
      var yyx: isize = yyxbegin;
      while (yyx < yyxend) : (yyx += 1) {
        if (yycheck[@@intCast(yyx + yyn)] == yyx and yyx != yysymbol_kind_t.]b4_symbol(error, kind)[
            and !yytable_value_is_error (yytable[@@intCast(yyx + yyn)]))
          {
            if (@@intFromPtr(yyarg) == 0) {
              yycount += 1;
            } else if (yycount == yyargn) {
              return 0;
            } else {
              yyarg[@@intCast(yycount)] = yyx;
              yycount += 1;
            }
          }
    }]])[
  }
    if (@@intFromPtr(yyarg) != 0 and yycount == 0 and yyargn > 0)
      yyarg[0] = yysymbol_kind_t.]b4_symbol(empty, kind)[;
    return yycount;
}

// /* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
//    YYDEST.  */
fn yystpcpy(yydest: [*]u8, yysrc: []const u8) [*]u8 {
    for (0..yysrc.len) |i| {
        yydest[i] = yysrc[i];
    }
    return yydest + yysrc.len;
}

]b4_push_if([[
// /* Similar to the previous function.  */
fn yypcontext_expected_tokens (yypctx: *yypcontext_t,
    yyarg: [*]isize, yyargn: usize) isize {
  return yypstate_expected_tokens(yypctx.yyps, yyarg, yyargn);
}]])[
]])[

]b4_parse_error_bmatch(
         [custom],
[[// /* The kind of the lookahead of this context.  */

fn yypcontext_token(yypctx: *yypcontext_t) yysymbol_kind_t {
  return yypctx.yytoken;
}

]b4_locations_if([[// /* The location of the lookahead of this context.  */
fn yypcontext_location(yypctx: *yypcontext_t) *YYLTYPE {
  return yypctx.yylloc;
}]])[

// /* User defined function to report a syntax error.  */
static int
yyreport_syntax_error (const yypcontext_t *yyctx]b4_user_formals[);]],
         [detailed\|verbose],
[[
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
]])[

fn yy_syntax_error_arguments (yypctx: *yypcontext_t,
                          yyarg: [*]allowzero isize, yyargn: usize) isize
{
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
//        action, or user semantic action that manipulated yychar.]b4_lac_if([[
//        In the first two cases, it might appear that the current syntax
//        error should have been detected in the previous state when yy_lac
//        was invoked.  However, at that time, there might have been a
//        different syntax error that discarded a different initial context
//        during error recovery, leaving behind the current lookahead.]], [[
//      - Of course, the expected token list depends on states to have
//        correct lookahead information, and it depends on the parser not
//        to perform extra reductions after fetching a lookahead from the
//        scanner and before detecting a syntax error.  Thus, state merging
//        (from LALR or IELR) and default reductions corrupt the expected
//        token list.  However, the list is correct for canonical LR with
//        one exception: it will still contain any token that will not be
//        accepted due to an error action in a later state.]])[
//   */
  if (yypctx.yytoken != yysymbol_kind_t.]b4_symbol(empty, kind)[)
    {
      ]b4_lac_if([[
      YYDPRINTF ((stderr, "Constructing syntax error message\n"));]])[
      if (@@intFromPtr(yyarg) != 0) {
        yyarg[@@intCast(yycount)] = yypctx.yytoken;
      }
      yycount += 1;
      const yyn = yypcontext_expected_tokens (yypctx,
                                        if (@@intFromPtr(yyarg) != 0) @@ptrCast(yyarg + 1) else @@ptrCast(yyarg), yyargn - 1);
      if (yyn == YYENOMEM) {
        return YYENOMEM;
      }]b4_lac_if([[
      else if (yyn == 0) {
        YYDPRINTF ((stderr, "No expected tokens.\n"));
      }]])[
      else {
        yycount += yyn;
      }
  }
  return yycount;
}

// /* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
//    about the unexpected token YYTOKEN for the state stack whose top is
//    YYSSP.]b4_lac_if([[  In order to see if a particular token T is a
//    valid looakhead, invoke yy_lac (YYESA, YYES, YYES_CAPACITY, YYSSP, T).]])[

//    Return 0 if *YYMSG was successfully written.  Return -1 if *YYMSG is
//    not large enough to hold the message.  In that case, also set
//    *YYMSG_ALLOC to the required number of bytes.  Return YYENOMEM if the
//    required number of bytes is too large to store]b4_lac_if([[ or if
//    yy_lac returned YYENOMEM]])[.  */
fn yysyntax_error(yyctx: *yyparse_context_t, yypctx: *yypcontext_t) ![]const u8 {
  const YYARGS_MAX = 5;
  // /* Arguments of yyformat: reported tokens (one for the "unexpected",
  //    one per "expected"). */
  var yyarg: [YYARGS_MAX]isize = undefined;

  // /* Actual size of YYARG. */
  const yycount = yy_syntax_error_arguments(yypctx, &yyarg, YYARGS_MAX);
  if (yycount == YYENOMEM)
    return error.YYENOMEM;

    var buf = std.ArrayList(u8).init(yyctx.allocator);
    defer buf.deinit();
    const buf_writer = buf.writer();

    switch (yycount) {
        0 => {
            buf_writer.print("syntax error", .{}) catch {
                return "syntax error";
            };
        },
        1 => {
            buf_writer.print("syntax error, unexpected {s}", .{yysymbol_kind_t.value2name(yyarg[0])}) catch {
                return "syntax error";
            };
        },
        2 => {
            buf_writer.print("syntax error, unexpected {s}, expecting {s}", .{ yysymbol_kind_t.value2name(yyarg[0]), yysymbol_kind_t.value2name(yyarg[1]) }) catch {
                return "syntax error";
            };
        },
        else => {
            buf_writer.print("syntax error, unexpected {s}, expecting {s}", .{ yysymbol_kind_t.value2name(yyarg[0]), yysymbol_kind_t.value2name(yyarg[1]) }) catch {
                return "syntax error";
            };
            for (2..YYARGS_MAX) |i| {
                buf_writer.print(" or {s}", .{yysymbol_kind_t.value2name(yyarg[i])}) catch {
                    return "syntax error";
                };
            }
        },
    }

    return buf.toOwnedSlice();
}
]])[

]b4_yydestruct_define[

]b4_pure_if([], [b4_declare_scanner_communication_variables])[

]b4_push_if([b4_pull_if([[

int
yyparse (]m4_ifset([b4_parse_param], [b4_formals(b4_parse_param)], [void])[)
{
  yypstate *yyps = yypstate_new ();
  if (!yyps)
    {]b4_pure_if([b4_locations_if([[
      static YYLTYPE yyloc_default][]b4_yyloc_default[;
      YYLTYPE yylloc = yyloc_default;]])[
      yyerror (]b4_yyerror_args[YY_("memory exhausted"));]], [[
      if (!yypstate_allocated)
        yyerror (]b4_yyerror_args[YY_("memory exhausted"));]])[
      return 2;
    }
  int yystatus = yypull_parse (yyps]b4_user_args[);
  yypstate_delete (yyps);
  return yystatus;
}

int
yypull_parse (yypstate *yyps]b4_user_formals[)
{
  YY_ASSERT (yyps);]b4_pure_if([b4_locations_if([[
  static YYLTYPE yyloc_default][]b4_yyloc_default[;
  YYLTYPE yylloc = yyloc_default;]])])[
  int yystatus;
  do {
]b4_pure_if([[    YYSTYPE yylval;
    int ]])[yychar = ]b4_yylex[;
    yystatus = yypush_parse (yyps]b4_pure_if([[, yychar, &yylval]b4_locations_if([[, &yylloc]])])m4_ifset([b4_parse_param], [, b4_args(b4_parse_param)])[);
  } while (yystatus == YYPUSH_MORE);
  return yystatus;
}]])[
][
]])[

// collect all yyparse loop variables into one struct so that when we deal with
// gotos, we will be with easier life
pub const yyparse_context_t = struct {
    allocator: std.mem.Allocator,

    ]m4_ifset([b4_user_formals], [b4_formals_struct(b4_user_formals)])[,
    ]b4_pure_if([b4_declare_scanner_communication_variables])[
    ]b4_declare_parser_state_variables([init])[
    ]b4_lac_if([[
  // /* Whether LAC context is established.  A Boolean.  */
  yy_lac_established: bool = false,]])[
  yyn: isize = 0,
  // /* The return value of yyparse.  */
  yyresult: usize = 0,
  // /* Lookahead symbol kind.  */
  yytoken: isize = yysymbol_kind_t.]b4_symbol(empty, kind)[,
  // /* The variables used to return semantic value and location from the
  //    action routines.  */
  yyval: YYSTYPE = undefined,]b4_locations_if([[
  yyloc: YYLTYPE = undefined,

  // /* The locations where the error started and ended.  */
  yyerror_range: [3]YYLTYPE = undefined,]])[

]b4_parse_error_bmatch([detailed\|verbose],
[[  // /* Buffer for error messages, and its allocated size.  */
  yymsgbuf: [128]u8 = undefined,
  yymsg: []u8 = undefined, // need init to = yymsgbuf;
  yymsg_alloc: usize = 128,
  yymsg_need_free: bool = false,]])[

  // /* The number of symbols on the RHS of the reduced rule.
  //    Keep to zero when no symbol should be popped.  */
  yylen: usize = 0,]
  b4_push_if([[
    yyps: *yypstate = undefined,
    yypushed_char: isize = undefined,
    yypushed_val: *YYSTYPE = undefined,
    ]b4_locations_if([
    yypushed_loc: *YYLTYPE = undefined,
    ])[
  ]])
  [

    pub fn YYPOPSTACK(this: *yyparse_context_t, N: usize) void {
        this.yyvsp -= N;
        this.yyssp -= N;
    }

    pub fn yyclearin(this: *yyparse_context_t) void {
      this.yychar = yytoken_kind_t.]b4_symbol(empty, id)[;
    }
  ]
  b4_push_if([[
    pub fn yyerrok(this: *yyparse_context_t) void {
      this.yyps.yyerrstatus = 0;
    }
  ]], [
    pub fn yyerrok(this: *yyparse_context_t) void {
      this.yyerrstatus = 0;
    }
  ])
  []b4_push_if([[

  pub fn copyFromYyps(this: *yyparse_context_t, yyps: *yypstate) void {
      this.yynerrs = yyps.yynerrs;
      this.yystate = yyps.yystate;
      this.yyerrstatus = yyps.yyerrstatus;
      this.yyssa = yyps.yyssa;
      this.yyss = yyps.yyss;
      this.yyssp = yyps.yyssp;
      this.yyvsa = yyps.yyvsa;
      this.yyvs = yyps.yyvs;
      this.yyvsp = yyps.yyvsp;
      ]b4_locations_if([
      this.yylsa = yyps.yylsa;
      this.yyls = yyps.yyls;
      this.yylsp = yyps.yylsp;
      ])[
      this.yystacksize = yyps.yystacksize;
  }

  pub fn copyToYyps(this: *yyparse_context_t, yyps: *yypstate) void {
      yyps.yynerrs = this.yynerrs;
      yyps.yystate = this.yystate;
      yyps.yyerrstatus = this.yyerrstatus;
      yyps.yyssa = this.yyssa;
      yyps.yyss = this.yyss;
      yyps.yyssp = this.yyssp;
      yyps.yyvsa = this.yyvsa;
      yyps.yyvs = this.yyvs;
      yyps.yyvsp = this.yyvsp;
      ]b4_locations_if([
      yyps.yylsa = this.yylsa;
      yyps.yyls = this.yyls;
      yyps.yylsp = this.yylsp;
      ])[
      yyps.yystacksize = this.yystacksize;
  }]])[
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
const LABEL_YYINIT = 0x0000000000004000;

// alias for using in rules,
//   in bison do: YYABORT;
//   in zison do: return YYABORT;
const YYACCEPT = LABEL_YYACCEPTLAB;
//   in bison do: YYERROR;
//   in zison do: return YYERROR;
const YYERROR = LABEL_YYERRORLAB;
//   in bison do: YYNOMEM;
//   in zison do: return YYNOMEM;
const YYNOMEM = LABEL_YYEXHAUSTEDLAB;

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
  YY_ASSERT (0 <= yyctx.yystate and yyctx.yystate < YYNSTATES);
  yyctx.yyssp[0] = @@as(yy_state_t, @@intCast(yyctx.yystate));
  yy_stack_print (yyctx.yyss, yyctx.yyssp);

  if (ptrLessThan(isize, yyctx.yyss + yyctx.yystacksize - 1, yyctx.yyssp)) {
      // /* Get the current used size of the three stacks, in elements.  */
      const yysize: usize = @@intCast(cPtrDistance(isize, yyctx.yyss, yyctx.yyssp) + 1);

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
          const yystack_alloc_size1 = yyctx.yystack_alloc_size;
          var yyptr: [*]yyalloc = try YYSTACK_ALLOC(yyctx, YYSTACK_BYTES(yyctx.yystacksize));
          YYSTACK_RELOCATE(yyctx, .yyss, &yyptr, yysize);
          YYSTACK_RELOCATE(yyctx, .yyvs, &yyptr, yysize);]b4_locations_if([
          YYSTACK_RELOCATE(yyctx, .yyls, &yyptr, yysize);])[
          // TODO: why undef?
          // #  undef YYSTACK_RELOCATE
          if (yyss1 != yyctx.yyssa[0..].ptr) {
            yyctx.allocator.free(yyss1[0..yystack_alloc_size1]);
          }
        }

      yyctx.yyssp = yyctx.yyss + yysize - 1;
      yyctx.yyvsp = yyctx.yyvs + yysize - 1;]b4_locations_if([
      yyctx.yylsp = yyctx.yyls + yysize - 1;])[

      if (yydebug) {
        std.debug.print("Stack size increased to {d}\n", .{yyctx.yystacksize});
      }

      if (ptrLessThan(isize, yyctx.yyss + yyctx.yystacksize - 1, yyctx.yyssp)) {
        return LABEL_YYABORTLAB;
      }
    }
]m4_ifdef([b4_start_symbols], [], [[
  if (yyctx.yystate == YYFINAL) {
    return LABEL_YYACCEPTLAB;
  }]])[

  return LABEL_YYBACKUP;
}

// /*-----------.
// | yybackup.  |
// `-----------*/
fn label_yybackup(yyctx: *yyparse_context_t) !usize {
  // /* Do appropriate processing given the current state.  Read a
  //    lookahead token if we need one and don't already have one.  */

  // /* First try to decide what to do without reference to lookahead token.  */
  yyctx.yyn = yypact[@@intCast(yyctx.yystate)];
  if (yypact_value_is_default (yyctx.yyn)) {
    return LABEL_YYDEFAULT;
  }

  // /* Not known => get a lookahead token if don't already have one.  */

  // /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yyctx.yychar == yytoken_kind_t.]b4_symbol(empty, id)[)
    {]b4_push_if([[
      if (yyctx.yyps.yynew == .INIT)
        {]b4_use_push_for_pull_if([], [[
          if (yydebug) {
            std.debug.print("Return for a new token:\n", .{});
          }
          yyctx.yyresult = YYPUSH_MORE;
          return LABEL_YYPUSHRETURN;
        }
      yyctx.yyps.yynew = .INIT;]])b4_pure_if([], [[
      // /* Restoring the pushed token is only necessary for the first
      //    yypush_parse invocation since subsequent invocations don't overwrite
      //    it before jumping to yyread_pushed_token.  */
      yyctx.yychar = yyctx.yypushed_char;
      yyctx.yylval = yyctx.yypushed_val;]b4_locations_if([[
      yyctx.yylloc = yyctx.yypushed_loc;]])])[]],
      [
        if (yydebug) {
          std.debug.print("Reading a token\n", .{});
        }
        yyctx.yychar = @@intCast(try yyctx.scanner.]b4_yylex[);
      ])
  }
  // This label is confusing as in pull mode there is no yyread_pushed_token label defined in original bison. But to
  // unify the generated code in zig (as there is no goto), let us keep this name, and just treat as the next middle
  // step of yybackup.
  return LABEL_YYREAD_PUSHED_TOKEN;
}

fn label_yyread_pushed_token(yyctx: *yyparse_context_t) !usize {[
  ]b4_push_if([
    if (yydebug) {
      std.debug.print("Reading a token\n", .{});
    }
    b4_pure_if([[
    yyctx.yychar = yyctx.yypushed_char;
    yyctx.yylval = yyctx.yypushed_val.*;
    ]b4_locations_if([[
    yyctx.yylloc = yyctx.yypushed_loc.*;
    ]])])], [[]])[

  if (yyctx.yychar <= yytoken_kind_t.]b4_symbol(eof, [id])[)
    {
      yyctx.yychar = yytoken_kind_t.]b4_symbol(eof, [id])[;
      yyctx.yytoken = yysymbol_kind_t.]b4_symbol(eof, [kind])[;
      if (yydebug) {
        std.debug.print("Now at end of input.\n", .{});
      }
    }
  else if (yyctx.yychar == yytoken_kind_t.]b4_symbol(error, [id])[)
    {
      // /* The scanner already issued an error message, process directly
      //    to error recovery.  But do not keep the error token as
      //    lookahead, it is too special and may lead us to an endless
      //    loop in error recovery. */
      yyctx.yychar = yytoken_kind_t.]b4_symbol(undef, [id])[;
      yyctx.yytoken = yysymbol_kind_t.]b4_symbol(error, [kind])[;]b4_locations_if([[
      yyctx.yyerror_range[1] = yyctx.yylloc;]])[
      return LABEL_YYERRLAB1;
    }
  else
    {
      yyctx.yytoken = YYTRANSLATE(@@as(usize, @@intCast(yyctx.yychar)));
      try YY_SYMBOL_PRINT("Next token is", yyctx.yytoken, &yyctx.yylval, &yyctx.yylloc);
    }

  // /* If the proper action on seeing token YYTOKEN is to reduce or to
  //    detect an error, take that action.  */
  yyctx.yyn += yyctx.yytoken;
  if (yyctx.yyn < 0 or YYLAST < yyctx.yyn or yycheck[@@intCast(yyctx.yyn)] != yyctx.yytoken)]b4_lac_if([[
    {
      YY_LAC_ESTABLISH;
      return LABEL_YYDEFAULT;
    }]], [[
      return LABEL_YYDEFAULT;
    ]])[
    yyctx.yyn = yytable[@@intCast(yyctx.yyn)];
    if (yyctx.yyn <= 0)
    {
      if (yytable_value_is_error (yyctx.yyn)) {
        return LABEL_YYERRLAB;
      }
      yyctx.yyn = -yyctx.yyn;]b4_lac_if([[
      YY_LAC_ESTABLISH;]])[
        return LABEL_YYREDUCE;
    }

    // /* Count tokens shifted since error; after three, turn off error
    //    status.  */
    if (yyctx.yyerrstatus > 0) {
      yyctx.yyerrstatus -= 1;
    }

    // /* Shift the lookahead token.  */
    try YY_SYMBOL_PRINT("Shifting", yyctx.yytoken, &yyctx.yylval, &yyctx.yylloc);
    yyctx.yystate = yyctx.yyn;
    yyctx.yyvsp += 1;
    yyctx.yyvsp[0] = yyctx.yylval;
    ]b4_locations_if([
    yyctx.yylsp += 1;
    yyctx.yylsp[[0]] = yyctx.yylloc;
    ])[

    // /* Discard the shifted token.  */
    yyctx.yychar = yytoken_kind_t.]b4_symbol(empty, id)[;]b4_lac_if([[
    YY_LAC_DISCARD ("shift");]])[
    return LABEL_YYNEWSTATE;
}

// /*-----------------------------------------------------------.
// | yydefault -- do the default action for the current state.  |
// `-----------------------------------------------------------*/
fn label_yydefault(yyctx: *yyparse_context_t) usize {
  yyctx.yyn = yydefact[@@intCast(yyctx.yystate)];
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
  yyctx.yylen = @@intCast(yyr2[@@intCast(yyctx.yyn)]);

  // /* If YYLEN is nonzero, implement the default value of the action:
  //    '$$ = $1'.
  //
  //    Otherwise, the following line sets YYVAL to garbage.
  //    This behavior is undocumented and Bison
  //    users should not rely upon it.  Assigning to YYVAL
  //    unconditionally makes the parser a bit smaller, and it avoids a
  //    GCC warning that YYVAL may be used uninitialized.  */
    const yyvspi = 1 - @@as(isize, @@intCast(yyctx.yylen));
    yyctx.yyval = movePtr(yyctx.yyvsp, yyvspi)[0];
]b4_locations_if(
[[// /* Default location. */
  YYLLOC_DEFAULT (&yyctx.yyloc, (yyctx.yylsp - yyctx.yylen), yyctx.yylen);
  yyctx.yyerror_range[1] = yyctx.yyloc;]])[
  try yy_reduce_print(yyctx, @@intCast(yyctx.yyn));]b4_lac_if([[
  {
    var yychar_backup = yyctx.yychar;
    switch (yyctx.yyn)
      {
]b4_user_actions[
        else => {},
      }
    if (yychar_backup != yyctx.yychar) {
      YY_LAC_DISCARD ("yychar change");
    }
  }]], [[
  switch (yyctx.yyn)
    {
]b4_user_actions[
      else => {},
    }]])[

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
    try YY_SYMBOL_PRINT("-> $$ =", yyr1[@@intCast(yyctx.yyn)], &yyctx.yyval, &yyctx.yyloc);

    yyctx.YYPOPSTACK (yyctx.yylen);
    yyctx.yylen = 0;

    yyctx.yyvsp += 1;
    yyctx.yyvsp[0] = yyctx.yyval;]b4_locations_if([
    yyctx.yylsp += 1;
    yyctx.yylsp[[0]] = yyctx.yyloc;])[

    // /* Now 'shift' the result of the reduction.  Determine what state
    //    that goes to, based on the state we popped back to and the rule
    //    number reduced by.  */
    {
      const yylhs = yyr1[@@intCast(yyctx.yyn)] - YYNTOKENS;
      const yyi = yypgoto[@@intCast(yylhs)] + yyctx.yyssp[0];
      yyctx.yystate = if (0 <= yyi and yyi <= YYLAST and yycheck[@@intCast(yyi)] == yyctx.yyssp[0])
                yytable[@@intCast(yyi)]
                else yydefgoto[@@intCast(yylhs)];
    }

    return LABEL_YYNEWSTATE;
}

// /*--------------------------------------.
// | yyerrlab -- here on detecting error.  |
// `--------------------------------------*/
fn label_yyerrlab(yyctx: *yyparse_context_t) !usize {
  // /* Make sure we have latest lookahead translation.  See comments at
  //    user semantic actions for why this is necessary.  */
  yyctx.yytoken = if (yyctx.yychar == yytoken_kind_t.]b4_symbol(empty, id)[) yysymbol_kind_t.YYSYMBOL_YYEMPTY else YYTRANSLATE(@@as(usize, @@intCast(yyctx.yychar)));
  // /* If not already recovering from an error, report this error.  */
  if (yyctx.yyerrstatus == 0)
    {
      yyctx.yynerrs += 1;
      ]b4_parse_error_case(
      [custom],
      [[{
        var yypctx
          = yypcontext_t{]b4_push_if([[.yyps = yyctx.yyps,]],[[.yyssp = yyctx.yyssp,]])[.yytoken =]b4_lac_if([[yyctx.yyesa, &yyctx.yyes, &yctx.yyes_capacity]])[yyctx.yytoken]b4_locations_if([[, .yylloc = &yyctx.yylloc]])b4_lac_if([[
        if (yyctx.yychar != ]b4_symbol(empty, id)[)
          YY_LAC_ESTABLISH;]])[
        if (yyreport_syntax_error (&yypctx]m4_ifset([b4_parse_param],
                                   [[, ]b4_args(b4_parse_param)])[) == 2)
          return LABEL_YYEXHAUSTEDLAB;
      }]],
      [simple],
[[      // yyerror (]b4_yyerror_args[YY_("syntax error"));]],
[[      {
        var yypctx
          = yypcontext_t{]b4_push_if([[.yyps = yyctx.yyps,]], [[.yyssp = yyctx.yyssp,]])[.yytoken = ]b4_lac_if([[yyctx.yyesa, &yyctx.yyes, &yyctx.yyes_capacity]])[yyctx.yytoken]b4_locations_if([[, .yylloc = &yyctx.yylloc]])[};

        var yymsgp = yysyntax_error(yyctx, &yypctx) catch |err| switch (err) {
          error.YYENOMEM => {
              return LABEL_YYEXHAUSTEDLAB;
          },
          else => unreachable,
        };
        defer yyctx.allocator.free(yymsgp);
        _ = &yymsgp;

        if (yyctx.yymsg.len < yymsgp.len) {
          if (yyctx.yymsg_need_free) {
              yyctx.allocator.free(yyctx.yymsg);
              yyctx.yymsg_need_free = false;
          }
          yyctx.yymsg = try yyctx.allocator.alloc(u8, yymsgp.len * 2);
          @@memcpy(yyctx.yymsg, yymsgp);
          yyctx.yymsg_need_free = true;
        } else {
          @@memcpy(yyctx.yymsg, yymsgp);
        }
        ]b4_lac_if([[
        if (yyctx.yychar != ]b4_symbol(empty, id)[)
          YY_LAC_ESTABLISH;]])[
      }]])[
    }
]b4_locations_if([[
  yyctx.yyerror_range[1] = yyctx.yylloc;]])[
  if (yyctx.yyerrstatus == 3)
    {
      // /* If just tried and failed to reuse lookahead token after an
      //    error, discard it.  */

      if (yyctx.yychar <= yytoken_kind_t.]b4_symbol(eof, [id])[)
        {
          // /* Return failure if at end of input.  */
          if (yyctx.yychar == yytoken_kind_t.]b4_symbol(eof, [id])[) {
            return LABEL_YYABORTLAB;
          }
        }
      else
        {
          try yydestruct (yyctx, "Error: discarding",
                      yyctx.yytoken, &yyctx.yylval]b4_locations_if([, &yyctx.yylloc])[][);
          yyctx.yychar = yytoken_kind_t.]b4_symbol(empty, id)[;
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
  yyctx.YYPOPSTACK (yyctx.yylen);
  yyctx.yylen = 0;
  yy_stack_print (yyctx.yyss, yyctx.yyssp);
  yyctx.yystate = yyctx.yyssp[0];
  return LABEL_YYERRLAB1;
}

// /*-------------------------------------------------------------.
// | yyerrlab1 -- common code for both syntax error and YYERROR.  |
// `-------------------------------------------------------------*/
fn label_yyerrlab1(yyctx: *yyparse_context_t) !usize {
  yyctx.yyerrstatus = 3;      // /* Each real token shifted decrements this.  */

  // /* Pop stack until we find a state that shifts the error token.  */
  while(true) {
      yyctx.yyn = yypact[@@intCast(yyctx.yystate)];
      if (!yypact_value_is_default (yyctx.yyn))
        {
          yyctx.yyn += yysymbol_kind_t.]b4_symbol(error, kind)[;
          if (0 <= yyctx.yyn and yyctx.yyn <= YYLAST and yycheck[@@intCast(yyctx.yyn)] == yysymbol_kind_t.]b4_symbol(error, kind)[)
            {
              yyctx.yyn = yytable[@@intCast(yyctx.yyn)];
              if (0 < yyctx.yyn)
                break;
            }
        }

      // /* Pop the current state because it cannot handle the error token.  */
      if (yyctx.yyssp == yyctx.yyss) {
        return LABEL_YYABORTLAB;
      }

]b4_locations_if([[      yyctx.yyerror_range[1] = yyctx.yylsp[0];]])[
      try yydestruct (yyctx, "Error: popping",
                  YY_ACCESSING_SYMBOL (@@intCast(yyctx.yystate)), &yyctx.yyvsp[0]]b4_locations_if([, &yyctx.yylsp[[0]]])[][);
      yyctx.YYPOPSTACK (1);
      yyctx.yystate = yyctx.yyssp[0];
      yy_stack_print (yyctx.yyss, yyctx.yyssp);
    }]b4_lac_if([[

  // /* If the stack popping above didn't lose the initial context for the
  //    current lookahead token, the shift below will for sure.  */
  YY_LAC_DISCARD ("error recovery");]])[

  yyctx.yyvsp += 1;
  yyctx.yyvsp[0] = yyctx.yylval;
]b4_locations_if([[
  yyctx.yyerror_range[2] = yyctx.yylloc;
  yyctx.yylsp += 1;
  YYLLOC_DEFAULT (&yyctx.yylsp[0], yyctx.yyerror_range[0..].ptr, 2);]])[

  // /* Shift the error token.  */
  try YY_SYMBOL_PRINT("Shifting", YY_ACCESSING_SYMBOL(@@intCast(yyctx.yyn)), &(yyctx.yyvsp[0]), &(yyctx.yylsp[0]));

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
  // yyerror (]b4_yyerror_args[YY_("memory exhausted"));
  yyctx.yyresult = 2;
  return LABEL_YYRETURNLAB;
}

// /*----------------------------------------------------------.
// | yyreturnlab -- parsing is finished, clean up and return.  |
// `----------------------------------------------------------*/
fn label_yyreturnlab(yyctx: *yyparse_context_t) !usize {
  if (yyctx.yychar != yytoken_kind_t.]b4_symbol(empty, id)[)
    {
      // /* Make sure we have latest lookahead translation.  See comments at
      //   user semantic actions for why this is necessary.  */
      yyctx.yytoken = YYTRANSLATE (@@as(usize, @@intCast(yyctx.yychar)));
      try yydestruct (yyctx, "Cleanup: discarding lookahead",
                  yyctx.yytoken, &yyctx.yylval]b4_locations_if([, &yyctx.yylloc])[][);
    }
  // /* Do not reclaim the symbols of the rule whose action triggered
  //    this YYABORT or YYACCEPT.  */
  yyctx.YYPOPSTACK (yyctx.yylen);
  yy_stack_print (yyctx.yyss, yyctx.yyssp);
  while (yyctx.yyssp != yyctx.yyss)
    {
      try yydestruct (yyctx, "Cleanup: popping",
                  YY_ACCESSING_SYMBOL (@@intCast(yyctx.yyssp[0])), &yyctx.yyvsp[0]]b4_locations_if([, &yyctx.yylsp[[0]]])[][);
      yyctx.YYPOPSTACK (1);
    }]b4_push_if([[
  yyctx.yyps.yynew = .FINISHED;
    ]])[
  return LABEL_YYPUSHRETURN;
}

fn label_yyinit(yyctx: *yyparse_context_t) usize {
    if (yydebug) {
        std.debug.print("Starting parse\n", .{});
    }

    ]m4_ifdef([b4_start_symbols], [],
    [[yyctx.yychar = yytoken_kind_t.]b4_symbol(empty, id)[; // /* Cause a token to be read.  */]])[
    ]m4_ifdef([b4_initial_action], [
    b4_dollar_pushdef([m4_define([b4_dollar_dollar_used])yylval], [], [],
                      [b4_push_if([b4_pure_if([*])yypushed_loc], [yylloc])])dnl
    b4_user_initial_action
    b4_dollar_popdef[]dnl
    m4_ifdef([_used],[[  yyctx.yyvsp[0] = yyctx.yylval;]])])dnl
    b4_locations_if([[
      yyctx.yylsp[0] = ]b4_push_if([b4_pure_if([])yyctx.yypushed_loc.*], [yyctx.yylloc])[;
    ]])dnl
[
    return LABEL_YYSETSTATE;
}

]b4_push_if([[
// /*---------------.
// | yypush_parse.  |
// `---------------*/

pub fn yypush_parse (allocator: std.mem.Allocator, yyps: *yypstate]b4_pure_if([[,
              yypushed_char: isize, yypushed_val: *YYSTYPE]b4_locations_if([[, yypushed_loc: *YYLTYPE]])])b4_user_formals[)]],
[[
// /*----------.
// | yyparse.  |
// `----------*/

]m4_ifdef([b4_start_symbols],
[[// Extract data from the parser.
typedef struct
{
  YYSTYPE yyvalue;
  int yynerrs;
} yy_parse_impl_t;

// Run a full parse, using YYCHAR as switching token.
static int
yy_parse_impl (int yychar, yy_parse_impl_t *yyimpl]m4_ifset([b4_parse_param], [, b4_formals(b4_parse_param)])[);

]m4_map([_b4_define_sub_yyparse], m4_defn([b4_start_symbols]))[

int
yyparse (]m4_ifset([b4_parse_param], [b4_formals(b4_parse_param)], [void])[)
{
  return yy_parse_impl (]b4_symbol(_b4_first_switching_token, id)[, YY_NULLPTR]m4_ifset([b4_parse_param],
                                                    [[, ]b4_args(b4_parse_param)])[);
}

static int
yy_parse_impl (int yychar, yy_parse_impl_t *yyimpl]m4_ifset([b4_parse_param], [, b4_formals(b4_parse_param)])[)]],
[[pub fn yyparse (allocator: std.mem.Allocator,]m4_ifset([b4_parse_param], [b4_formals(b4_parse_param)], [void])[)]])])[ anyerror!usize {
  // replace all local variables with yyps, so later when access should use yyps
  var yyctx = yyparse_context_t{
    .allocator = allocator,
  };
]m4_ifset([b4_parse_param], [b4_formals_copy(b4_parse_param);], [])
[
  yyctx.yyss = &yyctx.yyssa;
  yyctx.yyssp = yyctx.yyss;
  yyctx.yyvs = &yyctx.yyvsa;
  yyctx.yyvsp = yyctx.yyvs;
  yyctx.yyls = &yyctx.yylsa;
  yyctx.yylsp = yyctx.yyls;
]b4_parse_error_bmatch([detailed\|verbose],[
  yyctx.yymsg = yyctx.yymsgbuf[[0..]];
])
  b4_push_if([[
    yyctx.yyps = yyps;
    yyctx.yypushed_char = yypushed_char;
    yyctx.yypushed_val = yypushed_val;
    yyctx.yypushed_loc = yypushed_loc;

    yyctx.copyFromYyps(yyps);
  ]])
[
    var loop_control: usize = LABEL_YYSETSTATE;
]b4_push_if([[

  switch (yyps.yynew)
    {
      .INIT => {
        yyctx.yyn = yypact[@@intCast(yyctx.yystate)];
        loop_control = LABEL_YYREAD_PUSHED_TOKEN;
      },

    .FINISHED => {
      yyps.deinit();
      return yyctx.yyresult;
    },

    else => {},
    }]])[
][
  while(true) {
    switch(loop_control) {
      LABEL_YYINIT => {
        loop_control = label_yyinit(&yyctx);
      },

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
        loop_control = try label_yybackup(&yyctx);
      },

      LABEL_YYDEFAULT => {
        loop_control = label_yydefault(&yyctx);
      },

      LABEL_YYPUSHRETURN => { break; },

      LABEL_YYREAD_PUSHED_TOKEN => {
        loop_control = try label_yyread_pushed_token(&yyctx);
      },

      LABEL_YYERRLAB1 => {
        loop_control = try label_yyerrlab1(&yyctx);
      },

      LABEL_YYERRLAB => {
        loop_control = try label_yyerrlab(&yyctx);
      },

      LABEL_YYREDUCE => {
        loop_control = try label_yyreduce(&yyctx);
      },

      LABEL_YYERRORLAB => {
        loop_control = label_yyerrorlab(&yyctx);
      },

      LABEL_YYRETURNLAB => {
        loop_control = try label_yyreturnlab(&yyctx);
      },

      else => unreachable,
    }
  }

  // /*-------------------------.
  // | yypushreturn -- return.  |
  // `-------------------------*/
    if (yyctx.yyss != yyctx.yyssa[0..].ptr) {
        yyctx.allocator.free(yyctx.yyss[0..yyctx.yystack_alloc_size]);
    }
  ]b4_lac_if([[
    if (yyctx.yyes != yyctx.yyesa)
      yyctx.allocator.free (yyctx.yyes);]])[
  ]b4_parse_error_bmatch([detailed\|verbose],
  [[  if (yyctx.yymsg.ptr != yyctx.yymsgbuf[0..].ptr) {
        yyctx.allocator.free(yyctx.yymsg);
  }]])[]m4_ifdef([b4_start_symbols], [[
    if (yyimpl)
      yyimpl.yynerrs = yyctx.yynerrs;]])[
  ]
  b4_push_if([yyctx.copyToYyps(yyps);])
  [
    return yyctx.yyresult;
}
]b4_percent_code_get([[epilogue]])[]dnl
b4_main_fn[]dnl
b4_epilogue[]dnl
b4_output_end
