// zlex utils

void zlex_start_condition_begin(size_t start_condition) {
    yy_start = 1 + 2 * start_condition;
}

int8_t zlex_action_input() {
    return (int8_t)input();
}

void zlex_action_echo() {
    ECHO;
}

uintptr_t zlex_yy_create_buffer(FILE *f, size_t size) {
    return ZLEX_CAST_UINTPTR(yy_create_buffer(f, size));
}

void zlex_yy_switch_to_buffer(uintptr_t new_buffer) {
    yy_switch_to_buffer((YY_BUFFER_STATE)(void *)new_buffer);
}

void zlex_yy_delete_buffer(uintptr_t buffer) {
    yy_delete_buffer((YY_BUFFER_STATE)(void *)buffer);
}

void zlex_yypush_buffer_state(uintptr_t buffer) {
    yypush_buffer_state((YY_BUFFER_STATE)(void *)buffer);
}

void zlex_yypop_buffer_state() {
    yypop_buffer_state();
}

void zlex_yy_flush_buffer(uintptr_t buffer) {
    yy_flush_buffer((YY_BUFFER_STATE)(void *)buffer);
}

uintptr_t zlex_yy_scan_string(const char *str) {
    return ZLEX_CAST_UINTPTR(yy_scan_string(str));
}

uintptr_t zlex_yy_scan_bytes(const char *str, size_t len) {
    return ZLEX_CAST_UINTPTR(yy_scan_bytes(str, len));
}

uintptr_t zlex_yy_scan_buffer(char *base, size_t size) {
    YY_BUFFER_STATE s = yy_scan_buffer(base, size);
    printf("scan buffer return: %p\n", s);
    return ZLEX_CAST_UINTPTR(s);
}
