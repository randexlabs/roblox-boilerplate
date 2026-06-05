# Runtime Gizmo Components API

## Marker Components

The `gizmo` table contains the visualization markers created by `world(world)`.

Each marker is used by adding the component to an entity or by setting it with a style payload.

## `gizmo.cframe`

### Required data

- `jecs_gizmo.cframe`

### Accepted value

- `nil`
- an optional style override table

### Draw behavior

- draws a point at `cframe.Position`
- when `advanced = true`, also draws axis arrows
- right axis is red
- up axis is green
- look axis is blue

## `gizmo.position`

### Required data

One of:

- `jecs_gizmo.position`
- `jecs_gizmo.cframe`

### Accepted value

- `nil`
- an optional style override table

### Draw behavior

- draws only a point
- when backed by a CFrame, uses `cframe.Position`

## `gizmo.direction`

### Required data

- `jecs_gizmo.direction`
- plus one of:
    - `jecs_gizmo.position`
    - `jecs_gizmo.cframe`

### Accepted value

- `nil`
- an optional style override table

### Draw behavior

- draws an arrow from the resolved origin
- arrow endpoint is origin plus the direction vector

## `gizmo.distance`

### Required data

The source entity needs one of:

- `jecs_gizmo.position`
- `jecs_gizmo.cframe`

The pair target entity also needs one of:

- `jecs_gizmo.position`
- `jecs_gizmo.cframe`

### Attachment shape

Attach it as a pair whose target is the other entity:

```luau
world:add(sourceEntity, jecs.pair(gizmo.distance, targetEntity))
```

### Accepted value

- pair-only marker with no payload via `world:add(...)`
- pair component with an optional style override via `world:set(...)`

### Draw behavior

- draws a point at the source
- draws a point at the target
- draws an arrow from source to target
- draws text above the midpoint using `"%.2f studs"`

### Caveat

The queried style value is currently ignored by the implementation, so all distance visuals render with the default style.

## `gizmo.lookvector`

### Required data

- `jecs_gizmo.cframe`

### Accepted value

- `nil`
- an optional style override table

### Draw behavior

- draws an arrow from `cframe.Position`
- endpoint is `cframe.Position + cframe.LookVector`

## Style Payload Semantics

Using `world:add(entity, gizmo.someMarker)` is equivalent to using the default style.

Using `world:set(entity, gizmo.someMarker, {})` also resolves to the default style.

When a style table is provided, only the specified keys override defaults; unspecified keys fall back to the global renderer defaults.
