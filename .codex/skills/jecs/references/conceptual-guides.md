# Conceptual Guides

## Components Are Entities

`jecs` does not treat components as a separate nominal kind. A component is an entity with the built-in `jecs.Component` trait. This has several consequences:

- components can have metadata such as `jecs.Name`
- components can have hooks attached to them
- components can participate in queries
- relationships can target component entities too

The model is uniform, but it also means users must distinguish carefully between data-bearing component IDs and plain tag-like IDs.

## Entity Handles And Liveliness

Entity handles embed both the entity index and generation. When an index is recycled, the generation changes, so stale handles can be detected.

This leads to two different checks:

- `world:exists(entity)` answers whether the sparse slot has ever been allocated and still has a record
- `world:contains(entity)` answers whether the specific handle is currently alive

When debugging stale references, `contains` is the stricter and usually more relevant check.

## Archetypes And Why Queries Are Fast

Entities with the exact same component set live in the same archetype. Each archetype stores:

- a list of entities
- a parallel column per component
- a component-to-column map

A query usually matches whole archetypes instead of checking every entity one by one. This is why normal `world:query(...)` can already be fast.

## Query Filters

Base query terms specify the values you want returned. Filters add presence constraints without adding returned values:

- `query:with(...)` means the entity must also contain those IDs
- `query:without(...)` means the entity must not contain those IDs

This is especially useful when tags or relationship presence affect behavior but their values are irrelevant.

## Cached Queries

Cached queries trade setup and observer bookkeeping for cheaper repeated iteration. They:

- compute the compatible archetype set once
- attach observers so the cache updates as matching archetypes are created or deleted
- support `cachedQuery:has(entity)` without re-evaluating the whole query

Important operational rule:

- Call `cachedQuery:fini()` when the cached query is no longer needed. Otherwise the archetype observers remain attached.

## Archetype-Level Iteration

For very hot paths, you can ask a query for matching archetypes and then read columns directly:

```luau
for _, archetype in world:query(Position, Velocity):archetypes() do
	local entities = archetype.entities
	local columns = archetype.columns_map
	local positions = columns[Position]
	local velocities = columns[Velocity]

	for row, entity in entities do
		local pos = positions[row]
		local vel = velocities[row]
	end
end
```

This removes query iterator call overhead and enables archetype-specific optimizations, but it couples the system more tightly to storage details.

## Relationships, Targets, And Wildcards

Pairs model relationships as `(relation, target)` encoded into one ID. Common patterns:

- `pair(ChildOf, parent)` for hierarchy
- `pair(Likes, alice)` for graph edges
- `pair(Eats, Apples)` with stored payload data

Wildcard queries are powerful:

- `pair(Relation, jecs.Wildcard)` means any target for one relation
- `pair(jecs.Wildcard, Target)` means any relation for one target

When using wildcard targets, `world:target(entity, relation, index)` is the normal way to recover the concrete target.

One caveat from the guides:

- the wildcard match is not defined as "all matching pairs returned independently" for a single entity through the normal query values; if you need every target, walk them explicitly with `world:target(..., index)` or `world:targets(...)`

## Cleanup Traits

Cleanup traits define what happens when referenced IDs disappear, so the ECS never leaves dangling references behind.

Conditions:

- `jecs.OnDelete`
- `jecs.OnDeleteTarget`

Actions:

- `jecs.Remove`
- `jecs.Delete`

Examples:

- `(OnDelete, Remove)` removes that ID from all referencing entities
- `(OnDelete, Delete)` cascades deletion to entities that hold that ID
- `(OnDeleteTarget, Delete)` is useful for relationship-driven graph cleanup

Default behavior is effectively cleanup-by-removal, not dangling references.

## Hooks Versus Signals

Hooks:

- stored on the component entity through `jecs.OnAdd`, `jecs.OnChange`, `jecs.OnRemove`
- only one hook of each kind per component
- good for invariants and tightly-owned side effects

Signals:

- `world:added`, `world:changed`, `world:removed`
- allow multiple listeners
- return disconnect functions
- good for dynamic subscriptions and fan-out

The implementation preserves existing hooks by folding them into the listener dispatch path, so signal subscription can coexist with hook-driven behavior.

## Fragmentation

Because `jecs` is archetype-based, each unique component combination creates a new archetype. Relationship-heavy designs can explode the number of combinations.

Practical implications:

- more archetypes means more query matching work
- relationship pairs create extra wildcard index registrations
- excessive semantic splitting into tags/pairs can raise churn without adding real value

The library is optimized for high archetype counts, but fragmentation is still a real design cost.
