// /* A Bison parser, made by GNU Bison 3.8.2.1-118cd-dirty.//  */

// /* Bison implementation for Yacc-like parsers in C

//    Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
//    Inc.

//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.

//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.

//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <https://www.gnu.org/licenses/>.//  */

// /* As a special exception, you may create a larger work that contains
//    part or all of the Bison parser skeleton and distribute that work
//    under terms of your choice, so long as that work isn't itself a
//    parser generator using the skeleton or a modified version thereof
//    as a parser skeleton.  Alternatively, if you modify or redistribute
//    the parser skeleton itself, you may (at your option) remove this
//    special exception, which will cause the skeleton and the resulting
//    Bison output files to be licensed under the GNU General Public
//    License without this special exception.

//    This special exception was added by the Free Software Foundation in
//    version 2.2 of Bison.//  */

// /* C LALR(1) parser skeleton written by Richard Stallman, by
//   simplifying the original so-called "semantic" parser.  */

// /* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
//    especially those whose name start with YY_ or yy_.  They are
//    private implementation details that can be changed or removed.//  */

// /* All symbols defined below should begin with yy or YY, to avoid
//    infringing on user name space.  This should be done even for local
//    variables, as they might otherwise be expanded by user macros.
//    There are some unavoidable exceptions within include files to
//    define necessary library symbols; they are noted "INFRINGES ON
//    USER NAME SPACE" below.  */

// /* Identify Bison output, and Bison version.  */
pub const YYBISON = 30802;

// /* Bison version string.  */
pub const YYBISON_VERSION = "3.8.2.1-118cd-dirty";

// /* Skeleton name.  */
pub const YYSKELETON_NAME = "yacc.c";

// /* Pure parsers.  */
pub const YYPURE = 2;

// /* Push parsers.  */
pub const YYPUSH = 0;

// /* Pull parsers.  */
pub const YYPULL = 1;

// /* "%code top" blocks.//  */

// #include <stdarg.h> // va_list.
// #include <stdio.h>  // printf.
// #include <stdlib.h> // getenv.









// /* Debug traces.  */
pub const YYDEBUG = 1;

pub extern var yydebug: bool;

// /* "%code requires" blocks.//  */

  // #ifndef YY_TYPEDEF_YY_SCANNER_T
  // # define YY_TYPEDEF_YY_SCANNER_T
  // typedef void* yyscan_t;
  // #endif

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
    TOK_EOF = 0,                   // /* "end-of-file"//  */
    TOK_YYerror = 256,             // /* error//  */
    TOK_YYUNDEF = 257,             // /* "invalid token"//  */
    TOK_PLUS = 258,                // /* "+"//  */
    TOK_MINUS = 259,               // /* "-"//  */
    TOK_STAR = 260,                // /* "*"//  */
    TOK_SLASH = 261,               // /* "/"//  */
    TOK_EOL = 262,                 // /* "end-of-line"//  */
    TOK_NUM = 263,                 // /* "number"//  */
    TOK_STR = 264,                 // /* "string"//  */
    TOK_UNARY = 265                // /* UNARY//  */
  };

// /* Value type.  */
pub const YYSTYPE = union 
{
  TOK_STR: [*c]u8                        ,// /* "string"//  */
  TOK_NUM: c_int                           ,// /* "number"//  */
  TOK_exp: c_int                           ,// /* exp//  */


};





// /* "%code provides" blocks.//  */

  // Tell Flex the expected prototype of yylex.
  // The scanner argument must be named yyscanner.
// #define YY_DECL                                                         \
//  yytoken_kind_t yylex (YYSTYPE* yylval, yyscan_t yyscanner, result *res)
//  YY_DECL;

//  void yyerror (yyscan_t scanner, result *res, const char *msg, ...);



// /* Symbol kind.  */
pub const yysymbol_kind_t = enum(i32)
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      // /* "end-of-file"//  */
  YYSYMBOL_YYerror = 1,                    // /* error//  */
  YYSYMBOL_YYUNDEF = 2,                    // /* "invalid token"//  */
  YYSYMBOL_PLUS = 3,                       // /* "+"//  */
  YYSYMBOL_MINUS = 4,                      // /* "-"//  */
  YYSYMBOL_STAR = 5,                       // /* "*"//  */
  YYSYMBOL_SLASH = 6,                      // /* "/"//  */
  YYSYMBOL_EOL = 7,                        // /* "end-of-line"//  */
  YYSYMBOL_NUM = 8,                        // /* "number"//  */
  YYSYMBOL_STR = 9,                        // /* "string"//  */
  YYSYMBOL_UNARY = 10,                     // /* UNARY//  */
  YYSYMBOL_YYACCEPT = 11,                  // /* $accept//  */
  YYSYMBOL_input = 12,                     // /* input//  */
  YYSYMBOL_line = 13,                      // /* line//  */
  YYSYMBOL_eol = 14,                       // /* eol//  */
  YYSYMBOL_exp = 15                        // /* exp//  */
};


// /* Unqualified %code blocks.//  */

  // result parse_string (const char* cp);
  // result parse (void);


// #ifdef short
// # undef short
// #endif

// /* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
//   <limits.h> and (if available) <stdint.h> are included
//   so that the code can choose integer types of a good width.  */

// #ifndef __PTRDIFF_MAX__
// # include <limits.h> /* INFRINGES ON USER NAME SPACE */
// # if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
// #  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
// #  define YY_STDINT_H
// # endif
// #endif

// /* Narrow types that promote to a signed type and that can represent a
//   signed or unsigned integer of at least N bits.  In tables they can
//   save space and decrease cache pressure.  Promoting to a signed type
//   helps avoid bugs in integer arithmetic.  */

// #ifdef __INT_LEAST8_MAX__
// typedef __INT_LEAST8_TYPE__ yytype_int8;
// #elif defined YY_STDINT_H
// typedef int_least8_t yytype_int8;
// #else
// typedef signed char yytype_int8;
// #endif
pub const yytype_int8 = i8;

