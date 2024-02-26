#!/bin/bash

rm -f zlexison.zig
echo "generating zlexison.zig..."
../../zig-out/bin/zison zlexison -o zlexison.zig parser.y
echo "generating scan.zig..."
../../zig-out/bin/zlex -o scan.zig scan.l
echo "generating parser.zig..."
../../zig-out/bin/zison -o parser.zig parser.y
echo "compiling..."
zig build-exe parser.zig
