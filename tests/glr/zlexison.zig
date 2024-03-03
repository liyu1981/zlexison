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

// /* "%code requires" blocks.//  */

pub const Node = struct {
    pub const Nterm = struct {
        format: []const u8,
        children: [3]?*Node,
    };
    pub const Term = struct {
        text: []const u8,
    };

    isNterm: bool,
    parents: usize,
    content: union {
        nterm: *Nterm,
        term: *Term,
    },

    pub fn newNterm(allocator: std.mem.Allocator, fmt: []const u8, n1: ?*Node, n2: ?*Node, n3: ?*Node) !*Node {
        var parents: usize = 0;
        if (n1 != null) parents += 1;
        if (n2 != null) parents += 1;
        if (n3 != null) parents += 1;
        const new_nterm = try allocator.create(Nterm);
        new_nterm.* = .{
            .format = fmt,
            .children = .{ n1, n2, n3 },
        };
        const new_node = try allocator.create(Node);
        new_node.* = Node{
            .isNterm = true,
            .parents = 0,
            .content = .{ .nterm = new_nterm },
        };
        return new_node;
    }

    pub fn newTerm(allocator: std.mem.Allocator, text: []const u8) !*Node {
        const new_term = try allocator.create(Term);
        new_term.* = .{
            .text = text,
        };
        const new_node = try allocator.create(Node);
        new_node.* = Node{
            .isNterm = false,
            .parents = 0,
            .content = .{ .term = new_term },
        };
        return new_node;
    }

    pub fn free(this: *allowzero Node, allocator: std.mem.Allocator) void {
        this.parents -= 1;
        if (this.parents > 0) {
            return;
        }
        if (this.isNterm) {
            for (0..3) |i| {
                if (this.content.nterm.children[i]) |c| {
                    c.free(allocator);
                }
            }
            allocator.destroy(this.content.nterm);
        } else {
            allocator.free(this.content.term.text);
            allocator.destroy(this.content.term);
        }
        allocator.destroy(this);
    }

    pub fn toString(this: *allowzero const Node, allocator: std.mem.Allocator) ![]const u8 {
        var buf = std.ArrayList(u8).init(allocator);
        defer buf.deinit();
        var buf_writer = buf.writer();
        if (this.isNterm) {
            var child_strs: [3][]const u8 = undefined;
            var child_strs_count: usize = 0;
            defer {
                for (0..child_strs_count) |i| {
                    allocator.free(child_strs[i]);
                }
            }

            for (0..3) |i| {
                if (this.content.nterm.children[i]) |c| {
                    const s = try c.toString(allocator);
                    if (s.len > 0) {
                        child_strs[child_strs_count] = s;
                        child_strs_count += 1;
                    }
                }
            }

            switch (child_strs_count) {
                0 => return this.content.nterm.format,
                1 => {
                    try buf_writer.print("{s}({s})", .{ this.content.nterm.format, child_strs[0] });
                    return buf.toOwnedSlice();
                },
                2 => {
                    try buf_writer.print("{s}({s}, {s})", .{ this.content.nterm.format, child_strs[0], child_strs[1] });
                    return buf.toOwnedSlice();
                },
                3 => {
                    try buf_writer.print("{s}({s}, {s}, {s})", .{ this.content.nterm.format, child_strs[0], child_strs[1], child_strs[2] });
                    return buf.toOwnedSlice();
                },
                else => unreachable,
            }
        } else {
            try buf_writer.print("{s}", .{this.content.term.text});
        }
        return buf.toOwnedSlice();
    }

    pub fn format(this: Node, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) @TypeOf(writer).Error!void {
        _ = options;
        if (std.mem.eql(u8, fmt, "s")) {
            const s = try this.toString(std.heap.page_allocator);
            defer std.heap.page_allocator.free(s);
            try writer.print("{s}", .{s});
        } else {
            @panic("print YYLTYPE with 's'(full L<begin>:C<begin> - L<end>:C<end>) or 'sb'(L<begin>:C<begin>) or 'se'(L<end>:C<end>)");
        }
    }
};

// /* Token kinds.  */
pub const yytoken_kind_t = enum(i32) {
    YYEMPTY = -2,
    YYEOF = 0, // /* "end of file"//  */
    YYerror = 256, // /* error//  */
    YYUNDEF = 257, // /* "invalid token"//  */
    TYPENAME = 258, // /* "typename"//  */
    ID = 259, // /* "identifier"//  */
};

// /* Value type.  */
pub const YYSTYPE = extern union {
    TYPENAME: ExternUnionType(Node), // /* "typename"//  */
    ID: ExternUnionType(Node), // /* "identifier"//  */
    stmt: ExternUnionType(Node), // /* stmt//  */
    expr: ExternUnionType(Node), // /* expr//  */
    decl: ExternUnionType(Node), // /* decl//  */
    declarator: ExternUnionType(Node), // /* declarator//  */

    pub fn default() YYSTYPE {
        return YYSTYPE{ .declarator = YYSTYPE.defaultValue(Node) };
    }

    pub fn TYPENAME() YYSTYPE {
        return YYSTYPE{ .TYPENAME = YYSTYPE.defaultValue(Node) };
    }

    pub fn ID() YYSTYPE {
        return YYSTYPE{ .ID = YYSTYPE.defaultValue(Node) };
    }

    pub fn stmt() YYSTYPE {
        return YYSTYPE{ .stmt = YYSTYPE.defaultValue(Node) };
    }

    pub fn expr() YYSTYPE {
        return YYSTYPE{ .expr = YYSTYPE.defaultValue(Node) };
    }

    pub fn decl() YYSTYPE {
        return YYSTYPE{ .decl = YYSTYPE.defaultValue(Node) };
    }

    pub fn declarator() YYSTYPE {
        return YYSTYPE{ .declarator = YYSTYPE.defaultValue(Node) };
    }

    fn defaultValue(comptime T: type) ExternUnionType(T) {
        switch (T) {
            []u8, []const u8, [:0]u8, [:0]const u8 => return "",

            u8, u16, u32, u64, u128, i8, i16, i32, i64, i128, isize, usize, c_char, c_short, c_ushort, c_int, c_uint, c_long, c_ulong, c_longlong, c_ulonglong, c_longdouble, f16, f32, f64, f80, f128 => return 0,

            bool => return false,

            Node => return @ptrFromInt(0),

            else => {
                @compileError("provide default value in zlexison.zig for type:" ++ @typeName(T));
            },
        }
    }
};
