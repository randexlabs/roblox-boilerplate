# Runtime Spring Components API

## Goal Pair

### `pair(goal, animatedComponent) -> Animatable`

Stores the spring target for one specific component.

Supported value family from the README and Ripple typings:

- `number`
- `vector`
- `Vector3`
- `Vector2`
- `CFrame`
- `Color3`
- `UDim`
- `UDim2`
- `Rect`

When the goal pair is first added, the package creates a new spring for that component.

When the goal pair later changes:

- the spring is retargeted only if the new goal differs from `motion.state.goal`
- completion markers are removed from both the animated entity and the internal controller entity

When the goal pair is removed:

- the spring is destroyed
- the motion pair is removed
- the internal controller entity is deleted

## Options Pair

### `pair(options, animatedComponent) -> SpringOptions`

Stores Ripple configuration for one component-specific spring.

Observed behavior on updates:

- add/change/remove all route through the same handler
- if a motion and goal exist, the code reapplies the goal with the provided options
- if only a motion exists, the code reconfigures the spring directly
- removing the pair falls back to `{}` rather than preserving the old options table

Practical guidance:

- set options before the first goal when you need deterministic startup behavior

## Motion Pair

### `pair(motion, animatedComponent) -> Spring`

Exposes the live Ripple spring object after a goal is created.

The README demonstrates using it like:

```luau
local spring_motion = world:get(entity, pair(jecs_spring.motion, component))
spring_motion:impulse(Vector3.new(5, 5, 5))
```

Lifecycle rules:

- available immediately after goal creation
- removed when the goal pair is removed
- destroyed before removal during goal cleanup

## Completed Pair

### `pair(completed, animatedComponent)`

Signals that the spring has reached its current goal.

Completion behavior:

- added when Ripple's `onComplete` callback fires
- removed when the goal changes
- removed implicitly for controller entities when the controller is deleted after goal removal

Important caveat:

- this pair is attached to both the animated entity and the internal controller entity

So a plain completed query is not guaranteed to return only the visible or domain-level entity you care about.

## Step Semantics

`system(delta)` iterates active controller entities and performs:

```luau
motion:step(delta)
```

then writes the returned value into the animated component.

That means the spring value in the ECS world is pull-driven by the frame loop, not updated automatically when the goal changes.
