%{

#include "dl.tab.h"
#include <signal.h>

#define YY_EXTRA_TYPE driver_t*

#define YY_USER_ACTION { \
    yylloc->begin = yylloc->end; \
    yylloc->end   = yylloc->begin + yyleng; \
}

#define YY_USER_INIT { \
    yylloc->linenoBegin = 1; \
    yylloc->linenoEnd = 1; \
    yylloc->begin = 0; \
    yylloc->end = 0; \
}

#define YY_NEW_LINE { \
    yylloc->linenoBegin += 1; \
    yylloc->linenoEnd += 1; \
    yylloc->begin = 0; \
    yylloc->end = 0; \
}

#define yyterminate() return TK_EOF;

#ifdef DEBUG
    #define ECHO do { \
        fwrite(yytext, (size_t)yyleng, 1, yyout); \
        fprintf(yyout, "\tline %d col %lu-%lu\n", yylineno, yylloc->begin, yylloc->end); \
    } while (0)
#else
    #define ECHO do {} while(0)
#endif

// QUERYALLOC is shared by dl.l and dl.y but they must point to different
// locations for qalloc. So here we undef and then define.
#undef QUERYALLOC
#define QUERYALLOC ((yyg->yyextra_r->pAlloc))

#define LITERAL_CHAR(x) (struct DLLiteralData){.charValue=x}
#define LITERAL_INT(x) (struct DLLiteralData){.intValue=x}
#define LITERAL_DOUBLE(x) (struct DLLiteralData){.doubleValue=x}
#define LITERAL_BOOL(x) (struct DLLiteralData){.boolValue=x}

#define LITERAL_YYTEXTDUP ((struct DLLiteralData){\
    .charpValue=qstrndup(QUERYALLOC, yytext, yyleng),\
    .len=yylloc->end-yylloc->begin\
})
#define LITERAL_YYTEXTDUP_OFFSET(offset) ((struct DLLiteralData){\
    .charpValue=qstrndup(QUERYALLOC, ((char*)yytext+offset), yyleng-offset),\
    .len=yylloc->end-yylloc->begin-offset\
})

/* check whether symbol is valid by:

   "If -, + or . are the first character, the second character (if any) must be
    non-numeric."

   according to edn spec: https://github.com/edn-format/edn
 */
bool dlTokenIsValidSymbol(char *text)
{
    int tLen;
    char first, second;

    if (tLen > 1)
    {
        first = text[0];
        second = text[1];
        if (first == '-' || first == '+' || first == '.')
        {
            if (second >= '0' && second <= '9')
            {
                return false;
            }
        }
    }
    return true;
}

// convert a string like "\u123a" to Null-terminated multibyte strings of unicode
// https://en.cppreference.com/w/c/string/multibyte
char* dlStr2Unicode(char* s, int* lenp) {
    // we assume s is well formatted, so will not check
    char* r = malloc(5); // max is 4 bytes
    memset(r, 0, 5);
    int i;
    int l = 0;
    for (i=2; i<strlen(s); ++i) { // start from 2 as first 2 chars is always '\\u'
        if (s[i] != '0') { break; } // find the 1st non zero place (deal with \u001)
    }
    if (i>=strlen(s)) {
         // special case: \u0 or \u00 or \u000 or \u0000
         *lenp = 1;
        return r;
    }
    for (int j=i; j<strlen(s); ++j) {
        if (s[j] >= '0' && s[j] <= '9') {
            *(r+(j-i)) = s[j] - '0';
            l += 1;
            continue;
        }
        if (s[j] >= 'a' && s[j] <= 'f') {
            *(r+(j-i)) = (s[j] - 'a') + 10;
            l += 1;
            continue;
        }
    }
    *lenp = l;
    return r;
}


%}

%option noyywrap batch reentrant
%option bison-bridge bison-locations
%option yylineno
%x COMMENT

ws [ \t]
nl [\r\n]
exceptNl [^\r\n]
alpha [A-Za-z]
/* alnum [A-Za-z_0-9] */
utf8 [\x01-\x7f]|[\x80-\xff]+
digit1to9 [1-9]
digit [0-9]

