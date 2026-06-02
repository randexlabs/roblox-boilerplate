# Color Support API

This file documents the exported API and tested behavior of the internal `color_support` module.

It is not the main user-facing import, but it controls how every Tint style behaves.

## Exported API

`lib/color_support.luau` returns a frozen table with:

| Key | Type | Meaning |
| --- | --- | --- |
| `level` | `number` | resolved color level at module load time |
| `has_basic` | `boolean` | `level >= 1` |
| `has_256` | `boolean` | `level >= 2` |
| `has_16m` | `boolean` | `level >= 3` |
| `detect_level` | `(config?) -> number` | recompute support level using optional overrides |

## Color Levels

Tint uses these levels:

| Level | Meaning |
| --- | --- |
| `0` | no colors |
| `1` | basic ANSI 16 colors |
| `2` | ANSI 256 colors |
| `3` | true color / 16 million colors |

## `detect_level(config?)`

Signature as implemented:

```luau
detect_level(config: {
    env: { [string]: string? }?,
    args: { string }?,
    os: string?,
    is_tty: boolean?,
}?) -> number
```

### Config Behavior

- `env` defaults to runtime-detected environment
- `args` defaults to runtime-detected CLI args
- `os` defaults to runtime-detected OS
- `is_tty` defaults to runtime-detected TTY information

When `config.args` is omitted inside an override call, it falls back to `{}` rather than the runtime args. That matters in tests and custom calls.

## Detection Order

The logic is effectively:

1. read disabling flags:
   - `--no-color`
   - `--color=false`
   - `--color=never`
2. read enabling flags:
   - `--color`
   - `--color=true`
   - `--color=always`
3. parse `FORCE_COLOR`
4. if `FORCE_COLOR` is present and valid, it overrides the flag-derived force value
5. if the resulting forced value is `0`, return `0` immediately
6. if explicit high-level flags are present, return:
   - `3` for `--color=16m`, `--color=full`, `--color=truecolor`
   - `2` for `--color=256`
7. if `NO_COLOR` exists and no force override exists, return `0`
8. if not a TTY and no force override exists, return `0`
9. apply terminal/OS heuristics
10. fall back to the forced minimum or `0`

## CLI Flag Behavior

### Disable flags

These all force `0`:

- `--no-color`
- `--color=false`
- `--color=never`

### Enable flags

These all imply at least level `1`:

- `--color`
- `--color=true`
- `--color=always`

### Explicit high-level flags

- `--color=16m` -> `3`
- `--color=full` -> `3`
- `--color=truecolor` -> `3`
- `--color=256` -> `2`

### Precedence caveat

If both `--no-color` and `--color` appear, the implementation checks the no-color family first, so disable wins unless `FORCE_COLOR` overrides it later.

## `FORCE_COLOR`

The parser supports:

| Value | Result |
| --- | --- |
| unset | `nil`, no override |
| `""` | `1` |
| `"true"` | `1` |
| `"false"` | `0` |
| `"0"` | `0` |
| `"1"` | `1` |
| `"2"` | `2` |
| `"3"` | `3` |
| `"99"` | `3` after capping |

Invalid numeric strings:

- negative values become invalid because they fall below `0` after flooring
- non-numeric strings like `"banana"` are ignored

### Key precedence rule

Valid `FORCE_COLOR` overrides:

- `NO_COLOR`
- `--no-color`
- regular `--color` flags

And `FORCE_COLOR=0` can still disable output even if other heuristics suggest color.

## `NO_COLOR`

If `NO_COLOR` exists at all, Tint disables colors unless a force override exists.

The value itself does not matter:

- `NO_COLOR=""` disables
- `NO_COLOR="1"` also disables

## TTY Handling

If `is_tty` is `false` and there is no force override, Tint returns `0`.

This is how the library tries to avoid coloring output that is being piped.

### Caveat

Actual TTY detection only exists in the Zune runtime branch. In Lune and Lute, runtime probing currently assumes `is_tty = true`.

## OS And Terminal Heuristics

### `TERM=dumb`

If `TERM == "dumb"`, Tint returns the current minimum forced level.

That means:

- with no force override, it returns `0`
- with `FORCE_COLOR=1`, it returns `1`

### Windows

If `os == "windows"`, Tint returns `math.max(3, min)`.

In practice:

- plain Windows resolves to `3`
- Windows with `FORCE_COLOR=1` still resolves to `3`
- Windows with `FORCE_COLOR=0` returns `0` earlier because the function exits before this branch

This is a strong assumption: Tint treats Windows as true-color capable.

### CI

If `CI` exists:

- `GITHUB_ACTIONS` or `GITLAB_CI` present -> `3`
- otherwise generic CI -> `1`

### True-color terminal hints

These yield `3`:

- `COLORTERM=truecolor`
- `TERM=xterm-kitty`
- `TERM=xterm-ghostty`
- `TERM=wezterm`

### `TERM_PROGRAM`

- `TERM_PROGRAM=iTerm.app` with major version `>= 3` -> `3`
- `TERM_PROGRAM=iTerm.app` with lower or missing major version -> `2`
- `TERM_PROGRAM=Apple_Terminal` -> `2`

### `TERM`

If `TERM` ends with `-256color`, Tint returns `2`.

If `TERM` matches any of these patterns, Tint returns `1`:

- `^screen`
- `^xterm`
- `^vt100`
- `^rxvt`
- `color`
- `ansi`
- `linux`

### Generic `COLORTERM`

If `COLORTERM` exists with any value and no higher rule matched, Tint returns `1`.

## Fallback

If nothing matches, Tint returns the current minimum forced level.

That means:

- unknown environment with no overrides -> `0`
- unknown environment with `FORCE_COLOR=1` -> `1`

## Practical Caveats

- `level` is computed at module load time. If environment conditions change after require, `level` will not update automatically.
- To reason about alternate conditions, call `detect_level(...)` directly.
- Because Lune and Lute branches assume TTY by default, runtime behavior there may be more optimistic than a real piped terminal situation.
