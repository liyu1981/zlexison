rm -f *.o
rm -f *.out
zig cc -c -g flex.yy.c
zig build-exe -Doptimize=Debug -L /opt/homebrew/opt/flex/lib -lfl main.zig flex.yy.o  -femit-bin=main.out
