// adapted glr example from bison
//
// /* Simplified C++ Type and Expression Grammar.
//    Written by Paul Hilfinger for Bison's test suite.  */

%locations
%debug

/* Nice error messages with details. */
%define parse.error detailed

%code requires
{
  pub const Node = struct{
    pub const Nterm = struct {
      format: []const u8,
      children: [3]?*Node,
    };
    pub const Term = struct {
      text: []const u8,
    };

    isNterm: bool,
    parents: usize,
    content: union{
      nterm: Nterm,
      term: Term,
    },

    pub fn newNterm(allocator: std.mem.Allocator, fmt: []const u8, n1: ?*Node, n2: ?*Node, n3: ?*Node) !*Node {
      var parents: usize = 0;
      if (n1 != null) parents += 1;
      if (n2 != null) parents += 1;
      if (n3 != null) parents += 1;
      const new_node = try allocator.create(Node);
      new_node.* = Node{
        .isNterm = true,
        .parents = parents,
        .content = .{
          .nterm = .{
            .format = fmt,
            .children = .{n1, n2, n3},
          },
        },
      };
      return new_node;
    }

    pub fn newTerm(allocator: std.mem.Allocator, text: []const u8) !*Node {
      const new_node = try allocator.create(Node);
      new_node.* = Node{
        .isNterm = false,
        .parents = 0,
        .content = .{
          .term = .{
            .text = text,
          },
        },
      };
      return new_node;
    }

    pub fn free(this: *allowzero Node, allocator: std.mem.Allocator) void {
        if (@intFromPtr(this) == 0) return;
        if (this.isNterm) {
            // terms can be shared across nterms so to avoid double free use a hashmap
            var terms = std.AutoArrayHashMap(*Node, void).init(allocator);
            defer terms.deinit();
            this._free(allocator, &terms);
            var it = terms.iterator();
            while (it.next()) |t| {
                t.key_ptr.*.free(allocator);
            }
        } else {
            allocator.destroy(this);
        }
    }

    fn _free(this: *allowzero Node, allocator: std.mem.Allocator, terms: *std.AutoArrayHashMap(*Node, void)) void {
        if (this.isNterm) {
            for (0..3) |i| {
                if (this.content.nterm.children[i]) |c| {
                    c._free(allocator, terms);
                }
            }
            allocator.destroy(this);
        } else {
            if (@intFromPtr(this) != 0) {
                terms.put(@ptrCast(this), {}) catch {
                    unreachable;
                };
            }
        }
    }

    pub fn toString(this: *allowzero const Node, allocator: std.mem.Allocator) ![]const u8 {
      var buf = std.ArrayList(u8).init(allocator);
      defer buf.deinit();
      var buf_writer = buf.writer();
      if (@intFromPtr(this) == 0) return buf.toOwnedSlice();
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
          0 => try buf_writer.print("{s}", .{this.content.nterm.format}),
          1 => try buf_writer.print("{s}({s})", .{ this.content.nterm.format, child_strs[0] }),
          2 => try buf_writer.print("{s}({s}, {s})", .{ this.content.nterm.format, child_strs[0], child_strs[1] }),
          3 => try buf_writer.print("{s}({s}, {s}, {s})", .{ this.content.nterm.format, child_strs[0], child_strs[1], child_strs[2] }),
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
}

%code YYSTYPE_defaultValue {
  Node => return @ptrFromInt(0),
}

%code top {
  const YYLexer = @import("scan.zig").YYLexer;
  const Node = zlexison.Node;

  pub const Ast = struct {
    loc: YYLTYPE,
    root: *allowzero Node,
    errmsg_buf: [4096]u8,
    last_err: []u8,
  };
}

%define api.value.type union

%expect-rr 1

%token
  TYPENAME "typename"
  ID "identifier"

%right '='
%left '+'

%glr-parser

%type <Node> stmt expr decl declarator TYPENAME ID
%destructor { $$.free(yyctx.allocator); } <Node>
%printer { const s = try $$.toString(std.heap.page_allocator);
  defer std.heap.page_allocator.free(s);
  try yyo.writer().print("{s}", .{s}); } <Node>

%param {scanner: *YYLexer}{ast_out: *Ast}

%%

prog : %empty
     | prog stmt   { yyctx.ast_out.loc = @2; yyctx.ast_out.root = $2; }
     ;

stmt : expr ';'  %merge <stmtMerge>     { $$ = $1; }
     | decl      %merge <stmtMerge>
     | error ';'        { $$ = try Node.newNterm(yyctx.allocator, "<error>", null, null, null); }
     ;

expr : ID
     | TYPENAME '(' expr ')'
                        { $$ = try Node.newNterm(yyctx.allocator, "<cast>", $3, $1, null); }
     | expr '+' expr    { $$ = try Node.newNterm(yyctx.allocator, "+", $1, $3, null); }
     | expr '=' expr    { $$ = try Node.newNterm(yyctx.allocator, "=", $1, $3, null); }
     ;

decl : TYPENAME declarator ';'
                        { $$ = try Node.newNterm(yyctx.allocator, "<declare>", $1, $2, null); }
     | TYPENAME declarator '=' expr ';'
                        { $$ = try Node.newNterm(yyctx.allocator, "<init-declare>", $1, $2, $4); }
     ;

declarator
     : ID
     | '(' declarator ')' { $$ = $2; }
     ;

%%

fn stmtMerge(yyctx: *yyparse_context_t, x0: *YYSTYPE, x1: *YYSTYPE) !*Node {
    return try Node.newNterm(yyctx.allocator, "<OR>", x0.value.stmt, x1.value.stmt, null);
}

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        _ = gpa.detectLeaks();
    }
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const stdout_writer = std.io.getStdOut().writer();

    var f: std.fs.File = brk: {
        if (args.len > 1) {
            break :brk try std.fs.cwd().openFile(args[1], .{});
        } else {
            break :brk std.io.getStdIn();
        }
    };
    defer f.close();

    const content = try f.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(content);
    try stdout_writer.print("read {d}bytes\n", .{content.len});

    var scanner = YYLexer{ .allocator = allocator };
    try scanner.init();
    defer scanner.deinit();

    try scanner.scan_string(std.mem.trim(u8, content, &std.ascii.whitespace));

    var ast: Ast = undefined;

    _ = try YYParser.yyparse(allocator, &scanner, &ast);

    const out_writer = std.io.getStdOut().writer();
    try out_writer.print("{s}", .{ast.loc});
    try out_writer.print(": ", .{});
    try out_writer.print("{s}", .{ast.root});
    try out_writer.print("\n", .{});
    ast.root.free(allocator);

    return 0;
}
