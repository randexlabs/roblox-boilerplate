# Type annotations, casts, and aliases

## When to read this

- You want the syntax for `:` annotations, `::` casts, and `type` aliases.

## Variable + function annotations

```luau
local age: number = 25

function greet(name: string): string
	return "Hello, " .. name
end
```

## Type casts (`::`)

Use `::` to override an inferred type (casts are type-checked):

```luau
local myTable = { names = {} :: {string} }
```

For multi-return functions / variadics, a cast preserves only the first return value.

## Type aliases

```luau
type Point = { x: number, y: number }
type Array<T> = { [number]: T }
```

Aliases are file-local unless exported:

```luau
export type Point = { x: number, y: number }
```

