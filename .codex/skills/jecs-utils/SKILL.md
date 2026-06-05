---
name: jecs-utils
description: Practical reference for jecs-utils, a Luau helper library for jecs queries, observers, entity refs, inheritance tags, and event collection. Use when Codex needs to answer questions about query helpers, monitor or observer behavior, `ref` identity mapping, `interval` throttling, `is_a` propagation, required `world(world)` setup, or runtime caveats such as singleton module state and observer cleanup mismatches.
---

# jecs-utils

Use this skill for practical questions about `jecs-utils`, especially when a user is building gameplay or tooling on top of `jecs` and needs the actual behavior of the helper layer rather than generic ECS advice.

## Quick Routing

- For what the package is, what it exposes, and where it fits relative to raw `jecs`, read [references/overview.md](references/overview.md).
- For install shape, required setup order, and first-use patterns, read [references/getting-started.md](references/getting-started.md).
- For the runtime model behind query helpers, monitors, refs, and inheritance tags, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For failure modes, cleanup issues, and docs-versus-runtime mismatches, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Top-level package surface, initialization, aliases, and module state: [references/apis/module-surface.md](references/apis/module-surface.md)
- Query helpers for first/count/entities/random/changed/monitor: [references/apis/query-helpers.md](references/apis/query-helpers.md)
- Observer and monitor APIs and their event semantics: [references/apis/observers-and-monitors.md](references/apis/observers-and-monitors.md)
- Utility APIs for `collect`, `interval`, `ref`, and `is_a`: [references/apis/utility-helpers.md](references/apis/utility-helpers.md)

## Working Rules

- Treat the package as a singleton module bound to one active `jecs` world at a time.
- Call `world(world)` before relying on `ref`, `is_a`, `observer`, or `monitor`.
- Be explicit that `world(world)` only rebinds `ref` and `is_a`; the query helpers operate directly on the `Query` you pass.
- Mention that `is_a` and `ref` mutate module-global state and are not isolated per caller.
- Call out observed mismatches when relevant: observer archetype cleanup has a disconnect bug, and the `collect` runtime accepts more event shapes than the TypeScript surface documents.
