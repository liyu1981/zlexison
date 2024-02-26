#!/bin/bash

rm -f zlexison.zig
echo "generating empty zlexison.zig..."
../../zig-out/bin/zlex init -t zlexison -o zlexison.zig
echo "generating example.zig..."
../../zig-out/bin/zlex -o example.zig example.l
echo "compiling..."
zig build-exe example.zig
