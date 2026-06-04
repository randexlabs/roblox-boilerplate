# Troubleshooting

## Docs, Types, And Runtime Do Not Fully Match

Several public-facing surfaces drift from each other.

Important mismatches:

- `Observer` method names in `index.d.ts` use `getEntityInZone` and `getPlayerInZone`, but the runtime methods are actually `getZoneOfEntity` and `getZoneOfPlayer`.
- `Zone` docs and TypeScript declarations mention `observers` in constructor/helper configs, but the runtime implementation does not consume that field when creating zones.
- `Types.luau` omits `setAutoSyncRate` from the root `QuickZone` type even though the runtime exports the method.
- Runtime docs/examples describe constructor invocation as `QuickZone.Zone(...)`, while the actual exported class shape is `QuickZone.Zone.new(...)` plus helper constructors.

When answering questions, prefer the runtime implementation and call out the mismatch explicitly.

## Client-only APIs

These are client-only:

- `Group.localPlayer()`
- `Observer:observeLocalPlayer(...)`
- `Observer:onLocalPlayerEnter(...)`
- `Observer:onLocalPlayerExit(...)`
- `Observer:onLocalPlayerTransition(...)`

Attempting to use them on the server throws a fatal error.

## Managed Groups Are Not Manually Editable

Managed groups created by:

- `Group.fromTag(...)`
- `Group.players()`
- `Group.localPlayer()`

reject manual `add`, `addBulk`, `remove`, `removeBulk`, `clear`, and `setAutoClean` changes. The runtime only warns and ignores the request.

## Invalid Entities

If a custom entity does not expose an accepted spatial field or method, QuickZone logs a non-fatal invalid entity warning and refuses to track it.

Accepted duck-typing fields:

- `Position`
- `WorldPosition`
- `CFrame`
- `Transform`
- `GetPivot`

## AutoSync Without Reference

Calling `zone:setAutoSync(true)` without a reference does not crash immediately, but the runtime warns and cannot sync the zone.

## Observer Creation Warnings

Observers created without attached zones or subscribed groups may warn after construction.

Ways to avoid misleading warnings:

- pass explicit empty tables if building incrementally
- create the observer disabled and enable later
- attach and subscribe immediately

## Safety Off Means No Yielding

If observer safety is disabled, do not yield in callbacks. The docs state that yielding in unsafe mode breaks QuickZone.

## Destroy Semantics

Destroying groups, zones, zone collections, or observers can trigger exit-style cleanup logic and observer callbacks as state is torn down.

Do not assume destruction is silent.
