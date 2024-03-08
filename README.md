# zlexison: zlex & zison

zlexison is `zig`'s adaption of `flex` & `bison` (`zlex` & `zison`) for writting lexer and parser.

## zlex

zlex is flex for zig: it will use the same input format for flex (or yacc), and output single zig file as lexer, which is the program doing lexical analysis: parse document into tokens.

zlex can also be used as flex, so that when need to generate a c/c++ lexer, can do the work.

the usage of zlex is like below

```bash
usage: zlex -o <output_file_path> -z <zlexison_file_path> -m <yes/no> <input_file_path>
       zlex init -t <zlex/zison/zlexison> -o <output_file_path>
       zlex zlexison -o <output_file_path>
       zlex flex <all_flex_options>
       zlex --version
```

## zison

similarly, zison is bison for zig: it will use the same input format for bison (or yacc), and output single zig file as parser, which is the program doing semantic analysis: parse stream of tokens into AST (abstract syntax tree).

zison can also be used as bison, so that when need to generate a c/c++ parser, it can work with flex and do the work.

the usage of zison is like below

```bash
usage: zison -o <output_file_path> -m <yes|no> <input_file_path>
       zison init -t <zlex/zison/zlexison> -o <output_file_path>
       zison zlexison -o <output_file_path> <input_file_path>
       zison bison <all_bison_options>
       zison --version
```

## Show me the usage by code

(yes, totally agree with that :))

Nothing is better than just show an practical example. There are many examples in `tests` folder, which can be good references. Let us check the one named with `reccalc`. It is the classic calculator implementation: accept user input like `3 + 4 * 5` and output result like `23`.

### 1. Generate shared token definitions

The shared token definitions are for both our future `lexer` and `parser`, which is the first thing to generate. We can use follow commands

```bash
zison zlexison -o zlexison.zig parser.y
```

(or can use `zlex` too)

```bash
zlex zlexison -o zlexison.zig parser.y
```

(`parser.y` is the syntax file for our `parser`. Tokens are defined conventionally in `parser.y` conventionally in flex/bison.)

### 2. Generate `lexer`

With `zlexison.zig` containing our common token definitions, we can generate our `lexer` with

```bash
zlex -o scan.zig scan.l
```

generated `scan.zig` will try importing `zlexison.zig` in same folder. After this we can

```bash
zig build-exe scan.zig
```

for building the lexer and test it, like `./scan` (or `./scan <input_file>`), it will read from input and try to print out what tokens it has found.

### 3. Generate `parser`

Finally let us generate our parser

```bash
zison -o parser.zig parser.y
```

generated `parser.zig` will try importing `zlexison.zig` and `scan.zig` for token definition and `lexer`.

We can be built our test `parser` with

```bash
zig build-exe parser.zig
```

then we can test it with `./parser` (or `./parser <input_file>`), it will read from input and try to do the parsing. In the example, it will print parsing result to stdout.

To use the new `parser`/`lexer` programmatically, simply read the end of file `scan.zig` or `parser.zig` file for the `main` fn. The usage code can be copied and easily adapted other places and reuse, as `zlex`/`zison` will always generate reentrant `lexer`/`parser`.

There is a `build.sh` script in example folder for all commands mentioned, so feel free to open and copy them.

## Usage

### Overview

`zlex` and `zison` is designed with following principles

1. stay as close as to `flex` and `bison` generated code so that manuals of `flex` and `bison` can be reused.
2. benefit from modern experience of practice to generate reusable/testable code.

Therefore `zlex` and `zison` have been intentionally designed to

1. generate code that can be understood by reading the manuals/blogs for `flex` and `bison`.
2. generate code with enforced defaults (like reentrant/pure settings) so that it can be easily reused.
3. can be used as `flex` and `bison` to generate C/C++ code too.

### `zlex`

TLDR; usage

```bash
# generate a default token definition file
zlex init -t zlexison -o zlexison.zig
# or if have parser.y defined can generate zlexison.zig as
zlex zlexison -o zlexison.zig parser.y
# generate a template for writing scan.l
zlex init -t zlex -o scan.l
# (modifying scan.l with your fav editor)
# after finish, generate lexer with
zlex -o scan.zig scan.l
# compile test lexer
zig build-exe scan.zig
# (when found errors, edit scan.l and regen and loop until work)
```

For detail usage of `zlex`, can read [zlex usage]().

### `zison`

TLDR; usage

```bash
# generate a template for writing parser.y
zison init -t zison -o parser.y
# (modifying parser.y with your fav editor for token definition)
# now generate zlexison.zig as
zison zlexison -o zlexison.zig parser.y
# (modifying parser.y with your fav editor again for rules)
# after finish, generate lexer with
zlex -o parser.zig parser.y
# compile test parser.y (you may need scan.zig ready too)
zig build-exe parser.zig
# (when found errors, edit scan.l and regen and loop until work)
```

For detail usage of `zison`, can read [zison usage]().

## Status of Features

TODO

## Features to do

TODO

## License

`zlex` and `zison` are built on top of `flex` and `bison`, so will stay compatible with upstream licenses correspondingly.

1. `flex`'s license can be found [here](https://github.com/FLEXTool/FLEX?tab=License-1-ov-file) and `zlex` part of this project is licensed under MIT license.
2. `bison` is licensed under GPLv3, so `zison` part of this project is licensed under GPLv3 too. (majority in folder `share`).
3. rest of code (mostly in `zig`, `src` folder), will be licensed under MIT license.
4. notice that any `lexer` and `parser` code generated by `flex` and `bison` are exempted to comply with same license. `zlex` and `zison` follow the same model, granting the generated files freedom to comply with your syntax/rule license if there any, or decide freely if there is none.
