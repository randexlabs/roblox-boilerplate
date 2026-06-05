# Getting Started

## Minimum Integration Flow

1. Require your component ids and the `jecs-gizmo` module.
2. Assign the module's `cframe`, `position`, and `direction` fields to your existing ECS component ids as needed.
3. Call `world(world)` once to bind the module to the current jecs world and create the marker component ids.
4. Add `system()` to your frame schedule after gameplay systems have updated the ECS data for that frame.
5. Mark entities with one of the generated `gizmo.*` components to make them visible.

## Setup Example

```luau
local c = require(components)
local jecs_gizmo = require(path.to.jecs_gizmo)

jecs_gizmo.cframe = c.transform
jecs_gizmo.position = c.position
jecs_gizmo.direction = c.direction

jecs_gizmo.world(world)

return {
	system = function()
		jecs_gizmo.system()
	end,
}
```

## Marker Usage Examples

### Draw a CFrame Gizmo

```luau
local gizmo = require(path.to.jecs_gizmo).gizmo

local entity = world:entity()
world:set(entity, c.transform, CFrame.new(1, 1, 1))
world:add(entity, gizmo.cframe)
```

This draws a point at `CFrame.Position` and, when advanced styling is enabled, also draws axis arrows.

### Draw Only a Position

```luau
local entity = world:entity()
world:set(entity, c.position, Vector3.new(1, 1, 1))
world:add(entity, gizmo.position)
```

If the entity has a CFrame and `gizmo.position`, the system also accepts that and draws only the position.

### Draw a Direction Arrow

```luau
local entity = world:entity()
world:set(entity, c.position, Vector3.new(0, 1, 0))
world:set(entity, c.direction, Vector3.new(0, 1, 0))
world:add(entity, gizmo.direction)
```

Direction gizmos require a direction vector plus either:

- a position component, or
- a CFrame component

### Draw Distance Between Two Entities

```luau
local a = world:entity()
local b = world:entity()

world:set(a, c.position, Vector3.new(1, 1, 1))
world:set(b, c.transform, CFrame.new(10, 10, 10))
world:add(a, jecs.pair(gizmo.distance, b))
```

The source entity and target entity can mix position and CFrame data, as long as each side has one of the supported location sources.

### Draw a LookVector

```luau
local entity = world:entity()
world:set(entity, c.transform, CFrame.new(1, 1, 1) * CFrame.Angles(0, math.pi / 2, 0))
world:add(entity, gizmo.lookvector)
```

`lookvector` only works from the configured CFrame component.

## Style Overrides

Each marker component accepts an optional style table as its component value.

```luau
world:set(entity, gizmo.cframe, {
	scale = 0.2,
	color = Color3.fromRGB(255, 128, 0),
})
```

Passing `nil`, omitting the value via `world:add`, or using an empty table all resolve to the module's default style.

## Enabling Only In Studio

```luau
local RunService = game:GetService("RunService")

jecs_gizmo.enabled = RunService:IsStudio()
```

This prevents the query iteration and drawing work from running in live runtime contexts where the visuals are not useful.
