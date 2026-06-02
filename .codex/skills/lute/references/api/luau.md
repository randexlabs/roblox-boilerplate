# `definitions/luau.luau`

## Purpose

This definition file exposes Luau introspection and tooling primitives under `@lute/luau`.

Use this file when the question is about:

- parsing Luau source
- CST node structure
- compiling and loading Luau bytecode
- resolving `require` paths
- module return-type introspection

This is a tooling-oriented surface, not a day-to-day application helper library.

## Major API Areas

The file exposes:

- spans and trivia
- token types
- CST node types for expressions, statements, types, and type packs
- parse functions
- compile/load functions
- module resolution
- resolved-type and type-pack introspection

## Parse and Compile Functions

### `luau.parse(source: string) -> CstParseResult`

Parses a full source file.

Practical meaning:

- use this when working on file-level transforms or analyzers

### `luau.parseExpr(source: string) -> CstExpr`

Parses a single expression.

Practical meaning:

- this is the simpler entry point for quick expression inspection or expression-only tooling

The local parsing example uses the higher-level syntax module like this:

```luau
local syntax = require("@std/syntax")
local foo = syntax.parseExpr("5")
```

### `luau.compile(source: string) -> Bytecode`

Compiles source into a `Bytecode` record.

### `luau.load(bytecode, chunkname, env?) -> (...any) -> ...any`

Loads compiled bytecode into a callable function.

Important caveat from the contract:

- the optional `env` lets callers override the global environment

What to avoid:

- do not describe `load` as always running in the default globals

## Module Resolution and Type Introspection

### `luau.resolveModule(path, fromchunkname) -> string`

Resolves a require path relative to another chunk.

Practical meaning:

- this is the low-level resolver used by higher-level tools

### `luau.typeofModule(modulepath) -> TypePack?`

Returns the module's return-type pack, or `nil` if unavailable.

Important caveat:

- failure or unavailability is part of the contract

What to avoid:

- do not assume module type introspection always succeeds

## CST and Type Model Caveats

The definitions are intentionally granular:

- expression nodes are distinct from statement nodes
- type nodes are distinct from type-pack nodes
- punctuated sequences preserve separator tokens
- many nodes expose exact `tag` and `kind` information

Practical meaning:

- if exact syntax shape matters, answer with CST-level precision rather than generic “AST” wording

What to avoid:

- do not flatten everything into one undifferentiated node type when tags and kinds are relevant

## `@std/luau` Wrapper

The stdlib wrapper adds practical utilities:

- `compile(source)`
- `load(bytecode, chunkname?, env?)`
- `loadModule(requirePath, env?)`
- `typeofModule(modulepath)`
- `resolveModule(modulepath, frompath)`
- `requires(filePath)`

Useful wrapper behavior:

- it accepts `Pathlike` values where appropriate
- `loadModule` reads, compiles, and executes a file for you
- `requires(...)` parses the file and returns discovered `require(...)` calls, along with resolved paths when possible

## Example-Backed Usage

The module-return-type example uses `@std/luau.typeofModule(...)` defensively:

- it checks for `nil`
- it checks for missing `head`
- it checks that the returned type shape is a table before reading properties

That is a good model for future answers: this API should be treated as introspection that can fail or produce shapes you still need to inspect.

## What To Avoid

- do not present this module as a casual runtime library for everyday scripts
- do not assume `typeofModule` always returns a table-shaped module result
- do not answer CST questions from memory if exact node/tag structure matters; the definition file is the contract
