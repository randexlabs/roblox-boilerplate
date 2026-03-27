# Embedding: library sandboxing

## When to read this

- You embed Luau and need to understand what standard library pieces are unsafe.

## Common removals / reductions

Many embedders remove or restrict parts of the standard library to prevent file/process access and to preserve isolation. Common patterns include:

- Removing `io.*` and `package.*` entirely.
- Restricting `os.*` to time/date helpers (no environment/process/file access).
- Restricting `debug.*` to safe introspection helpers (often only `traceback`/`info`-like APIs).
- Removing `dofile/loadfile` and removing access to bytecode loading/dumping.

## Notes

- `getfenv/setfenv` can create isolation challenges by enabling global injection into other scripts’ environments.

