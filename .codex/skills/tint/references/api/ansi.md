# ANSI Code Map

This file documents the exact ANSI open/close pairs defined in `lib/ansi.luau`.

These mappings are important because Tint's chainable API is built entirely on top of them.

## Modifiers

| Name            | Open | Close |
| --------------- | ---- | ----- |
| `reset`         | `0`  | `0`   |
| `bold`          | `1`  | `22`  |
| `dim`           | `2`  | `22`  |
| `italic`        | `3`  | `23`  |
| `underline`     | `4`  | `24`  |
| `overline`      | `53` | `55`  |
| `inverse`       | `7`  | `27`  |
| `hidden`        | `8`  | `28`  |
| `strikethrough` | `9`  | `29`  |

## Foreground Colors

| Name      | Open | Close |
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

## Bright Foreground Colors

| Name             | Open | Close |
| ---------------- | ---- | ----- |
| `bright_black`   | `90` | `39`  |
| `bright_red`     | `91` | `39`  |
| `bright_green`   | `92` | `39`  |
| `bright_yellow`  | `93` | `39`  |
| `bright_blue`    | `94` | `39`  |
| `bright_magenta` | `95` | `39`  |
| `bright_cyan`    | `96` | `39`  |
| `bright_white`   | `97` | `39`  |

## Background Colors

| Name         | Open | Close |
| ------------ | ---- | ----- |
| `bg_black`   | `40` | `49`  |
| `bg_red`     | `41` | `49`  |
| `bg_green`   | `42` | `49`  |
| `bg_yellow`  | `43` | `49`  |
| `bg_blue`    | `44` | `49`  |
| `bg_magenta` | `45` | `49`  |
| `bg_cyan`    | `46` | `49`  |
| `bg_white`   | `47` | `49`  |

## Bright Background Colors

| Name                | Open  | Close |
| ------------------- | ----- | ----- |
| `bg_bright_black`   | `100` | `49`  |
| `bg_bright_red`     | `101` | `49`  |
| `bg_bright_green`   | `102` | `49`  |
| `bg_bright_yellow`  | `103` | `49`  |
| `bg_bright_blue`    | `104` | `49`  |
| `bg_bright_magenta` | `105` | `49`  |
| `bg_bright_cyan`    | `106` | `49`  |
| `bg_bright_white`   | `107` | `49`  |

## Practical Notes

- `gray` and `bright_black` are aliases at the ANSI level.
- `bold` and `dim` share the same close code `22`.
- Foreground closes use `39`.
- Background closes use `49`.
- Tint builds nested output by concatenating open codes in chain order and close codes in reverse order.
