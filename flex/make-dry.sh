test -f config.h || rm -f stamp-h1
test -f config.h || /Library/Developer/CommandLineTools/usr/bin/make  stamp-h1
/Library/Developer/CommandLineTools/usr/bin/make  all-am
test -f config.h || rm -f stamp-h1
test -f config.h || /Library/Developer/CommandLineTools/usr/bin/make  stamp-h1
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-buf.o -MD -MP -MF .deps/flex-buf.Tpo -c -o flex-buf.o `test -f 'buf.c' || echo './'`buf.c
mv -f .deps/flex-buf.Tpo .deps/flex-buf.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-ccl.o -MD -MP -MF .deps/flex-ccl.Tpo -c -o flex-ccl.o `test -f 'ccl.c' || echo './'`ccl.c
mv -f .deps/flex-ccl.Tpo .deps/flex-ccl.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-dfa.o -MD -MP -MF .deps/flex-dfa.Tpo -c -o flex-dfa.o `test -f 'dfa.c' || echo './'`dfa.c
mv -f .deps/flex-dfa.Tpo .deps/flex-dfa.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-ecs.o -MD -MP -MF .deps/flex-ecs.Tpo -c -o flex-ecs.o `test -f 'ecs.c' || echo './'`ecs.c
mv -f .deps/flex-ecs.Tpo .deps/flex-ecs.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-filter.o -MD -MP -MF .deps/flex-filter.Tpo -c -o flex-filter.o `test -f 'filter.c' || echo './'`filter.c
mv -f .deps/flex-filter.Tpo .deps/flex-filter.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-misc.o -MD -MP -MF .deps/flex-misc.Tpo -c -o flex-misc.o `test -f 'misc.c' || echo './'`misc.c
mv -f .deps/flex-misc.Tpo .deps/flex-misc.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-options.o -MD -MP -MF .deps/flex-options.Tpo -c -o flex-options.o `test -f 'options.c' || echo './'`options.c
mv -f .deps/flex-options.Tpo .deps/flex-options.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-parse.o -MD -MP -MF .deps/flex-parse.Tpo -c -o flex-parse.o `test -f 'parse.c' || echo './'`parse.c
mv -f .deps/flex-parse.Tpo .deps/flex-parse.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-regex.o -MD -MP -MF .deps/flex-regex.Tpo -c -o flex-regex.o `test -f 'regex.c' || echo './'`regex.c
mv -f .deps/flex-regex.Tpo .deps/flex-regex.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-scanflags.o -MD -MP -MF .deps/flex-scanflags.Tpo -c -o flex-scanflags.o `test -f 'scanflags.c' || echo './'`scanflags.c
mv -f .deps/flex-scanflags.Tpo .deps/flex-scanflags.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-scanopt.o -MD -MP -MF .deps/flex-scanopt.Tpo -c -o flex-scanopt.o `test -f 'scanopt.c' || echo './'`scanopt.c
mv -f .deps/flex-scanopt.Tpo .deps/flex-scanopt.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-sym.o -MD -MP -MF .deps/flex-sym.Tpo -c -o flex-sym.o `test -f 'sym.c' || echo './'`sym.c
mv -f .deps/flex-sym.Tpo .deps/flex-sym.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-tables.o -MD -MP -MF .deps/flex-tables.Tpo -c -o flex-tables.o `test -f 'tables.c' || echo './'`tables.c
mv -f .deps/flex-tables.Tpo .deps/flex-tables.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-tables_shared.o -MD -MP -MF .deps/flex-tables_shared.Tpo -c -o flex-tables_shared.o `test -f 'tables_shared.c' || echo './'`tables_shared.c
mv -f .deps/flex-tables_shared.Tpo .deps/flex-tables_shared.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-tblcmp.o -MD -MP -MF .deps/flex-tblcmp.Tpo -c -o flex-tblcmp.o `test -f 'tblcmp.c' || echo './'`tblcmp.c
mv -f .deps/flex-tblcmp.Tpo .deps/flex-tblcmp.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-yylex.o -MD -MP -MF .deps/flex-yylex.Tpo -c -o flex-yylex.o `test -f 'yylex.c' || echo './'`yylex.c
mv -f .deps/flex-yylex.Tpo .deps/flex-yylex.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-gen_zig.o -MD -MP -MF .deps/flex-gen_zig.Tpo -c -o flex-gen_zig.o `test -f 'gen_zig.c' || echo './'`gen_zig.c
mv -f .deps/flex-gen_zig.Tpo .deps/flex-gen_zig.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-main_zig.o -MD -MP -MF .deps/flex-main_zig.Tpo -c -o flex-main_zig.o `test -f 'main_zig.c' || echo './'`main_zig.c
mv -f .deps/flex-main_zig.Tpo .deps/flex-main_zig.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-nfa_zig.o -MD -MP -MF .deps/flex-nfa_zig.Tpo -c -o flex-nfa_zig.o `test -f 'nfa_zig.c' || echo './'`nfa_zig.c
mv -f .deps/flex-nfa_zig.Tpo .deps/flex-nfa_zig.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-zig_skel.o -MD -MP -MF .deps/flex-zig_skel.Tpo -c -o flex-zig_skel.o `test -f 'zig_skel.c' || echo './'`zig_skel.c
mv -f .deps/flex-zig_skel.Tpo .deps/flex-zig_skel.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-scan.o -MD -MP -MF .deps/stage1flex-scan.Tpo -c -o stage1flex-scan.o `test -f 'scan.c' || echo './'`scan.c
mv -f .deps/stage1flex-scan.Tpo .deps/stage1flex-scan.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-buf.o -MD -MP -MF .deps/stage1flex-buf.Tpo -c -o stage1flex-buf.o `test -f 'buf.c' || echo './'`buf.c
mv -f .deps/stage1flex-buf.Tpo .deps/stage1flex-buf.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-ccl.o -MD -MP -MF .deps/stage1flex-ccl.Tpo -c -o stage1flex-ccl.o `test -f 'ccl.c' || echo './'`ccl.c
mv -f .deps/stage1flex-ccl.Tpo .deps/stage1flex-ccl.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-dfa.o -MD -MP -MF .deps/stage1flex-dfa.Tpo -c -o stage1flex-dfa.o `test -f 'dfa.c' || echo './'`dfa.c
mv -f .deps/stage1flex-dfa.Tpo .deps/stage1flex-dfa.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-ecs.o -MD -MP -MF .deps/stage1flex-ecs.Tpo -c -o stage1flex-ecs.o `test -f 'ecs.c' || echo './'`ecs.c
mv -f .deps/stage1flex-ecs.Tpo .deps/stage1flex-ecs.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-filter.o -MD -MP -MF .deps/stage1flex-filter.Tpo -c -o stage1flex-filter.o `test -f 'filter.c' || echo './'`filter.c
mv -f .deps/stage1flex-filter.Tpo .deps/stage1flex-filter.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-misc.o -MD -MP -MF .deps/stage1flex-misc.Tpo -c -o stage1flex-misc.o `test -f 'misc.c' || echo './'`misc.c
mv -f .deps/stage1flex-misc.Tpo .deps/stage1flex-misc.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-options.o -MD -MP -MF .deps/stage1flex-options.Tpo -c -o stage1flex-options.o `test -f 'options.c' || echo './'`options.c
mv -f .deps/stage1flex-options.Tpo .deps/stage1flex-options.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-parse.o -MD -MP -MF .deps/stage1flex-parse.Tpo -c -o stage1flex-parse.o `test -f 'parse.c' || echo './'`parse.c
mv -f .deps/stage1flex-parse.Tpo .deps/stage1flex-parse.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-regex.o -MD -MP -MF .deps/stage1flex-regex.Tpo -c -o stage1flex-regex.o `test -f 'regex.c' || echo './'`regex.c
mv -f .deps/stage1flex-regex.Tpo .deps/stage1flex-regex.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-scanflags.o -MD -MP -MF .deps/stage1flex-scanflags.Tpo -c -o stage1flex-scanflags.o `test -f 'scanflags.c' || echo './'`scanflags.c
mv -f .deps/stage1flex-scanflags.Tpo .deps/stage1flex-scanflags.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-scanopt.o -MD -MP -MF .deps/stage1flex-scanopt.Tpo -c -o stage1flex-scanopt.o `test -f 'scanopt.c' || echo './'`scanopt.c
mv -f .deps/stage1flex-scanopt.Tpo .deps/stage1flex-scanopt.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-sym.o -MD -MP -MF .deps/stage1flex-sym.Tpo -c -o stage1flex-sym.o `test -f 'sym.c' || echo './'`sym.c
mv -f .deps/stage1flex-sym.Tpo .deps/stage1flex-sym.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-tables.o -MD -MP -MF .deps/stage1flex-tables.Tpo -c -o stage1flex-tables.o `test -f 'tables.c' || echo './'`tables.c
mv -f .deps/stage1flex-tables.Tpo .deps/stage1flex-tables.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-tables_shared.o -MD -MP -MF .deps/stage1flex-tables_shared.Tpo -c -o stage1flex-tables_shared.o `test -f 'tables_shared.c' || echo './'`tables_shared.c
mv -f .deps/stage1flex-tables_shared.Tpo .deps/stage1flex-tables_shared.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-tblcmp.o -MD -MP -MF .deps/stage1flex-tblcmp.Tpo -c -o stage1flex-tblcmp.o `test -f 'tblcmp.c' || echo './'`tblcmp.c
mv -f .deps/stage1flex-tblcmp.Tpo .deps/stage1flex-tblcmp.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-yylex.o -MD -MP -MF .deps/stage1flex-yylex.Tpo -c -o stage1flex-yylex.o `test -f 'yylex.c' || echo './'`yylex.c
mv -f .deps/stage1flex-yylex.Tpo .deps/stage1flex-yylex.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-gen.o -MD -MP -MF .deps/stage1flex-gen.Tpo -c -o stage1flex-gen.o `test -f 'gen.c' || echo './'`gen.c
mv -f .deps/stage1flex-gen.Tpo .deps/stage1flex-gen.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-main.o -MD -MP -MF .deps/stage1flex-main.Tpo -c -o stage1flex-main.o `test -f 'main.c' || echo './'`main.c
mv -f .deps/stage1flex-main.Tpo .deps/stage1flex-main.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-nfa.o -MD -MP -MF .deps/stage1flex-nfa.Tpo -c -o stage1flex-nfa.o `test -f 'nfa.c' || echo './'`nfa.c
mv -f .deps/stage1flex-nfa.Tpo .deps/stage1flex-nfa.Po
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"   -DDEBUG -g -MT stage1flex-skel.o -MD -MP -MF .deps/stage1flex-skel.Tpo -c -o stage1flex-skel.o `test -f 'skel.c' || echo './'`skel.c
mv -f .deps/stage1flex-skel.Tpo .deps/stage1flex-skel.Po
rm -f stage1flex
/bin/sh ../libtool  --tag=CC   --mode=link clang  -DDEBUG -g   -o stage1flex stage1flex-scan.o stage1flex-buf.o stage1flex-ccl.o stage1flex-dfa.o stage1flex-ecs.o stage1flex-filter.o stage1flex-misc.o stage1flex-options.o stage1flex-parse.o stage1flex-regex.o stage1flex-scanflags.o stage1flex-scanopt.o stage1flex-sym.o stage1flex-tables.o stage1flex-tables_shared.o stage1flex-tblcmp.o stage1flex-yylex.o stage1flex-gen.o stage1flex-main.o stage1flex-nfa.o stage1flex-skel.o    -lm 
./stage1flex   -o stage1scan.c ./scan.l
clang -DHAVE_CONFIG_H -I.  -DLOCALEDIR=\"/usr/local/share/locale\"    -DDEBUG -g -MT flex-stage1scan.o -MD -MP -MF .deps/flex-stage1scan.Tpo -c -o flex-stage1scan.o `test -f 'stage1scan.c' || echo './'`stage1scan.c
mv -f .deps/flex-stage1scan.Tpo .deps/flex-stage1scan.Po
rm -f flex
/bin/sh ../libtool  --tag=CC   --mode=link clang   -DDEBUG -g   -o flex flex-buf.o flex-ccl.o flex-dfa.o flex-ecs.o flex-filter.o flex-misc.o flex-options.o flex-parse.o flex-regex.o flex-scanflags.o flex-scanopt.o flex-sym.o flex-tables.o flex-tables_shared.o flex-tblcmp.o flex-yylex.o flex-gen_zig.o flex-main_zig.o flex-nfa_zig.o flex-zig_skel.o flex-stage1scan.o   -lm 
