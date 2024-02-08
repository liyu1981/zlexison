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
pub const YYSTYPE = union {
    TOK_STR: []const u8, // /* "string"//  */
    TOK_NUM: c_int, // /* "number"//  */
    TOK_exp: c_int, // /* exp//  */

};
