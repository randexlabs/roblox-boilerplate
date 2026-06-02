---
name: tint-docs
description: Answer practical Tint questions using reorganized local documentation and code-derived API notes. Use when working with Tint installation, `pesde` setup, chainable terminal styling, ANSI color behavior, nested styles, RGB and hex colors, color-level detection, runtime compatibility across Zune/Lune/Lute, internal modules like `color_support` and `color_convert`, or when you need caveats and exact behavior for any exported Tint API.
---

# Tint Docs

Use this skill when the user needs source-based guidance about how Tint behaves in practice.

Start with the smallest matching file in `references/`. Read only what matches the task, but preserve caveats, examples, defaults, edge cases, and behavior inferred from tests when answering.

## Workflow

1. Decide whether the question is about public styling usage, runtime/color detection, internal modules, packaging, or known limitations.
2. Open `references/index.md` only if you need a map first.
3. Prefer the public API file first for end-user questions, then pull in internal-module files only when behavior depends on implementation details.
4. Keep the distinction explicit between:
    - public API exposed by `require("@pkg/tint")`
    - internal modules that explain behavior but are not the main user-facing surface
    - documented behavior from `README.md`
    - stronger guarantees inferred from tests
5. Preserve author intent and operational caveats instead of flattening the library into a bare symbol list.

## Reference Map

- `references/index.md`
    - Human-readable map of the reorganized corpus and coverage.
- `references/overview-and-getting-started.md`
    - What Tint is, installation, first require, mental model, and high-level usage patterns.
- `references/api/tint.md`
    - Complete public API for `require("@pkg/tint")`, including every style, color, background color, `rgb`, `hex`, `bg_rgb`, and `bg_hex`.
- `references/api/color-support.md`
    - Complete `color_support` module behavior: detection order, overrides, return levels, runtime assumptions, and tested precedence rules.
- `references/api/color-convert.md`
    - Complete `color_convert` module behavior and downgrade logic for RGB to ANSI 256 / ANSI 16.
- `references/api/runtime.md`
    - Runtime detection behavior for Zune, Lune, Lute, and fallback mode.
- `references/api/ansi.md`
    - Canonical ANSI code table used by Tint, including every modifier, foreground, bright foreground, background, and bright background mapping.
- `references/behavior-and-caveats.md`
    - Cross-cutting caveats such as argument joining, nil lookups, hex parsing permissiveness, nesting/restoration rules, and newline limitations.
- `references/testing-and-observed-behavior.md`
    - Behavior validated by the test suite, especially precedence and edge cases that are easy to misstate from README alone.
- `references/packaging-and-compatibility.md`
    - `pesde` metadata, supported target/runtime expectations, and what “runtime agnostic” means here.
- `references/roadmap-and-known-gaps.md`
    - Open TODO items and what is not implemented yet.

## Usage Notes

- For normal usage questions, start with `overview-and-getting-started.md` and `api/tint.md`.
- For “what exactly happens if…” questions, combine `api/tint.md` with `testing-and-observed-behavior.md`.
- For `FORCE_COLOR`, `NO_COLOR`, `--color`, `--no-color`, CI, Windows, or TTY behavior, start with `api/color-support.md`.
- For RGB or hex downgrade questions, combine `api/tint.md` with `api/color-convert.md`.
- For “does this runtime support Tint?” questions, combine `packaging-and-compatibility.md` with `api/runtime.md`.
- For “why did this output look odd?” questions, check `behavior-and-caveats.md` and `roadmap-and-known-gaps.md`.
- For low-level ANSI mapping questions, open `api/ansi.md`.

## Resources

- `references/`
    - Topic-grouped Tint documentation reorganized for fast lookup while preserving examples, implementation caveats, and tested behavior.
