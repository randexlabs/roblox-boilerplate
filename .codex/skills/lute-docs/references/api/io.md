# `definitions/io.luau`

## Purpose

This definition file describes the low-level standard-input and standard-output API exposed under `@lute/io`.

Use this file when the question is about:

- raw stdin/stdout interaction
- line-based input
- how `@std/io` adds prompting behavior

## Functions

### `io.write(...: string) -> ()`

Writes one or more strings to standard output without adding a trailing newline.

Practical meaning:

- if you want a newline, include it yourself or use `print`
- this is useful for prompts where the cursor should remain on the same line

### `io.read() -> string`

Reads a single line from standard input and returns it as a string.

Practical meaning:

- this is line-oriented input, not byte streaming

## `@std/io` Wrapper

The stdlib wrapper exposes:

- `write(...)`
- `input(prompt?)`

`input(prompt?)` behaves like:

1. if a prompt is provided, write it to stdout
2. read a line from stdin
3. return the string

Practical consequence:

- prompting is std-level convenience, not part of the low-level runtime function

## Example-Backed Usage

The input examples explicitly show three supported usage patterns:

1. interactive terminal input
2. piped input, e.g. `echo "Hello!" | lute script.luau`
3. redirected file input, e.g. `lute script.luau < input.txt`

Examples:

```luau
local io = require("@std/io")
local name = io.input("Please enter your name: ")
print(name)
```

```luau
local io = require("@std/io")
local input = io.input()
print(input)
```

## What To Avoid

- do not describe `io.read()` as a prompt-taking API; prompting belongs to `@std/io.input`
- do not describe this layer as a general stream API; the definitions only document line-based input and direct stdout writes
