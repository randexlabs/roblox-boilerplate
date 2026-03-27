# Luau docs (structured)

This is a modularized set of Luau notes optimized for quick lookup.

## Start here

- `overview/what-is-luau.md`: what Luau is, and where it differs from Lua
- `overview/strictness-modes.md`: `--!nocheck`, `--!nonstrict`, `--!strict`

## Language syntax (Luau additions)

- `syntax/literals.md`: string + number literal extensions
- `syntax/control-flow.md`: `continue`
- `syntax/assignments.md`: compound assignments (`+=`, `..=`, …)
- `syntax/if-expressions.md`: `if <expr> then <expr> else <expr>`
- `syntax/iteration.md`: generalized iteration + `__iter`
- `syntax/string-interpolation.md`: backtick strings with `{expr}`

## Types

- `types/annotations-and-aliases.md`: `:` annotations, `::` casts, `type` aliases, `export type`
- `types/type-inference-modes.md`: how `nocheck/nonstrict/strict` affect inference
- `types/structural-typing.md`: structural typing basics + width subtyping intuition
- `types/primitives.md`: primitive types + `any/unknown/never` + type packs
- `types/tables.md`: unsealed vs sealed vs generic tables; indexers
- `types/generics.md`: generic type aliases + generic functions
- `types/unions-and-intersections.md`: unions, intersections, tagged unions
- `types/refinements.md`: truthy/type guards/equality refinements
- `types/foreign-types.md`: embedder/Roblox foreign types (classes, enums, `IsA`)
- `types/additional-considerations.md`: module requires + cyclic deps

## Linter

- `linter/overview.md`: what it checks and how to suppress warnings
- `linter/warnings-index.md`: warning names + numeric codes

## Standard library reference (AI-friendly)

- `stdlib/index.md`: which libs exist + where to look
- `stdlib/global.md`: global functions
- `stdlib/math.md`, `stdlib/string.md`, `stdlib/table.md`, `stdlib/coroutine.md`, `stdlib/debug.md`, `stdlib/os.md`, `stdlib/bit32.md`, `stdlib/utf8.md`, `stdlib/buffer.md`

## Embedding / sandboxing

- `embedding/library-sandboxing.md`: what gets removed/limited for safety
- `embedding/globals-and-environments.md`: readonly globals + per-script env tables
- `embedding/gc-and-finalizers.md`: why `__gc` isn’t supported; host-side destructors
- `embedding/interrupts.md`: CPU/time interrupts and watchdogs

## Performance

- `performance/how-luau-is-fast.md`: high-level performance model + JIT notes
- `performance/profiling.md`: built-in sampling profiler (`--profile`)

## Reference

- `reference/syntax-grammar.md`: EBNF grammar for syntax + type grammar

