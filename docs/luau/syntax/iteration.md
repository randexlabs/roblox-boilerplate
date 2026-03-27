# Generalized iteration

## When to read this

- You see `for k, v in someTable do` without `pairs/ipairs`.
- You want to implement custom iteration for userdata/tables.

## Key points

- In Luau, you can iterate a table directly:

```luau
for k, v in {1, 4, 9} do
	assert(k * k == v)
end
```

- You can customize iteration with `__iter` (metamethod returns an iterator function like `next`):

```luau
local obj = { items = {1, 4, 9} }
setmetatable(obj, { __iter = function(o) return next, o.items end })
```