// #ifdef __INT_LEAST16_MAX__
// typedef __INT_LEAST16_TYPE__ yytype_int16;
// #elif defined YY_STDINT_H
// typedef int_least16_t yytype_int16;
// #else
// typedef short yytype_int16;
// #endif

// /* Work around bug in HP-UX 11.23, which defines these macros
//    incorrectly for preprocessor constants.  This workaround can likely
//    be removed in 2023, as HPE has promised support for HP-UX 11.23
//    (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
//    <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
// #ifdef __hpux
// # undef UINT_LEAST8_MAX
// # undef UINT_LEAST16_MAX
// # define UINT_LEAST8_MAX 255
// # define UINT_LEAST16_MAX 65535
// #endif

// #if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
// typedef __UINT_LEAST8_TYPE__ yytype_uint8;
// #elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
//        && UINT_LEAST8_MAX <= INT_MAX)
// typedef uint_least8_t yytype_uint8;
// #elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
// typedef unsigned char yytype_uint8;
// #else
// typedef short yytype_uint8;
// #endif

// #if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
// typedef __UINT_LEAST16_TYPE__ yytype_uint16;
// #elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
//        && UINT_LEAST16_MAX <= INT_MAX)
// typedef uint_least16_t yytype_uint16;
// #elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
// typedef unsigned short yytype_uint16;
// #else
// typedef int yytype_uint16;
// #endif

// #ifndef YYPTRDIFF_T
// # if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
// #  define YYPTRDIFF_T __PTRDIFF_TYPE__
// #  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
// # elif defined PTRDIFF_MAX
// #  ifndef ptrdiff_t
// #   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
// #  endif
// #  define YYPTRDIFF_T ptrdiff_t
// #  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
// # else
// #  define YYPTRDIFF_T long
// #  define YYPTRDIFF_MAXIMUM LONG_MAX
// # endif
// #endif

// #ifndef YYSIZE_T
// # ifdef __SIZE_TYPE__
// #  define YYSIZE_T __SIZE_TYPE__
// # elif defined size_t
// #  define YYSIZE_T size_t
// # elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
// #  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
// #  define YYSIZE_T size_t
// # else
// #  define YYSIZE_T unsigned
// # endif
// #endif

// #define YYSIZE_MAXIMUM                                  \
//   YY_CAST (YYPTRDIFF_T,                                 \
//            (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
//             ? YYPTRDIFF_MAXIMUM                         \
//             : YY_CAST (YYSIZE_T, -1)))

// #define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


// /* Stored state numbers (used for stacks). */
// typedef yytype_int8 yy_state_t;
pub const yy_state_t = i8;

// /* State numbers in computations.  */
// typedef int yy_state_fast_t;
pub const yy_state_fast_t = c_int;

// #ifndef YY_
// # if defined YYENABLE_NLS && YYENABLE_NLS
// #  if ENABLE_NLS
// #   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
// #   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
// #  endif
// # endif
// # ifndef YY_
// #  define YY_(Msgid) Msgid
// # endif
// #endif


// #ifndef YY_ATTRIBUTE_PURE
// # if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
// #  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
// # else
// #  define YY_ATTRIBUTE_PURE
// # endif
// #endif

// #ifndef YY_ATTRIBUTE_UNUSED
// # if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
// #  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
// # else
// #  define YY_ATTRIBUTE_UNUSED
// # endif
// #endif

// /* Suppress unused-variable warnings by "using" E.  */
// #if ! defined lint || defined __GNUC__
// # define YY_USE(E) ((void) (E))
// #else
// # define YY_USE(E) /* empty */
// #endif

// /* Suppress an incorrect diagnostic about yylval being uninitialized.  */
// #if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
// # if __GNUC__ * 100 + __GNUC_MINOR__ < 407
// #  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
//     _Pragma ("GCC diagnostic push")                                     \
//     _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
// # else
// #  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
//     _Pragma ("GCC diagnostic push")                                     \
//     _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
//     _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
// # endif
// # define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
//     _Pragma ("GCC diagnostic pop")
// #else
// # define YY_INITIAL_VALUE(Value) Value
// #endif
// #ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
// # define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
// # define YY_IGNORE_MAYBE_UNINITIALIZED_END
// #endif
// #ifndef YY_INITIAL_VALUE
// # define YY_INITIAL_VALUE(Value) /* Nothing. */
// #endif

// #if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
// # define YY_IGNORE_USELESS_CAST_BEGIN                          \
//     _Pragma ("GCC diagnostic push")                            \
//     _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
// # define YY_IGNORE_USELESS_CAST_END            \
//     _Pragma ("GCC diagnostic pop")
// #endif
// #ifndef YY_IGNORE_USELESS_CAST_BEGIN
// # define YY_IGNORE_USELESS_CAST_BEGIN
// # define YY_IGNORE_USELESS_CAST_END
// #endif


// #define YY_ASSERT(E) ((void) (0 && (E)))
pub const YY_ASSERT = std.debug.assert;

// #if 1

// /* The parser invokes alloca or malloc; define the necessary symbols.  */

// # ifdef YYSTACK_USE_ALLOCA
// #  if YYSTACK_USE_ALLOCA
// #   ifdef __GNUC__
// #    define YYSTACK_ALLOC __builtin_alloca
// #   elif defined __BUILTIN_VA_ARG_INCR
// #    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
// #   elif defined _AIX
// #    define YYSTACK_ALLOC __alloca
// #   elif defined _MSC_VER
// #    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
// #    define alloca _alloca
// #   else
// #    define YYSTACK_ALLOC alloca
// #    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
// #     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
//       /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
// #     ifndef EXIT_SUCCESS
// #      define EXIT_SUCCESS 0
// #     endif
// #    endif
// #   endif
// #  endif
// # endif

