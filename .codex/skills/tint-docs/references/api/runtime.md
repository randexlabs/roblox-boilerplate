# Runtime API

This file documents the internal `runtime` module that Tint uses to gather environment information before color detection runs.

## Exported API

`lib/runtime.luau` returns a frozen table with:

| Key | Type | Meaning |
| --- | --- | --- |
| `env` | table | environment variables table |
| `args` | array | CLI arguments |
| `os` | string | runtime OS identifier |
| `is_tty` | boolean | whether Tint believes stdout is a TTY |

## Runtime Probe Strategy

Tint inspects `_VERSION:lower()` and branches like this:

1. if the version string contains `"zune"`:
   - `env = zune.process.env`
   - `args = zune.process.args`
   - `os = zune.platform.os`
   - `is_tty = zune.io.terminal.isTTY`
2. otherwise:
   - if version contains `"lune"`, use alias `@lune`
   - else use alias `@lute`
   - attempt `require("{alias}/process")`
3. if that require succeeds:
   - `env = process.env`
   - `args = process.args`
   - `os = process.os`
   - `is_tty = true`
4. if that require fails:
   - `env = {}`
   - `args = {}`
   - `os = "unknown"`
   - `is_tty = true`

## Practical Meaning

### Zune

Zune is the only branch with explicit TTY detection.

This is the most information-rich path, and it is the branch that can actually distinguish TTY from piped output at runtime.

### Lune

Tint treats a Lune runtime as having:

- process env access
- process args access
- process OS access
- assumed TTY

### Lute

Tint treats a non-Zune, non-Lune runtime as Lute first and attempts `require("@lute/process")`.

If that works, Tint gets:

- process env
- process args
- process OS
- assumed TTY

## Caveats

- Lune and Lute currently assume `is_tty = true`. This affects `color_support` because non-TTY disabling logic only works if `is_tty` can be false.
- The fallback path also assumes `is_tty = true`, so a runtime probe failure does not automatically disable colors.
- If `_VERSION` does not clearly identify the runtime and `@lute/process` cannot be required, Tint still returns a structurally valid runtime table with empty env/args and `os = "unknown"`.
- The module exports raw tables from the runtime when available. It does not normalize keys or argument conventions beyond storing them.
