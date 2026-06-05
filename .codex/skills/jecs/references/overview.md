# Overview

`jecs` is a typed Luau Entity Component System built around archetype storage and column-major access. It is designed for very fast bulk iteration, first-class entity relationships, and direct control over low-level ECS behavior when needed.

## What It Models

- Entities are opaque numeric handles with an embedded generation counter.
- Components are also entities. A component is just an entity marked with the built-in `jecs.Component` trait.
- Tags are IDs without component storage. They mark presence only and carry no value.
- Relationships are pairs of IDs encoded into a single numeric ID. This lets relationship pairs live in the same storage model as regular components.
- Worlds own the entity index, archetypes, component metadata, query machinery, hooks, and event subscriptions.

## Main Strengths

- Relationship pairs are first-class, including wildcard queries and direct target lookup.
- Queries work on archetypes, so iteration stays efficient for dense workloads.
- The API is type-oriented. `world:component()` and `jecs.component()` let Luau track component value types.
- The runtime also exposes advanced helpers for archetypes, records, and entity-index inspection when the user needs to build tooling or squeeze performance.

## Everyday API vs Advanced API

Everyday API:

- `jecs.world()` / `jecs.World.new()`
- `world:entity()`, `world:component()`
- `world:add`, `world:set`, `world:get`, `world:remove`, `world:delete`
- `world:query`, `query:with`, `query:without`, `query:cached`
- `world:target`, `world:targets`, `world:parent`, `world:children`
- `world:added`, `world:changed`, `world:removed`
- `jecs.pair`, `jecs.Wildcard`, `jecs.ChildOf`, cleanup and hook traits

Advanced API:

- `jecs.record`, `jecs.component_record`
- `jecs.bulk_insert`, `jecs.bulk_remove`
- `jecs.entity_index_*` helpers
- `jecs.archetype_*` helpers
- `jecs.query_*` helpers
- `jecs.ECS_*` constants and pair decomposition helpers

The advanced exports are useful, but they expose storage assumptions more directly. Use them for tooling, diagnostics, archetype-specialized systems, or custom high-performance paths, not as the first choice for normal gameplay code.

## Built-In Concepts To Know Early

- Components live in the low ID range. `world:component()` allocates from the reserved component region.
- Tags should be added with `world:add`, not `world:set`.
- `world:get` returns `nil` when the entity does not currently have that component.
- Queries iterate backwards through entity arrays. This is friendly to deletion during iteration.
- Wildcard relationship queries can match one relationship slot at a time, but they do not enumerate every matching target unless you explicitly walk targets yourself.

## Bundled Helper Modules

The repository also includes practical helper modules built around `jecs`, especially:

- event collection utilities
- deserialization helpers for networked entity IDs and pairs
- entity inspection and lifetime visualization helpers
- runtime lint wrappers

These helpers are not the ECS core, but they are useful examples of how the low-level exports are intended to be used.