// # ifdef YYSTACK_ALLOC
//    /* Pacify GCC's 'empty if-body' warning.  */
// #  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
// #  ifndef YYSTACK_ALLOC_MAXIMUM
//     /* The OS might guarantee only one guard page at the bottom of the stack,
//        and a page size can be as small as 4096 bytes.  So we cannot safely
//        invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
//        to allow for a few compiler-allocated temporary stack slots.  */
// #   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
// #  endif
// # else
// #  define YYSTACK_ALLOC YYMALLOC
// #  define YYSTACK_FREE YYFREE
// #  ifndef YYSTACK_ALLOC_MAXIMUM
// #   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
// #  endif
// #  if (defined __cplusplus && ! defined EXIT_SUCCESS \
//        && ! ((defined YYMALLOC || defined malloc) \
//              && (defined YYFREE || defined free)))
// #   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
// #   ifndef EXIT_SUCCESS
// #    define EXIT_SUCCESS 0
// #   endif
// #  endif
// #  ifndef YYMALLOC
// #   define YYMALLOC malloc
// #   if ! defined malloc && ! defined EXIT_SUCCESS
// void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
// #   endif
// #  endif
// #  ifndef YYFREE
// #   define YYFREE free
// #   if ! defined free && ! defined EXIT_SUCCESS
// void free (void *); /* INFRINGES ON USER NAME SPACE */
// #   endif
// #  endif
// # endif
// #endif /* 1 */

// #if (! defined yyoverflow \
//     && (! defined __cplusplus \
//          || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

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
// # define YYSTACK_BYTES(N) \
//      ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
//       + YYSTACK_GAP_MAXIMUM)
pub fn YYSTACK_BYTES(comptime N: usize) usize {
    return N + @sizeOf(yy_state_t) + @sizeOf(YYSTYPE) + YYSTACK_GAP_MAXIMUM;
}


// # define YYCOPY_NEEDED 1
pub const YYCOPY_NEEDED = 1;

// /* Relocate STACK from its old location to the new one.  The
//    local variables YYSIZE and YYSTACKSIZE give the old and new number of
//    elements in the stack, and YYPTR gives the new location of the
//    stack.  Advance YYPTR to a properly aligned location for the next
//    stack.  */
// # define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
//     do                                                                  \
//       {                                                                 \
//         YYPTRDIFF_T yynewbytes;                                         \
//         YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
//         Stack = &yyptr->Stack_alloc;                                    \
//         yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
//         yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
//       }                                                                 \
//     while (0)
//
// #endif
pub fn YYSTACK_RELOCATE(Stack_alloc: yyalloc, Stack_: **yyalloc, yysize: usize, yystacksize: usize, yyptr_: **yyptr_t) void {
    var yynewbytes: usize = 0;
    YYCOPY(yyptr_.*.Stack_alloc, Stack_.*.*, yysize);
    Stack_.* = yyptr_.*.Stack_alloc;
    yynewbytes = yystacksize * @sizeOf(yyalloc) + YYSTACK_GAP_MAXIMUM;
    yyptr_.* = yyptr_.*.* + yynewbytes / @sizeOf(yyptr_t);
}

// #if defined YYCOPY_NEEDED && YYCOPY_NEEDED
// /* Copy COUNT objects from SRC to DST.  The source and destination do
//    not overlap.  */
// # ifndef YYCOPY
// #  if defined __GNUC__ && 1 < __GNUC__
// #   define YYCOPY(Dst, Src, Count) \
//       __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
// #  else
// #   define YYCOPY(Dst, Src, Count)              \
//       do                                        \
//         {                                       \
//           YYPTRDIFF_T yyi;                      \
//           for (yyi = 0; yyi < (Count); yyi++)   \
//             (Dst)[yyi] = (Src)[yyi];            \
//         }                                       \
//       while (0)
// #  endif
// # endif
// #endif /* !YYCOPY_NEEDED */

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
// #define YYTRANSLATE(YYX)                                \
//   (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
//    ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
//    : YYSYMBOL_YYUNDEF)
pub fn YYTRANSLATE(YYX: anytype) yysymbol_kind_t {
    if (YYX >= 0 and YYX <= YYMAXUTOK) {
        return yytranslate[YYX];
    } else {
        return YYSYMBOL_YYUNDEF;
    }
}

// /* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
//    as returned by yylex.  */
pub const yytranslate = [_]yytype_int8{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10
};

// #if YYDEBUG
// /* YYRLINE[YYN] -- Source line where rule number YYN was defined.//  */
pub const yyrline = [_]yytype_uint8{
       0,    98,    98,    99,   103,   109,   116,   117,   121,   122,
     123,   124,   125,   135,   136,   137
};
// #endif

// /** Accessing symbol of state STATE.  */
// #define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])
pub inline fn YY_ACCESSING_SYMBOL(State: anytype) yysymbol_kind_t {
    return yystos[State];
}

// #if 1
// /* The user-facing name of the symbol whose (internal) number is
//    YYSYMBOL.  No bounds checking.  */
// static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

pub fn yysymbol_name(yysymbol: yysymbol_kind_t) [*c]const u8 {
  const yy_sname = []u8 {
  "end-of-file", "error", "invalid token", "+", "-", "*", "/",
  "end-of-line", "number", "string", "UNARY", "$accept", "input", "line",
  "eol", "exp", YY_NULLPTR
  };
  return yy_sname[yysymbol];
}
// #endif

// #define YYPACT_NINF (-5)
pub const YYPACT_NINF = -5;

// #define yypact_value_is_default(Yyn) \
//  ((Yyn) == YYPACT_NINF)
pub fn yypact_value_is_default(Yyn: anytype) bool {
  return false;
}

// #define YYTABLE_NINF (-1)
pub const YYTABLE_NINF = -1;

// #define yytable_value_is_error(Yyn) \
//   0
pub fn yytable_value_is_error(Yyn: anytype) bool {
  return false;
}

// /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
//    STATE-NUM.//  */
pub const yypact = [_]yytype_int8{
      17,    12,    29,    29,    -5,    -5,     2,    -5,    24,    -5,
      -5,    -5,    -5,    -5,    -5,    -5,    29,    29,    29,    29,
      -5,     3,     3,    -5,    -5
};

// /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
//    Performed when YYTABLE does not specify something else to do.  Zero
//    means the default is an error.//  */
pub const yydefact = [_]yytype_int8{
       0,     0,     0,     0,     8,    15,     0,     2,     0,     6,
       7,     5,    13,    14,     1,     3,     0,     0,     0,     0,
       4,     9,    10,    11,    12
};

