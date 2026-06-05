# Runtime Operations API

## Propagation

### `system(): void`

Walk every known assembly and propagate final transforms through the pivot chain.

Per-assembly behavior:

1. skip assemblies of size `<= 1`
2. read the root node's `transform`
3. skip the assembly if that root transform is missing
4. walk the assembly in stored depth-first order
5. multiply the current inherited transform by each node's `relative` or `CFrame.identity`
6. write the result back to the node's `transform`

Important semantics:

- the first node acts as the transform root
- descendants overwrite their own `transform` with the resolved result
- relative offsets are accumulated in traversal order

## Reparenting

### `swap_pivot(entity: Entity, pivot: Entity, relative?: CFrame): void`

Change the entity's pivot parent while choosing a new `relative` transform.

Behavior when transforms exist:

- reads `transform` from the entity
- reads `transform` from the new pivot
- computes a new relative transform intended to keep the entity's world-space transform stable

Behavior when transforms are missing:

- sets `relative` to the provided override, or
- uses `CFrame.identity`

After computing `relative`, the function:

- removes all old `pair(pivot, oldParent)` relations found through `world:target(entity, pivot)`
- adds `pair(pivot, newParent)`

## Effective Formulas

### Propagation step

For a node with parent-resolved transform `parentWorld` and local offset `relative`:

```luau
resolved = parentWorld * relative
```

For the first child in an assembly, `parentWorld` starts from the assembly root's `transform`.

### Reparenting solve step

When both transforms exist:

```luau
local desiredFrame = relativeOverride and pivotTransform * relativeOverride or pivotTransform
local solvedRelative = desiredFrame:Inverse() * entityTransform
```

That solved value is written to the module's `relative` component before the new pivot pair is added.

## Observed Edge Behavior

- Assemblies with only one node are ignored by `system()`.
- Nodes without a `relative` component behave as if `relative == CFrame.identity`.
- If the root transform is absent, descendants in that assembly are not updated on that pass.
- `swap_pivot()` assumes the module already has an active world from `world(world)`.
