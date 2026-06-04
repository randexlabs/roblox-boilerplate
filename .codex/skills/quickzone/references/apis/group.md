# Group API

## Purpose

A `Group` is a tracked collection of entities.

Every entity must be in at least one group to participate in observer logic.

## Constructors

### `QuickZone.Group.new(config?): Group`

Config:

- `entities?: any[]`
- `autoClean?: boolean`

### `QuickZone.Group.fromTag(tag: string): Group`

Create a managed group that tracks tagged instances only while they are descendants of `workspace`.

Supported tagged instance kinds:

- `BasePart`
- `Model`
- `Attachment`
- `Bone`
- `Camera`

### `QuickZone.Group.players(): Group`

Managed group for all players.

Behavior:

- tracks players automatically
- relies on internal player tracking for character lifecycle

### `QuickZone.Group.localPlayer(): Group`

Managed group for the local player only.

Client-only.

## Management

### `setAutoClean(enabled: boolean): Group`

Auto-remove instance entities when destroyed or parented to `nil`.

Caveat:

- managed groups ignore this request and warn instead

### `add(entity): Group`

### `addBulk(entities): Group`

### `remove(entity): Group`

### `removeBulk(entities): Group`

### `clear(): Group`

These are for custom groups.

Caveat:

- managed groups ignore manual edits and warn instead

## Entity Support

Accepted entity forms:

- `Player`
- `BasePart`
- `Model`
- `Attachment`
- `Bone`
- `Camera`
- custom table with supported spatial fields

For custom tables QuickZone looks for, in order:

- `Position`
- `CFrame`
- `Transform`
- `WorldPosition`
- `GetPivot`

## Accessors And Queries

### `contains(entity): boolean`

### `getId(): number`

### `getEntities(): any[]`

`getEntities()` returns mapped references when reference mappings exist.

## Iterator

### `iterEntities()`

Zero-allocation iterator over the group's entities.

## Lifecycle

### `onDestroy(callback): () -> ()`

### `destroy(): void`

Destroying a group:

- removes its entities
- detaches observer relationships indirectly via runtime state cleanup
- fires on-destroy callbacks asynchronously

## Caveats

- Invalid entities log a non-fatal warning and are not tracked.
- `Player` handling is special-cased and delegated to the internal player tracker.
