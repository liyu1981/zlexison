#include <stdint.h>
#define zig_extern
zig_extern void zlex_prepare_yy(uintptr_t const a0, uint8_t *const a1, uintptr_t const a2, uintptr_t const a3, uintptr_t const a4, uintptr_t const a5, uintptr_t const a6);
zig_extern uint32_t zlex_parser_section(uintptr_t const a0);
zig_extern uint32_t zlex_parser_code_block_inline(uintptr_t const a0);
zig_extern uint32_t zlex_parser_code_block_start(uintptr_t const a0);
zig_extern uint32_t zlex_parser_code_block_stop(uintptr_t const a0);
zig_extern uint32_t zlex_parser_code_block_content(uintptr_t const a0);
zig_extern uint32_t zlex_parser_code_block_new_line(uintptr_t const a0);
zig_extern uint32_t zlex_parser_start_condition(uintptr_t const a0);
zig_extern uint32_t zlex_parser_rule_line(uintptr_t const a0);
zig_extern uint32_t zlex_parser_rule_new_line(uintptr_t const a0);
zig_extern uint32_t zlex_parser_user_code_block(uintptr_t const a0);
zig_extern uint32_t zlex_parser_default_rule(uintptr_t const a0);
