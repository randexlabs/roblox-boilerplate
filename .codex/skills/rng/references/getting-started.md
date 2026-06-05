# Getting Started

## Installation Paths

The README documents four installation routes:

- download the packaged model from the latest release
- Wally dependency: `ernisto/rng`
- Pesde in Roblox projects: `pesde add wally#ernisto/rng`
- Pesde in Luau projects: `pesde add ernisto/rng`

## Requiring the Module

Roblox example:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rng = require(ReplicatedStorage.Packages.rng)
```

Pure Luau-style example:

```lua
local rng = require("@pkg/rng")
```

## First Helpers To Reach For

Basic numeric draws:

```lua
local x = rng.number()         -- ratio-like random number
local y = rng.number(10)       -- scaled to [0, 10]
local z = rng.range(5, 15)     -- between two bounds
local n = rng.step(10, 2)      -- discrete stepped values
```

Probability booleans:

```lua
if rng.truth(0.2) then
    print("20% chance")
end

if rng.skip(1 / 3) then
    return
end
```

Weighted choice:

```lua
local skill = rng.key_by_weight({
    fire = 5,
    water = 5,
    earth = 5,
    lava = 3,
    light = 1,
    dark = 1,
})
```

Array utilities:

```lua
local items = { "a", "b", "c", "d" }
local pick = rng.value(items)
rng.write_shuffle(items)
```

## Choosing A Generator

Use the root module when you just need convenience helpers:

```lua
local x = rng.vector(10, 0, 10)
```

Use a seeded PRNG when you need reproducible sequences:

```lua
local seeded = rng.new("daily-loot")
local roll = seeded.int_range(1, 100)
```

Use the secure generator when predictability matters more than raw simplicity:

```lua
local secure = rng.new_secure("public-seed", someSaltBuffer)
local item = secure.key_by_weight(weights)
```

## Stable Iteration For Shared Decisions

The README's "daily market" example uses `same_iter_order` to normalize iteration order before repeated weighted selection across servers:

```lua
local possibleItems = rng.same_iter_order({
    apple = 75,
    soup = 50,
    sword = 20,
    armor = 4,
    totem = 1,
})
```

This helper matters only when downstream logic depends on table iteration order being aligned for equivalent data.
