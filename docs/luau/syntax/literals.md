# Literal extensions (strings + numbers)

## When to read this

- You see Luau code using `\x..`, `\u{...}`, `\z`, `0b...`, or `_` separators.

## String literals

Luau adds Lua 5.3-style escapes for string literals:

- `\xAB`: byte with code `0xAB`
- `\u{ABC}`: UTF-8 encoding of Unicode code point `U+0ABC`
- `\z` at end-of-line: consumes following whitespace (including newlines)

## Number literals

Luau supports:

- Hex integer literals: `0xABC` / `0XABC`
- Binary integer literals: `0b0101` / `0B0101`
- `_` separators for readability: `1_048_576`, `0xFFFF_FFFF`, `0b_0101_0101`

Notes:

- Luau has a single number type: IEEE754 double precision. Integers > `2^53` lose precision.

