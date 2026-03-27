# If-then-else expressions

## When to read this

- You want an expression form (ternary-like) instead of `if ... end` statements.

## Shape

Luau supports:

```luau
local x = if cond then a else b
```

Rules:

- `else` is mandatory.
- `elseif` chains are allowed.

Example:

```luau
local sign = if x < 0 then -1 elseif x > 0 then 1 else 0
```

