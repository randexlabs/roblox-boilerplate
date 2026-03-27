# Compatibility: Lua version feature status (summary)

## When to read this

- You’re looking for a Lua 5.2+ feature (e.g. `goto`, yieldable metamethods) and need to know if Luau supports it.

## How to use this summary

The upstream compatibility matrix is long. For local use, prefer:

- Identify the feature category (syntax, library, VM/GC behavior).
- Check whether the feature impacts sandboxing or performance (these are common reasons for exclusion).

## Practical note

If you’re porting Lua code, test the specific feature in your target embedder: some features vary by environment and configuration.

