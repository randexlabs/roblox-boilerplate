# Type refinements

## When to read this

- You want to narrow a union/optional/unknown type based on runtime checks.

## Common refinements

- Truthiness: `if x then ...`
- Type guards: `if type(x) == "number" then ...` / `typeof(x)`
- Equality: `if x == "hello" then ...` (singleton types)
- Logical composition with `and/or/not`

`assert(...)` can also refine types.

