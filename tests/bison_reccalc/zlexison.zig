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
pub const YYSTYPE = union(enum) {
    TOK_STR: []const u8, // /* "string"//  */
    TOK_NUM: c_int, // /* "number"//  */
    TOK_exp: c_int, // /* exp//  */

    pub fn default() YYSTYPE {
        return YYSTYPE{ .TOK_exp = YYSTYPE.defaultValue(c_int) };
    }

    pub fn TOK_STR() YYSTYPE {
        return YYSTYPE{ .TOK_STR = YYSTYPE.defaultValue([]const u8) };
    }

    pub fn TOK_NUM() YYSTYPE {
        return YYSTYPE{ .TOK_NUM = YYSTYPE.defaultValue(c_int) };
    }

    pub fn TOK_exp() YYSTYPE {
        return YYSTYPE{ .TOK_exp = YYSTYPE.defaultValue(c_int) };
    }

    fn defaultValue(comptime T: type) T {
        switch (T) {
            []u8, []const u8, [:0]u8, [:0]const u8 => return "",

            u8, u16, u32, u64, u128, i8, i16, i32, i64, i128, isize, usize, c_char, c_short, c_ushort, c_int, c_uint, c_long, c_ulong, c_longlong, c_ulonglong, c_longdouble, f16, f32, f64, f80, f128 => return 0,

            bool => return false,

            else => {
                @compileError("provide default value in zlexison.zig for type:" ++ @typeName(T));
            },
        }
    }
};
