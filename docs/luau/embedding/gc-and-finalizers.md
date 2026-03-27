# Embedding: GC and finalizers (`__gc`)

## When to read this

- You’re looking for `__gc` finalizers (Lua-style) and can’t find them.

## Key points

- `__gc` finalizers can be problematic for performance, memory safety, and isolation in sandboxed embedders.
- A common alternative is host-only destructor hooks (tag-based destructors) that run right before userdata memory is freed.

## Practical implication

- Prefer explicit resource management in host APIs instead of relying on script-level finalizers.

