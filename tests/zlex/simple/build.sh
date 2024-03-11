#!/bin/bash

ROOT_DIR=../../..

rm -f zlexison.zig
echo "generating empty zlexison.zig..."
${ROOT_DIR}/zig-out/bin/zlex init -t zlexison -o zlexison.zig
echo "generating simple.zig..."
${ROOT_DIR}/zig-out/bin/zlex -o simple.zig simple.l
echo "compiling..."
zig build-exe simple.zig
