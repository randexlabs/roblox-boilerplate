# Roblox API

Import:

```luau
local roblox = require("@lune/roblox")
```

## Repo rule

When tests need mocked Roblox instances, prefer the Lune Roblox API over handwritten `:: any` tables.

Use it to:

- create `Instance` and `Player` mocks
- attach methods with `implementMethod`
- keep tests closer to real Roblox object behavior

Keep plain table doubles only for non-Roblox dependencies such as stores, service adapters, and pure domain contracts.

## Common patterns

### Create an instance

```luau
local player = roblox.Instance.new("Player")
player.Name = "Player44"
player.UserId = 44
```

### Mock a method

```luau
roblox.implementMethod("Player", "Kick", function(player, ...: any)
	local message = select(1, ...) :: string
	-- capture assertions here
end :: any)
```

## Available surface

See Lune's Roblox support for:

- `Instance.new`
- `DataModel:GetService`
- supported `Instance` methods and Roblox datatypes

Use this API only for Roblox objects. Do not force non-Roblox collaborators into it.
