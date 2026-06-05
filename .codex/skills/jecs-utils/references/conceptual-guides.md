# Conceptual Guides

## Query Helpers Are Split Into Snapshot vs Reactive APIs

The package has two different styles of query helper.

Snapshot helpers read current query state immediately:

- `query_first`
- `query_count`
- `query_entities`
- `query_random`

Reactive helpers subscribe to world changes and accumulate or emit later:

- `observer`
- `monitor`
- `query_changed`
- `query_monitor`

This distinction matters because the snapshot helpers are allocation-light and stateless, while the reactive helpers create live observers that must be disconnected.

## `query_changed` vs `query_monitor`

These two are easy to confuse.

`query_changed(query)` tracks entities whose relevant query components changed while they still matched the query. It returns an iterable queue you drain yourself.

`query_monitor(query)` tracks query membership transitions:

- `added()` drains entities that started matching
- `removed()` drains entities that stopped matching

Use `query_changed` for value churn inside the match set, and `query_monitor` for membership churn at the boundary.

## Observer Model

`observer(query, callback)` is lower-level than `query_changed`.

It listens to:

- `world:changed(...)` for terms inside the main query ids
- `world:added(...)` for `with(...)` filters
- `world:removed(...)` for `without(...)` filters

The callback is only fired if the resulting archetype still matches the query.

For pair ids, the implementation special-cases wildcard-second pairs so it can react to any matching target.

## Monitor Model

`monitor(query)` emits transitions rather than raw component events.

Internally it compares source and destination archetypes against a cached set of query-matching archetypes and invokes:

- `added(callback)` when an entity starts matching
- `removed(callback)` when an entity stops matching

This is broader than "component X was added" because the membership decision is query-based, not term-based.

## `ref` Is an Identity Map, Not a World Query

`ref` does not search the ECS world.

It is a module-global Lua table mapping arbitrary keys to entity ids. If the key is missing, `ref(key)` creates a new entity in the bound world and stores it. If the key is falsy, it always creates a fresh entity and does not store it.

That gives `ref` two distinct modes:

- stable lookup mode for truthy keys
- ad hoc entity factory mode for falsy keys

## `is_a` Is Propagation, Not Structural Inheritance

The `is_a` helper sets up listeners so one component can mirror into another component defined as its parent.

When a component is marked with `pair(utils.is_a, ParentComponent)`:

- adding the child component to an entity also adds or sets the parent component
- removing the child component removes the parent component
- changing the child value updates the parent value for non-tag parents

If the parent is a tag, the propagation uses `world:add` rather than `world:set`.

This is useful for category trees or derived tags, but it is runtime propagation logic, not a compile-time type relationship.

## `collect` As Queue Adapter

`collect` turns push-style events into a pull-style iterable queue.

That is useful when you want to batch work inside your own loop instead of running logic directly in an event callback.

The iterator drains in insertion order by repeatedly removing the first buffered payload.

## Singleton State Implications

The package keeps shared mutable state in module scope:

- bound world for `ref` and `is_a`
- generated `is_a` relation id
- stored refs table

Rebinding with another world does not create a second isolated instance. It overwrites the active state used by future `ref` and `is_a` calls.
