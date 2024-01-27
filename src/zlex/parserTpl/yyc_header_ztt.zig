pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("#define ZLEX_CAST_U8PTR(x) ((uint8_t *)(void *)(x))\n#define ZLEX_CAST_UINTPTR(x) ((uintptr_t)(void *)(x))\nstatic uintptr_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_intptr = 0;\nstatic int ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_param_reg[8];\nstatic int ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_control;\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_setup_parser(intptr_t ptr) {\n    ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_intptr = ptr;\n}\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_set_parser_param_reg(int index, int v) {\n    ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_param_reg[index] = v;\n}\nextern void ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_call_user_action(uintptr_t zyy_parser_intptr);\nextern void ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_call_user_init(uintptr_t zyy_parser_intptr);\n#define ZLEX_CONTROL(x)                      \\\n    switch ((x)) {                           \\\n        case 0 /*RETURN*/:                   \\\n            return 0;                        \\\n        case 1 /*REJECT*/: {                 \\\n            REJECT;                          \\\n        } break;                             \\\n        case 2 /*TERMINATE*/: {              \\\n            yyterminate();                   \\\n        } break;                             \\\n        case 3 /*YYLESS*/: {                 \\\n            yyless(");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_param_reg[0]); \\\n        } break;                             \\\n    }\n#define YY_USER_ACTION                           \\\n    (");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_call_user_action(");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_intptr));\n#define YY_USER_INIT                           \\\n    (");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_call_user_init(");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_parser_intptr));\n");
}
