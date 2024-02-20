%{
%}

%%

"+"      { return '+'; }
"-"      { return '-'; }
"*"      { return '*'; }
"/"      { return '/'; }

[0-9]+   {
    // Scan an integer.
    const intval = try std.fmt.parseInt(i64, yyget_text(yyg), 10);
    yylval_.* = .{ .NUM = @as(f64, @floatFromInt(intval)) };
    return @intFromEnum(TOK_TYPE.NUM);
  }

\.[0-9]+ {
    // Scan an float like .123
    const floatval = try std.fmt.parseFloat(f64, yyget_text(yyg));
    yylval_.* = .{ .NUM = floatval };
    return @intFromEnum(TOK_TYPE.NUM);
  }

[0-9]+\.[0-9]+ {
    // Scan an float like 1.23
    const floatval = try std.fmt.parseFloat(f64, yyget_text(yyg));
    yylval_.* = .{ .NUM = floatval };
    return @intFromEnum(TOK_TYPE.NUM);
  }

[ \t]+   {}

\n { return '\n'; }

.        {
    std.io.getStdErr().writer().print(
      "syntax error, invalid character: {c} at line: {d}, column: {d}.\n",
      .{ yyg.yytext_r[0], yyget_lineno(yyg), yyget_column(yyg) },
    ) catch |err| { return err; };
    return error.SyntaxError;
  }

<<EOF>>  { return @intFromEnum(TOK_TYPE.YYEOF); }

%%
