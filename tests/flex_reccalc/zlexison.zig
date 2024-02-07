pub const YYSTYPE = struct {
    TOK_STR: []const u8 = undefined, // /* "string"//  */
    TOK_NUM: c_int = 0, // /* "number"//  */
    TOK_exp: c_int = 0, // /* exp//  */
};
pub const TOK_TYPE = enum(u32) {
    TOK_EOF = 0,
    // first TOK should start from 258, e.g., TOK_NUM = 258,
    TOK_PLUS = 258,
    TOK_MINUS,
    TOK_STAR,
    TOK_SLASH,
    TOK_EOL,
    TOK_NUM,
    TOK_STR,
};
