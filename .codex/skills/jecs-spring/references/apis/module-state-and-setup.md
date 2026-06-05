# Module State And Setup API

## Default Export Shape

The Luau module returns a mutable table whose main public fields are:

- `options`
- `goal`
- `completed`
- `motion`
- `world`
- `system`

The TypeScript declarations export the same fields individually and as part of the default export.

## Generated Ids

These ids are created inside `world(world)` and are invalid to use before initialization.

### `options: Entity<SpringOptions>`

Component id used as the first element in:

```luau
pair(jecs_spring.options, animatedComponent)
```

The pair value is a Ripple `SpringOptions` table.

### `goal: Tag`

Entity/tag id used as the first element in:

```luau
pair(jecs_spring.goal, animatedComponent)
```

The pair value is the desired Ripple `Animatable` goal.

### `completed: Tag`

Entity/tag id used as the first element in:

```luau
pair(jecs_spring.completed, animatedComponent)
```

This marks completion of the current goal, but the marker can appear on both gameplay entities and internal controller entities.

### `motion: Entity<Spring>`

Component id used as the first element in:

```luau
pair(jecs_spring.motion, animatedComponent)
```

The pair value is the live Ripple `Spring` instance.

## Initialization

### `world(world: World): void`

Binds the module to one jecs world and allocates all generated ids.

Observed behavior:

- stores the world in module-local state
- creates fresh ids for `options`, `goal`, `completed`, and `motion`
- creates internal ids for controller bookkeeping
- builds and caches the active-springs query
- registers handlers for options add/change/remove and goal add/change/remove

Important implications:

- call it before any other use
- treat re-calling it as a global rebind, not an incremental update
- do not expect generated ids from a previous bind to remain authoritative

## Runtime Step

### `system(delta: number): void`

Steps all active springs by the provided frame delta and writes the interpolated values back into the corresponding user-facing components.

The active query excludes controller entities already marked completed, so completed springs stop stepping until retargeted.

## Observable Internal Fields

The Lua module also exposes additional mutable fields not covered by the public type declarations:

- `default`, pointing back to the same module table
- `__spring_target`
- `__spring_controller`
- `__spring_target_info`

Those fields exist for internal bookkeeping and should not be treated as stable public API.
