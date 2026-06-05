# Troubleshooting

## `system()` Does Nothing

Check the usual causes:

- `world(world)` was never called
- the root entity in the assembly has no `transform`
- `system()` is running before parent transforms are established
- the child was given a pivot pair but the wrong `transform` component id was configured

## Child Never Moves With Parent

Verify all of these:

- the child has `pair(pivot, parent)` added with the library's configured `pivot` id
- the child `relative` value is written to the same `relative` component id the module uses
- `system()` is actually being called each frame or tick where propagation matters

## Reparenting Snaps Unexpectedly

`swap_pivot()` only preserves world space if both of these already exist:

- `world:get(entity, transform)`
- `world:get(newPivot, transform)`

If either is missing, the function falls back to:

- the explicit `relative` argument, or
- `CFrame.identity`

That can look like a snap because the entity effectively becomes aligned to the new pivot frame.

## Multiple Pivots On One Entity

The implementation explicitly removes existing pivot targets in a loop before adding the new one in `swap_pivot()`.

If you bypass `swap_pivot()` and manually add multiple pivot pairs, behavior depends on how the rest of your code interprets those relationships. The helper assumes there is one effective pivot chain per entity.

## Recalling `world(world)` Repeatedly

The implementation installs `added` and `removed` callbacks every time `world(world)` is called.

Practical caution:

- repeated calls are not presented as an idempotent reinitialize API
- changing worlds in the same runtime can leave the module behaving like a shared singleton with accumulated assumptions

Prefer treating `world(world)` as one-time setup for the active runtime world.

## Internal Export Visibility

`__alive_tracking__` is exposed publicly in the type surface, but it exists for bookkeeping.

Treat it as:

- useful when inspecting the module state
- not a normal gameplay-facing API to build features around unless you intentionally mirror the library internals

## Missing Relative Values

Missing `relative` values do not block propagation.

The runtime uses `CFrame.identity`, so a child with a pivot but no relative component inherits the parent's resolved transform directly.
