# Overview

## What jecs-gizmo Is

`jecs-gizmo` is a debug-visualization helper for `jecs`.

It watches entities that carry caller-defined data components such as CFrames, positions, and directions, then draws Roblox adornments and text every frame so those values can be inspected visually in Studio.

## Core Use Case

Use it when ECS data exists in the world already and you want a lightweight way to visualize it without attaching debug parts manually.

Typical uses:

- inspect world-space CFrames
- show point locations from `Vector3` position components
- draw direction vectors from a position or CFrame origin
- inspect `LookVector` orientation for transforms
- measure distances between two ECS entities using a jecs pair

## Public Surface

The package exposes a mutable module table containing:

- `cframe`: component id that should point at your CFrame-bearing ECS component
- `position`: component id that should point at your Vector3 position component
- `direction`: component id that should point at your Vector3 direction component
- `enabled`: runtime toggle for whether drawing work should happen
- `gizmo`: a table of generated marker component ids created by `world(world)`
- `world(world)`: initialize the module against a jecs world and build cached queries
- `system()`: iterate cached queries and draw all active gizmos for the frame

It also exposes named TypeScript exports for `gizmo`, `world`, and `system`, plus a default export matching the module table.

## Generated Marker Components

After initialization, `gizmo.gizmo` contains component ids used only to mark what to draw:

- `gizmo.cframe`
- `gizmo.position`
- `gizmo.direction`
- `gizmo.distance`
- `gizmo.lookvector`

You attach these marker components to entities in addition to your own data components.

## Dependency Model

The package assumes normal `jecs` world operations:

- `world:component()` to allocate component ids
- `world:query(...)` to build cached queries
- `world:add(entity, component)` or `world:set(entity, component, value)` to mark entities
- `jecs.pair(component, targetEntity)` for the distance relation
- `world:target(entity, relation)` to resolve pair targets

## What It Does Not Try To Be

This package does not:

- create per-world renderer instances
- infer your data components automatically
- persist drawn objects as gameplay state
- expose a generalized drawing API for arbitrary shapes through the top-level public package

The bundled renderer is richer internally than the public `jecs` integration surface, but the supported package-level workflow is still "map your ECS components, call `world`, then run `system`."
