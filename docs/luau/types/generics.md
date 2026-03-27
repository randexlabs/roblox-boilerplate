# Generics and polymorphism

## When to read this

- You want reusable types/functions that preserve element types (e.g. `reverse<T>`).

## Generic type aliases

```luau
type Pair<T> = { first: T, second: T }
type PairWithDefault<T = string> = Pair<T>
```

## Generic functions

Generic functions can take type parameters:

```luau
function reverse<T>(a: {T}): {T}
	local result: {T} = {}
	for i = #a, 1, -1 do
		table.insert(result, a[i])
	end
	return result
end
```

Note: function generics don’t support defaults.

