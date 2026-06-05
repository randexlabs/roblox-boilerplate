# Getting Started

## Dependency Shape

The package expects these peer dependencies in the consuming project:

- `jecs`
- `jecs-utils`
- `vide`

The published metadata describes `jecs-vide` as a shared package, so it is intended for code that can run wherever those dependencies are available.

## Required Setup Order

1. Require `jecs-vide`.
2. Create or obtain the `jecs.World` the UI should observe.
3. Call `jecs_vide.world(world)` once before relying on hook output.
4. Create `Vide` effects/computations that read the returned sources.

Minimal setup pattern:

```luau
local jecs = require(path.to.jecs)
local vide = require(path.to.vide)
local jecs_vide = require(path.to["jecs-vide"])

local world = jecs.World()
jecs_vide.world(world)
```

If `jecs-utils` is also in use elsewhere, `jecs_vide.world(world)` will rebind `jecs-utils` to the same world when needed.

## First-Use Examples

### Read A Component Reactively

```luau
local health = world:component() :: jecs.Entity<number>
local selectedEntity = vide.source(nil :: jecs.Entity?)

local healthState = jecs_vide.useEntityGet(selectedEntity, health)

vide.effect(function()
	print("health", healthState())
end)
```

### Track Tag Presence

```luau
local stunned = world:component()
local hasStunned = jecs_vide.useEntityHas(selectedEntity, stunned)

vide.effect(function()
	print("is stunned", hasStunned())
end)
```

### Track Query Membership

```luau
local enemy = world:component()
local enemies = jecs_vide.useQuery(world:query(enemy))

vide.effect(function()
	for _, entity in enemies() do
		print("enemy", entity)
	end
end)
```

### Track The First Matching Entity

```luau
local enemy = world:component()
local visible = world:component()

local firstVisibleEnemy = jecs_vide.useQueryFirst(
	world:query(enemy, visible),
	function(entity)
		return true
	end
)
```

### Track A Relation Target

```luau
local parent = world:component()
local currentParent = jecs_vide.useTarget(selectedEntity, parent)

vide.effect(function()
	print("parent entity", currentParent())
end)
```

## Setup Advice

- Bind the world once during app initialization instead of rebinding on every render.
- Treat the hooks as view/read helpers. They do not manage writes back into the world.
- If the consuming UI depends on stable list order, add your own sorting layer on top of `useQuery()`.
- If a hook appears inert, verify that the world binding happened before the effect using the hook became active.
