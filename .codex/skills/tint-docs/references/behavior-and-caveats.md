# Behavior And Caveats

This file collects cross-cutting behavior that is easy to miss if you only skim the README.

## Styles Return Strings

Tint styles do not print. They return strings containing ANSI escapes when color is enabled.

Use:

```luau
print(tint.red("error"))
```

## Arguments Are Joined With Spaces

Every style call concatenates its arguments with `" "`:

```luau
tint.red("foo", "bar") -- "foo bar" with color
```

This affects composition:

- it is convenient for label/value style output
- it is not suitable when you need exact byte-for-byte concatenation without spaces

If exact joining matters, concatenate manually before styling.

## No Arguments Returns Empty String

Calling any style with no arguments returns `""`.

This is true even for long chains:

```luau
tint.red.blue.black() -- ""
```

## Level `0` Returns Plain Joined Text

When `color_support.level == 0`, Tint does not emit ANSI codes. It just returns the space-joined arguments.

That means style calls still transform argument layout, even with colors disabled.

## Unknown Properties Return `nil`

Invalid property names are not wrapped in a custom error. They simply miss in `ansi` and return `nil`.

What to avoid:

- assuming misspellings fail loudly
- chaining from unvalidated dynamic property names

## Chaining Creates New Style Objects

Tint does not mutate a shared builder in place. Each property access clones the code list and returns a fresh style object.

That is why patterns like this are safe:

```luau
local red = tint.red
local redBold = tint.red.bold
```

## Nesting Uses Escape Reopening, Not Structural Parsing

Tint reopens outer styles by replacing close sequences found inside the text:

1. build the outer `open` and `close` strings
2. for each close code used by the style
3. replace occurrences of that close code in the text with `close + open`

This is a pragmatic strategy that supports nested Tint output well, but it is still string rewriting.

### Consequences

- nested Tint output generally works
- same-type nested colors also work according to tests
- behavior depends on ANSI close sequences already being present in the string
- arbitrary external ANSI sequences may not interact in a fully semantic way

## Newline Handling Is Still A Known Gap

The TODO list explicitly includes:

- line break handling
- reopening colors after `\n`

Interpretation:

- Tint handles close-sequence reopening inside nested ANSI-coded strings
- it does not yet advertise line-aware reopening after newline boundaries as a completed feature

If you need resilient multiline styling semantics, treat this as a current limitation.

## Hex Parsing Is Permissive

`tint.hex` and `tint.bg_hex`:

- remove all `#`
- read the first six hex digits in pairs
- silently use `0` for invalid or missing pairs

What to avoid:

- assuming validation errors for malformed strings
- assuming CSS-style 3-digit shorthand support

Examples of practical outcomes:

- `"#FF0000"` works
- `"FF0000"` works
- `"#f80"` does not expand to `#ff8800`; it parses partial pairs and falls back
- `"oops"` degrades toward zero-filled channels instead of throwing

## RGB Input Is Not Validated

`rgb` and `bg_rgb` do not clamp or validate input ranges.

What this means:

- on true-color terminals, values are interpolated directly into escape strings
- on lower-color terminals, conversion code approximates using the provided numbers

Avoid assuming Tint sanitizes channel values for you.

## Runtime TTY Assumptions Are Optimistic Outside Zune

Only Zune provides explicit TTY detection in Tint's runtime layer.

For Lune, Lute, and fallback mode:

- `is_tty` is assumed to be `true`

So if someone asks why piping behavior differs outside Zune, this is one of the first files to check.
