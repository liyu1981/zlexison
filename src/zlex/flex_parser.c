
extern int flex_parse_only;

// well copied some code from flex/src/main.c
void flex_set_parser_only(int v) {
    flex_parse_only = v;
}
