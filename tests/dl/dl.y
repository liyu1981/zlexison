/* Procude a GLR parser */
%glr-parser

/* Create a parser-header files for flex */
%defines

/* Verbose error messages */
%define parse.error verbose

/* Enable location tracking */
%locations

/* Create a pure parser */
%define api.pure

/* Generate the parser description file. */
%verbose

/* Enable run-time traces (yydebug). */
%define parse.trace

/* `driver_t` (defined below) holds shared data */
%parse-param              {driver_t *driver}

/* Pass flex's yyscanner through bison */
%parse-param              {void *scanner}
%lex-param                {void *scanner}

%code requires {
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
}

%union {
    DLLiteral* literal;
    DLQuery* query;
    DLNode* node;
    DLNodeList nodeList;
}

%{
    /* Bison needs these macros to handle custom locations */
    #define YYLLOC_DEFAULT(Cur, Rhs, N)                 \
    do                                                  \
    if (N) {                                            \
        (Cur) = node_loc_merge(&(YYRHSLOC(Rhs, 1)),     \
                               &(YYRHSLOC(Rhs, N)));    \
    } else {                                            \
        (Cur).begin = (Cur).end = YYRHSLOC(Rhs, 0).end; \
    }                                                   \
    while (0)
%}

/* Parser header is shared between lexer, parser and user */
%code provides
{
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
}

%initial-action
{
    @$ = node_loc_init(1);
}

%token           TK_EOF               0  "end of input" // used in dl.l
// %token               TK_COMMENT

%token <literal> TK_NIL                  "nil"
%token <literal> TK_STRING               "string literal"
%token <literal> TK_INT                  "integer literal"
%token <literal> TK_DOUBLE               "double literal"
%token <literal> TK_KEYWORD              ":keyword literal"
%token <literal> TK_BOOL                 "boolean literal"
%token <literal> TK_CHAR                 "escaped char"

%token <literal> TK_PLAIN_SYMBOL         "plain symbol" // not start with ? $ or %
%token <literal> TK_VAR                  "var" // symbol start with ?
%token <literal> TK_SRC_VAR              "src-var" // symbol start with $, or just $

%token <literal> TK_BRACKET_OPEN         "[" // [
%token <literal> TK_BRACKET_CLOSE        "]" // ]
%token <literal> TK_PARENTHESES_OPEN     "(" // (
%token <literal> TK_PARENTHESES_CLOSE    ")" // )
%token <literal> TK_PERCENTAGE           "%" // %
%token <literal> TK_UNDERSCORE           "_" // _
%token <literal> TK_DOTDOTDOT            "..." // ...
%token <literal> TK_PULL                 "pull" // pull
%token <literal> TK_NOT                  "not" // not
%token <literal> TK_NOT_JOIN             "not-join" // not-join
%token <literal> TK_OR                   "or" // or
%token <literal> TK_AND                  "and" // and
%token <literal> TK_OR_JOIN              "or-join" // or-join

%token <literal> TK_RESERVED_FIND        ":find" // :find
%token <literal> TK_RESERVED_KEYS        ":keys" // :keys
%token <literal> TK_RESERVED_SYMS        ":syms" // :syms
%token <literal> TK_RESERVED_STRS        ":strs" // :strs
%token <literal> TK_RESERVED_WITH        ":with" // :with
%token <literal> TK_RESERVED_WHERE       ":where" // :where
%token <literal> TK_RESERVED_IN          ":in" // :in
%token <literal> TK_RESERVED_EXPLAIN     ":explain" // :explain

%type <query> query-body;
%type <node> find-spec return-map-spec with-clause inputs where-clauses
             find-elem fn-arg aggregate pull-expr pattern-arg variable
             src-var constant return-keys return-syms return-strs input-param
             clause binding bind-tuple bind-coll bind-rel not-clause
             expression-clause data-pattern or-clause and-clause
             or-inner-clause not-join-clause or-join-clause rule-expr pred-expr
             fn-expr fn str;
%type <nodeList> find-elems fn-args pattern-args variables symbols input-params
                 clauses or-inner-clauses str-list;

%% /* Grammar */

query
    : TK_BRACKET_OPEN TK_RESERVED_EXPLAIN query-body TK_BRACKET_CLOSE {
        $3->explain = true;
        driver->query = $3;
    }
    | TK_BRACKET_OPEN query-body TK_BRACKET_CLOSE { driver->query = $2; }
    ;

