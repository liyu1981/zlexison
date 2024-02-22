%code requires {
pub const Symrec = struct {
    pub const TYPE = enum {
        VAR,
        FUN,
    };

    pub const VALUE = union(TYPE) {
        VAR: f64,
        FUN: *const fn(f64) f64,
    };

    allocator: std.mem.Allocator,
    name: []const u8 = undefined,
    type: TYPE,
    value: VALUE = undefined,
    next: ?*Symrec = null,

    pub fn init(allocator: std.mem.Allocator) !*Symrec {
        const sr = try allocator.create(Symrec);
        sr.* = Symrec{
            .allocator = allocator,
            .type = .VAR,
        };
        return sr;
    }

    pub fn putsym(this: *Symrec, name: []const u8, sym_type: Symrec.TYPE) *Symrec {
        var new_sr = this.allocator.create(Symrec);
        new_sr.* = Symrec{
          .allocator = this.allocator,
          .name = name,
          .type = sym_type,
        };
        new_sr.next = this;
        return new_sr;
    }

    pub fn getsym(this: *Symrec, name: []const u8) ?*Symrec {
        var p: ?*Symrec = this;
        while(p != null) {
            if (std.mem.eql(u8, p.?.name, name)) {
                return p.?;
            }
            p = p.?.next;
        }
        return null;
    }
};
}

%{
const YYLexer = @import("scan.zig");
const Symrec = @import("zlexison.zig").Symrec;
%}

%define api.value.type union /* Generate YYSTYPE from these types: */
%token <f64>  NUM     /* Double precision number. */
%token <*Symrec> VAR FUN /* Symbol table pointer: variable/function. */
%nterm <f64>  exp

%precedence '='
%left '-' '+'
%left '*' '/'
%precedence NEG /* negation--unary minus */
%right '^'      /* exponentiation */

/* Generate the parser description file. */
// %verbose

/* Enable run-time traces (yydebug). */
%define parse.trace

/* Formatting semantic values. */
%printer { try yyo.writer().print("{s}", .{$$.name}); } VAR;
%printer { try yyo.writer().print("{s}()", .{$$.name}); } FUN;
%printer { try yyo.writer().print("{d:10.2}", .{$$}); } <f64>;

%param {scanner: *YYLexer}

%% /* The grammar follows. */

input:
  %empty
| input line
;

line:
  '\n'
| exp '\n'   { try std.io.getStdOut().writer().print("{d:10.2}\n", .{$1}); }
| error '\n' { yyctx.yyerrok();        }
;

exp:
  NUM
| VAR                { $$ = ($1).value.VAR;             }
| VAR '=' exp        { $$ = $3; ($1).value.VAR = $3;    }
| FUN '(' exp ')'    { $$ = ($1).value.FUN($3);         }
| exp '+' exp        { $$ = $1 + $3;                    }
| exp '-' exp        { $$ = $1 - $3;                    }
| exp '*' exp        { $$ = $1 * $3;                    }
| exp '/' exp        { $$ = $1 / $3;                    }
| '-' exp  %prec NEG { $$ = -$2;                        }
| exp '^' exp        { $$ = std.math.pow(f64, $1, $3);               }
| '(' exp ')'        { $$ = $2;                         }
;

%%

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

    var content = try f.readToEndAlloc(arena, std.math.maxInt(usize));
    defer arena.free(content);
    _ = &content;
    try stdout_writer.print("read {d}bytes\n", .{content.len});

    var scanner = YYLexer{ .allocator = arena };

    try YYLexer.yylex_init(&scanner);
    defer YYLexer.yylex_destroy(&scanner);

    _ = try YYParser.yyparse(arena, &scanner);

    return 0;
}
