# Module State And Setup API

## Default Export Shape

The package exposes named exports and a default export table with matching fields.

The default export contains:

- `transform`
- `relative`
- `pivot`
- `world`
- `system`
- `__alive_tracking__`

`swap_pivot` is exported as a named function in the type surface and should be treated as part of the public API alongside the module table.

## Exported Component And Tag Ids

### `transform: Entity<CFrame>`

Component id used for resolved world-space transforms.

Behavior:

- can be assigned by the caller before initialization
- otherwise is created by `world(world)` via `world:component()`
- is written by `system()` for every propagated node

### `relative: Entity<CFrame>`

Component id used for local offset CFrames from child to parent.

Behavior:

- can be assigned by the caller before initialization
- otherwise is created by `world(world)` via `world:component()`
- if missing on an entity during propagation, the runtime uses `CFrame.identity`

### `pivot: Tag`

Relation id used as the first element of a jecs pair.

Usage shape:

```luau
world:add(child, pair(jecs_assemblies.pivot, parent))
```

Behavior:

- can be assigned by the caller before initialization
- otherwise is created by `world(world)` via `world:entity()`

### `__alive_tracking__: Tag`

Bookkeeping id created during `world(world)`.

Observed role in implementation:

- marks entities that are being tracked by the assembly bookkeeping
- drives cleanup when entities lose that tracking marker

This is publicly visible but operationally internal.

## Initialization

### `world(world: World): void`

Bind the module to a jecs world and install the listeners that maintain internal assembly bookkeeping.

What it does:

- stores the passed world in module-local state
- ensures `transform`, `relative`, and `pivot` ids exist
- creates `__alive_tracking__`
- wires listeners for pivot addition, pivot removal, and alive-tracking removal

Usage rule:

- call before `system()` or `swap_pivot()`

Practical caveat:

- the function mutates global module state rather than returning an isolated instance
- repeated calls are not documented as harmless reinitialization
