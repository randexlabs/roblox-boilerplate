# Conceptual Guides

## Mental Model

Think of the library as maintaining a forest of parent-child transform chains inside jecs.

Each linked entity belongs to an internal assembly. During `system()`:

1. the assembly root contributes the starting world transform
2. each child contributes a `relative` offset, defaulting to `CFrame.identity`
3. the module multiplies offsets down the chain
4. each entity receives its final `transform`

## Root Versus Children

The implementation treats the first node in an assembly as the source of the starting world transform.

Important consequence:

- the root must already have a valid `transform`
- propagation for that assembly is skipped if the root transform is missing

Children do not need an explicit `relative`; they default to `CFrame.identity`.

## Pivot Representation

Parenting is expressed through a jecs pair relation:

```luau
world:add(child, pair(jecs_assemblies.pivot, parent))
```

That means:

- `pivot` is not a data component
- the parent entity is stored as the pair target
- changing parent means replacing the current pivot pair

## Assembly Traversal

Internally, the module flattens each tree into a depth-first ordered list and stores order boundaries per node.

That lets `system()` walk a linear list while still knowing when it has finished a subtree and should pop back to the previous transform stack frame.

Practical consequence:

- a single `system()` pass updates nested chains without recursive calls during propagation

## How `swap_pivot()` Works

`swap_pivot(entity, newPivot, relativeOverride?)` does two jobs:

1. remove every existing pivot pair from the entity
2. add a new pivot pair pointing to `newPivot`

Before doing that, it chooses the new relative transform:

- if both the entity transform and new pivot transform exist, it computes a relative offset intended to preserve the current world transform
- otherwise it uses `relativeOverride` if provided
- otherwise it falls back to `CFrame.identity`

## World-Space Preservation Formula

When both transforms exist, the module calculates:

```luau
local final_transform = relativeOverride and pivotTransform * relativeOverride or pivotTransform
local newRelative = final_transform:Inverse() * entityTransform
```

Interpretation:

- without `relativeOverride`, it keeps the entity in place relative to the new pivot's current world transform
- with `relativeOverride`, it treats `pivotTransform * relativeOverride` as the desired new frame before solving the relative CFrame that preserves the entity result against that frame

## Global-State Model

The module is singleton-style.

It stores:

- configured component ids on the module table
- the current world in module-local state
- assembly bookkeeping in shared tables

This is convenient for a single ECS runtime, but it is not modeled as isolated per-world instances.