query-body
    : find-spec return-map-spec with-clause inputs where-clauses { $$ = newQuery(QUERYALLOC, $1,   $2,   $3,   $4,   $5); }
    | find-spec return-map-spec with-clause                      { $$ = newQuery(QUERYALLOC, $1,   $2,   $3, NULL, NULL); }
    | find-spec return-map-spec with-clause inputs               { $$ = newQuery(QUERYALLOC, $1,   $2,   $3,   $4, NULL); }
    | find-spec return-map-spec with-clause        where-clauses { $$ = newQuery(QUERYALLOC, $1,   $2,   $3, NULL,   $4); }
    | find-spec return-map-spec             inputs where-clauses { $$ = newQuery(QUERYALLOC, $1,   $2, NULL,   $3,   $4); }
    | find-spec return-map-spec                                  { $$ = newQuery(QUERYALLOC, $1,   $2, NULL, NULL, NULL); }
    | find-spec return-map-spec             inputs               { $$ = newQuery(QUERYALLOC, $1,   $2, NULL,   $3, NULL); }
    | find-spec return-map-spec                    where-clauses { $$ = newQuery(QUERYALLOC, $1,   $2, NULL, NULL,   $3); }
    | find-spec                 with-clause inputs where-clauses { $$ = newQuery(QUERYALLOC, $1, NULL,   $2,   $3,   $4); }
    | find-spec                 with-clause                      { $$ = newQuery(QUERYALLOC, $1, NULL,   $2, NULL, NULL); }
    | find-spec                 with-clause inputs               { $$ = newQuery(QUERYALLOC, $1, NULL,   $2,   $3, NULL); }
    | find-spec                 with-clause        where-clauses { $$ = newQuery(QUERYALLOC, $1, NULL,   $2, NULL,   $3); }
    | find-spec                             inputs where-clauses { $$ = newQuery(QUERYALLOC, $1, NULL, NULL,   $2,   $3); }
    | find-spec                                                  { $$ = newQuery(QUERYALLOC, $1, NULL, NULL, NULL, NULL); }
    | find-spec                             inputs               { $$ = newQuery(QUERYALLOC, $1, NULL, NULL,   $2, NULL); }
    | find-spec                                    where-clauses { $$ = newQuery(QUERYALLOC, $1, NULL, NULL, NULL,   $2); }
    ;

find-spec
    : TK_RESERVED_FIND find-elems {
        DLFindSpec* fspec = qmalloc(QUERYALLOC, sizeof(DLFindSpec));
        fspec->elems = $2;
        loc_t nll = getNodeListLoc($2);
        loc_t loc = node_loc_merge(&($1->loc), &nll);
        $$ = newNode(QUERYALLOC, NT_SPEC_FIND, fspec, loc);
    }
    ;

return-map-spec
    : return-keys { $$ = $1; }
    | return-syms { $$ = $1; }
    | return-strs { $$ = $1; }
    ;

with-clause
    : TK_RESERVED_WITH variables {
        DLWithSpec* wspec = qmalloc(QUERYALLOC, sizeof(DLWithSpec));
        wspec->elems = $2;
        loc_t nll = getNodeListLoc($2);
        loc_t loc = node_loc_merge(&($1->loc), &nll);
        $$ = newNode(QUERYALLOC, NT_SPEC_WITH, wspec, loc);
    }
    ;

inputs
    : TK_RESERVED_IN input-params {
        DLInputsSpec* ispec = qmalloc(QUERYALLOC, sizeof(DLInputsSpec));
        ispec->elems = $2;
        loc_t nll = getNodeListLoc($2);
        loc_t loc = node_loc_merge(&($1->loc), &nll);
        $$ = newNode(QUERYALLOC, NT_SPEC_INPUTS, ispec, loc);
    }
    ;

where-clauses
    : TK_RESERVED_WHERE clauses {
        DLWhereSpec* wspec = qmalloc(QUERYALLOC, sizeof(DLWhereSpec));
        wspec->elems = $2;
        loc_t nll = getNodeListLoc($2);
        loc_t loc = node_loc_merge(&($1->loc), &nll);
        $$ = newNode(QUERYALLOC, NT_SPEC_WHERE, wspec, loc);
    }
    ;

return-keys
    : TK_RESERVED_KEYS symbols {
        loc_t nll = getNodeListLoc($2);
        loc_t loc = node_loc_merge(&($1->loc), &nll);
        DLReturnSpec* rspec = qmalloc(QUERYALLOC, sizeof(DLReturnSpec));
        rspec->type = RS_KEYS;
        rspec->elems = $2;
        $$ = newNode(QUERYALLOC, NT_SPEC_RETURN, rspec, loc);
    }
    ;

