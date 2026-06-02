# Testing And Observed Behavior

This file groups behavior that is explicitly enforced by `tests/init.luau`.

Use it when the README is too high-level and you need to know what the implementation is expected to do.

## Color Detection Precedence

The tests confirm:

- `--no-color`, `--color=false`, and `--color=never` return `0`
- `--color`, `--color=true`, and `--color=always` return `1`
- `--color=16m`, `--color=full`, and `--color=truecolor` return `3`
- `--color=256` returns `2`

They also confirm override behavior:

- `FORCE_COLOR=3` overrides `NO_COLOR`
- `FORCE_COLOR=3` overrides `--no-color`
- `FORCE_COLOR=0` overrides true-color hints
- `FORCE_COLOR=0` overrides `--color=256`

## `FORCE_COLOR` Edge Cases

Tests explicitly cover:

- `FORCE_COLOR="true"` -> `1`
- `FORCE_COLOR="false"` -> `0`
- `FORCE_COLOR=""` -> `1`
- `FORCE_COLOR="99"` -> capped to `3`
- invalid strings like `"banana"` are ignored
- negative strings like `"-1"` are ignored

## Environment And Terminal Cases

Tests verify:

- `NO_COLOR` with any value disables colors when not overridden
- `TERM=dumb` disables unless a force override exists
- Windows resolves to `3`
- generic `CI` resolves to `1`
- `GITHUB_ACTIONS` and `GITLAB_CI` resolve to `3`
- `COLORTERM=truecolor` resolves to `3`
- `xterm-kitty`, `xterm-ghostty`, and `wezterm` resolve to `3`
- iTerm major version `3+` resolves to `3`
- older or versionless iTerm resolves to `2`
- `Apple_Terminal` resolves to `2`
- `*-256color` terms resolve to `2`
- `xterm`, `screen`, `vt100`, `rxvt`, `linux`, `*-color`, and `ansi` patterns resolve to `1`
- unknown environments resolve to `0`

## TTY Cases

Tests confirm:

- `is_tty = false` disables color even if `COLORTERM=truecolor`
- `is_tty = false` with `FORCE_COLOR=3` still returns `3`
- `is_tty = true` with true-color hints behaves as expected

This makes the force override behavior unambiguous.

## Style Output Cases

Tests verify:

- `tint.underline "foo"` -> `\27[4mfoo\27[24m`
- `tint.red "foo"` -> `\27[31mfoo\27[39m`
- `tint.bg_red "foo"` -> `\27[41mfoo\27[49m`
- mixed style order is preserved in open/close sequence order
- nested styles restore outer state
- same-type nested colors restore correctly
- `reset` wraps the whole string with `\27[0m ... \27[0m`
- `gray` is equivalent to `bright_black`
- multiple arguments are joined with spaces
- no-argument style calls return `""`
- `rgb`, `bg_rgb`, `hex`, `bg_hex`, and chaining from them all work

## Why This File Matters

The tests reveal behavior that a user can rely on more strongly than README prose, especially for:

- precedence rules
- surprising edge cases
- string output shape
- alias behavior
