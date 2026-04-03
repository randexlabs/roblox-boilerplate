# Regex API

Import:

```luau
local Regex = require("@lune/regex")
```

## Constructor

- `Regex.new(pattern: string) -> Regex`
  Errors if the pattern is invalid.

## Methods

### `Regex`

- `isMatch(text: string) -> boolean`
- `find(text: string) -> RegexMatch?`
- `captures(text: string) -> RegexCaptures?`
- `split(text: string) -> {string}`
- `replace(haystack: string, replacer: string) -> string`
- `replaceAll(haystack: string, replacer: string) -> string`

### `RegexMatch`

- `start: number`
- `finish: number`
- `text: string`
- `len: number`

### `RegexCaptures`

- `get(index: number) -> string?`
- `#captures -> number`