return-syms
    : TK_RESERVED_SYMS symbols {
        loc_t nll = getNodeListLoc($2);
        loc_t loc = node_loc_merge(&($1->loc), &nll);
        DLReturnSpec* rspec = qmalloc(QUERYALLOC, sizeof(DLReturnSpec));
        rspec->type = RS_SYMS;
        rspec->elems = $2;
        $$ = newNode(QUERYALLOC, NT_SPEC_RETURN, rspec, loc);
     }
    ;

return-strs
    : TK_RESERVED_STRS str-list {
        loc_t nll = getNodeListLoc($2);
        loc_t loc = node_loc_merge(&($1->loc), &nll);
        DLReturnSpec* rspec = qmalloc(QUERYALLOC, sizeof(DLReturnSpec));
        rspec->type = RS_STRS;
        rspec->elems = $2;
        $$ = newNode(QUERYALLOC, NT_SPEC_RETURN, rspec, loc);
    }
    ;

input-params
    : input-param { $$ = newNodeList(QUERYALLOC, $1); }
    | input-params input-param { $$ = nodeListConcat(QUERYALLOC, $1, $2); }
    ;

input-param
    : src-var { $$ = $1; }
    | binding { $$ = $1; }
    | TK_PLAIN_SYMBOL { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    | TK_PERCENTAGE { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    ;

clauses
    : clause { $$ = newNodeList(QUERYALLOC, $1); }
    | clauses clause { $$ = nodeListConcat(QUERYALLOC, $1, $2); }
    ;

clause
    : not-clause { $$ = $1; }
    | not-join-clause { $$ = $1; }
    | or-clause {$$ = $1; }
    | or-join-clause { $$ = $1; }
    | expression-clause { $$ = $1; }
    ;

find-elems
    : find-elem { $$ = newNodeList(QUERYALLOC, $1); }
    | find-elems find-elem { $$ = nodeListConcat(QUERYALLOC, $1, $2); }
    ;

find-elem
    : variable { $$ = $1; }
    | pull-expr { $$ = $1; }
    | aggregate { $$ = $1; }
    ;

pull-expr
    : TK_PARENTHESES_OPEN TK_PULL variable TK_BRACKET_OPEN pattern-args TK_BRACKET_CLOSE TK_PARENTHESES_CLOSE {
        DLPullExpr* pep = qmalloc(QUERYALLOC, sizeof(DLPullExpr));
        pep->var = $3;
        pep->pattern = $5;
        loc_t loc = node_loc_merge(&($1->loc), &($7->loc));
        $$ = newNode(QUERYALLOC, NT_PULL_EXPR, pep, loc);
    }
    ;

aggregate
    : TK_PARENTHESES_OPEN TK_PLAIN_SYMBOL fn-args TK_PARENTHESES_CLOSE {
        loc_t l = node_loc_merge(&($1->loc), &($4->loc));
        char* fname = $2->stringValue;
        if (isAggregateFunctionName(fname)) {
            DLFunction* func = newFunction(QUERYALLOC, $2, $3, l);
            $$ = newNode(QUERYALLOC, NT_AGGREGATE, func, l);
        } else {
            char msg[256];
            sprintf(msg, "syntax error, unexpected aggregate function name: %s", fname);
            yyerror (&($2->loc), driver, scanner, YY_(msg));
            YYABORT;
        }
    }
    ;

fn-args
    : fn-arg { $$ = newNodeList(QUERYALLOC, $1); }
    | fn-args fn-arg { $$ = nodeListConcat(QUERYALLOC, $1, $2); }
    ;

fn-arg
    : variable { $$ = $1; }
    | constant { $$ = $1; }
    | src-var { $$ = $1; }
    ;

symbols
    : TK_PLAIN_SYMBOL {
        $$ = newNodeList(QUERYALLOC, newNode(QUERYALLOC, NT_LITERAL, $1, yylloc));
    }
    | symbols TK_PLAIN_SYMBOL {
        $$ = nodeListConcat(QUERYALLOC, $1, newNode(QUERYALLOC, NT_LITERAL, $2, yylloc));
    }
    ;

variables
    : variable { $$ = newNodeList(QUERYALLOC, $1); }
    | variables variable { $$ = nodeListConcat(QUERYALLOC, $1, $2); }
    ;

binding
    : variable { $$ = $1; }
    | bind-tuple { $$ = $1; }
    | bind-coll { $$ = $1; }
    | bind-rel { $$ = $1; }
    ;

bind-tuple
    : TK_BRACKET_OPEN variables TK_BRACKET_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($3->loc));
        DLTuple* t = qmalloc(QUERYALLOC, sizeof(DLTuple));
        t->elems = $2;
        $$ = newNode(QUERYALLOC, NT_BIND_TUPLE, t, loc);
    }
    ;