// /* YYPGOTO[NTERM-NUM].//  */
pub const yypgoto = [_]yytype_int8{
      -5,    -5,     1,    -4,    -2
};

// /* YYDEFGOTO[NTERM-NUM].//  */
pub const yydefgoto = [_]yytype_int8{
       0,     6,     7,    11,     8
};

// /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
//    positive, shift that token.  If negative, reduce the rule whose
//    number is the opposite.  If YYTABLE_NINF, syntax error.//  */
pub const yytable = [_]yytype_int8{
      12,    13,    14,     1,    20,     2,     3,    15,    18,    19,
       4,     5,     9,     0,    21,    22,    23,    24,     1,    10,
       2,     3,     0,     0,     9,     4,     5,    16,    17,    18,
      19,    10,     2,     3,     0,     0,     0,     4,     5
};

pub const yycheck = [_]yytype_int8{
       2,     3,     0,     1,     8,     3,     4,     6,     5,     6,
       8,     9,     0,    -1,    16,    17,    18,    19,     1,     7,
       3,     4,    -1,    -1,     0,     8,     9,     3,     4,     5,
       6,     7,     3,     4,    -1,    -1,    -1,     8,     9
};

// /* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
//    state STATE-NUM.//  */
pub const yystos = [_]yytype_int8{
       0,     1,     3,     4,     8,     9,    12,    13,    15,     0,
       7,    14,    15,    15,     0,    13,     3,     4,     5,     6,
      14,    15,    15,    15,    15
};

// /* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.//  */
pub const yyr1 = [_]yytype_int8{
       0,    11,    12,    12,    13,    13,    14,    14,    15,    15,
      15,    15,    15,    15,    15,    15
};

// /* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.//  */
pub const yyr2 = [_]yytype_int8{
       0,     2,     1,     2,     2,     2,     1,     1,     1,     3,
       3,     3,     3,     2,     2,     1
};


// enum { YYENOMEM = -2 };
pub const YYENOMEM = -2;

// #define yyerrok         (yyerrstatus = 0)
// #define yyclearin       (yychar = TOK_YYEMPTY)

// #define YYACCEPT        goto yyacceptlab
// #define YYABORT         goto yyabortlab
// #define YYERROR         goto yyerrorlab
// #define YYNOMEM         goto yyexhaustedlab


// #define YYRECOVERING()  (!!yyerrstatus)

// #define YYBACKUP(Token, Value)                                    \
//   do                                                              \
//     if (yychar == TOK_YYEMPTY)                                        \
//       {                                                           \
//         yychar = (Token);                                         \
//         yylval = (Value);                                         \
//         YYPOPSTACK (yylen);                                       \
//         yystate = *yyssp;                                         \
//         goto yybackup;                                            \
//       }                                                           \
//     else                                                          \
//       {                                                           \
//         yyerror (yyscan_t, result, YY_("syntax error: cannot back up")); \
//         YYERROR;                                                  \
//       }                                                           \
//   while (0)
pub fn YYBACKUP(Token: anytype, Value: anytype) void {
}

// /* Backward compatibility with an undocumented macro.
//    Use TOK_YYerror or TOK_YYUNDEF. */
// #define YYERRCODE TOK_YYUNDEF
pub const YYERRCODE = TOK_YYUNDEF;


// /* Enable debugging if requested.  */
// #if YYDEBUG

// # ifndef YYFPRINTF
// #  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
// #  define YYFPRINTF fprintf
// # endif

// # define YYDPRINTF(Args)                        \
// do {                                            \
//   if (yydebug)                                  \
//     YYFPRINTF Args;                             \
// } while (0)

// 


// # define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
// do {                                                                      \
//   if (yydebug)                                                            \
//     {                                                                     \
//       YYFPRINTF (stderr, "%s ", Title);                                   \
//       yy_symbol_print (stderr,                                            \
//                   Kind, Value, yyscan_t, result); \
//       YYFPRINTF (stderr, "\n");                                           \
//     }                                                                     \
// } while (0)
pub fn YY_SYMBOL_PRINT(Title: []const u8, Kind: anytype, Value: anytype, Location: anytype) void {
    std.debug.print("%s", .{Title});
    std.debug.print("{any}{any}{any}", .{Kind, Value, yyscan_t, result});
}

// 
// /*-----------------------------------.
// | Print this symbol's value on YYO.  |
// `-----------------------------------*/

// static void
// yy_symbol_value_print (FILE *yyo,
//                        yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep, scanner: yyscan_t, res: *result)
// {
//   FILE *yyoutput = yyo;
//   // YY_USE (yyoutput);
  // YY_USE (yyscan_t);
  // YY_USE (result);
//   if (!yyvaluep)
//     return;
// //   YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
//   switch (yykind)
   // {
   //   else => {},
   // }
//   YY_IGNORE_MAYBE_UNINITIALIZED_END
// // }


// /*---------------------------.
// | Print this symbol on YYO.  |
// `---------------------------*/

// static void
// yy_symbol_print (FILE *yyo,
//                  yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep, scanner: yyscan_t, res: *result)
// {
//   YYFPRINTF (yyo, "%s %s (",
//              yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

// //   yy_symbol_value_print (yyo, yykind, yyvaluep// , yyscan_t, result);
//   YYFPRINTF (yyo, ")");
// }

// /*------------------------------------------------------------------.
// | yy_stack_print -- Print the state stack from its BOTTOM up to its |
// | TOP (included).                                                   |
// `------------------------------------------------------------------*/

// static void
// yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
// {
//   YYFPRINTF (stderr, "Stack now");
//   for (; yybottom <= yytop; yybottom++)
//     {
//       int yybot = *yybottom;
//       YYFPRINTF (stderr, " %d", yybot);
//     }
//   YYFPRINTF (stderr, "\n");
// }

// # define YY_STACK_PRINT(Bottom, Top)                            \
// do {                                                            \
//   if (yydebug)                                                  \
//     yy_stack_print ((Bottom), (Top));                           \
// } while (0)


// /*------------------------------------------------.
// | Report that the YYRULE is going to be reduced.  |
// `------------------------------------------------*/

