# Union and intersection types

## When to read this

- You see `A | B` or `A & B` and need to model what’s allowed.

## Unions (`|`)

- A value is one of the member types.
- You typically need refinements to use a union where a concrete type is expected.

## Tagged unions

Use a discriminant property (often a singleton string) to refine:

```luau
type Ok<T> = { type: "ok", value: T }
type Err<E> = { type: "err", error: E }
type Result<T, E> = Ok<T> | Err<E>
```

## Intersections (`&`)

- Combines requirements (useful for “merged” table shapes).
- Also used to represent overloaded function signatures (builtins).