bind-coll
    : TK_BRACKET_OPEN variable TK_DOTDOTDOT TK_BRACKET_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($4->loc));
        $$ = newNode(QUERYALLOC, NT_BIND_COLL, $2, loc);
    }
    ;

bind-rel
    : TK_BRACKET_OPEN bind-tuple TK_BRACKET_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($3->loc));
        $$ = newNode(QUERYALLOC, NT_BIND_REL, $2, loc);
    }
    ;

not-clause
    : TK_PARENTHESES_OPEN src-var TK_NOT clauses TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($5->loc));
        DLNotClause* nclause = qmalloc(QUERYALLOC, sizeof(DLNotClause));
        nclause->hasSrcVar = true;
        nclause->srcVar = $2;
        nclause->clauses = $4;
        $$ = newNode(QUERYALLOC, NT_NOT_CLAUSE, nclause, loc);
    }
    | TK_PARENTHESES_OPEN TK_NOT clauses TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($4->loc));
        DLNotClause* nclause = qmalloc(QUERYALLOC, sizeof(DLNotClause));
        nclause->hasSrcVar = false;
        nclause->srcVar = NULL;
        nclause->clauses = $3;
        $$ = newNode(QUERYALLOC, NT_NOT_CLAUSE, nclause, loc);
    }
    ;

not-join-clause
    : TK_PARENTHESES_OPEN src-var TK_NOT_JOIN TK_BRACKET_OPEN variables TK_BRACKET_CLOSE clauses TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($8->loc));
        DLNotJoinClause* njclause = qmalloc(QUERYALLOC, sizeof(DLNotJoinClause));
        njclause->hasSrcVar = true;
        njclause->srcVar = $2;
        njclause->vars = $5;
        njclause->clauses = $7;
        $$ = newNode(QUERYALLOC, NT_NOT_JOIN_CLAUSE, njclause, loc);
    }
    | TK_PARENTHESES_OPEN TK_NOT_JOIN TK_BRACKET_OPEN variables TK_BRACKET_CLOSE clauses TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($7->loc));
        DLNotJoinClause* njclause = qmalloc(QUERYALLOC, sizeof(DLNotJoinClause));
        njclause->hasSrcVar = false;
        njclause->srcVar = NULL;
        njclause->vars = $4;
        njclause->clauses = $6;
        $$ = newNode(QUERYALLOC, NT_NOT_JOIN_CLAUSE, njclause, loc);
    }
    ;

or-clause
    : TK_PARENTHESES_OPEN src-var TK_OR or-inner-clauses TK_PARENTHESES_CLOSE{
        loc_t loc = node_loc_merge(&($1->loc), &($5->loc));
        DLOrClause* oclause = qmalloc(QUERYALLOC, sizeof(DLOrClause));
        oclause->hasSrcVar = true;
        oclause->srcVar = $2;
        oclause->clauses = $4;
        $$ = newNode(QUERYALLOC, NT_OR_CLAUSE, oclause, loc);
    }
    | TK_PARENTHESES_OPEN TK_OR or-inner-clauses TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($4->loc));
        DLOrClause* oclause = qmalloc(QUERYALLOC, sizeof(DLOrClause));
        oclause->hasSrcVar = false;
        oclause->srcVar = NULL;
        oclause->clauses = $3;
        $$ = newNode(QUERYALLOC, NT_OR_CLAUSE, oclause, loc);
    }
    ;

or-inner-clauses
    : or-inner-clause { $$ = newNodeList(QUERYALLOC, $1); }
    | or-inner-clauses or-inner-clause { $$ = nodeListConcat(QUERYALLOC, $1, $2); }
    ;

or-inner-clause
    : clause { $$ = $1; }
    | and-clause { $$ = $1; }
    ;

