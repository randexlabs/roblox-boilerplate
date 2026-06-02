# Tint Reference Index

This corpus reorganizes the available Tint material from:

- `README.md`
- `TODO.md`
- `lib/init.luau`
- `lib/color_support.luau`
- `lib/color_convert.luau`
- `lib/runtime.luau`
- `lib/ansi.luau`
- `tests/init.luau`

The goal is not to summarize Tint. The goal is to keep the full practical shape of the library easy to query later, including public API, internal behavior that affects output, and tested edge cases.

## Best Entry Points

- Start with `overview-and-getting-started.md` for installation, mental model, and common usage.
- Start with `api/tint.md` for the complete public API.
- Start with `api/color-support.md` for environment-variable, CLI-flag, terminal, CI, Windows, and TTY behavior.
- Start with `behavior-and-caveats.md` for surprising behaviors and “what to avoid”.
- Start with `testing-and-observed-behavior.md` when a claim needs to match what the tests enforce.

## File Map

### Core usage

- `overview-and-getting-started.md`
    - What Tint is, installation, requiring, chaining, nesting, RGB, hex, and background usage.

### Public API

- `api/tint.md`
    - Every public chainable style and color plus `rgb`, `hex`, `bg_rgb`, and `bg_hex`.

### Internal modules that affect behavior

- `api/color-support.md`
    - Color-level detection, precedence rules, runtime assumptions, and exported flags.
- `api/color-convert.md`
    - RGB downgrade helpers and caveats around approximation.
- `api/runtime.md`
    - Runtime probing and how Tint populates env/args/os/TTY data.
- `api/ansi.md`
    - Exact ANSI open/close code map used by Tint.

### Behavior and compatibility

- `behavior-and-caveats.md`
    - Output-shaping rules, leniencies, omissions, and practical failure modes.
- `testing-and-observed-behavior.md`
    - Behavior confirmed by tests, grouped by concern.
- `packaging-and-compatibility.md`
    - `pesde` target, runtime notes, and import shape.
- `roadmap-and-known-gaps.md`
    - Explicit TODO items and missing features.
