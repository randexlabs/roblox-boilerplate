# Public Types And Config

## ShapeType

```text
"Block" | "Ball" | "Cylinder" | "Wedge" | "CornerWedge"
```

## EntityTable

Duck-typed custom entity support accepts tables with one or more of:

- `Position?: Vector3`
- `WorldPosition?: Vector3`
- `CFrame?: CFrame`
- `Transform?: CFrame`
- `GetPivot?: (self) -> CFrame`

## Entity

Supported entity union:

- `Player`
- `BasePart`
- `Model`
- `Camera`
- `Attachment`
- `Bone`
- `EntityTable`

## Config Defaults

### Group defaults

- `autoClean = true`

### Scheduler defaults

- `enabled = true`
- `frameBudget = 1 / 1000` seconds
- `autoSyncRate = 30` Hz

### Observer defaults

- `updateRate = 30`
- `precision = 0.1`
- `safety = true`

## Internal Strategy Constants

QuickZone internally classifies how to read entity position with strategy constants:

- `POS`
- `PRIM`
- `WORLD`
- `CFRAME`
- `TRANSFORM`
- `PIVOT`

These are implementation-facing, but they explain why different entity kinds are supported.

## Debug Visualization Colors

The runtime config includes debug colors for:

- active static zones
- inactive static zones
- active dynamic zones
- inactive dynamic zones
- transparency

This matters if `visualize(true)` is used and you need to reason about what the colors mean.
