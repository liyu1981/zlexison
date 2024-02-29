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
      form: []const u8,
      children: [3]*Node,
    };
    pub const Term = struct {
      text: []const u8,
    };

    isNterm: bool,
    parents: usize,
    content: union{
      nterm: *Nterm,
      term: *Term,
    },

    pub fn newNterm(allocator: std.mem.Allocator, form: []const u8, n1: ?*Node, n2: ?*Node, n3: ?*Node) !*Node {
      var parents: usize = 0;
      if (n1 != null) parents += 1;
      if (n2 != null) parents += 1;
      if (n3 != null) parents += 1;
      const new_nterm = try allocator.create(Nterm);
      new_nterm.* = .{
        .form = form,
        .children = .{n1, n2, n3},
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

    pub fn free(this: *Node, allocator: std.mem.Allocator) void {
      this.parents -= 1;
      if (this.parents > 0) {
        return;
      }
      if (this.isNterm) {
        this.content.nterm.children[0].free(allocator);
        this.content.nterm.children[1].free(allocator);
        this.content.nterm.children[2].free(allocator);
        allocator.free(this.content.nterm.form);
        allocator.destroy(this.content.nterm);
      } else {
        allocator.free(this.content.term.text);
        allocator.destroy(this.content.term);
      }
      allocator.destroy(this);
    }

    pub fn toString(this: *const Node, allocator: std.mem.Allocator) ![]const u8 {
      var buf = std.ArrayList(u8).init(allocator);
      defer buf.deinit();
      var buf_writer = buf.writer();
      if (this.isNterm) {
        const cs1 = try this.content.nterm.children[0].toString(allocator);
        defer allocator.free(cs1);
        const cs2 = try this.content.nterm.children[1].toString(allocator);
        defer allocator.free(cs2);
        const cs3 = try this.content.nterm.children[2].toString(allocator);
        defer allocator.free(cs3);
        try buf_writer.print("{s}{s}{s}", .{cs1, cs2, cs3});
      } else {
        try buf_writer.print("{s}", this.content.term.text);
      }
      return buf.toOwnedSlice();
    }
  };
}

%code top {
  const YYLexer = @import("scan.zig");
  const zlexison = @import("zlexison.zig");
  const Node = zlexison.Node;
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
  yyo.writer().print("{s}", .{s}); } <Node>

%param {scanner: *YYLexer}

%%

prog : %empty
     | prog stmt   {
                     const stdout_writer = std.io.getStdOut().writer();
                     try stdout_writer.print("{s}", .{&@2});
                     try stdout_writer.print(": ", .{});
                     try stdout_writer.print("{s}", .{$2});
                     try stdout_writer.print("\n", .{});
                     $2.deinit(yyctx.allocator);
                   }
     ;

stmt : expr ';'  %merge <stmtMerge>     { $$ = $1; }
     | decl      %merge <stmtMerge>
     | error ';'        { $$ = try Node.newNterm(yyctx.allocator, "<error>", null, null, null); }
     ;

expr : ID
     | TYPENAME '(' expr ')'
                        { $$ = try Node.newNterm(yyctx.allocator, "<cast>(%s, %s)", $3, $1, null); }
     | expr '+' expr    { $$ = try Node.newNterm(yyctx.allocator, "+(%s, %s)", $1, $3, null); }
     | expr '=' expr    { $$ = try Node.newNterm(yyctx.allocator, "=(%s, %s)", $1, $3, null); }
     ;

decl : TYPENAME declarator ';'
                        { $$ = try Node.newNterm(yyctx.allocator, "<declare>(%s, %s)", $1, $2, null); }
     | TYPENAME declarator '=' expr ';'
                        { $$ = try Node.newNterm(yyctx.allocator, "<init-declare>(%s, %s, %s)", $1, $2, $4); }
     ;

declarator
     : ID
     | '(' declarator ')' { $$ = $2; }
     ;

%%

fn stmtMerge(yyctx: *yyparse_context_t, x0: *YYSTYPE, x1: *YYSTYPE) !*Node {
    return try Node.newNterm(yyctx.allocator, "<OR>(%s, %s)", x0.stmt, x1.stmt, null);
}

pub fn main() !u8 {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.heap.page_allocator.free(args);
    var aa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer aa.deinit();
    const arena = aa.allocator();

    const stdout_writer = std.io.getStdOut().writer();

    var f: std.fs.File = brk: {
        if (args.len > 1) {
            break :brk try std.fs.cwd().openFile(args[1], .{});
        } else {
            break :brk std.io.getStdIn();
        }
    };
    defer f.close();

    try zlexison.initSymTable(arena);

    const content = try f.readToEndAlloc(arena, std.math.maxInt(usize));
    defer arena.free(content);
    try stdout_writer.print("read {d}bytes\n", .{content.len});

    var scanner = YYLexer{ .allocator = arena };

    try YYLexer.yylex_init(&scanner);
    defer YYLexer.yylex_destroy(&scanner);

    _ = try YYLexer.yy_scan_string(content, scanner.yyg);

    _ = try YYParser.yyparse(arena, &scanner);

    return 0;
}
