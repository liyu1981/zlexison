#!/bin/bash

../../zig-out/bin/zlex -o example.zig example.l
zig build-exe example.zig
