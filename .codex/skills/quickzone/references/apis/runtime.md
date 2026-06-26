# Root Runtime API

## Purpose

The root `QuickZone` module configures the scheduler, exposes global queries, manages entity/reference mapping, and provides constructors for `Zone`, `Group`, and `Observer`.

## Constructors And Namespaces

### `QuickZone.Zone`

Class-like namespace for zone creation.

### `QuickZone.Group`

Class-like namespace for group creation.

### `QuickZone.Observer`

Class-like namespace for observer creation.

## Global Configuration

### `configure(config): QuickZone`

Apply multiple runtime settings at once.

Accepted keys:

- `enabled?: boolean`
- `autoSyncRate?: number`
- `frameBudget?: number`

### `setEnabled(enabled: boolean): QuickZone`

Enable or disable automatic scheduler updates.

If disabled, the caller must drive updates manually.

### `setAutoSyncRate(hz: number): QuickZone`

Set how often auto-sync zones poll their references.

Caveat:

- exported at runtime
- present in `index.d.ts`
- missing from the `Types.luau` root `QuickZone` type

### `setFrameBudget(ms: number): QuickZone`

Set scheduler frame budget in milliseconds.

Internally this is converted to seconds.

### `update(dt: number): QuickZone`

Run one manual update step.

Use together with `setEnabled(false)` for deterministic manual stepping.

### `rebuild(): QuickZone`

Force pending tree rebuilds immediately.

Use when changes must be reflected right away instead of waiting for the next scheduler step.

## Entity/Reference Mapping

### `setReference(entity: Entity, reference?: any): QuickZone`

Associate a tracked entity with another value to be returned in callbacks and iterators.

Common use:

- track a model, return a player
- track one object, return another reference value

### `removeEntity(entity: any): QuickZone`

Remove an entity from every group and resolve observer exit state safely.

### `getEntityOfReference(reference: any): Entity?`

Resolve a reference back to a physical or duck-typed tracked entity.

### `getReferenceOfEntity(entity: Entity): any`

Return the mapped reference, or the entity itself if no reference mapping exists.

## Introspection Arrays

### `getObservers(): Observer[]`

Return all current observers.

### `getGroups(): Group[]`

Return all current groups.

### `getZones(): Zone[]`

Return all current zones.

### `getEntities(): Entity[]`

Return all tracked entities, after reference mapping where applicable.

## Introspection Iterators

### `iterObservers()`

### `iterGroups()`

### `iterZones()`

### `iterEntities()`

Zero-allocation iterators over the corresponding runtime collections.

## Spatial Queries

### `getZonesAtPoint(position: Vector3): Zone[]`

Return every zone containing a world-space point.

### `iterZonesAtPoint(position: Vector3)`

Zero-allocation iterator version of `getZonesAtPoint`.

### `getZonesOfEntity(entity: any): Zone[]`

Return all zones the entity is actively in across observers.

### `iterZonesOfEntity(entity: any)`

Iterator version of `getZonesOfEntity`.

### `getGroupsOfEntity(entity: any): Group[]`

Return all groups the entity belongs to.

### `iterGroupsOfEntity(entity: any)`

Iterator version of `getGroupsOfEntity`.

## Debugging

### `visualize(enabled: boolean): QuickZone`

Toggle debug rendering of registered zones in the workspace.

Behavior notes:

- static and dynamic zones use different colors
- active and inactive states also use different colors
- uses adornments against `workspace.Terrain`
- loop event is `PreRender` on client and `Heartbeat` on server