and-clause
    : TK_PARENTHESES_OPEN TK_AND clauses TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($4->loc));
        DLAndClause* aclause = qmalloc(QUERYALLOC, sizeof(DLAndClause));
        aclause->clauses = $3;
        $$ = newNode(QUERYALLOC, NT_AND_CLAUSE, aclause, loc);
    }
    ;

or-join-clause
    : TK_PARENTHESES_OPEN src-var TK_OR_JOIN TK_BRACKET_OPEN variables TK_BRACKET_CLOSE or-inner-clauses TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($8->loc));
        DLOrJoinClause* ojclause = qmalloc(QUERYALLOC, sizeof(DLOrJoinClause));
        ojclause->hasSrcVar = true;
        ojclause->srcVar = $2;
        ojclause->vars = $5;
        ojclause->clauses = $7;
        $$ = newNode(QUERYALLOC, NT_OR_JOIN_CLAUSE, ojclause, loc);
    }
    | TK_PARENTHESES_OPEN TK_OR_JOIN TK_BRACKET_OPEN variables TK_BRACKET_CLOSE or-inner-clauses TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($7->loc));
        DLOrJoinClause* ojclause = qmalloc(QUERYALLOC, sizeof(DLOrJoinClause));
        ojclause->hasSrcVar = false;
        ojclause->srcVar = NULL;
        ojclause->vars = $4;
        ojclause->clauses = $6;
        $$ = newNode(QUERYALLOC, NT_OR_JOIN_CLAUSE, ojclause, loc);
    }
    ;

expression-clause
    : data-pattern { $$ = $1; }
    | pred-expr { $$ = $1; }
    | fn-expr { $$ = $1; }
    | rule-expr { $$ = $1; }
    ;

data-pattern
    : TK_BRACKET_OPEN src-var pattern-args TK_BRACKET_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($4->loc));
        DLDataPattern* dpatternp = qmalloc(QUERYALLOC, sizeof(DLDataPattern));
        dpatternp->hasSrcVar = true;
        dpatternp->srcVar = $2;
        dpatternp->pattern = $3;
        $$ = newNode(QUERYALLOC, NT_DATA_PATTERN, dpatternp, loc);
    }
    | TK_BRACKET_OPEN pattern-args TK_BRACKET_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($3->loc));
        DLDataPattern* dpatternp = qmalloc(QUERYALLOC, sizeof(DLDataPattern));
        dpatternp->hasSrcVar = false;
        dpatternp->srcVar = NULL;
        dpatternp->pattern = $2;
        $$ = newNode(QUERYALLOC, NT_DATA_PATTERN, dpatternp, loc);
    }
    ;

pattern-args
    : pattern-arg { $$ = newNodeList(QUERYALLOC, $1); }
    | pattern-args pattern-arg { $$ = nodeListConcat(QUERYALLOC, $1, $2); }
    ;

pattern-arg
    : variable { $$ = $1; }
    | constant { $$ = $1; }
    | TK_UNDERSCORE { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    ;

pred-expr
    : TK_BRACKET_OPEN fn-expr TK_BRACKET_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($3->loc));
        DLPredExpr* pexprp = qmalloc(QUERYALLOC, sizeof(DLPredExpr));
        pexprp->fn = NULL;
        pexprp->fnExpr = $2;
        $$ = newNode(QUERYALLOC, NT_PRED_EXPR, pexprp, loc);
    }
    | TK_BRACKET_OPEN fn TK_BRACKET_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($3->loc));
        DLPredExpr* pexprp = qmalloc(QUERYALLOC, sizeof(DLPredExpr));
        pexprp->fn = $2;
        pexprp->fnExpr = NULL;
        $$ = newNode(QUERYALLOC, NT_PRED_EXPR, pexprp, loc);
    }
    ;

fn-expr
    : TK_BRACKET_OPEN fn binding TK_BRACKET_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($4->loc));
        DLFnExpr* fexprp = qmalloc(QUERYALLOC, sizeof(DLFnExpr));
        fexprp->fn = $2;
        fexprp->binding = $3;
        $$ = newNode(QUERYALLOC, NT_FN_EXPR, fexprp, loc);
    }
    ;

fn
    : TK_PARENTHESES_OPEN TK_PLAIN_SYMBOL fn-args TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($4->loc));
        DLFn* fnp = qmalloc(QUERYALLOC, sizeof(DLFn));
        fnp->name = $2;
        fnp->args = $3;
        $$ = newNode(QUERYALLOC, NT_FN, fnp, loc);
    }
    ;

