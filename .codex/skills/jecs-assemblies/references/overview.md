# Overview

## What jecs-assemblies Is

`jecs-assemblies` is a small helper built on top of `jecs` for hierarchical transform propagation.

It lets one entity follow another entity through a pivot relationship while storing only:

- a world-space transform component on entities that own an absolute transform
- a relative CFrame from child to parent
- a pivot pair that identifies the parent entity

## Core Use Case

Use it when you want entity-to-entity transform chains such as:

- character -> weapon
- character -> camera anchor
- vehicle body -> turret -> barrel
- any ECS-driven attachment chain where local offsets should resolve into final world transforms

The library computes final transforms by walking pivot-linked assemblies and writing propagated results back into the configured `transform` component.

## Public Surface

The module exposes:

- `transform`: component id for absolute/world-space CFrames
- `relative`: component id for local/relative CFrames
- `pivot`: tag/entity id used in jecs pair relations to point at a parent
- `world(world)`: initialize the module against a jecs world
- `system()`: propagate transforms through current assemblies
- `swap_pivot(entity, pivot, relative?)`: reparent while attempting to preserve world-space transform
- `__alive_tracking__`: internal-looking but publicly exported bookkeeping id
- a default export whose fields mirror the named exports

## Dependency Model

The package is designed around `@rbxts/jecs` and expects normal jecs pair operations such as:

- `world:add(entity, pair(pivot, parent))`
- `world:target(entity, pivot)`
- `world:set(entity, component, value)`
- `world:get(entity, component)`

## What It Does Not Try To Be

This is not a general scene graph or transform class hierarchy.

It does not:

- instantiate separate assembly objects for callers
- expose per-world instances
- manage transform application to Roblox instances for you
- infer update order automatically beyond the order in which you schedule `system()`
