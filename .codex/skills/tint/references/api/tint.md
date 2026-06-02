# Tint Public API

This file documents the full public API exposed by:

```luau
local tint = require("@pkg/tint")
```

## API Shape

Tint exports a callable-and-chainable object.

The type declared in `lib/init.luau` is conceptually:

```luau
type style = ((...string) -> string) & { ...chainable properties... }
type tint = style & {
    rgb: (r: number, g: number, b: number) -> style,
    hex: (hex: string) -> style,
    bg_rgb: (r: number, g: number, b: number) -> style,
    bg_hex: (hex: string) -> style,
}
```

That means:

- `tint.red` is a callable style object
- `tint.red.bold` is another callable style object
- `tint.rgb(255, 0, 0)` returns a callable style object
- every style object can be chained with the same supported properties

## Calling A Style

Any style can be called as:

```luau
style(...strings) -> string
```

Behavior:

- zero arguments returns `""`
- arguments are concatenated with `" "` between them
- if detected color level is `0`, the returned string is plain text with spaces, not ANSI-coded output
- otherwise the returned string is wrapped with open and close ANSI sequences

Examples:

```luau
tint.red("foo")               -- "\27[31mfoo\27[39m"
tint.red("foo", "bar")        -- "\27[31mfoo bar\27[39m"
tint.red()                    -- ""
tint.red.bold("warn")         -- red + bold ANSI sequence
```

## Modifier Styles

All modifier properties below are part of the public API:

| Property        | Meaning                    | Open | Close |
| --------------- | -------------------------- | ---- | ----- |
| `reset`         | reset everything           | `0`  | `0`   |
| `bold`          | bold/intense text          | `1`  | `22`  |
| `dim`           | dim/faint text             | `2`  | `22`  |
| `italic`        | italic text                | `3`  | `23`  |
| `underline`     | underline text             | `4`  | `24`  |
| `overline`      | overline text              | `53` | `55`  |
| `inverse`       | swap foreground/background | `7`  | `27`  |
| `hidden`        | hidden/concealed text      | `8`  | `28`  |
| `strikethrough` | strike text                | `9`  | `29`  |

Examples:

```luau
print(tint.bold("bold"))
print(tint.reset("plain again"))
print(tint.inverse("swap"))
print(tint.hidden("secret"))
```

### Caveats For Modifiers

- `reset` is a style like the others, not a separate imperative command.
- `bold` and `dim` both close with ANSI code `22`.
- Because Tint reopens outer styles after matching close sequences, nested modifier interactions are based on escape-code replacement, not a semantic style tree.

## Foreground Colors

All foreground color properties below are public:

| Property  | Open | Close |
| --------- | ---- | ----- |
| `black`   | `30` | `39`  |
| `red`     | `31` | `39`  |
| `green`   | `32` | `39`  |
| `yellow`  | `33` | `39`  |
| `blue`    | `34` | `39`  |
| `magenta` | `35` | `39`  |
| `cyan`    | `36` | `39`  |
| `white`   | `37` | `39`  |
| `gray`    | `90` | `39`  |

Example:

```luau
print(tint.red("error"))
print(tint.gray("muted"))
```

### `gray` Caveat

`gray` is not a separate ANSI family. It maps to the same codes as `bright_black`.

## Bright Foreground Colors

| Property         | Open | Close |
| ---------------- | ---- | ----- |
| `bright_black`   | `90` | `39`  |
| `bright_red`     | `91` | `39`  |
| `bright_green`   | `92` | `39`  |
| `bright_yellow`  | `93` | `39`  |
| `bright_blue`    | `94` | `39`  |
| `bright_magenta` | `95` | `39`  |
| `bright_cyan`    | `96` | `39`  |
| `bright_white`   | `97` | `39`  |

Example:

```luau
print(tint.bright_red("hot"))
print(tint.bright_black("gray-like"))
```

## Background Colors

| Property     | Open | Close |
| ------------ | ---- | ----- |
| `bg_black`   | `40` | `49`  |
| `bg_red`     | `41` | `49`  |
| `bg_green`   | `42` | `49`  |
| `bg_yellow`  | `43` | `49`  |
| `bg_blue`    | `44` | `49`  |
| `bg_magenta` | `45` | `49`  |
| `bg_cyan`    | `46` | `49`  |
| `bg_white`   | `47` | `49`  |

Example:

```luau
print(tint.bg_red("warning area"))
print(tint.red.bg_white("red on white"))
```

## Bright Background Colors

| Property            | Open  | Close |
| ------------------- | ----- | ----- |
| `bg_bright_black`   | `100` | `49`  |
| `bg_bright_red`     | `101` | `49`  |
| `bg_bright_green`   | `102` | `49`  |
| `bg_bright_yellow`  | `103` | `49`  |
| `bg_bright_blue`    | `104` | `49`  |
| `bg_bright_magenta` | `105` | `49`  |
| `bg_bright_cyan`    | `106` | `49`  |
| `bg_bright_white`   | `107` | `49`  |

## Dynamic Color Constructors

### `tint.rgb(r, g, b) -> style`

Create a foreground style from RGB channel values.

Behavior by detected support level:

- true color available: emits `38;2;r;g;b`
- 256-color available: converts to nearest ANSI 256 code and emits `38;5;<code>`
- only basic color available: converts to an ANSI 16 foreground code

Examples:

```luau
print(tint.rgb(255, 0, 0)("red"))
print(tint.rgb(123, 45, 67).underline("custom"))
```

### Caveats

- There is no explicit range validation in `lib/init.luau`.
- On true-color terminals, out-of-range values are interpolated directly into the escape sequence.
- On lower-color terminals, conversion logic approximates to Tint's nearest supported bucket.

### `tint.bg_rgb(r, g, b) -> style`

Background equivalent of `rgb`.

Behavior by level:

- true color: `48;2;r;g;b`
- 256-color: `48;5;<code>`
- basic color: converted ANSI 16 foreground code plus `10` to shift into the background range

Example:

```luau
print(tint.bg_rgb(30, 30, 46)("surface"))
```

### `tint.hex(hex) -> style`

Create a foreground style from a hex string.

Implementation behavior:

1. removes all `#` characters
2. reads bytes `1-2`, `3-4`, and `5-6`
3. converts each pair with `tonumber(..., 16) or 0`
4. delegates to `tint.rgb`

Examples:

```luau
print(tint.hex("#FF0000")("red"))
print(tint.hex("1e1e2e").bold("dark"))
```

### Caveats

- No strict validation.
- No dedicated support for 3-digit shorthand like `#f80`.
- Short or malformed strings silently fall back to `0` for missing/invalid channels.
- Because every `#` is removed, unusual inputs like `"##ff0000"` are normalized instead of rejected.

### `tint.bg_hex(hex) -> style`

Background equivalent of `hex`. It uses the same permissive parsing logic and delegates to `tint.bg_rgb`.

## Chaining Rules

Any style returned from any property or constructor can be chained with any other known style property:

```luau
tint.red.bold.underline("x")
tint.hex("#ff0000").bold("x")
tint.rgb(1, 2, 3).bg_white.italic("x")
```

Internally, chaining appends ANSI code pairs and produces nested close sequences in reverse order.

## Unknown Properties

Unknown style names return `nil`, not an error from Tint itself:

```luau
local maybe = tint.not_a_real_style -- nil
```

This means misspellings can fail later when you try to call or chain them.

## Reusable Styles

Styles are reusable values:

```luau
local errorLabel = tint.red.bold
print(errorLabel("ERROR"))
print(errorLabel("FATAL"))
```

Each property access creates a new style object rather than mutating a shared one.
