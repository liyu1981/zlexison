#!/bin/bash

rm -f zlexison.zig
../../zig-out/bin/zison zlexison -o zlexison.zig ../bison_reccalc/parser.y
../../zig-out/bin/zlex -o scan.zig -z zlexison.zig scan.l
zig build-exe scan.zig
