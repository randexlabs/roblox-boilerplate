# Conceptual Guides

## Two Layers Of Components

The package operates on two separate component layers:

- your own data components, assigned into `jecs_gizmo.cframe`, `jecs_gizmo.position`, and `jecs_gizmo.direction`
- generated marker components under `jecs_gizmo.gizmo.*`, which say what kind of visualization to draw

An entity becomes drawable only when both sides line up:

- the entity has the required data component(s)
- the entity has the matching marker component

## Initialization Builds The Query Set

`world(world)` does more than store the world reference.

It also:

- creates the marker component ids
- creates cached jecs queries only for the data sources that were configured at initialization time
- stores those queries on the module table

That means the timing matters:

- assign `cframe`, `position`, and `direction` before calling `world(world)`
- if you change those component ids later, the cached queries will still reflect the earlier setup until `world(world)` is called again

## How Each Marker Is Interpreted

### `gizmo.cframe`

Requires the configured `cframe` data component.

Draws:

- a point at the CFrame position
- axis arrows when the resolved style has `advanced = true`

### `gizmo.position`

Works with either:

- the configured `position` data component, or
- the configured `cframe` data component

In both cases it draws only a point.

### `gizmo.direction`

Requires:

- the configured `direction` component
- plus either the configured `position` component or the configured `cframe` component

The arrow origin is `position` or `cframe.Position`, and the endpoint is origin plus the direction vector.

### `gizmo.distance`

Must be attached as a jecs pair whose target is another entity.

The source entity can resolve its origin from either:

- the configured `position` component, or
- the configured `cframe` component

The target entity is resolved through `world:target(entity, gizmo.distance)`, then the target location is read from:

- the configured `cframe` component first when iterating a CFrame-backed source query
- otherwise the configured `position` component

The visual output is:

- a point on the source
- a point on the target
- an arrow from source to target
- a text label above the midpoint showing the distance in studs

### `gizmo.lookvector`

Requires the configured `cframe` data component.

Draws an arrow from `cframe.Position` to `cframe.Position + cframe.LookVector`.

## Style Model

Each marker component can store an optional style override table.

The runtime merges that table over a global default style whose starting values are:

- `alwaysOnTop = true`
- `color = Color3.fromRGB(255, 255, 0)`
- `layer = 1`
- `advanced = true`
- `transparency = 0`
- `scale = 0.1`

The merge happens per draw call, not by mutating the global defaults.

## Frame Timing

`system()` does not mutate ECS state. It only reads cached queries and issues draw calls to the bundled renderer.

As a scheduling rule, run it after the rest of the systems that update transform, position, or direction values. Otherwise the gizmos will display stale values from earlier in the frame.

## Global Module State

The package is a singleton-style module.

It stores:

- the active world reference
- generated marker component ids
- cached queries
- the enabled flag

This means the public API models one configured world per Lua runtime. It is not designed as an instance factory that can keep multiple isolated worlds configured simultaneously.

## Bundled Renderer Behavior

Internally, the package uses a generalized adornment renderer that:

- reuses a tagged `Folder` named `Gizmos` under `Workspace`
- reuses a tagged hidden `Part` as the adornment target
- renders on `RunService.RenderStepped` on the client and `RunService.Heartbeat` on the server
- pools adornment instances between frames

That renderer is not the main package surface, but it explains why visuals are transient and why the package is best treated as a debug overlay rather than persistent scene content.