digits {digit}+
frac [.]{digits}
e [eE][+-]?
exp {e}{digits}
decimal {digit}|{digit1to9}{digits}|-{digit}|-{digit1to9}{digits}|\+{digit}|\+{digit1to9}{digits}
int {decimal}|{decimal}{exp}
float {decimal}{frac}|{decimal}{frac}{exp}|{frac}|{frac}{exp}

hexdigit [0-9a-f]
unescapedchar [ -!#-\[\]-~]
escapedchar \\["\\bfnrt/]
unicodechar \\u{hexdigit}?{hexdigit}?{hexdigit}?{hexdigit}
char {unescapedchar}|{escapedchar}|{unicodechar}
chars {char}+
dblquote ["]

plainsymbol [[:alpha:]\.\*\+\-!_&=<>/][[:alnum:]\.\*\+\-!_&=<>/]*

%% /* Rules */

{ws}+

{nl} {
    YY_NEW_LINE;
}

";" {
    BEGIN(COMMENT);
}

<COMMENT>{
    {exceptNl}+ {
        ECHO;
    }

    {nl} {
        YY_NEW_LINE;
        BEGIN(INITIAL);
    }
}

"[" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
    return TK_BRACKET_OPEN;
}

"]" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
    return TK_BRACKET_CLOSE;
}

"(" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
    return TK_PARENTHESES_OPEN;
}

")" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
    return TK_PARENTHESES_CLOSE;
}

"$" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
    return TK_SRC_VAR;
}

"%" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
    return TK_PERCENTAGE;
}

"_" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
    return TK_UNDERSCORE;
}

"..." {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
    return TK_DOTDOTDOT;
}

"pull" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_SYMBOL, LITERAL_YYTEXTDUP, *yylloc);
    return TK_PULL;
}

"not" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_SYMBOL, LITERAL_YYTEXTDUP, *yylloc);
    return TK_NOT;
}

"not-join" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_SYMBOL, LITERAL_YYTEXTDUP, *yylloc);
    return TK_NOT_JOIN;
}

"or" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_SYMBOL, LITERAL_YYTEXTDUP, *yylloc);
    return TK_OR;
}

"and" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_SYMBOL, LITERAL_YYTEXTDUP, *yylloc);
    return TK_AND;
}

"or-join" {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_SYMBOL, LITERAL_YYTEXTDUP, *yylloc);
    return TK_OR_JOIN;
}

:find|:keys|:syms|:strs|:with|:where|:in|:explain {
    ECHO;
    if (strcmp(yytext, ":find") == 0) {
        yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
        return TK_RESERVED_FIND;
    } else if (strcmp(yytext, ":keys") == 0) {
        yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
        return TK_RESERVED_KEYS;
    } else if (strcmp(yytext, ":syms") == 0) {
        yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
        return TK_RESERVED_SYMS;
    } else if (strcmp(yytext, ":strs") == 0) {
        yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
        return TK_RESERVED_STRS;
    } else if (strcmp(yytext, ":with") == 0) {
        yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
        return TK_RESERVED_WITH;
    } else if (strcmp(yytext, ":where") == 0) {
        yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
        return TK_RESERVED_WHERE;
    } else if (strcmp(yytext, ":in") == 0) {
        yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
        return TK_RESERVED_IN;
    } else if (strcmp(yytext, ":explain") == 0) {
        yylval->literal = newLiteral(QUERYALLOC, LT_RESERVED, LITERAL_YYTEXTDUP, *yylloc);
        return TK_RESERVED_EXPLAIN;
    } else {
        fprintf(stderr, "Oops! Can never be here with yytext=%s: file %s, line %d",
            yytext, __FILE__, __LINE__);
        exit(1);
    }
}

nil {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_NIL, LITERAL_INT(0), *yylloc);
    return TK_NIL;
}

true|false {
    ECHO;
    if (strcmp(yytext, "true") == 0) {
        yylval->literal = newLiteral(QUERYALLOC, LT_BOOL, LITERAL_BOOL(true), *yylloc);
    } else {
        yylval->literal = newLiteral(QUERYALLOC, LT_BOOL, LITERAL_BOOL(false), *yylloc);
    }
    return TK_BOOL;
}

{unicodechar} {
    ECHO;
    int ul = 0;
    char* u = dlStr2Unicode(yytext, &ul);
    struct DLLiteralData d = (struct DLLiteralData) {
        .charpValue=qstrndup(QUERYALLOC, u, ul),
        .len = ul
    };
    yylval->literal = newLiteral(QUERYALLOC, LT_UNICODE_CHAR, d, *yylloc);
    free(u);
    return TK_CHAR;
}

