const std = @import("std");

/// a comptime checking function to remind what type can use in YYSTYPE and what can not
fn ExternUnionType(comptime T: type) type {
    switch (@typeInfo(T)) {
        .Bool, .Int, .Float => return T,

        .Pointer => |pinfo| {
            if (pinfo.size == .Slice) {
                @compileError("slice is not supported, use pointer to slice instead");
            }
            return T;
        },

        .Array, .Struct, .Enum, .Union => return *allowzero T,

        .ComptimeInt, .ComptimeFloat, .Type, .Void, .NoReturn, .Undefined, .Null, .ErrorSet, .Fn, .Opaque, .Frame, .AnyFrame, .Vector, .EnumLiteral, .Optional, .ErrorUnion => {
            @compileError("not supported type:" ++ @typeName(T));
        },
    }
}

// /* Token kinds.  */
pub const yytoken_kind_t = struct {
    pub var yytoken_kind_t_value_buf: [32]u8 = undefined;

    pub const YYEMPTY = -2;
    // EOF must be defined with value 0
    pub const YYEOF = 0; // /* "end of file"//  */
    // first TOK must start from 258, e.g.,
    // pub const NUM = 258;

    pub fn value2name(v: isize) []const u8 {
        switch (v) {
            -2 => return "YYEMPTY",
            0 => return "YYEOF", // /* "end of file"//  */
            // more names here, e.g.,
            // 258 => return "NUM",

            else => {
                return std.fmt.bufPrint(&yytoken_kind_t_value_buf, "char=({d})", .{v}) catch {
                    return "";
                };
            },
        }
    }
};

// /* Value type.  */
pub const YYSTYPE = extern union {
    dummy: u8,
    // use ExternUnionType to convert type, e.g.,
    // NUM: ExternUnionType(f64), // /* "number"//  */
    // or generate this file from parser.y

    // a default value function must be provided
    pub fn default() YYSTYPE {
        return YYSTYPE{ .dummy = 0 };
    }
};
