---
name: luau-docs
description: Answer practical Luau questions from reorganized local documentation and release notes. Use when working with the Luau language, `luau` CLI, `luau-analyze`, syntax, lints, standard library, type system, type functions, attributes, grammar, compatibility with Lua, embedding, sandboxing, runtime performance, profiling, or historical feature caveats and release behavior.
---

# Luau Docs

Use this skill for source-based Luau answers that need exact API details, caveats, examples, CLI behavior, or historical context behind language and runtime features.

Read the smallest relevant file first. Pull in release notes only when the question depends on behavior changes over time, feature rollout details, deprecations, or caveats that are easy to miss in the stable reference.

## Workflow

1. Decide whether the question is about language syntax, typing, public libraries, analysis/tooling, embedding/runtime, or historical evolution.
2. Open `references/index.md` only if you need a map.
3. Prefer stable reference files before release notes for current behavior.
4. Use deep-dive release notes when a feature has design rationale or important edge cases not captured in the stable docs.
5. Preserve caveats, defaults, restrictions, implementation limits, and author guidance instead of flattening everything into a symbol list.

## Reference Map

- `references/index.md`
  - Human-readable map of the reorganized corpus.
- `references/getting-started-and-cli.md`
  - Luau overview, first script, `luau`, `luau-analyze`, strict vs nonstrict, and annotation basics.
- `references/overview-and-motivation.md`
  - Why Luau exists, what problems it solves, and high-level runtime/compiler positioning.
- `references/syntax-and-language-features.md`
  - Luau-only syntax features such as `continue`, compound assignment, `const`, if-expressions, generalized iteration, string interpolation, floor division, and attribute syntax.
- `references/compatibility-and-differences.md`
  - Lua 5.1-5.5 compatibility status, implementation limits, and behavior differences.
- `references/linting-and-static-analysis.md`
  - Complete lint catalog, directives, warning meanings, and caveats.
- `references/runtime-performance.md`
  - Runtime/compiler optimizations, fast paths, GC behavior, JIT/native compilation context, and performance guidance.
- `references/profiling.md`
  - Built-in profiler workflow, flamegraph usage, and profiling caveats.
- `references/embedding-sandbox-and-safety.md`
  - Sandboxing model, removed APIs, isolation model, interrupt behavior, and `__gc` restrictions.
- `references/api/standard-library.md`
  - Complete standard library API, including globals, `math`, `table`, `string`, `coroutine`, `bit32`, `utf8`, `os`, `debug`, `buffer`, and `vector`.
- `references/api/type-function-library.md`
  - Complete `types` library API and `type` object API available inside type functions.
- `references/api/attributes.md`
  - Built-in attributes such as `@native` and `@deprecated`, including parameter syntax and warning behavior.
- `references/api/grammar.md`
  - Complete EBNF grammar.
- `references/types/*.md`
  - Type-system reference split by topic: overview, basic types, tables, unions/intersections, generics, refinements, OOP patterns, embedder/Roblox types, type functions, and module considerations.
- `references/release-notes/index.md`
  - Map for historical material.

## Usage Notes

- For standard library or exact symbol questions, start with `references/api/standard-library.md`.
- For type-function or analyzer metaprogramming questions, combine `references/types/type-functions.md` with `references/api/type-function-library.md`.
- For “why does Luau reject/accept this type?” questions, start with the matching `references/types/*.md` file and then check deep dives if behavior is historically nuanced.
- For warnings, directives, or `luau-analyze` output, start with `references/linting-and-static-analysis.md` and `references/getting-started-and-cli.md`.
- For performance or GC questions, start with `references/runtime-performance.md`; add `references/profiling.md` when the user is trying to measure or diagnose bottlenecks.
- For embedding, safety, or removed-Lua-surface questions, start with `references/embedding-sandbox-and-safety.md` and `references/compatibility-and-differences.md`.
- For feature rollout details, deprecations, or recent additions such as `vector`, newer math helpers, or C API changes, check `references/release-notes/chronology/`.
- For conceptual essays and design rationale, check `references/release-notes/deep-dives/`.

## Resources

- `references/`
  - Reorganized Luau documentation and release notes for fast lookup while preserving API details, examples, warnings, caveats, and design context.
