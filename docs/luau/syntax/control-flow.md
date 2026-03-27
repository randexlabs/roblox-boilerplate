# `continue` in loops

## When to read this

- You want a loop early-continue, like in many C-like languages.

## Key points

- Luau supports `continue` in loops.
- `continue` is *not* a keyword for compatibility reasons: `continue` is a statement, but `continue()` is a function call.

Example:

```luau
if x < 0 then
	continue
end
```

## `repeat ... until` caveat

In `repeat ... until`, `continue` can’t skip a local declaration if that local is used in the loop condition.

