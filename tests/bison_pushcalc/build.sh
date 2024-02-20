#!/bin/bash

rm -f zlexison.zig
../../zig-out/bin/zison zlexison -o zlexison.zig parser.y
../../zig-out/bin/zlex -o scan.zig -z zlexison.zig scan.l
../../zig-out/bin/zison -o parser.zig -m no parser.y
zig build-exe parser.zig
