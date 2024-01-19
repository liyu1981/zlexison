/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Skeleton interface for Bison GLR parsers in C

   Copyright (C) 2002-2015, 2018-2021 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_DL_TAB_H_INCLUDED
# define YY_YY_DL_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 29 "dl.y"

    #define DL_PARSER_YACC
    #include <stdio.h>
    #include <stdbool.h>
    #include "dlNode.h"
    #include "dlUtil.h"
    #include "fmemopen.h"
    #include "sds.h"
    #include "dlite.h"

    typedef struct dlite_stmt dlite_stmt;

    typedef struct driver {
        const char* file;
        FILE* fd;
        char* buffer;
        size_t bufferCap; // capacity is the buffer memory allocated
        size_t bufferLen; // buffer len used
        DLQuery* query;
        DLAllocator* pAlloc;
        bool bOwnAlloc; // flag for whether pAlloc is owned by this driver
        void* scanner;
        int error;
        char* errmsg;
    } driver_t;

    #define YYLTYPE loc_t

    #undef QUERYALLOC
    #define QUERYALLOC (driver->pAlloc)

    /* Merge two locations */
    static inline loc_t node_loc_merge(const loc_t *first, const loc_t *second) {
        loc_t loc = {
            .linenoBegin = first->linenoBegin,
            .linenoEnd = second->linenoEnd,
            .begin = first->begin,
            .end = second->end,
        };

        return loc;
    }

    /* Initialize a location */
    static inline loc_t node_loc_init(size_t begin) {
        loc_t loc = {
            .linenoBegin = 1,
            .linenoEnd = 1,
            .begin = begin,
            .end = begin,
        };

        return loc;
    }

    /* Extend location */
    static inline void node_loc_extend(loc_t *loc, size_t end) {
        loc->end = end;
    }

#line 105 "dl.tab.h"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    TK_EOF = 0,                    /* "end of input"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TK_NIL = 258,                  /* "nil"  */
    TK_STRING = 259,               /* "string literal"  */
    TK_INT = 260,                  /* "integer literal"  */
    TK_DOUBLE = 261,               /* "double literal"  */
    TK_KEYWORD = 262,              /* ":keyword literal"  */
    TK_BOOL = 263,                 /* "boolean literal"  */
    TK_CHAR = 264,                 /* "escaped char"  */
    TK_PLAIN_SYMBOL = 265,         /* "plain symbol"  */
    TK_VAR = 266,                  /* "var"  */
    TK_SRC_VAR = 267,              /* "src-var"  */
    TK_BRACKET_OPEN = 268,         /* "["  */
    TK_BRACKET_CLOSE = 269,        /* "]"  */
    TK_PARENTHESES_OPEN = 270,     /* "("  */
    TK_PARENTHESES_CLOSE = 271,    /* ")"  */
    TK_PERCENTAGE = 272,           /* "%"  */
    TK_UNDERSCORE = 273,           /* "_"  */
    TK_DOTDOTDOT = 274,            /* "..."  */
    TK_PULL = 275,                 /* "pull"  */
    TK_NOT = 276,                  /* "not"  */
    TK_NOT_JOIN = 277,             /* "not-join"  */
    TK_OR = 278,                   /* "or"  */
    TK_AND = 279,                  /* "and"  */
    TK_OR_JOIN = 280,              /* "or-join"  */
    TK_RESERVED_FIND = 281,        /* ":find"  */
    TK_RESERVED_KEYS = 282,        /* ":keys"  */
    TK_RESERVED_SYMS = 283,        /* ":syms"  */
    TK_RESERVED_STRS = 284,        /* ":strs"  */
    TK_RESERVED_WITH = 285,        /* ":with"  */
    TK_RESERVED_WHERE = 286,       /* ":where"  */
    TK_RESERVED_IN = 287,          /* ":in"  */
    TK_RESERVED_EXPLAIN = 288      /* ":explain"  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 90 "dl.y"

    DLLiteral* literal;
    DLQuery* query;
    DLNode* node;
    DLNodeList nodeList;

#line 162 "dl.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif



int yyparse (driver_t *driver, void *scanner);
/* "%code provides" blocks.  */
#line 112 "dl.y"

    /* entry point for parsing files */
    /* node_t *example_parse(const char *file); */

    /* shared error handler */
    void yyerror(loc_t *loc, driver_t *driver, void*, const char *msg);

    /* provided by lexer to circumvent lexer-header problems */
    extern void dlLexBegin(driver_t *driver);
    extern void dlLexEnd(driver_t *driver);

    /* NOTE: lexer protoype is in the parser-header to prevent
     *       conflicting types.
     */
    #define YY_DECL int yylex \
               (YYSTYPE* yylval_param, loc_t* yylloc_param , void *yyscanner)
    extern YY_DECL;

#line 207 "dl.tab.h"

#endif /* !YY_YY_DL_TAB_H_INCLUDED  */
