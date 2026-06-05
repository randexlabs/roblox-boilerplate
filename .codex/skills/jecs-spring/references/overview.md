# Overview

## What jecs-spring Is

`jecs-spring` is a small Luau helper that lets a jecs world drive Ripple springs through ECS pairs instead of imperative spring bookkeeping.

The package binds itself to one jecs world, allocates a few helper component/entity ids, and then reacts to pair changes:

- a `goal` pair starts or retargets a spring for one component
- an `options` pair configures that spring
- a `motion` pair exposes the live Ripple `Spring` object
- a `completed` pair marks that the current goal has finished

The actual animated value still lives in your own component. `jecs-spring` only manages the spring state around that component and writes the stepped value back into the world each frame.

## Main Mental Model

For each animated component on an entity:

1. Your game stores the current value in a normal component such as `c.size`.
2. You set `pair(jecs_spring.goal, c.size)` to the desired target value.
3. The package creates a Ripple spring, stores it in `pair(jecs_spring.motion, c.size)`, and steps it from `system(delta)`.
4. Each step writes the interpolated value back into `c.size`.
5. When the spring completes, the package adds `pair(jecs_spring.completed, c.size)`.

This keeps animation intent declarative inside the ECS world.

## Public Surface

The typed package surface exports:

- `options`
- `goal`
- `completed`
- `motion`
- `world(world: World): void`
- `system(delta: number): void`
- a default export exposing the same fields

The value types come from Ripple:

- goal values should be Ripple `Animatable` values such as `number`, `Vector2`, `Vector3`, `CFrame`, `Color3`, `UDim`, `UDim2`, or `Rect`
- option values are Ripple `SpringOptions`
- motion values are live Ripple `Spring` objects

## What It Does Not Do

`jecs-spring` does not:

- create isolated spring manager instances per world
- own your animated component ids
- automatically run itself every frame
- provide a public API for querying only "real" completed entities versus its internal controller entities

That behavior matters when integrating it into larger ECS pipelines.