// static void
// yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 // int yyrule, scanner: yyscan_t, res: *result)
// {
//   int yylno = yyrline[yyrule];
//   int yynrhs = yyr2[yyrule];
//   int yyi;
//   YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
//              yyrule - 1, yylno);
//   /* The symbols being reduced.  */
//   for (yyi = 0; yyi < yynrhs; yyi++)
//     {
//       YYFPRINTF (stderr, "   $%d = ", yyi + 1);
//       yy_symbol_print (stderr,
//                        YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
//                        &yyvsp[(yyi + 1) - (yynrhs)], yyscan_t, result);
//       YYFPRINTF (stderr, "\n");
//     }
// }

// # define YY_REDUCE_PRINT(Rule)          \
// do {                                    \
//   if (yydebug)                          \
//     yy_reduce_print (yyssp, yyvsp, Rule, yyscan_t, result); \
// } while (0)

// /* Nonzero means print parse trace.  It is left uninitialized so that
//   multiple parsers can coexist.  */
pub var yydebug: bool = false;
// int yydebug;
// #else /* !YYDEBUG */
// # define YYDPRINTF(Args) ((void) 0)
// # define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
// # define YY_STACK_PRINT(Bottom, Top)
// # define YY_REDUCE_PRINT(Rule)
// #endif /* !YYDEBUG */


// /* YYINITDEPTH -- initial size of the parser's stacks.  */
// #ifndef YYINITDEPTH
// # define YYINITDEPTH 200
// #endif
pub const YYINITDEPTH = 200;

// /* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
//    if the built-in stack extension method is used).

//    Do not make this value too large; the results are undefined if
//    YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
//    evaluated with infinite-precision integer arithmetic.  */

// #ifndef YYMAXDEPTH
// # define YYMAXDEPTH 10000
pub const YYMAXDEPTH = 10000;
// #endif


// /* Context of a parse error.  */
pub const yypcontext_t = struct {

  yyssp: *yy_state_t,
  yytoken: yysymbol_kind_t,
};

