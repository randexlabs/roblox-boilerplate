# Getting Started

## Package Names

The package is published as:

- npm / roblox-ts: `@rbxts/jecs-utils`
- Wally: `pepeeltoro41/jecs-utils@1.4.3`

It depends on `jecs@0.11.0`.

## Initialization Model

Only part of the package needs explicit initialization.

Call `world(world)` when you want to use:

- `ref`
- `is_a`
- the `is_a` / `IsA` exported relation id aliases

The query helpers do not need module initialization because they operate directly on the `Query` object you pass.

## Minimal Setup Pattern

```luau
local jecs = require(path.to.jecs)
local utils = require(path.to["jecs-utils"])

local world = jecs.world()

utils.world(world)

local Position = world:component()
local Enemy = world:component()

local query = world:query(Position):with(Enemy)
local entity, position = utils.query_first(query)
```

## Using `ref`

`ref` gives you stable entity lookup by arbitrary Lua key.

```luau
local PlayerRef = utils.ref(player, function(entity)
	world:add(entity, PlayerTag)
end)

local sameEntity = utils.ref(player)
local maybeEntity = utils.ref.find(player)
```

Use it when you need one entity per external object such as a `Player`, Instance, string id, or table identity.

## Using `is_a`

After `utils.world(world)`, `utils.is_a` and `utils.IsA` become a jecs relation id created from that world.

Typical usage:

```luau
local Damage = world:component()
local FireDamage = world:component()

world:add(FireDamage, jecs.pair(utils.is_a, Damage))
world:set(entity, FireDamage, 10)
```

This causes the package to mirror the value or tag onto `Damage`.

## Reactive Query Patterns

Use the reactive helpers based on what you need:

- `observer(query, callback)` for "tell me when matching entities changed relevant components"
- `monitor(query)` for "tell me when entities entered or left this query"
- `query_changed(query)` for "queue changed matches and drain them later"
- `query_monitor(query)` for "queue entered and left matches and drain them later"

These helpers are stateful subscriptions. Always disconnect them when they are no longer needed.
