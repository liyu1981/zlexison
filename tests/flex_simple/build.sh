#!/bin/bash

rm -f zlexison.zig
../../zig-out/bin/zlex -o example.zig -m no example.l
zig build-exe example.zig
