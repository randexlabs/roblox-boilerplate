# Conceptual Guides

## Pair Roles

The package uses one component id of yours as the pair target and one jecs-spring id as the pair source.

For a component like `c.size`:

- `pair(jecs_spring.goal, c.size)` stores the target value
- `pair(jecs_spring.options, c.size)` stores `SpringOptions`
- `pair(jecs_spring.motion, c.size)` stores the live Ripple `Spring`
- `pair(jecs_spring.completed, c.size)` marks that the current goal finished

This means each animatable component gets its own independent spring state on the same entity.

## Lifecycle Of A Spring

### 1. Goal Added

When `pair(goal, component)` is added:

- the package reads the current component value
- it creates a new Ripple spring with `ripple.createSpring(start or goal)`
- it applies the goal, optionally with current options
- it stores the spring in `pair(motion, component)`
- it creates an internal controller entity to help manage completion and query filtering

Important consequence:

- if the component has no current value yet, the spring starts from the goal value instead of animating from a prior state

### 2. Per-Frame Stepping

`system(delta)` iterates a cached query of active spring controller entities and does:

```luau
set_world:set(target.entity, target.component, motion:step(delta))
```

So the user-facing component is overwritten each frame with the new interpolated value.

### 3. Goal Changed

When `pair(goal, component)` changes:

- the current spring is retargeted if the new goal differs from `motion.state.goal`
- the completed marker is removed from both the animated entity and the controller entity

The implementation calls `motion:setGoal(goal)` here without explicitly passing options. In practice this relies on the existing Ripple spring retaining its current configuration.

### 4. Options Changed

When `pair(options, component)` is added, changed, or removed:

- if both a motion and goal already exist, the spring is updated through `motion:setGoal(goal, options or {})`
- if only the motion exists, the spring is reconfigured with `motion:configure(options or {})`

Removing options effectively falls back to an empty options table.

### 5. Completion

When the Ripple spring reports completion:

- the current goal is re-read from the world
- `pair(completed, component)` is added to the animated entity
- the same completed pair is also added to the internal controller entity
- the animated component is set directly to the goal value

That final write ensures the component lands exactly on the stored goal when completion fires.

### 6. Goal Removed

When `pair(goal, component)` is removed:

- the Ripple spring is destroyed
- `pair(motion, component)` is removed from the animated entity
- the internal controller entity is deleted
- the controller reference pair is removed from the animated entity

This is the cleanup boundary for one spring lifecycle.

## One Shared Module, One Active World

`jecs-spring` is not a constructor and does not return isolated instances.

Calling `world(world)`:

- overwrites module-local world state
- allocates fresh ids for `options`, `goal`, `completed`, and `motion`
- rebuilds the cached spring query
- rebinds event listeners on the new world

Treat it as a globally rebound module. If multiple systems expect separate worlds at once, they will conflict.

## Why Completed Uses Internal Entities Too

The stepping query is built over internal controller entities, not directly over your gameplay entities.

On completion, the controller entity is also marked completed so it drops out of the cached active-springs query. That internal bookkeeping leaks into public-world queries because the same `pair(completed, component)` is used for both.

Practical implication:

- `world:query(pair(jecs_spring.completed, component))` is not automatically restricted to just the animated gameplay entities

Filter with your own domain components or other known markers when you need only the real target entities.
