/* dates.lex: An example of using start states to
            distinguish between different date formats.
*/

%{
pub var month: []const u8 = undefined;
pub var dow: []const u8 = undefined;
pub var day: []const u8 = undefined;
pub var year: []const u8 = undefined;
%}

skip    [ \t,]*of|the|[ \t,]*

mon	    ((M|m)on(day)?)
tue	    ((T|t)ue(sday)?)
wed	    ((W|w)ed(nesday)?)
thu	    ((T|t)hu(rsday)?)
fri	    ((F|f)ri(day)?)
sat	    ((S|s)at(urday)?)
sun	    ((S|s)un(day)?)

day_of_the_week	({mon}|{tue}|{wed}|{thu}|{fri}|{sat}|{sun})

jan	    ((J|j)an(uary)?)
feb	    ((F|f)eb(ruary)?)
mar	    ((M|m)ar(ch)?)
apr	    ((A|a)pr(il)?)
may	    ((M|m)ay)
jun	    ((J|j)un(e)?)
jul	    ((J|j)ul(y)?)
aug	    ((A|a)ug(ust)?)
sep	    ((S|s)ep(tember)?)
oct	    ((O|o)ct(ober)?)
nov	    ((N|n)ov(ember)?)
dec	    ((D|d)ec(ember)?)

first_half  ({jan}|{feb}|{mar}|{apr}|{may}|{jun})
second_half ({jul}|{aug}|{sep}|{oct}|{nov}|{dec})
month 	    {first_half}|{second_half}

nday         [1-9]|[1-2][0-9]|3[0-1]
nmonth       [1-9]|1[0-2]
nyear        [0-9]{1,4}

year_ext    (ad|AD|bc|BC)?
day_ext     (st|nd|rd|th)?

%s LONG SHORT
%s DAY DAY_FIRST YEAR_FIRST YEAR_LAST YFMONTH YLMONTH

%%

  /* the default is month-day-year */

<LONG>{day_of_the_week}    dow = try yyg.arena_allocator.dupe(u8, yyget_text(yyg));
<LONG>{month}              month = try yyg.arena_allocator.dupe(u8, yyget_text(yyg)); BEGIN(DAY, yyg);

  /* handle the form: day-month-year */

<LONG>{nday}{day_ext}      day = try yyg.arena_allocator.dupe(u8, yyget_text(yyg)); BEGIN(DAY_FIRST, yyg);
<DAY_FIRST>{month}         month = try yyg.arena_allocator.dupe(u8, yyget_text(yyg)); BEGIN(LONG, yyg);
<DAY>{nday}{day_ext}       day = try yyg.arena_allocator.dupe(u8, yyget_text(yyg)); BEGIN(LONG, yyg);

<LONG>{nyear}{year_ext}  {
        switch(yyg.yyout_r) {
            .buf => |b| {
                const writer = b.writer();
                try writer.print("Long:\n", .{});
                try writer.print("  DOW   : {s} \n", .{dow});
                try writer.print("  Day   : {s} \n", .{day});
                try writer.print("  Month : {s} \n", .{month});
                try writer.print("  Year  : {s} \n", .{yyget_text(yyg)});
            },
            .file => |f| { 
                const writer = f.writer();
                try writer.print("Long:\n", .{});
                try writer.print("  DOW   : {s} \n", .{dow});
                try writer.print("  Day   : {s} \n", .{day});
                try writer.print("  Month : {s} \n", .{month});
                try writer.print("  Year  : {s} \n", .{yyget_text(yyg)});
            }
        }
    }

  /* handle dates of the form: day-month-year */

<SHORT>{nday}              day = try yyg.arena_allocator.dupe(u8, yyget_text(yyg));  BEGIN(YEAR_LAST, yyg);
<YEAR_LAST>{nmonth}        month = try yyg.arena_allocator.dupe(u8, yyget_text(yyg));BEGIN(YLMONTH, yyg);
<YLMONTH>{nyear}           year = try yyg.arena_allocator.dupe(u8, yyget_text(yyg)); BEGIN(SHORT, yyg);

  /* handle dates of the form: year-month-day */

<SHORT>{nyear}             year = try yyg.arena_allocator.dupe(u8, yyget_text(yyg)); BEGIN(YEAR_FIRST, yyg);
<YEAR_FIRST>{nmonth}       month = try yyg.arena_allocator.dupe(u8, yyget_text(yyg)); BEGIN(YFMONTH, yyg);
<YFMONTH>{nday}            day = try yyg.arena_allocator.dupe(u8, yyget_text(yyg)); BEGIN(SHORT, yyg);


<SHORT>\n  {
        switch(yyg.yyout_r) {
            .buf => |b| { 
                const writer = b.writer();
                try writer.print("Short:\n", .{});
                try writer.print("  Day   : {s} \n", .{day});
                try writer.print("  Month : {s} \n", .{month});
                try writer.print("  Year  : {s} \n", .{year});
            },
            .file => |f| { 
                const writer = f.writer();
                try writer.print("Short:\n", .{});
                try writer.print("  Day   : {s} \n", .{day});
                try writer.print("  Month : {s} \n", .{month});
                try writer.print("  Year  : {s} \n", .{year});
            },
        }
    }

long\n                      BEGIN(LONG, yyg);
short\n                     BEGIN(SHORT, yyg);

{skip}*
\n
.

%%

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.detectLeaks();
    }

    var yylval: YYLexer.YYSTYPE = YYLexer.YYSTYPE.default();
    var yylloc: YYLexer.YYLTYPE = .{};

    var lexer = YYLexer{ .allocator = allocator };
    try lexer.init();
    defer lexer.deinit();

    YYLexer.yydebug = true;

    _ = lexer.yylex(&yylval, &yylloc) catch |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    };

    return 0;
}
