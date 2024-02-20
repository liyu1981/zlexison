# zlexison: zlex & zison

zlexison is `zig`'s adaption of `flex` & `bison` (`zlex` & `zison`) for writting lexer and parser.

## zlex

zlex is flex for zig: it will use the same input format for flex (or yacc), and output single zig file as lexer, which is the program doing lexical analysis: parse document into tokens.

zlex can also be used as flex, so that when need to generate a c/c++ lexer, can do the work.

the usage of zlex is like below

```bash
usage: zlex -o <output_file_path> -z <zlexison_file_path> -m <yes/no> <input_file_path>
       zlex flex <all_flex_options>
       zlex --version
```

## zison

similarly, zison is bison for zig: it will use the same input format for bison (or yacc), and output single zig file as parser, which is the program doing semantic analysis: parse stream of tokens into AST (abstract syntax tree).

zison can also be used as bison, so that when need to generate a c/c++ parser, it can work with flex and do the work.

the usage of zison is like below

```bash
usage: zlex -o <output_file_path> -z <zlexison_file_path> -m <yes/no> <input_file_path>
       zlex flex <all_flex_options>
       zlex --version
```

## show me the usage by code

(yes, totally agree with that :)) Nothing is better than just show an practical example. There are many examples in `tests` folder, which can be good references. Let us check the one named with `bison_reccalc`. It is the classic calculator implementation: accept user input like `3 + 4 * 5` and output result like `23`.

first is to generate a shared token definitions for both future `lexer` and `parser`, which can be done with (all below commands are invoked in `bison_reccalc` folder)

```bash
zison zlexison -o zlexison.zig parser.y
```

(`parser.y` is the syntax define file just like in flex/bison)

with `zlexison.zig` containing our common token definitions, we can generate our lexer with below command

```bash
zlex -o scan.zig -z zlexison.zig scan.l
```

after this we can `zig build-exe scan.zig` for building the lexer and test it.

finally let us generate our parser with below command

```bash
zison -o parser.zig parser.y
```

after this we will have `parser.zig` which will call our lexer and can be built with `zig build-exe parser.zig` for the testing program.

to use the new parser/lexer programmatically, simply look at the end of `scan.zig`/`parser.zig` file for the `main` fn, we can copy the usage code to other places, as zlex/zison will always generate reentrant `lexer`/`parser`.

# usage and manual

TODO

# differences to flex/bison

TODO

# what's work now, what's not yet work, and what's in plan to be made to work

TODO
