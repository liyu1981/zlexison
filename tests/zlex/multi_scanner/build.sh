#!/bin/bash

ROOT_DIR=../../..
NAME=multi_scanner

rm -f zlexison.zig
echo "generating empty zlexison.zig..."
${ROOT_DIR}/zig-out/bin/zlex init -t zlexison -o zlexison.zig
echo "generating ${NAME}_1.zig..."
${ROOT_DIR}/zig-out/bin/zlex -o ${NAME}_1.zig ${NAME}_1.l
echo "generating ${NAME}_2.zig..."
${ROOT_DIR}/zig-out/bin/zlex -o ${NAME}_2.zig ${NAME}_2.l
if [ -z ${NO_COMPILE+x} ]; then
    echo "compiling..."
    zig build-exe ${NAME}.zig
fi