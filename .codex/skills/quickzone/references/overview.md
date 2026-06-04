# Overview

## What QuickZone Is

QuickZone is a physics-free spatial query library for Roblox focused on high zone counts, predictable runtime cost, and low garbage pressure.

Instead of leaning on Roblox collision queries such as `.Touched`, `GetPartsInPart`, or `GetBoundsInBox`, QuickZone uses:

- geometric math
- a dual static/dynamic Linear BVH
- entity-centric querying
- a budgeted scheduler

## Core Promise

QuickZone is built to make the number of zones cheap. Runtime cost is primarily driven by tracked entities and observer settings rather than by looping over every zone instance.

The documented scaling model is effectively:

- entity-centric processing
- `O(N log Z)` query behavior

## What It Gives Developers

QuickZone exposes:

- a root runtime module for configuration, updates, queries, entity/reference mapping, and debug visualization
- a `Zone` class for single spatial regions
- a `Zones` class for managed collections of zones
- a `Group` class for tracked entities
- an `Observer` class for lifecycle, event, and polling logic
- typed support for `Player`, `BasePart`, `Model`, `Attachment`, `Bone`, `Camera`, and duck-typed custom tables

## Detection Model

QuickZone is point-based, not volume-based.

It checks whether a chosen point for an entity is inside the zone:

- `BasePart`: `.Position`
- `Model`: `.PrimaryPart.Position` or `:GetPivot()`
- `Attachment` / `Bone`: `.WorldPosition`
- `Camera`: `.CFrame.Position`
- custom table: `.Position`, `.WorldPosition`, `.CFrame`, `.Transform`, or `:GetPivot()`

This matters because QuickZone does not attempt full shape-vs-shape entity overlap for tracked entities.

## Main Architectural Split

QuickZone is organized around:

- `Zones`: where tracking happens
- `Groups`: who is being tracked
- `Observers`: how logic responds

That separation is one of the library's main design benefits.