rule-expr
    : TK_PARENTHESES_OPEN src-var TK_PLAIN_SYMBOL pattern-args TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($5->loc));
        DLRuleExpr* rexprp = qmalloc(QUERYALLOC, sizeof(DLRuleExpr));
        rexprp->hasSrcVar = true;
        rexprp->srcVar = $2;
        rexprp->name = $3;
        rexprp->args = $4;
        $$ = newNode(QUERYALLOC, NT_RULE_EXPR, rexprp, loc);
    }
    | TK_PARENTHESES_OPEN TK_PLAIN_SYMBOL pattern-args TK_PARENTHESES_CLOSE {
        loc_t loc = node_loc_merge(&($1->loc), &($4->loc));
        DLRuleExpr* rexprp = qmalloc(QUERYALLOC, sizeof(DLRuleExpr));
        rexprp->hasSrcVar = false;
        rexprp->srcVar = NULL;
        rexprp->name = $2;
        rexprp->args = $3;
        $$ = newNode(QUERYALLOC, NT_RULE_EXPR, rexprp, loc);
    }
    ;

variable
    : TK_VAR { $$ = newNode(QUERYALLOC, NT_VAR, $1, yylloc); }
    ;

constant
    : TK_BOOL { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    | TK_INT { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    | TK_DOUBLE { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    | TK_CHAR { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    | TK_NIL { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    | TK_KEYWORD { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    | TK_STRING { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    ;

src-var
    : TK_SRC_VAR { $$ = newNode(QUERYALLOC, NT_SRC_VAR, $1, yylloc); }
    ;

str-list
    : str { $$ = newNodeList(QUERYALLOC, $1); }
    | str-list str { $$ = nodeListConcat(QUERYALLOC, $1, $2); }
    ;

str
    : TK_STRING { $$ = newNode(QUERYALLOC, NT_LITERAL, $1, yylloc); }
    ;

%% /* Footer */

void yyerror(loc_t *pLoc, driver_t *pDriver, void *scanner,  const char *msg)
{
    size_t bp = getNthLineBegin(pDriver->buffer, pDriver->bufferLen, pLoc->linenoBegin);
    char* parsed = strndup(pDriver->buffer + bp, pLoc->end);
    char* padding1 = getPadding(pLoc->begin, ' ');
    char* padding2 = getPadding(pLoc->end - pLoc->begin, '^');
    sds zBuf = sdscatprintf(sdsempty(),
        "In Line %lu, Col %lu-%lu from FILE: %s:\n"
        "%s\n"
        "%s%s => %s\n",
        pLoc->linenoBegin, pLoc->begin, pLoc->end, pDriver->file,
        parsed,
        padding1, padding2, msg
    );
    pDriver->error = DLITE_ERROR_SYNTAX;
    pDriver->errmsg = qstrndup(pDriver->pAlloc, zBuf, sdslen(zBuf));
    free(parsed);
    free(padding1);
    free(padding2);
    sdsfree(zBuf);
}

int dlParse(driver_t *pDriver) {
    dlLexBegin(pDriver);
    int ret = yyparse(pDriver, pDriver->scanner);
    dlLexEnd(pDriver);
    return ret;
}

void initDlDriver(driver_t* pDriver, DLAllocator* pAlloc, const char* zFile) {
    assert(pDriver != NULL);
    memset(pDriver, 0, sizeof(driver_t));
    pDriver->file = (zFile == NULL) ? "stdin" : zFile;
    pDriver->pAlloc = (pAlloc == NULL) ? newDLAllocator() : pAlloc;
    pDriver->bOwnAlloc = (pAlloc == NULL) ? true : false;
}

int dlDriverOpenBuffer(driver_t* pDriver, const char* pBuf, size_t len) {
    pDriver->buffer = strndup(pBuf, len);
    pDriver->bufferLen = pDriver->bufferCap = len;
    pDriver->fd = fmemopen(pDriver->buffer, pDriver->bufferLen, "r");
    if (pDriver->fd == NULL) {
        return 1;
    }
    return 0;
}

void destroyDlDriver(driver_t* pDriver) {
    if (pDriver == NULL) { return; }
    if (pDriver->fd != NULL) { fclose(pDriver->fd); }
    if (pDriver->buffer != NULL) { free(pDriver->buffer); }
    if (pDriver->bOwnAlloc) {
        qfreeAll(pDriver->pAlloc);
        free(pDriver->pAlloc);
    }
    // query is freed automatically as it is allocated through qalloc
}
