# Observer API

## Purpose

An `Observer` is the logic bridge between groups and zones.

It supports:

- lifecycle callbacks
- one-shot events
- transition handling
- group-level logic
- polling queries
- tuning for priority, update rate, precision, enabled state, and callback safety

## Constructor

### `QuickZone.Observer.new(config?): Observer`

Config:

- `groups?: Group[]`
- `zones?: (Zone | Zones)[]`
- `priority?: number`
- `updateRate?: number`
- `precision?: number`
- `enabled?: boolean`
- `safety?: boolean`

Defaults:

- `priority = 0`
- `updateRate = 30`
- `precision = 0.1`
- `enabled = true`
- `safety = true`

Construction warning behavior:

- if no zones are attached, QuickZone may warn
- if no groups are subscribed, QuickZone may warn
- explicit empty tables or disabled creation suppress misleading warnings

## Wiring

### `subscribe(group): Observer`

### `unsubscribe(group): Observer`

Manage which groups the observer tracks.

### `attach(zoneOrZones): Observer`

### `detach(zoneOrZones): Observer`

Manage which zones or zone collections the observer watches.

## Lifecycle Observation

### `observe(callback): () -> ()`

### `observePlayer(callback): () -> ()`

### `observeLocalPlayer(callback): () -> ()`

### `observeGroup(callback): () -> ()`

These run logic on enter and accept an optional cleanup function for exit.

Key semantic details:

- `observe`: any entity
- `observePlayer`: only mapped player references
- `observeLocalPlayer`: client-only local-player specialization
- `observeGroup`: enter on first group member, cleanup on last group member leaving

## Event Callbacks

### Generic

- `onEnter(callback)`
- `onExit(callback)`
- `onTransition(callback)`

### Player-specialized

- `onPlayerEnter(callback)`
- `onPlayerExit(callback)`
- `onPlayerTransition(callback)`

### Local-player specialized

- `onLocalPlayerEnter(callback)`
- `onLocalPlayerExit(callback)`
- `onLocalPlayerTransition(callback)`

Client-only.

### Group-specialized

- `onGroupEnter(callback)`
- `onGroupExit(callback)`

Group event semantics:

- `onGroupEnter`: first group member enters observer coverage
- `onGroupExit`: last group member leaves observer coverage

## State Controls

### `setEnabled(enabled: boolean): Observer`

Enable or disable the observer.

Important behavior:

- disabling forces entities out of observer state
- exit callbacks can fire
- logic topology version is bumped

### `setSafety(enabled: boolean): Observer`

Control whether callbacks are wrapped in `task.spawn`.

### `setPriority(p: number): Observer`

Set overlap-resolution priority.

Higher priority observers take control when systems overlap.

### `setUpdateRate(hz: number): Observer`

Set update frequency in Hz.

`hz < 0` is fatal.

### `setPrecision(n: number): Observer`

Set movement threshold in studs.

`n < 0` is fatal.

## Status And Tuning Accessors

### `isEnabled(): boolean`

### `isSafe(): boolean`

### `isPointInside(position: Vector3): boolean`

### `getId(): number`

### `getPriority(): number`

### `getUpdateRate(): number`

### `getPrecision(): number`

## Collection Accessors

### `getEntitiesInside(): any[]`

### `getPlayersInside(): Player[]`

### `getZones(): Zone[]`

### `getGroups(): Group[]`

## Zone Lookup Methods

### Runtime names

- `getZoneOfEntity(entity): Zone?`
- `getZoneOfPlayer(player): Zone?`

### Typing names in `index.d.ts`

- `getEntityInZone(entity): Zone?`
- `getPlayerInZone(player): Zone?`

Treat the runtime names as authoritative.

## Per-zone Queries

### `getEntitiesInZone(zone): any[]`

### `getPlayersInZone(zone): Player[]`

## Iterators

### `iterZones()`

### `iterGroups()`

### `iterEntitiesInside()`

### `iterPlayersInside()`

### `iterEntitiesInZone(zone)`

### `iterPlayersInZone(zone)`

All are designed as zero-allocation iteration helpers.

## Lifecycle

### `onDestroy(callback): () -> ()`

### `destroy(): void`

Destroying an observer:

- disables it
- clears group and zone links
- clears callback registries
- clears tuning state

## Caveats

- `observeLocalPlayer`, `onLocalPlayerEnter`, `onLocalPlayerExit`, and `onLocalPlayerTransition` are client-only.
- With safety off, yielding in callbacks is unsupported and can break the runtime.
- Transition semantics only apply when changing between overlapping zones within the same observer.
