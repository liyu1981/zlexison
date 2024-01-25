pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("// zlex utils\n\nsize_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yyget_lineno(uintptr_t yyg_intptr) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return yyget_lineno(yyscanner);\n}\n\nsize_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yyget_column(uintptr_t yyg_intptr) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return yyget_column(yyscanner);\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yyrestart(uintptr_t yyg_intptr, FILE *f) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    yyrestart(f, yyscanner);\n}\n\nuintptr_t ");
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
    try stream.writeAll("_yy_scan_buffer(uintptr_t yyg_intptr, char *base, size_t size) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return ZLEX_CAST_UINTPTR(yy_scan_buffer(base, size, yyscanner));\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_begin(uintptr_t yyg_intptr, size_t start_condition) {\n    struct yyguts_t *yyg = (struct yyguts_t *)(yyscan_t)yyg_intptr;\n    yyg->yy_start = 1 + 2 * start_condition;\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_push_state(uintptr_t yyg_intptr, size_t new_state) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    yy_push_state(new_state, yyscanner);\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_pop_state(uintptr_t yyg_intptr) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    yy_pop_state(yyscanner);\n}\n\nsize_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_top_state(uintptr_t yyg_intptr) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return yy_top_state(yyscanner);\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_ECHO(uintptr_t yyg_intptr) {\n    struct yyguts_t *yyg = (struct yyguts_t *)(yyscan_t)yyg_intptr;\n    ECHO;\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yymore(uintptr_t yyg_intptr) {\n    struct yyguts_t *yyg = (struct yyguts_t *)(yyscan_t)yyg_intptr;\n    yymore();\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_unput(uintptr_t yyg_intptr, char c) {\n    struct yyguts_t *yyg = (struct yyguts_t *)(yyscan_t)yyg_intptr;\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    unput(c);\n}\n\nint8_t ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_input(uintptr_t yyg_intptr) {\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    return (int8_t)input(yyscanner);\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_YY_FLUSH_BUFFER(uintptr_t yyg_intptr) {\n    struct yyguts_t *yyg = (struct yyguts_t *)(yyscan_t)yyg_intptr;\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    YY_FLUSH_BUFFER;\n}\n\nvoid ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_yy_set_bol(uintptr_t yyg_intptr, int at_bol) {\n    struct yyguts_t *yyg = (struct yyguts_t *)(yyscan_t)yyg_intptr;\n    yyscan_t yyscanner = (yyscan_t)yyg_intptr;\n    yy_set_bol(at_bol);\n}\n\nint ");
    try stream.print("{s}", .{ctx.prefix});
    try stream.writeAll("_YY_AT_BOL(uintptr_t yyg_intptr) {\n    struct yyguts_t *yyg = (struct yyguts_t *)(yyscan_t)yyg_intptr;\n    return YY_AT_BOL();\n}\n");
}