// /* Put in YYARG at most YYARGN of the expected tokens given the
//    current YYCTX, and return the number of tokens stored in YYARG.  If
//    YYARG is null, return the number of expected tokens (guaranteed to
//    be less than YYNTOKENS).  Return YYENOMEM on memory exhaustion.
//    Return 0 if there are more than YYARGN expected tokens, yet fill
//    YYARG up to YYARGN. */
pub fn
yypcontext_expected_tokens (yyctx: *yypcontext_t,
                            yyarg: [*c]yysymbol_kind_t, yyargn: unsize) c_int
{
  // /* Actual size of YYARG. */
  var yycount: c_int = 0;

  var yyn: c_int = yypact[yyctx.yyssp];
  if (!yypact_value_is_default (yyn))
    {
      // /* Start YYX at -YYN if negative to avoid negative indexes in
      //    YYCHECK.  In other words, skip the first -YYN actions for
      //    this state because they are default actions.  */
      var yyxbegin = if (yyn < 0) -yyn else 0;
      // /* Stay within bounds of both yycheck and yytname.  */
      var yychecklim = YYLAST - yyn + 1;
      var yyxend = if (yychecklim < YYNTOKENS) yychecklim else YYNTOKENS;
      var yyx = yyxbegin;
      while (yyx < yyxend) : (yyx += 1) {
        if (yycheck[yyx + yyn] == yyx and yyx != YYSYMBOL_YYerror
            and !yytable_value_is_error (yytable[yyx + yyn]))
          {
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




// #ifndef yystrlen
// # if defined __GLIBC__ && defined _STRING_H
// #  define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
// # else
// /* Return the length of YYSTR.  */
// static YYPTRDIFF_T
// yystrlen (const char *yystr)
// {
//   YYPTRDIFF_T yylen;
//   for (yylen = 0; yystr[yylen]; yylen++)
//     continue;
//   return yylen;
// }
// # endif
// #endif

// #ifndef yystpcpy
// # if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
// #  define yystpcpy stpcpy
// # else
// /* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
//    YYDEST.  */
// static char *
// yystpcpy (char *yydest, const char *yysrc)
// {
//   char *yyd = yydest;
//   const char *yys = yysrc;

//   while ((*yyd++ = *yys++) != '\0')
//     continue;

//   return yyd - 1;
// }
// # endif
// #endif



pub fn yy_syntax_error_arguments (yyctx: *yypcontext_t,
                          yyarg: [*c]yysymbol_kind_t, yyargn: usize) c_int
{
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
  if (yyctx.yytoken != YYSYMBOL_YYEMPTY)
    {
      var yyn: c_int = 0;
      if (yyarg)
        yyarg[yycount] = yyctx.yytoken;
      yycount += 1;
      yyn = yypcontext_expected_tokens (yyctx,
                                        if (yyarg > 0) yyarg + 1 else yyarg, yyargn - 1);
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
pub fn yysyntax_error (yymsg_alloc: *usize, yymsg: *[*c]u8,
                yyctx: *yypcontext_t) c_int
{
  const YYARGS_MAX = 5;
  // /* Internationalized format string. */
  var yyformat: []char = undefined;
  // /* Arguments of yyformat: reported tokens (one for the "unexpected",
  //    one per "expected"). */
  var yyarg: [YYARGS_MAX]yysymbol_kind_t = undefined;
  // /* Cumulated lengths of YYARG.  */
  var yysize: usize = 0;

  // /* Actual size of YYARG. */
  var yycount = yy_syntax_error_arguments (yyctx, yyarg, YYARGS_MAX);
  if (yycount == YYENOMEM)
    return YYENOMEM;

  switch (yycount)
    {
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
        var yysize1: usize
          = yysize + yystrlen (yysymbol_name (yyarg[yyi]));
        if (yysize <= yysize1 and yysize1 <= YYSTACK_ALLOC_MAXIMUM) {
          yysize = yysize1;
        } else {
          return YYENOMEM;
        }
    }
  }

  if (yymsg_alloc.* < yysize)
    {
      yymsg_alloc.* = 2 * yysize;
      if (! (yysize <= yymsg_alloc.*
             and yymsg_alloc.* <= YYSTACK_ALLOC_MAXIMUM))
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
      if (yyp.* == '%' and yyformat[1] == 's' and yyi < yycount)
        {
          yyi += 1;
          yyp = yystpcpy (yyp, yysymbol_name (yyarg[yyi]));
          yyi += 1;
          yyformat += 2;
        }
      else
        {
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

pub fn yydestruct (yymsg: [*c]u8,
            yykind: yysymbol_kind_t, yyvaluep: *YYSTYPE, scanner: yyscan_t, res: *result)
void {
  // YY_USE (yyvaluep);
  // YY_USE (yyscan_t);
  // YY_USE (result);
 if (yymsg == null) {
    yymsg = "Deleting";
  }
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  // YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  // switch (yykind)
   // {
   //   else => {},
   // }
  // YY_IGNORE_MAYBE_UNINITIALIZED_END
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


// /*----------.
// | yyparse.  |
// `----------*/

pub fn yyparse (scanner: yyscan_t, res: *result) c_int {
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

  // TODO: goto!
   // goto yysetstate;


// /*------------------------------------------------------------.
// | yynewstate -- push a new state, which is found in yystate.  |
// `------------------------------------------------------------*/
// TODO: label!
// yynewstate:
//   /* In all cases, when you get here, the value and location stacks
//      have just been pushed.  So pushing a state here evens the stacks.  */
  yyctx.yyssp += 1;


// /*--------------------------------------------------------------------.
// | yysetstate -- set current state (the top of the stack) to yystate.  |
// `--------------------------------------------------------------------*/
// TODO: label!
// yysetstate:
  if (yydebug) {
    std.debug.print("Entering state {d}\n", .{yyctx.yystate});
  }
  YY_ASSERT (0 <= yyctx.yystate and yyctx.yystate < YYNSTATES);
  // YY_IGNORE_USELESS_CAST_BEGIN
  // *yyssp = YY_CAST (yy_state_t, yystate);
  // YY_IGNORE_USELESS_CAST_END
  yyctx.yyssp.* = yyctx.yystate;
  // TODO: get stack print back!
  // YY_STACK_PRINT (yyss, yyssp);

  if (yyctx.yyss + yyctx.yystacksize - 1 <= yyctx.yyssp)
// #if !defined yyoverflow && !defined YYSTACK_RELOCATE
  {
    // TODO: goto!
    // goto yyexhaustedlab;
  }
// #else
    {
      // /* Get the current used size of the three stacks, in elements.  */
      var yysize: usize = yyctx.yyssp - yyctx.yyss + 1;

      if (yyoverflow)
// # if defined yyoverflow
      {
        // /* Give user a chance to reallocate the stack.  Use copies of
        //    these so that the &'s don't force the real ones into
        //    memory.  */
        var yyss1 = yyctx.yyss;
        var yyvs1 = yyctx.yyvs;

        // /* Each stack pointer address is followed by the size of the
        //    data in use in that stack, in bytes.  This used to be a
        //    conditional around just the two extra args, but that might
        //    be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyctx.yyss = yyss1;
        yyctx.yyvs = yyvs1;
      }
      else if (YYSTACK_RELOCATE) {
// # else /* defined YYSTACK_RELOCATE */
      // /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yyctx.yystacksize) {
        // TODO: goto!
        // goto yyexhaustedlab;
      }
      yyctx.yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize) {
        yyctx.yystacksize = YYMAXDEPTH;
      }

      {
        var yyss1 = yyss;
        var yyptr: [*c]yyalloc =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (yyptr == null) {
          // TODO: goto!
          // goto yyexhaustedlab;
        }
        YYSTACK_RELOCATE (yyps, .yyss);
        YYSTACK_RELOCATE (yyps, .yyvs);
        YYSTACK_RELOCATE = false;
// #  undef YYSTACK_RELOCATE
        if (yyss1 != yyctx.yyssa) {
          YYSTACK_FREE (yyss1);
        }
      }
// # endif

      yyctx.yyssp = yyctx.yyss + yyctx.yysize - 1;
      yyctx.yyvsp = yyctx.yyvs + yyctx.yysize - 1;

      // YY_IGNORE_USELESS_CAST_BEGIN
      // YYDPRINTF ((stderr, "Stack size increased to %ld\n",
      //            YY_CAST (long, yystacksize)));
      // YY_IGNORE_USELESS_CAST_END
      if (yydebug) {
        std.debug.print("Stack size increased to {d}\n", yyctx.yystacksize);
      }

      if (yyctx.yyss + yyctx.yystacksize - 1 <= yyctx.yyssp) {
        // TODO: goto!
        // goto yyabortlab;
      }
    }
// #endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yyctx.yystate == YYFINAL) {
    // TODO: goto!
    // goto yyacceptlab;
  }

  // TODO: goto!
  // this goto just fallthrough :)
  // goto yybackup;


// /*-----------.
// | yybackup.  |
// `-----------*/
// TODO: label!
// yybackup:
  // /* Do appropriate processing given the current state.  Read a
  //    lookahead token if we need one and don't already have one.  */

  // /* First try to decide what to do without reference to lookahead token.  */
  yyctx.yyn = yypact[yyctx.yystate];
  if (yypact_value_is_default (yyctx.yyn)) {
    // TODO: label!
    // goto yydefault;
  }

  // /* Not known => get a lookahead token if don't already have one.  */

  // /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yyctx.yychar == TOK_YYEMPTY)
    {
      if (yydebug) {
        std.debug.print("Reading a token\n");
      }
      
      yyctx.yychar = yylex (&yylval, yyscan_t, result);
    }

  if (yyctx.yychar <= TOK_EOF)
    {
      yyctx.yychar = TOK_EOF;
      yyctx.yytoken = YYSYMBOL_YYEOF;
      if (yydebug) {
        std.debug.print("Now at end of input.\n");
      }
    }
  else if (yyctx.yychar == TOK_YYerror)
    {
      // /* The scanner already issued an error message, process directly
      //    to error recovery.  But do not keep the error token as
      //    lookahead, it is too special and may lead us to an endless
      //    loop in error recovery. */
      yyctx.yychar = TOK_YYUNDEF;
      yyctx.yytoken = YYSYMBOL_YYerror;
      // TODO: goto!
      // goto yyerrlab1;
    }
  else
    {
      yyctx.yytoken = YYTRANSLATE (yyctx.yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  // /* If the proper action on seeing token YYTOKEN is to reduce or to
  //    detect an error, take that action.  */
  yyctx.yyn += yyctx.yytoken;
  if (yyctx.yyn < 0 or YYLAST < yyctx.yyn or yyctx.yycheck[yyctx.yyn] != yyctx.yytoken)
      // TODO: goto!
    // goto yydefault;
  yyctx.yyn = yytable[yyctx.yyn];
  if (yyctx.yyn <= 0)
    {
      if (yytable_value_is_error (yyctx.yyn)) {
        // TODO: goto!
        // goto yyerrlab;
      }
      yyctx.yyn = -yyctx.yyn;
        // TODO: goto!
      // goto yyreduce;
    }

  // /* Count tokens shifted since error; after three, turn off error
  //    status.  */
  if (yyctx.yyerrstatus) {
    yyctx.yyerrstatus -= 1;
  }

  // /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yyctx.yystate = yyctx.yyn;
  // YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  yyctx.yyvsp += 1;
  yyctx.yyvsp.* = yyctx.yylval;
  // YY_IGNORE_MAYBE_UNINITIALIZED_END

  // /* Discard the shifted token.  */
  yyctx.yychar = TOK_YYEMPTY;
  // TODO: goto!
  // goto yynewstate;


// /*-----------------------------------------------------------.
// | yydefault -- do the default action for the current state.  |
// `-----------------------------------------------------------*/
// TODO: label!
// yydefault:
  yyctx.yyn = yydefact[yyctx.yystate];
  if (yyctx.yyn == 0) {
    // TODO: goto!
    // goto yyerrlab;
  }
  // TODO: goto!
  // goto yyreduce;


// /*-----------------------------.
// | yyreduce -- do a reduction.  |
// `-----------------------------*/
// TODO: label!
// yyreduce:
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
  yyctx.yyval = yyctx.yyvsp[1-yyctx.yylen];


  YY_REDUCE_PRINT (yyctx.yyn);
  switch (yyctx.yyn)
    {
  4=>{ // /* line: exp eol//  */
    {
      res->value = (yyvsp[-1].TOK_exp);
      if (res->verbose)
        printf ("%d\n", (yyvsp[-1].TOK_exp));
    }
    },

  5=>{ // /* line: error eol//  */
    {
      yyerrok;
    }
    },

  8=>{ // /* exp: "number"//  */
                { (yyval.TOK_exp) = (yyvsp[0].TOK_NUM); }
    },

  9=>{ // /* exp: exp "+" exp//  */
                { (yyval.TOK_exp) = (yyvsp[-2].TOK_exp) + (yyvsp[0].TOK_exp); }
    },

  10=>{ // /* exp: exp "-" exp//  */
                { (yyval.TOK_exp) = (yyvsp[-2].TOK_exp) - (yyvsp[0].TOK_exp); }
    },

  11=>{ // /* exp: exp "*" exp//  */
                { (yyval.TOK_exp) = (yyvsp[-2].TOK_exp) * (yyvsp[0].TOK_exp); }
    },

  12=>{ // /* exp: exp "/" exp//  */
  {
    if ((yyvsp[0].TOK_exp) == 0)
      {
        yyerror (scanner, res, "invalid division by zero");
        YYERROR;
      }
    else
      (yyval.TOK_exp) = (yyvsp[-2].TOK_exp) / (yyvsp[0].TOK_exp);
  }
    },

  13=>{ // /* exp: "+" exp//  */
                       { (yyval.TOK_exp) = + (yyvsp[0].TOK_exp); }
    },

  14=>{ // /* exp: "-" exp//  */
                       { (yyval.TOK_exp) = - (yyvsp[0].TOK_exp); }
    },

  15=>{ // /* exp: "string"//  */
  {
    result r = parse_string ((yyvsp[0].TOK_STR));
    free ((yyvsp[0].TOK_STR));
    if (r.nerrs)
      {
        res->nerrs += r.nerrs;
        YYERROR;
      }
    else
      (yyval.TOK_exp) = r.value;
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
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yyctx.yylen);
  yyctx.yylen = 0;

  yyctx.yyvsp += 1;
  yyctx.yyvsp.* = yyctx.yyval;

  // /* Now 'shift' the result of the reduction.  Determine what state
  //    that goes to, based on the state we popped back to and the rule
  //    number reduced by.  */
  {
    const yylhs = yyr1[yyctx.yyn] - YYNTOKENS;
    const yyi = yypgoto[yyctx.yylhs] + yyctx.yyssp.*;
    yyctx.yystate = if (0 <= yyctx.yyi and yyctx.yyi <= YYLAST and yycheck[yyctx.yyi] == yyctx.yyssp.*
               ? yytable[yyctx.yyi]
               : yydefgoto[yyctx.yylhs]);
  }

  // TODO: goto!
  // goto yynewstate;


// /*--------------------------------------.
// | yyerrlab -- here on detecting error.  |
// `--------------------------------------*/
// TODO: label!
// yyerrlab:
  // /* Make sure we have latest lookahead translation.  See comments at
  //    user semantic actions for why this is necessary.  */
  yyctx.yytoken = if (yyctx.yychar == TOK_YYEMPTY)YYSYMBOL_YYEMPTY : YYTRANSLATE (yyctx.yychar);
  // /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      yyctx.yynerrs += 1;
      {
        var yypctx: yypcontext_t
          = {yyctx.yyssp, yyctx.yytoken};
        var yymsgp: []const u8 = "syntax error";
        var yysyntax_error_status: c_int;
        yysyntax_error_status = yysyntax_error (&yyctx.yymsg_alloc, &yyctx.yymsg, &yypctx);
        if (yysyntax_error_status == 0) {
          yymsgp = yyctx.yymsg;
        } else if (yysyntax_error_status == -1)
          {
            if (yyctx.yymsg != yyctx.yymsgbuf)
              YYSTACK_FREE (yyctx.yymsg);
            yyctx.yymsg = YY_CAST (char *,
                             YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yyctx.yymsg_alloc)));
            if (yyctx.yymsg != null)
              {
                yysyntax_error_status
                  = yysyntax_error (&yyctx.yymsg_alloc, &yyctx.yymsg, &yypctx);
                yymsgp = yyctx.yymsg;
              }
            else
              {
                yymsg = yyctx.yymsgbuf;
                yyctx.yymsg_alloc = yyctx.yymsgbuf.len;
                yysyntax_error_status = YYENOMEM;
              }
          }
        yyerror (yyscan_t, result, yymsgp);
        if (yysyntax_error_status == YYENOMEM) {
          // TODO: goto!
          // goto yyexhaustedlab;
        }
      }
    }

  if (yyerrstatus == 3)
    {
      // /* If just tried and failed to reuse lookahead token after an
      //    error, discard it.  */

      if (yyctx.yychar <= TOK_EOF)
        {
          // /* Return failure if at end of input.  */
          if (yychar == TOK_EOF) {
            // TODO: goto!
            // goto yyabortlab;
          }
        }
      else
        {
          yydestruct ("Error: discarding",
                      yyctx.yytoken, &yyctx.yylval, yyscan_t, result);
          yyctx.yychar = TOK_YYEMPTY;
        }
    }

  // /* Else will try to reuse lookahead token after shifting the error
  //    token.  */
  // TODO: goto!
  // goto yyerrlab1;


// /*---------------------------------------------------.
// | yyerrorlab -- error raised explicitly by YYERROR.  |
// `---------------------------------------------------*/
// TODO: label!
// yyerrorlab:
  // /* Pacify compilers when the user code never invokes YYERROR and the
  //    label yyerrorlab therefore never appears in user code.  */
  // if (0)
  //   YYERROR;
  yyctx.yynerrs ++ 1;

  // /* Do not reclaim the symbols of the rule whose action triggered
  //    this YYERROR.  */
  YYPOPSTACK (yyctx.yylen);
  yyctx.yylen = 0;
  YY_STACK_PRINT (yyctx.yyss, yyctx.yyssp);
  yyctx.yystate = yyctx.yyssp.*;
  // TODO: goto!
  // goto yyerrlab1;


// /*-------------------------------------------------------------.
// | yyerrlab1 -- common code for both syntax error and YYERROR.  |
// `-------------------------------------------------------------*/
// TODO: label!
// yyerrlab1:
  yyctx.yyerrstatus = 3;      // /* Each real token shifted decrements this.  */

  // /* Pop stack until we find a state that shifts the error token.  */
  while(true) {
      yyctx.yyn = yypact[yyctx.yystate];
      if (!yypact_value_is_default (yyctx.yyn))
        {
          yyctx.yyn += YYSYMBOL_YYerror;
          if (0 <= yyctx.yyn and yyctx.yyn <= YYLAST and yycheck[yyctx.yyn] == YYSYMBOL_YYerror)
            {
              yyctx.yyn = yytable[yyctx.yyn];
              if (0 < yyctx.yyn)
                break;
            }
        }

      // /* Pop the current state because it cannot handle the error token.  */
      if (yyctx.yyssp == yyctx.yyss) {
        // TODO: goto!
        // goto yyabortlab;
      }


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yyctx.yystate), yyctx.yyvsp, yyscan_t, result);
      YYPOPSTACK (1);
      yyctx.yystate = yyctx.yyssp.*;
      YY_STACK_PRINT (yyctx.yyss, yyctx.yyssp);
    }

  // YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  yyctx.yyvsp += 1;
  yyctx.yyvsp = yyctx.yylval;
  // YY_IGNORE_MAYBE_UNINITIALIZED_END


  // /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyctx.yyn), yyctx.yyvsp, yyctx.yylsp);

  yyctx.yystate = yyctx.yyn;
  // TODO: goto!
  // goto yynewstate;


// /*-------------------------------------.
// | yyacceptlab -- YYACCEPT comes here.  |
// `-------------------------------------*/
// TODO: label!
// yyacceptlab:
  yyctx.yyresult = 0;
  // TODO: goto!
  // goto yyreturnlab;


// /*-----------------------------------.
// | yyabortlab -- YYABORT comes here.  |
// `-----------------------------------*/
// TODO: label!
// yyabortlab:
  yyctx.yyresult = 1;
  // TODO: goto!
  // goto yyreturnlab;


// /*-----------------------------------------------------------.
// | yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
// `-----------------------------------------------------------*/
// TODO: label!
// yyexhaustedlab:
  yyerror (yyscan_t, result, YY_("memory exhausted"));
  yyctx.yyresult = 2;
  // TODO: goto!
  // goto yyreturnlab;


// /*----------------------------------------------------------.
// | yyreturnlab -- parsing is finished, clean up and return.  |
// `----------------------------------------------------------*/
// TODO: label!
// yyreturnlab:
  if (yyctx.yychar != TOK_YYEMPTY)
    {
      // /* Make sure we have latest lookahead translation.  See comments at
      //   user semantic actions for why this is necessary.  */
      yyctx.yytoken = YYTRANSLATE (yyctx.yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yyctx.yytoken, &yyctx.yylval, yyscan_t, result);
    }
  // /* Do not reclaim the symbols of the rule whose action triggered
  //    this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yyctx.yylen);
  YY_STACK_PRINT (yyctx.yyss, yyctx.yyssp);
  while (yyctx.yyssp != yyctx.yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (yyctx.yyssp.*), yyctx.yyvsp, yyscan_t, result);
      YYPOPSTACK (1);
    }
if (yyoverflow) {
  if (yyctx.yyss != yyctx.yyssa)
    YYSTACK_FREE (yyctx.yyss);
}
  if (yyctx.yymsg != yyctx.yymsgbuf)
    YYSTACK_FREE (yyctx.yymsg);
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
