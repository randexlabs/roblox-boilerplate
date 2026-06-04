# Zones Collection API

## Purpose

`Zones` is a collection wrapper over multiple `Zone` instances. It lets one logical unit represent many underlying zones.

Use it for:

- bulk zone creation
- tag-driven zone sets
- shared hazard or effect maps
- attaching one observer to many zones at once

## Construction

Runtime constructor:

### `Zones.new(config?): Zones`

Config:

- `isDynamic?: boolean`
- `autoSync?: boolean`
- `metadata?: any`

Most users obtain `Zones` through `Zone.fromParts`, `Zone.fromChildren`, `Zone.fromDescendants`, or `Zone.fromTag`.

## Observer Wiring

### `attach(observer): Zones`

### `detach(observer): Zones`

Attach or detach one observer from every contained zone.

Important behavior:

- future added zones are also attached to existing observers
- removing a zone detaches it from collection observers

## Bulk Controls

### `sync(): Zones`

Sync every contained zone when the collection is dynamic.

### `setAutoSync(autoSync: boolean): Zones`

Apply auto-sync to every contained zone.

### `setDynamic(isDynamic: boolean): Zones`

Promote or demote every contained zone.

### `setMetadata(metadata): Zones`

Apply metadata to the collection and propagate it to zones.

## Queries And Accessors

### `getZones(): Zone[]`

### `isDynamic(): boolean`

### `isPointInside(point: Vector3): boolean`

### `getMetadata()`

### `contains(zone: Zone): boolean`

### `getReferences(): (BasePart | Attachment | Bone)[]`

## Iterators

### `iterZones()`

### `iterReferences()`

Both are zero-allocation iterator style APIs.

`iterReferences()` yields:

- the reference
- the owning `Zone`

## Lifecycle

### `onDestroy(callback): () -> ()`

### `destroy(): void`

Destroying a `Zones` collection:

- disconnects observer cleanup hooks
- destroys contained zones
- clears collection state

## Practical Notes

- Metadata on the collection is copied into zones when they are added if the zone has no metadata yet.
- `setDynamic` and `setAutoSync` behave as fan-out controls, not as separate collection-only state.
