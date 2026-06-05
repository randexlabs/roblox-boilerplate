---
name: rng
description: Practical reference for rng, a Luau random utility library for numbers, vectors, probabilistic booleans, weighted selection, array helpers, deterministic iteration helpers, and secure or seeded generators. Use when Codex needs to answer questions about rng's public API, helper behavior, seeded versus secure generators, pure Luau or Roblox usage, edge cases, or documentation mismatches.
---

# rng

Use this skill for practical questions about the `rng` library. Favor the runtime implementation and public typings when the README is incomplete or imprecise.

## Quick Routing

- For what `rng` provides, how the module is organized, and which environments it targets, read [references/overview.md](references/overview.md).
- For installation, require paths, and first-use examples, read [references/getting-started.md](references/getting-started.md).
- For behavior models, seeded determinism, probability semantics, and iteration-order helpers, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For sharp edges, undocumented behavior, and README/runtime mismatches, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Root constructors and top-level helpers: [references/apis/constructors-and-root.md](references/apis/constructors-and-root.md)
- Numeric, integer, buffer, and vector helpers: [references/apis/numbers-and-vectors.md](references/apis/numbers-and-vectors.md)
- Weighted choice, shuffle, key/value selection, and iteration helpers: [references/apis/selection-and-tables.md](references/apis/selection-and-tables.md)

## Working Rules

- Treat the module exports and `index.d.ts` as the public surface, then reconcile README gaps against the runtime.
- Call out the difference between `new()` and `new_secure()` whenever predictability or security matters.
- Be explicit about helper assumptions for empty inputs, invalid weights, optional `z` behavior, and stepped ranges.
- Preserve documented examples when they help explain intent, but do not repeat README inaccuracies as facts.
