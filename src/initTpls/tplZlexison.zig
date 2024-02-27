// /* Token kinds.  */
pub const yytoken_kind_t = enum(u32) {
    // EOF must be defined with value 0
    TOK_EOF = 0,
    // first TOK must start from 258, e.g., TOK_NUM = 258
};
// /* Value type.  */
pub const YYSTYPE = extern union {
    pub fn default() YYSTYPE {
        return YYSTYPE{};
    }
};
