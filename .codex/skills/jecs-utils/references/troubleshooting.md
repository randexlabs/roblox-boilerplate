# Troubleshooting

## `ref` Fails Because No World Was Bound

Symptoms:

- `attempt to index nil with 'entity'`
- entity creation through `ref(...)` crashes immediately

Cause:

`ref` creates entities through the module-local world assigned by `world(world)`. If you never called it, the helper has no world to create entities in.

Fix:

- call `utils.world(world)` before using `ref`
- do the same before relying on `utils.is_a` or `utils.IsA`

## `is_a` Creates a New Relation Id Every Time You Rebind

Symptoms:

- old entities tagged with a previous `is_a` id stop participating in new logic
- systems appear to disagree about which inheritance relation is active

Cause:

`world(world)` allocates a fresh relation entity for `is_a.is_a` each time it runs.

Fix:

- initialize once per active world
- avoid rebinding casually
- if you must switch worlds, treat the relation id as world-specific state and rebuild dependent setup

## Observer Disconnect Has an Archetype Cleanup Bug

Observed implementation issue:

- the archetype observer cleanup removes the delete observer by searching the create-observer array instead of the delete-observer array

Practical risk:

- disconnecting an `observer` or `monitor` can leave stale delete-observer registrations behind
- long-lived tooling or hot-reload workflows may accumulate leaked callbacks

Implication:

- be cautious with repeated create/destroy cycles
- if you patch the package locally, this is a good place to inspect first

## `collect` Runtime Accepts More Than the Types Promise

Observed mismatch:

- runtime supports `RBXScriptSignal`
- runtime supports function callbacks returning cleanup handles
- runtime attempts `Connect`, `connect`, and `on`
- runtime type comments mention `subscribe`, but the implementation never actually calls `subscribe`

TypeScript declaration mismatch:

- the declared `EventLike` only documents callback functions plus `Connect` / `connect` / `on`

Implication:

- some valid Lua call shapes are not visible from the roblox-ts declarations
- the apparent `subscribe` support should not be relied on without patching the implementation

## `query_changed` and `query_monitor` Drain Their Queues

Symptoms:

- a second iteration returns nothing
- users think the helper "forgot" prior events

Cause:

Both helpers swap out their internal queues when you call `iter()`, `added()`, or `removed()`.

Fix:

- treat the returned iterators as one-shot drains
- consume them on the frame or tick where you need the accumulated events

## `query_random` Depends On Current Query Cardinality

Symptoms:

- returns `nil` on an empty query
- sampled entity seems to change each call even without explicit shuffling

Cause:

The helper computes a fresh total size and samples by archetype row using `math.random`.

Implication:

- handle the empty-query case explicitly
- seed randomness yourself if deterministic tests matter

## `query_first` Can Return Nothing Despite Its Declaration

Observed mismatch:

- Lua implementation returns `nil` when the query is empty or when the predicate rejects every candidate
- the roblox-ts declaration does not model the `nil` case

Implication:

- Lua callers should guard the result
- TypeScript callers may need local narrowing or patched declarations if they want strict accuracy