{int} {
    ECHO;
    int ival = atoi(yytext);
    yylval->literal = newLiteral(QUERYALLOC, LT_INT, LITERAL_INT(ival), *yylloc);
    return TK_INT;
}

{float} {
    ECHO;
    double dval = atof(yytext);
    yylval->literal = newLiteral(QUERYALLOC, LT_DOUBLE, LITERAL_DOUBLE(dval), *yylloc);
    return TK_DOUBLE;
}

\\{alpha}|\\newline|\\return|\\space|\\tab {
    ECHO;
    struct DLLiteralData d;
    if (strcmp(yytext, "\\newline") == 0) {
        d.charValue = '\n';
    } else if (strcmp(yytext, "\\return") == 0) {
        d.charValue = '\r';
    } else if (strcmp(yytext, "\\space") == 0) {
        d.charValue = ' ';
    } else if (strcmp(yytext, "\\tab") == 0) {
        d.charValue = '\t';
    } else {
        d.charValue = *(yytext+1);
    }
    yylval->literal = newLiteral(QUERYALLOC, LT_CHAR, d, *yylloc);
    return TK_CHAR;
}

{dblquote}{dblquote} |
{dblquote}{chars}{dblquote} {
    ECHO;
    yylval->literal = newLiteral(QUERYALLOC, LT_STRING, LITERAL_YYTEXTDUP, *yylloc);
    return TK_STRING;
}

":"{plainsymbol} {
    ECHO;
    if (!dlTokenIsValidSymbol(yytext)) {
        fprintf(yyout,
            "invalid symbol: %s at line %d col %lu-%lu",
            yytext, yylineno, yylloc->begin, (yylloc->begin + yyleng));
        yyterminate();
    }
    yylval->literal = newLiteral(QUERYALLOC, LT_KEYWORD, LITERAL_YYTEXTDUP_OFFSET(1), *yylloc);
    if (strcmp(yylval->literal->stringValue, yytext+1) != 0) {
        raise(SIGINT);
        printf("literal keyword: %s, %s, %d\n", yylval->literal->stringValue, yytext, yyleng);
    }
    return TK_KEYWORD;
}

"?"{plainsymbol} {
    ECHO;
    if (!dlTokenIsValidSymbol(yytext)) {
        fprintf(yyout,
            "invalid symbol after $: %s at line %d col %lu-%lu",
            yytext, yylineno, yylloc->begin, (yylloc->begin + yyleng));
        yyterminate();
    }
    yylval->literal = newLiteral(QUERYALLOC, LT_SYMBOL, LITERAL_YYTEXTDUP_OFFSET(1), *yylloc);
    return TK_VAR;
}

"$"{plainsymbol} {
    ECHO;
    if (!dlTokenIsValidSymbol(yytext)) {
        fprintf(yyout,
            "invalid symbol after $: %s at line %d col %lu-%lu",
            yytext, yylineno, yylloc->begin, (yylloc->begin + yyleng));
        yyterminate();
    }
    yylval->literal = newLiteral(QUERYALLOC, LT_SYMBOL, LITERAL_YYTEXTDUP_OFFSET(1), *yylloc);
    return TK_SRC_VAR;
}

{plainsymbol} {
    ECHO;
    if (!dlTokenIsValidSymbol(yytext)) {
        fprintf(yyout,
            "invalid symbol: %s at line %d col %lu-%lu",
            yytext, yylineno, yylloc->begin, (yylloc->begin + yyleng));
        yyterminate();
    }
    yylval->literal = newLiteral(QUERYALLOC, LT_SYMBOL, LITERAL_YYTEXTDUP, *yylloc);
    return TK_PLAIN_SYMBOL;
}

"\0"            return TK_EOF;
{utf8}          {
    ECHO;
    yyerror(yylloc, yyextra, NULL, "invalid input");
}

%% /* Footer */

void dlLexBegin(driver_t *driver)
{
    yylex_init_extra(driver, &driver->scanner);
    yyrestart(driver->fd, driver->scanner);
}

void dlLexEnd(driver_t *driver)
{
    yylex_destroy(driver->scanner);
}
