# Compound assignments

## When to read this

- You see `+=`, `-=`, `..=`, etc. and want the exact behavior.

## Supported operators

Luau supports compound assignment statements:

`+=`, `-=`, `*=`, `/=`, `//=`, `%=`, `^=`, `..=`

## Semantics

- Compound assignments are statements (not expressions).
- The left-hand side is evaluated once (important for indexed assignments).

Example:

```luau
local a = { 1, 2, 3 }
function foo() return 2 end

-- evaluates foo() once
a[foo()] += 1
```

