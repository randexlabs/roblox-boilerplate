# Getting Started

## Required Setup Order

`world(world)` must be called before you use any of the generated ids such as `goal`, `options`, `motion`, or `completed`.

Minimal integration pattern:

```luau
local c = require(components)
local jecs_spring = require(jecs_spring)

jecs_spring.world(world)

return {
	system = function(delta: number)
		jecs_spring.system(delta)
	end,
}
```

## Recommended Frame Order

Run `jecs_spring.system(delta)` after gameplay code has decided what the spring goals should be for the frame, but before downstream systems consume the animated component values.

Why that order matters:

- goal changes need to be visible before stepping
- `system(delta)` writes the latest interpolated values back into your component
- any later system in the frame will observe the stepped value

## First Animated Component

Typical flow:

```luau
local spring = require(jecs_spring)

local cube = world:entity()

world:set(cube, c.size, Vector3.new(1, 1, 1))
world:set(cube, pair(spring.goal, c.size), Vector3.new(2, 2, 2))
```

This causes `c.size` to animate from its current value toward the goal.

## Adding Spring Options

Set options on the same component-specific pair:

```luau
world:set(cube, pair(spring.options, c.size), {
	friction = 30,
	tension = 800,
})
world:set(cube, pair(spring.goal, c.size), Vector3.new(2, 2, 2))
```

It is best to set options before the first goal so the spring starts with the intended configuration immediately.

## Accessing The Live Ripple Spring

After a goal is set, the package stores the created Ripple spring at:

```luau
local motion = world:get(cube, pair(spring.motion, c.size))
```

You can then call Ripple methods on it, such as:

```luau
motion:impulse(Vector3.new(5, 5, 5))
```

## Detecting Completion

When a spring finishes its current goal, the package adds:

```luau
pair(spring.completed, c.size)
```

Use that marker carefully. The implementation also mirrors the same completed pair onto an internal controller entity, so a raw query over `pair(spring.completed, c.size)` can return more than just your gameplay entity.
