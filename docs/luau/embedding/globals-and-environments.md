# Embedding: globals and environments

## When to read this

- You want “safe globals”: prevent monkey-patching while still allowing per-script globals.

## Typical pattern

- The builtin global table and library tables are marked readonly (host-only capability).
- Each script gets its own global table that uses `__index` to reference the builtin globals.

Result:

- Scripts can assign globals (to their own environment).
- Scripts can’t mutate builtin globals/libraries in-place.

