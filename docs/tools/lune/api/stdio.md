# Stdio API

Import:

```luau
local stdio = require("@lune/stdio")
```

## Functions

- `prompt(kind: "text" | "confirm" | "select" | "multiselect" | nil, message: string, defaultOrOptions: any?) -> any`
- `color(color: string) -> string`
  Returns an ANSI string for persistent output color. Use `"reset"` to reset.
- `style(style: string) -> string`
  Returns an ANSI string for persistent output style. Use `"reset"` to reset.
- `format(...: any) -> string`
  Formats values into a human-readable string.
- `write(s: string) -> ()`
- `ewrite(s: string) -> ()`
- `readLine() -> string`
- `readToEnd() -> string`

## Prompt kinds

- `"text"`: plain text input
- `"confirm"`: yes/no input
- `"select"`: choose one option
- `"multiselect"`: choose multiple options
- `nil`: equivalent to `"text"`
