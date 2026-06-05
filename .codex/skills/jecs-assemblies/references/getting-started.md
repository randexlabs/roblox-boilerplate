# Getting Started

## Minimum Setup

The intended integration flow is:

1. Require the module.
2. Optionally replace `transform`, `relative`, and `pivot` with your own existing jecs ids.
3. Call `world(world)` once before using the rest of the API.
4. Run `system()` in your update loop immediately before consuming the propagated transform results.

## Basic Example

```luau
local c = require(components)
local jecs_assemblies = require(jecs_assemblies)

jecs_assemblies.transform = c.transform
jecs_assemblies.world(world)

return {
    system = function()
        jecs_assemblies.system()
    end
}
```

## Relative Pivot Example

```luau
local c = require(components)
local ja = require(jecs_assemblies)

local character = world:entity()
local camera = world:entity()

world:set(character, c.transform, cf)

world:add(camera, pair(ja.pivot, character))
world:set(camera, c.relative, rel)

-- camera transform = character transform * camera rel
```

## Choosing Your Component Ids

By default, `world(world)` creates component/entity ids if `transform`, `relative`, or `pivot` are still unset.

Override them first when:

- your game already has canonical transform components
- multiple systems need to share the same ids
- you want the library to write into an existing ECS schema

## Scheduling Advice

Place `system()` right before whatever system reads final transforms to:

- position parts
- update attachments
- drive camera transforms
- apply replicated transform output

If it runs too early, later systems may overwrite parent transforms after the chain has already been propagated.
