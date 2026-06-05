# Module State And Setup API

## Default Export Shape

The Luau module returns a mutable table whose main supported fields are:

- `cframe`
- `position`
- `direction`
- `enabled`
- `gizmo`
- `world`
- `system`

The TypeScript surface exports:

- `gizmo`
- `world(world: World): void`
- `system(): void`
- a default export with the same core fields

## Caller-Assigned Data Component Fields

These fields are intended to be assigned by the caller before initialization.

### `cframe: Entity<CFrame>?`

Maps the package to the ECS component that stores world-space `CFrame` data.

If unset before `world(world)`, no CFrame-based queries are created.

### `position: Entity<Vector3>?`

Maps the package to the ECS component that stores `Vector3` positions.

If unset before `world(world)`, no position-based queries are created.

### `direction: Entity<Vector3>?`

Maps the package to the ECS component that stores direction vectors.

If unset before `world(world)`, no direction-based queries are created.

Direction drawing also depends on either `position` or `cframe` being configured.

## Runtime Toggle

### `enabled: boolean`

When `false`, `system()` returns immediately and does not perform query iteration or draw calls.

This flag can be changed at any time.

## Generated Marker Table

### `gizmo: { cframe, position, direction, distance, lookvector }`

Created inside `world(world)`.

Each field is a fresh jecs component id allocated from the bound world:

- `gizmo.cframe`
- `gizmo.position`
- `gizmo.direction`
- `gizmo.distance`
- `gizmo.lookvector`

These components are not your data sources. They are marker components that request a specific visualization mode.

## Initialization

### `world(world: World): void`

Bind the module to a jecs world and create the internal marker/query state.

What it does:

- stores the world reference in module-local state
- allocates the `gizmo.*` marker component ids
- clears and rebuilds `gizmo.queries`
- creates cached queries only for the caller-assigned data component ids that currently exist

Important implications:

- initialize after assigning component ids
- re-run if the component mapping changes
- treat the module as globally rebound after each call

## Style Shape

The public style override shape is:

```luau
type Style = {
	alwaysOnTop: boolean?,
	color: Color3?,
	layer: number?,
	advanced: boolean?,
	transparency: number?,
	scale: number?,
}
```

Resolved defaults are:

| Field          | Default                       |
| -------------- | ----------------------------- |
| `alwaysOnTop`  | `true`                        |
| `color`        | `Color3.fromRGB(255, 255, 0)` |
| `layer`        | `1`                           |
| `advanced`     | `true`                        |
| `transparency` | `0`                           |
| `scale`        | `0.1`                         |

## Observed Extra Fields

The Lua module also exposes extra fields that are not represented in the type declarations:

### `default`

Points back to the same module table.

This appears to exist for interop convenience rather than as a distinct instance object.

### `queries`

Populated by `world(world)` with cached query handles such as:

- `cframe`
- `position_cframe`
- `distance_cframe`
- `lookvector_cframe`
- `position`
- `distance`
- `direction`
- `direction_cframe`

These are observable from Lua but should be treated as internal state, not stable API.
