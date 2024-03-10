%code requires {
pub const Symrec = struct {
    pub const TYPE = enum {
        VAR,
        FUN,
    };

    pub const VALUE = union(TYPE) {
        VAR: f64,
        FUN: *allowzero const fn(f64) f64,
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
            .name = "",
            .value = .{ .VAR = 0 },
        };
        return sr;
    }

    pub fn deinit(this: *Symrec) void {
        defer this.allocator.destroy(this);
        if (this.next) |n| {
            n.deinit();
        }
    }

    pub fn putsym(this: *Symrec, name: []const u8, sym_type: Symrec.TYPE) !*Symrec {
        var new_sr = try this.allocator.create(Symrec);
        new_sr.* = Symrec{
          .allocator = this.allocator,
          .name = name,
          .type = sym_type,
          .value = brk: {
             switch (sym_type) {
               .VAR => {
                 break :brk VALUE{ .VAR = 0 };
               },
               .FUN => {
                 break :brk VALUE{ .FUN = @ptrFromInt(0) };
               },
            }
          },
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

pub var sym_table: *Symrec = undefined;

fn atan(n: f64) f64 {
    return std.math.atan(n);
}

fn cos(n: f64) f64 {
    return std.math.cos(n);
}

fn exp(n: f64) f64 {
    return std.math.exp(n);
}

fn ln(n: f64) f64 {
    return std.math.log(f64, std.math.log2e, n);
}

fn sin(n: f64) f64 {
    return std.math.sin(n);
}

fn sqrt(n: f64) f64 {
    return std.math.sqrt(n);
}

pub fn initSymTable(arena: std.mem.Allocator) !void {
    sym_table = try Symrec.init(arena);
    const fn_names = [_][]const u8{ "atan", "cos", "exp", "ln", "sin", "sqrt" };
    const fns = [_]*const fn (f64) f64{ atan, cos, exp, ln, sin, sqrt };
    for (fn_names, fns) |name, func| {
        sym_table = try sym_table.putsym(name, .FUN);
        sym_table.value.FUN = func;
    }
}

}

%{
const YYLexer = @import("scan.zig");
const Symrec = zlexison.Symrec;

pub var result_buf: std.ArrayList(u8) = undefined;
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
| exp '\n'   { try result_buf.writer().print("{d:10.2}", .{$1}); }
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
| exp '^' exp        { $$ = std.math.pow(f64, $1, $3);  }
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

    try zlexison.initSymTable(arena);

    const content = try f.readToEndAlloc(arena, std.math.maxInt(usize));
    defer arena.free(content);
    try stdout_writer.print("read {d}bytes\n", .{content.len});

    var scanner = YYLexer{ .allocator = arena };

    try scanner.init();
    defer scanner.deinit();

    try scanner.scan_string(content);

    YYParser.result_buf = std.ArrayList(u8).init(arena);

    _ = try YYParser.yyparse(arena, &scanner);

    std.debug.print("{s}\n", .{result_buf.items});

    return 0;
}
