# Color Convert API

This file documents the internal `color_convert` module used by `tint.rgb`, `tint.bg_rgb`, `tint.hex`, and `tint.bg_hex` when true color is unavailable.

## Exported API

`lib/color_convert.luau` returns a frozen table with:

| Key          | Type                                          | Meaning                            |
| ------------ | --------------------------------------------- | ---------------------------------- |
| `to_ansi256` | `(r: number, g: number, b: number) -> number` | map RGB to ANSI 256 palette index  |
| `to_ansi16`  | `(r: number, g: number, b: number) -> number` | map RGB to ANSI 16 foreground code |

## `to_ansi256(r, g, b)`

Convert RGB into an ANSI 256 color palette index.

### Behavior

- If `r == g == b`, Tint treats it as grayscale and maps to the grayscale ramp:
    - `< 8` -> `16`
    - `> 248` -> `231`
    - otherwise -> grayscale bucket `232..255`
- Otherwise it maps each channel into the 6x6x6 color cube and returns a code in `16..231`

### Tested examples

| RGB               | Result |
| ----------------- | ------ |
| `(255, 0, 0)`     | `196`  |
| `(0, 255, 0)`     | `46`   |
| `(0, 0, 255)`     | `21`   |
| `(255, 255, 255)` | `231`  |
| `(0, 0, 0)`       | `16`   |
| `(128, 128, 128)` | `244`  |

### Caveats

- This is approximation, not perceptual color matching.
- There is no input validation or clamping in the module itself.
- The returned number is a palette index, not a final full escape sequence.

## `to_ansi16(r, g, b)`

Convert RGB into a basic ANSI 16 foreground color code.

Implementation:

1. convert RGB to ANSI 256
2. reduce the ANSI 256 code into a basic/bright 16-color foreground code

### Tested examples

| RGB               | Result |
| ----------------- | ------ |
| `(255, 0, 0)`     | `91`   |
| `(0, 255, 0)`     | `92`   |
| `(0, 0, 255)`     | `94`   |
| `(255, 255, 255)` | `97`   |
| `(0, 0, 0)`       | `30`   |

### Caveats

- Return values are foreground ANSI codes. `tint.bg_rgb` converts them into background codes by adding `10`.
- Color reduction is coarse. Distinct RGB inputs can collapse to the same 16-color code.
- Like `to_ansi256`, this function does no explicit validation or clamping.

## When This Module Matters

This module is relevant whenever:

- the terminal does not support true color
- the user asks why a custom RGB/hex value changed appearance
- the question is about 256-color or basic-color downgrade behavior
