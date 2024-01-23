flex -o flex_test.zyy.c --prefix=zyy -R flex_test.l
zig cc -g flex_test.zyy.c
