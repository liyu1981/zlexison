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
%printer { const s = try $$.toString(yyctx.allocator);
  defer yyctx.allocator.free(s);
  yyo.writer().print("{s}", .{s}); } <Node>

%%

prog : %empty
     | prog stmt   {
                     YYLOCATION_PRINT (stdout, &@2);
                     fputs (": ", stdout);
                     node_print (stdout, $2);
                     putc ('\n', stdout);
                     fflush (stdout);
                     free_node ($2);
                   }
     ;

stmt : expr ';'  %merge <stmt_merge>     { $$ = $1; }
     | decl      %merge <stmt_merge>
     | error ';'        { $$ = new_nterm ("<error>", NULL, NULL, NULL); }
     ;

expr : ID
     | TYPENAME '(' expr ')'
                        { $$ = new_nterm ("<cast>(%s, %s)", $3, $1, NULL); }
     | expr '+' expr    { $$ = new_nterm ("+(%s, %s)", $1, $3, NULL); }
     | expr '=' expr    { $$ = new_nterm ("=(%s, %s)", $1, $3, NULL); }
     ;

decl : TYPENAME declarator ';'
                        { $$ = new_nterm ("<declare>(%s, %s)", $1, $2, NULL); }
     | TYPENAME declarator '=' expr ';'
                        { $$ = new_nterm ("<init-declare>(%s, %s, %s)", $1,
                                          $2, $4); }
     ;

declarator
     : ID
     | '(' declarator ')' { $$ = $2; }
     ;

%%

yytoken_kind_t
yylex (YYSTYPE *lval, YYLTYPE *lloc)
{
  static int lineNum = 1;
  static int colNum = 0;

  while (1)
    {
      int c;
      assert (!feof (input));
      c = getc (input);
      switch (c)
        {
        case EOF:
          return 0;
        case '\t':
          colNum = (colNum + 7) & ~7;
          break;
        case ' ': case '\f':
          colNum += 1;
          break;
        case '\n':
          lineNum += 1;
          colNum = 0;
          break;
        default:
          {
            yytoken_kind_t tok;
            lloc->first_line = lloc->last_line = lineNum;
            lloc->first_column = colNum;
            if (isalpha (c))
              {
                char buffer[256];
                unsigned i = 0;

                do
                  {
                    buffer[i++] = (char) c;
                    colNum += 1;
                    assert (i != sizeof buffer - 1);
                    c = getc (input);
                  }
                while (isalnum (c) || c == '_');

                ungetc (c, input);
                buffer[i++] = 0;
                if (isupper ((unsigned char) buffer[0]))
                  {
                    tok = TYPENAME;
                    lval->TYPENAME = new_term (strcpy (malloc (i), buffer));
                  }
                else
                  {
                    tok = ID;
                    lval->ID = new_term (strcpy (malloc (i), buffer));
                  }
              }
            else
              {
                colNum += 1;
                tok = c;
              }
            lloc->last_column = colNum;
            return tok;
          }
        }
    }
}

static Node *
stmt_merge (YYSTYPE x0, YYSTYPE x1)
{
  return new_nterm ("<OR>(%s, %s)", x0.stmt, x1.stmt, NULL);
}

static int
process (const char *file)
{
  int is_stdin = !file || strcmp (file, "-") == 0;
  if (is_stdin)
    input = stdin;
  else
    input = fopen (file, "r");
  assert (input);
  int status = yyparse ();
  if (!is_stdin)
    fclose (input);
  return status;
}

int
main (int argc, char **argv)
{
  if (getenv ("YYDEBUG"))
    yydebug = 1;

  int ran = 0;
  for (int i = 1; i < argc; ++i)
    // Enable parse traces on option -p.
    if (strcmp (argv[i], "-p") == 0)
      yydebug = 1;
    else
      {
        int status = process (argv[i]);
        ran = 1;
        if (!status)
          return status;
      }

  if (!ran)
    {
      int status = process (NULL);
      if (!status)
        return status;
    }
  return 0;
}
