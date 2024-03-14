#!/bin/bash

ROOT_DIR=../../..
NAME=eof_rules

rm -f zlexison.zig
echo "generating empty zlexison.zig..."
${ROOT_DIR}/zig-out/bin/zlex init -t zlexison -o zlexison.zig
echo "generating cat.zig..."
${ROOT_DIR}/zig-out/bin/zlex -o ${NAME}.zig ${NAME}.l
if [ -z ${NO_COMPILE+x} ]; then
    echo "compiling..."
    zig build-exe ${NAME}.zig
fi
