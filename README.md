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

## 1. Generate shared token definitions

The shared token definitions are for both our future `lexer` and `parser`, which is the first thing to generate. We can use follow commands

```bash
zison zlexison -o zlexison.zig parser.y
```

(or can use `zlex` too)

```bash
zlex zlexison -o zlexison.zig parser.y
```

(`parser.y` is the syntax file for our `parser`. Tokens are defined conventionally in `parser.y` conventionally in flex/bison.)

## 2. Generate `lexer`

With `zlexison.zig` containing our common token definitions, we can generate our `lexer` with

```bash
zlex -o scan.zig scan.l
```

generated `scan.zig` will try importing `zlexison.zig` in same folder. After this we can

```bash
zig build-exe scan.zig
```

for building the lexer and test it, like `./scan` (or `./scan <input_file>`), it will read from input and try to print out what tokens it has found.

## 3. Generate `parser`

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

# usage and manual

## principle

TODO

## zlex

TODO

## zison

TODO

# what's work

TODO

# what's not yet work

TODO

# what's in plan to be made to work

TODO

# reference manual of flex & bison

flex: https://www.cs.virginia.edu/~cr4bd/flex-manual/
bison: https://www.gnu.org/software/bison/manual/
