# Luau Reference Index

This corpus reorganizes Luau language, library, tooling, embedding, and release-history material for quick lookup without dropping useful context.

The goal is not to reduce Luau to a bare API catalog. The goal is to keep the full developer-facing surface queryable: CLI entry points, language features, type-system behavior, library APIs, lints, embedding caveats, performance guidance, and historical posts that explain why a feature behaves the way it does.

## Best Entry Points

- Start with `getting-started-and-cli.md` for the CLI surface, first-run workflow, and strict vs nonstrict behavior.
- Start with `syntax-and-language-features.md` for language constructs and feature syntax.
- Start with `api/standard-library.md` for the complete standard library API.
- Start with `types/overview.md` for the type-system map, then branch into the matching `types/*.md` file.
- Start with `linting-and-static-analysis.md` for warning codes, directives, and analysis-specific caveats.
- Start with `embedding-sandbox-and-safety.md` for sandboxing, removed APIs, and isolation behavior.
- Start with `runtime-performance.md` or `profiling.md` for optimization and diagnosis work.
- Start with `release-notes/index.md` when the answer depends on historical rollout, deprecations, or design rationale.

## File Map

### Orientation and everyday usage

- `getting-started-and-cli.md`
  - Initial Luau workflow, `luau`, `luau-analyze`, annotations, and type-checking modes.
- `overview-and-motivation.md`
  - Why Luau exists, what it optimizes for, and how compiler/runtime design differs from stock Lua.

### Language and semantics

- `syntax-and-language-features.md`
  - Luau-specific syntax and feature behavior.
- `compatibility-and-differences.md`
  - Support status for Lua 5.2-5.5 features, implementation limits, and intentional behavior differences.
- `api/attributes.md`
  - Built-in function attributes and parameterized attribute syntax.
- `api/grammar.md`
  - Full EBNF grammar.

### Types

- `types/overview.md`
  - Modes, structural typing, annotations, and casts.
- `types/basic-types.md`
  - Primitive types, `unknown`, `never`, `any`, function types, variadics, type packs, and singleton types.
- `types/tables.md`
  - Unsealed, sealed, and generic tables plus indexers.
- `types/unions-and-intersections.md`
  - Union types, tagged unions, intersection types, and overloaded-function caveats.
- `types/generics.md`
  - Generic type aliases, generic functions, and explicit type instantiation.
- `types/refinements.md`
  - Refinement rules via truthiness, `type`, equality, boolean composition, and `assert`.
- `types/object-oriented-programs.md`
  - Practical typing pattern for metatable-based OOP.
- `types/roblox-types.md`
  - Embedder-provided concrete types, enum access, and `IsA`-based refinement.
- `types/type-functions.md`
  - Analysis-time type functions and their execution environment.
- `types/considerations.md`
  - `require` path resolution caveats and cyclic dependency workaround.
- `api/type-function-library.md`
  - Complete `types` library and `type` object API.

### Tooling and runtime

- `linting-and-static-analysis.md`
  - Full lint list with examples and suppression rules.
- `runtime-performance.md`
  - VM/compiler optimizations, fast paths, GC pacing, table behavior, closure caching, and optimization-level caveats.
- `profiling.md`
  - Built-in profiler usage and flamegraph workflow.
- `embedding-sandbox-and-safety.md`
  - Removed libraries, restricted functions, readonly globals, `__gc`, and interrupt model.
- `api/standard-library.md`
  - Full builtin library reference, including `buffer` and `vector`.

### Historical context

- `release-notes/index.md`
  - Map of recap posts and deep-dive essays.

## Coverage Notes

- Stable reference files cover the current documented API and behavior surface.
- Release notes preserve rollout details, bug notes, deprecations, rationale, and edge cases that may not have been folded back into the stable docs.
- Historical files intentionally keep author commentary and narrative context when that helps explain tradeoffs or failure modes.
