# String interpolation (backtick strings)

## When to read this

- You see backtick strings like `` `Hello {name}` ``.

## Key points

- Use backticks to embed expressions inside `{ ... }`.
- Inside a backtick string, `\` escapes `` ` ``, `{`, `\`, and a newline.

Examples:

```luau
local count = 3
print(`Bob has {count} apple(s)!`)

local combos = {2, 7, 1, 8, 5}
print(`The lock combination is {table.concat(combos)}.`)
```

