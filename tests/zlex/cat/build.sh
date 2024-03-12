#!/bin/bash

ROOT_DIR=../../..

rm -f zlexison.zig
echo "generating empty zlexison.zig..."
${ROOT_DIR}/zig-out/bin/zlex init -t zlexison -o zlexison.zig
echo "generating cat.zig..."
${ROOT_DIR}/zig-out/bin/zlex -o cat.zig cat.l
echo "compiling..."
zig build-exe cat.zig
