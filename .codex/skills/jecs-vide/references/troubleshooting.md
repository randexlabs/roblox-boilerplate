# Troubleshooting

## Hook Returns Never Update

Check these first:

- `jecs_vide.world(world)` was called before the hook became active
- the hook is reading the same `jecs.World` instance that the game logic mutates
- the entity/query argument still resolves through `vide.read(...)` to the value you expect

Because module state is shared globally, binding the wrong world later can silently redirect every hook.

## `useQuery()` Order Seems Random

That is expected from the implementation.

- Initial population follows `query:iter()`.
- Later removals use swap-remove.
- After a removal, another entity can move into the removed slot.

If the UI needs stable order, sort the returned entity list before rendering or derive a separate ordered projection.

## A Query Consumer Did Not Notice Changes

`useQuery` mutates and re-emits the same array object rather than allocating a fresh array every time. Consumers that rely only on table identity will miss updates.

Treat the source emission itself as the update signal, or copy/sort the array into a new structure in the consuming layer.

## `useTarget()` Type Expectations Feel Wrong

The TypeScript declaration is more permissive than the runtime behavior.

- `useTarget<T extends Id = Entity>(...)` is typed as `Source<T>`
- the Luau implementation calls `world:target(...)`
- `world:target(...)` returns a target entity id, not an arbitrary component value

When explaining the API, prefer the runtime interpretation: this hook tracks a relation target entity.

## `useQueryFirst()` Documentation Uses `predicator`

That spelling comes from the package's public TypeScript surface and internal helper call sites. Preserve it when discussing the declared API, even if you would normally expect `predicate`.

## Removing A Tag Or Relation Looks Delayed By One Tick

That is intentional in the implementation.

- `useEntityHas` defers the post-removal recompute.
- `useTarget` defers the post-removal recompute.
- `useQuery` defers its removal bookkeeping too.

If you are stepping through frame timing, account for the fact that the returned source may settle after the removal callback finishes.

## Pair Reads Behave Differently Than Plain Component Reads

`useEntityGet` contains special pair-aware code:

- subscriptions are attached to the pair first-element
- wildcard pair removals scan remaining targets to find the next surviving value

If a pair-based source appears to "fall through" to another value after removal, that is expected behavior rather than a duplicate-event bug.
