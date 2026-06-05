# Overview

`jecs-vide` is a thin integration layer between `jecs`, `jecs-utils`, and `Vide`. Its job is to expose reactive `Vide` sources that stay in sync with ECS entities, components, and queries.

## What The Package Exposes

The public surface is small:

- `world(world)`: binds the package to the active `jecs.World`
- `useEntityGet` / `use_entity_get`: reactive component read for one entity
- `useEntityHas` / `use_entity_has`: reactive tag-presence check for one entity
- `useQueryFirst` / `use_query_first`: reactive first-match lookup for a query
- `useQuery` / `use_query`: reactive entity list for a query
- `useTarget` / `use_target`: reactive relation-target lookup for one entity

Each camelCase function also has a snake_case alias. The default export table exposes the same functions.

## How It Fits With The Dependencies

- `jecs` provides the world, entities, components, pairs, and event callbacks.
- `jecs-utils` provides the query monitor used by `useQuery` and `useQueryFirst`.
- `Vide` provides `source`, `effect`, `read`, and `cleanup`, which power the reactive behavior.

`jecs-vide` does not create a world, scheduler, or frame loop. It only subscribes to world/query events and reflects the results into `Vide` sources.

## Core Design Model

The package is singleton-style module state, not an instantiable object model.

- Every hook module stores a mutable `world` field.
- `world(world)` rewires that field for all hook modules.
- `world(world)` also forwards the same world into `jecs-utils.world(world)` when `jecs-utils` is bound to a different world.

This means one loaded copy of the package expects one active world at a time.

## Input And Output Conventions

Most hook parameters use the `Derivable<T>` pattern:

```luau
type Derivable<T> = (() -> T) | T
```

That means callers can pass either:

- a plain entity/query/relation value
- a `Vide` getter function or any other callable derivable that `vide.read` can resolve

All hooks return `Vide` sources, so the result is a callable state container rather than a plain value.

## When To Reach For Each Hook

| Hook            | Purpose                                     | Typical use                                                             |
| --------------- | ------------------------------------------- | ----------------------------------------------------------------------- |
| `useEntityGet`  | Track one component value on one entity     | Bind UI to health, name, selected state, relation pair value            |
| `useEntityHas`  | Track whether an entity has a tag/component | Show enabled/disabled or presence/absence state                         |
| `useQueryFirst` | Track the first entity matching a query     | Follow currently selected entity, first visible target, first candidate |
| `useQuery`      | Track all entities matching a query         | Render a list of ECS-backed UI rows or markers                          |
| `useTarget`     | Track the target entity of a relation       | Follow parent, owner, equipped item, or linked entity                   |

## Important Observed Constraints

- `world(world)` is effectively required before any entity-oriented hook can function.
- `useQuery` keeps one mutable array and updates it in place.
- `useQuery` removal uses swap-remove semantics, so query order is not stable.
- `useTarget` and `useEntityHas` intentionally defer removal-driven updates with `task.defer`.
- `useEntityGet` has special handling for wildcard pair removals to recompute the next available matching pair value.
