# Zone API

## What A Zone Represents

A `Zone` is a single spatial region. It is passive until attached to an observer.

## Constructors

### `QuickZone.Zone.new(config): Zone`

Manual constructor.

Config:

- `cframe: CFrame`
- `size: Vector3`
- `shape?: "Block" | "Ball" | "Cylinder" | "Wedge" | "CornerWedge"`
- `reference?: BasePart | Attachment | Bone`
- `isDynamic?: boolean`
- `metadata?: any`
- `autoSync?: boolean`

### `QuickZone.Zone.fromPart(part, config?): Zone`

Build from a single `BasePart` using its shape, transform, and extents.

### `QuickZone.Zone.fromParts(parts, config?): Zones`

Build a managed `Zones` collection from an array of parts.

### `QuickZone.Zone.fromChildren(parent, config?): Zones`

Track direct child `BasePart`s under a parent, updating as children are added or removed.

### `QuickZone.Zone.fromDescendants(parent, config?): Zones`

Track descendant `BasePart`s under a parent, updating as descendants are added or removed.

### `QuickZone.Zone.fromTag(tag, config?): Zones`

Track tagged parts, and also tagged containers whose descendant parts become zones.

## Attachment To Observers

### `attach(observer): Zone`

### `detach(observer): Zone`

These methods are real runtime methods used by observers and zone collections. They are part of the effective public surface even though they are not centered in `index.d.ts`.

## Sync And Topology Controls

### `setAutoSync(autoSync: boolean): Zone`

Enable or disable automatic syncing to the current reference.

Important behavior:

- enabling auto-sync on a static zone promotes it to dynamic
- base parts watch size changes
- `Part` instances also watch shape changes
- attachments and bones sync transform only

### `setReference(reference?): Zone`

Replace the tracked reference used for syncing.

### `sync(): Zone`

Manually pull transform/size/shape from the current reference.

For base parts:

- syncs `CFrame`
- syncs size via extents
- syncs shape

For attachments and bones:

- syncs `WorldCFrame`

### `setDynamic(isDynamic: boolean): Zone`

Move the zone between static and dynamic trees.

Important cost:

- rebuilding both trees can be triggered

## Geometry Mutators

### `setCFrame(cf: CFrame): Zone`

### `setPosition(pos: Vector3): Zone`

### `setSize(size: Vector3): Zone`

### `setShape(shape: ShapeType): Zone`

All mutate spatial geometry and request rebuild work.

### `setMetadata(metadata): Zone`

Store arbitrary metadata on the zone.

## Accessors

### `getMetadata()`

### `getId(): number`

### `getReference()`

### `getPosition(): Vector3`

### `getCFrame(): CFrame`

### `getSize(): Vector3`

### `getShape(): ShapeType`

### `isDynamic(): boolean`

### `isPointInside(point: Vector3): boolean`

## Lifecycle

### `onDestroy(callback): () -> ()`

Register a callback fired when the zone is destroyed. Returns a disconnect function.

### `destroy(): void`

Remove the zone from runtime state and notify attached observers.

Important behavior:

- auto-sync connections are cleared
- exit callbacks may fire for entities that were still inside
- rebuild flags are set for the appropriate tree

## Caveats

- Docs and typings mention constructor config `observers`, but the runtime constructor and helper constructors do not attach observers from config.
- Invalid shape strings warn and fall back to `Block`.
- `setAutoSync(true)` without a reference only warns and cannot do useful work.
