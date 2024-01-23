pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("// zlex utils\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_start_condition_begin(uintptr_t yyg_intptr, size_t start_condition) {\n    struct yyguts_t *yyg = (struct yyguts_t *)(yyscan_t)yyg_intptr;\n    yyg->yy_start = 1 + 2 * start_condition;\n}\n\nint8_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_action_input(uintptr_t yyg_intptr) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return (int8_t)input(yyscanner);\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_action_echo(uintptr_t yyg_intptr) {\n    struct yyguts_t *yyg = (struct yyguts_t *)(yyscan_t)yyg_intptr;\n    ECHO;\n}\n\nuintptr_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_create_buffer(uintptr_t yyg_intptr, FILE *f, size_t size) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return ZLEX_CAST_UINTPTR(yy_create_buffer(f, size, yyscanner));\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_switch_to_buffer(uintptr_t yyg_intptr, uintptr_t new_buffer) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    yy_switch_to_buffer((YY_BUFFER_STATE)(void *)new_buffer, yyscanner);\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_delete_buffer(uintptr_t yyg_intptr, uintptr_t buffer) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    yy_delete_buffer((YY_BUFFER_STATE)(void *)buffer, yyscanner);\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yypush_buffer_state(uintptr_t yyg_intptr, uintptr_t buffer) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    yypush_buffer_state((YY_BUFFER_STATE)(void *)buffer, yyscanner);\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yypop_buffer_state(uintptr_t yyg_intptr) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    yypop_buffer_state(yyscanner);\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_flush_buffer(uintptr_t yyg_intptr, uintptr_t buffer) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    yy_flush_buffer((YY_BUFFER_STATE)(void *)buffer, yyscanner);\n}\n\nuintptr_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_scan_string(uintptr_t yyg_intptr, const char *str) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return ZLEX_CAST_UINTPTR(yy_scan_string(str, yyscanner));\n}\n\nuintptr_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_scan_bytes(uintptr_t yyg_intptr, const char *str, size_t len) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return ZLEX_CAST_UINTPTR(yy_scan_bytes(str, len, yyscanner));\n}\n\nuintptr_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_scan_buffer(uintptr_t yyg_intptr, char *base, size_t size) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return ZLEX_CAST_UINTPTR(yy_scan_buffer(base, size, yyscanner));\n}\n");
}
