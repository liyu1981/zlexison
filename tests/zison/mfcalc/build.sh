#!/bin/bash

ROOT_DIR=../../..

rm -f zlexison.zig
echo "generating zlexison.zig..."
${ROOT_DIR}/zig-out/bin/zison zlexison -o zlexison.zig parser.y
echo "generating scan.zig..."
${ROOT_DIR}/zig-out/bin/zlex -o scan.zig scan.l
echo "generating parser.zig..."
${ROOT_DIR}/zig-out/bin/zison -o parser.zig parser.y
echo "compiling..."
zig build-exe parser.zig
