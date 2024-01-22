pub fn render(stream: anytype, ctx: anytype) !void {
  // beware of this dirty hack for pseudo-unused
  {
      const  ___magic = .{ stream, ctx };
      _ = ___magic;
  }
  // here comes the actual content
    try stream.writeAll("// zlex utils\n\nvoid zlex_start_condition_begin(size_t start_condition) {\n    yy_start = 1 + 2 * start_condition;\n}\n\nint8_t zlex_action_input() {\n    return (int8_t)input();\n}\n\nvoid zlex_action_echo() {\n    ECHO;\n}\n\nuintptr_t zlex_yy_create_buffer(FILE *f, size_t size) {\n    return ZLEX_CAST_UINTPTR(yy_create_buffer(f, size));\n}\n\nvoid zlex_yy_switch_to_buffer(uintptr_t new_buffer) {\n    yy_switch_to_buffer((YY_BUFFER_STATE)(void *)new_buffer);\n}\n\nvoid zlex_yy_delete_buffer(uintptr_t buffer) {\n    yy_delete_buffer((YY_BUFFER_STATE)(void *)buffer);\n}\n\nvoid zlex_yypush_buffer_state(uintptr_t buffer) {\n    yypush_buffer_state((YY_BUFFER_STATE)(void *)buffer);\n}\n\nvoid zlex_yypop_buffer_state() {\n    yypop_buffer_state();\n}\n\nvoid zlex_yy_flush_buffer(uintptr_t buffer) {\n    yy_flush_buffer((YY_BUFFER_STATE)(void *)buffer);\n}\n\nuintptr_t zlex_yy_scan_string(const char *str) {\n    return ZLEX_CAST_UINTPTR(yy_scan_string(str));\n}\n\nuintptr_t zlex_yy_scan_bytes(const char *str, size_t len) {\n    return ZLEX_CAST_UINTPTR(yy_scan_bytes(str, len));\n}\n\nuintptr_t zlex_yy_scan_buffer(char *base, size_t size) {\n    YY_BUFFER_STATE s = yy_scan_buffer(base, size);\n    printf(\"scan buffer return: %p\\n\", s);\n    return ZLEX_CAST_UINTPTR(s);\n}\n");
}
