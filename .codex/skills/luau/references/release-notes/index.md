# Luau Release Notes Index

This folder keeps historical Luau material separate from the stable reference so current API lookup stays clean while rollout details, caveats, and design rationale remain available.

## How To Use This Folder

- Use `chronology/` when the question is “when was this added?”, “what changed?”, “why did this start warning?”, or “which recap mentioned this API?”
- Use `deep-dives/` when the question depends on deeper explanation of the type system, language design, or the intended mental model behind a feature.
- Prefer the stable reference first for present-day API shape. Fall back to these files when the stable docs do not explain migration risk, rollout sequence, or subtle behavior changes.

## Deep Dives

- `deep-dives/2020-01-16-luau-type-checking-beta.md`
    - Early explanation of the type checker, modes, annotation syntax, and initial roadmap.
- `deep-dives/2020-11-19-luau-type-checking-release.md`
    - First release framing for type checking, intended usage, and migration guidance.
- `deep-dives/2022-10-31-luau-semantic-subtyping.md`
    - Detailed rationale for semantic subtyping, false positives, normalization, and pragmatic constraints.
- `deep-dives/2022-11-04-luau-origins-and-evolution.md`
    - Long-form rationale for Luau’s overall design direction and tradeoffs.
- `deep-dives/2023-02-02-luau-string-interpolation.md`
    - Focused announcement and examples for string interpolation.

## Chronology

- `chronology/2019-11-11-luau-recap-november-2019.md`
    - Early debugger, performance, library, syntax, and analysis updates.
- `chronology/2020-02-25-luau-recap-february-2020.md`
    - Debugger, language, diagnostics, performance, and API removals.
- `chronology/2020-05-18-luau-recap-may-2020.md`
    - Function type syntax, `export type`, limits, library changes, and runtime changes.
- `chronology/2020-06-20-luau-recap-june-2020.md`
    - Compound assignments, error messages, type-checker updates, lint updates, and `os` changes.
- `chronology/2020-08-11-luau-recap-august-2020.md`
    - Production-safe annotations, format-string analysis, string-library improvements, and assorted fixes.
- `chronology/2020-10-30-luau-recap-october-2020.md`
    - Type-syntax evolution, library changes, and performance work before full release.
- `chronology/2021-03-01-luau-recap-february-2021.md`
    - Parser, type assertions, library changes, performance, and debugger improvements.
- `chronology/2021-03-29-luau-recap-march-2021.md`
    - Typed variadics, generics, typechecking, debugger, and library updates.
- `chronology/2021-04-30-luau-recap-april-2021.md`
    - Editor, performance, generics, debugger, and behavior changes.
- `chronology/2021-05-31-luau-recap-may-2021.md`
    - Named function type arguments plus ongoing type/runtime work.
- `chronology/2021-06-30-luau-recap-june-2021.md`
    - Constraint resolver, typechecking, editor, behavior, and performance changes.
- `chronology/2021-07-30-luau-recap-july-2021.md`
    - Typechecking, lint, editor, and behavior updates.
- `chronology/2021-08-31-luau-recap-august-2021.md`
    - Editor features, typechecking, lints, and performance changes.
- `chronology/2021-09-30-luau-recap-september-2021.md`
    - Generic functions, bidirectional typechecking, editor, and performance updates.
- `chronology/2021-10-31-luau-recap-october-2021.md`
    - If-expressions, library changes, typechecking, and performance work.
- `chronology/2021-11-03-luau-goes-open-source.md`
    - Open-source announcement and project availability context.
- `chronology/2021-11-29-luau-recap-november-2021.md`
    - Type packs in aliases, library improvements, typechecking, and bug fixes.
- `chronology/2022-01-27-luau-recap-january-2022.md`
    - Performance, type assertions, error reporting, REPL, and new APIs.
- `chronology/2022-02-28-luau-recap-february-2022.md`
    - Default type alias parameters, typechecking, lints, and performance work.
- `chronology/2022-03-31-luau-recap-march-2022.md`
    - Singleton types, width subtyping, API and debugger improvements.
- `chronology/2022-05-02-luau-recap-april-2022.md`
    - Additional 2022 language, analysis, and runtime changes.
- `chronology/2022-06-01-luau-recap-may-2022.md`
    - Generalized iteration, typechecking, lints, and compiler optimization updates.
- `chronology/2022-07-07-luau-recap-june-2022.md`
    - Lower bounds, unsealed table literal behavior, and known bug notes.
- `chronology/2022-08-29-luau-recap-august-2022.md`
    - `__len`, `never`/`unknown`, new lints, and analysis/runtime fixes.
- `chronology/2022-11-01-luau-recap-september-october-2022.md`
    - Semantic subtyping rollout and related analysis/runtime updates.
- `chronology/2022-11-30-luau-recap-november-2022.md`
    - Analysis and error-message improvements.
- `chronology/2023-03-31-luau-recap-march-2023.md`
    - Refinements, deprecated table helpers, autocomplete, runtime, and analysis changes.
- `chronology/2023-07-28-luau-recap-july-2023.md`
    - Analysis, runtime, autocomplete, and debugger improvements.
- `chronology/2023-11-01-luau-recap-october-2023.md`
    - Floor division, native codegen preview, analysis, autocomplete, and runtime updates.
- `chronology/2024-07-23-luau-recap-july-2024.md`
    - Native code generation, attributes, `utf8` validation, integer warnings, and runtime changes.
- `chronology/2025-12-19-luau-recap-runtime-2025.md`
    - New libraries and APIs, runtime/compiler/native-codegen updates, and C API changes.
