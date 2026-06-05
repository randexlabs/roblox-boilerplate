# Getting Started

## Minimum Workflow

```luau
local jecs = require("@jecs")
local world = jecs.world()

local Position = world:component() :: jecs.Id<vector>
local Velocity = world:component() :: jecs.Id<vector>
local Walking = world:component()

local entity = world:entity()
world:set(entity, Position, vector.create(1, 2, 3))
world:set(entity, Velocity, vector.create(0, 1, 0))
world:add(entity, Walking)

for e, pos, vel in world:query(Position, Velocity) do
	print(e, pos, vel)
end
```

## Core Rules

- Use `world:component()` for data-bearing IDs.
- Use `world:add(entity, Tag)` for tags.
- Use `world:set(entity, Component, value)` for data-bearing components and pair data.
- Use `world:get(entity, Component)` when the value may or may not exist.
- Use `world:has(entity, TagOrComponent)` when you only need presence.

## Preregistered IDs

If you want to declare IDs before a world exists, use the top-level constructors:

```luau
local jecs = require("@jecs")

local Position = jecs.component() :: jecs.Id<vector>
local Dead = jecs.tag()
jecs.meta(Position, jecs.Name, "Position")

local world = jecs.world()
```

Important rule:

- `jecs.component()`, `jecs.tag()`, and `jecs.meta(...)` must run before `jecs.world()` if you expect those forward-declared IDs and their metadata to be allocated into the world automatically.

## Singletons

Since components are entities, a component can also act as the singleton entity that stores its own value:

```luau
local TimeOfDay = world:component() :: jecs.Id<number>
world:set(TimeOfDay, TimeOfDay, 5)
local t = world:get(TimeOfDay, TimeOfDay)
```

This is a common pattern for global ECS-owned resources or world state.

## Relationships

```luau
local pair = jecs.pair
local ChildOf = jecs.ChildOf

local parent = world:entity()
local child = world:entity()

world:add(child, pair(ChildOf, parent))

for e in world:query(pair(ChildOf, parent)) do
	print("child", e)
end
```

For wildcard relationships:

```luau
local Likes = world:component()
local __ = jecs.Wildcard

for e in world:query(pair(Likes, __)) do
	local target = world:target(e, Likes)
	print(e, target)
end
```

## Hooks And Signals

Hook traits are stored on the component entity itself:

```luau
world:set(Position, jecs.OnAdd, function(entity, id, value)
	print("added", entity, value)
end)
```

Signals support multiple listeners:

```luau
local disconnect = world:added(Position, function(entity, id, value)
	print("added", entity, value)
end)

disconnect()
```

Configure hooks before the component is widely used if you need predictable lifecycle coverage from the beginning.
