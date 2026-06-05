# Troubleshooting

## `world:set` fails or behaves wrong on a tag

Cause:

- the ID is a tag and does not store data

Use instead:

- `world:add(entity, Tag)` to add presence
- `world:has(entity, Tag)` to test presence

Related caveat:

- `world:get(entity, Tag)` is conceptually wrong. If the ID is a tag, use `has`, not `get`.

## Forward-declared components or tags are "invalid"

Cause:

- `jecs.component()`, `jecs.tag()`, or `jecs.meta(...)` ran after the world was already created

Fix:

- declare preregistered IDs and metadata before `jecs.world()`

This matters especially if the code depends on stable IDs or on metadata such as `jecs.Name`.

## Hook never fires

Common causes:

- the hook was configured after the component had already been used in the places you expected to observe
- the user expected `OnAdd` to fire on every reassignment, but `OnChange` handles updates
- the callback was attached to the wrong ID or wrong side of a pair

Practical rule:

- define hooks before the component starts participating in world mutations when deterministic lifecycle coverage matters

## `OnRemove` logic causes weird deletion-time behavior

Cause:

- the hook tries to make structural changes during full entity deletion without respecting the `delete` flag

Fix:

- branch on the third `delete` parameter and bail out for full deletion unless the logic is explicitly safe in that path

The guides are clear that normal component-removal cleanup and whole-entity teardown are different cases.

## Wildcard query returns less than expected

Cause:

- a wildcard query proves that an entity has a matching relation, but the simple query result is not a full enumeration of every target for that entity

Fix:

- call `world:target(entity, relation, index)` repeatedly
- or use `world:targets(entity, relation)` if the code wants an iterator of targets
- or inspect archetype columns directly in a performance-specialized path

## Cached query keeps memory or observers alive

Cause:

- `query:cached()` was used without later calling `fini()`

Fix:

- call `cachedQuery:fini()` when the cache is no longer needed

This is the main lifecycle caveat specific to cached queries.

## Deleting while iterating causes skipped items

Practical advice:

- prefer the normal query iteration order or explicit backward array loops
- when working on raw archetype arrays, iterate backwards if deletion may happen

The examples call this out directly for archetype-specialized loops.

## Component limit confusion

Important detail:

- the low reserved component range is limited; the source comments describe normal component allocation as occupying the low component-ID region

Workarounds:

- use `world:entity()` plus `world:add(id, jecs.Component)` when the user intentionally needs additional component-like IDs
- or patch the library if the project truly requires a higher reserved component budget

## Need better errors for invalid handles or invalid pair members

Use:

```luau
local world = jecs.world(true)
```

Debug mode adds stronger assertions for:

- stale entity generations
- invalid component IDs
- wildcard-pair misuse in places where it is forbidden
- structural mutation attempts during unsafe deletion paths

## Docs vs runtime notes worth remembering

- `world:get` supports up to four components in its typed overloads; broader helper code should not assume arbitrary-width typed returns.
- The source exports many internal helpers that are not part of the simple tutorial path. They are real exports, but they should be treated as advanced and storage-aware.
- Some conceptual guides describe query reset/drain behavior informally, but in practice the important public distinction is between normal queries, `:iter()`, `:cached()`, and direct archetype iteration.
