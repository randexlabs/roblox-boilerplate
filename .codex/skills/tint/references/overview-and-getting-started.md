# Tint Overview And Getting Started

## What Tint Is

Tint is a Chalk-inspired terminal string styling library for Luau.

The public shape is intentionally fluent:

```luau
local tint = require("@pkg/tint")

print(tint.red.bold.underline("text"))
```

The library is designed around a few core ideas:

- styles are chainable
- nested styled segments try to restore outer styles automatically
- RGB and hex styling degrade to 256-color or 16-color output when the terminal cannot do true color
- color support is detected automatically from runtime, environment, CLI flags, and terminal metadata
- the library aims to work across Zune, Lune, and Lute

## Installation

Add Tint to `pesde.toml`:

```toml
[dependencies]
tint = { name = "omarcoaraujo/tint", version = "^0.1.0" }
```

Then require it:

```luau
local tint = require("@pkg/tint")
```

The package metadata currently declares a `luau` target, not a dedicated `lute` or `lune` target.

## Mental Model

Tint does not print by itself. Each style is a callable object that returns a string with ANSI escape sequences.

That means this is the normal pattern:

```luau
print(tint.red("ERROR"))
```

Not:

```luau
tint.red("ERROR") -- returns a string, does not emit output by itself
```

Each chained property returns another callable style object:

```luau
local important = tint.red.bold.underline
print(important("Failure"))
```

## Basic Colors

```luau
print(tint.red("ERROR"))
print(tint.green("SUCCESS"))
print(tint.yellow("WARNING"))
print(tint.blue("INFO"))
print(tint.cyan("note"))
```

## Modifiers

```luau
print(tint.bold("bold"))
print(tint.italic("italic"))
print(tint.underline("underline"))
print(tint.dim("dim"))
print(tint.strikethrough("strikethrough"))
```

Tint also supports `reset`, `overline`, `inverse`, and `hidden`, even though the README examples only show a subset.

## Chaining

Styles can be chained in any order:

```luau
print(tint.red.bold("red and bold"))
print(tint.blue.bold.underline("important"))
print(tint.green.italic("success"))
```

Order changes the emitted open/close sequence order, but the resulting visual effect is usually what you expect.

## Nesting

Outer styles are reopened after inner styled segments close:

```luau
print(tint.red("error: ", tint.yellow("detail"), " continues in red"))
print(tint.bold("BOLD ", tint.underline("BOLD+UNDERLINE"), " BOLD again"))
```

This restoration behavior matters because Tint is designed to support nested composition instead of only flat styling.

## True Color, RGB, And Hex

```luau
print(tint.rgb(255, 136, 0)("orange"))
print(tint.hex("#ff8800")("also orange"))
print(tint.rgb(255, 136, 0).bold("bold orange"))
```

Background variants:

```luau
print(tint.bg_rgb(30, 30, 46)("text on dark bg"))
print(tint.bg_hex("#1e1e2e")("text on hex bg"))
```

When true color is unavailable, Tint downgrades RGB and hex to the closest internal 256-color or 16-color approximation it can compute.

## Background Colors

```luau
print(tint.bg_red("red background"))
print(tint.bg_green("green background"))
print(tint.red(tint.bg_white("red text on white background")))
```

## Runtime Compatibility

The documented compatibility table is:

| Runtime | Color support | TTY detection   |
| ------- | ------------- | --------------- |
| Zune    | Full          | Yes             |
| Lune    | Full          | No, assumes TTY |
| Lute    | Full          | No, assumes TTY |

This table is directionally correct, but the exact behavior depends on `lib/runtime.luau` and `lib/color_support.luau`. For those details, see:

- `api/runtime.md`
- `api/color-support.md`

## Important First Caveats

- If Tint detects color level `0`, style calls return plain joined text instead of ANSI-colored text.
- Multiple arguments are joined with a single space.
- Calling a style with no arguments returns an empty string.
- Hex parsing is permissive rather than strict.
- Newline-specific color reopening is listed as a TODO, so nested restoration is not the same thing as line-aware continuation behavior.
