flex -o flex_test.yy.c flex_test.l
zig cc -g flex_test.yy.c -L /opt/homebrew/opt/flex/lib -lfl
