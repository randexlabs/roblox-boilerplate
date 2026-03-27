# rng [![Release](https://github.com/ernisto/rng/actions/workflows/release.yml/badge.svg)](https://github.com/ernisto/rng/actions/workflows/release.yml)

Simple, fast RNG utilities for Luau: numbers, booleans by probability, weighted choice, array helpers, vectors, and buffers.

## Quick start

Require it from your `Packages` (adjust the path to match your setup):

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rng = require(ReplicatedStorage.Packages.rng)
```

You can also use this module in pure luau environment 💪

```lua
local rng = require('@pkg/rng')
```

### Regular RNG usage

```lua
local function teleport(humanoid: Humanoid, cframe: CFrame)
  humanoid.RootPart.CFrame = cframe * CFrame.new(rng.vector(10, 0, 10))
end
```

```lua
local function spin_skill()
  return rng.key_from_weight {
    fire = 5,
    water = 5,
    earth = 5,
    lava = 3,
    light = 1,
    dark = 1,
  }
end
```

### Secure daily market

```lua
local RESET_INTERVAL = 1*24*60*60
local function remaining_time_to_refresh()
  return RESET_INTERVAL - os.time() % RESET_INTERVAL
end

-- rng.same_iter_order to keep iteration order the same for all servers
local possible_items = rng.same_iter_order {
  -- total weight  → 150 → (75 + 50 + 20 + 4 + 1)
  apple = 75,  -- 75/150 → 50.0%
  soup = 50,   -- 50/150 → 33.3%
  sword = 20,  -- 20/150 → 13.3%
  armor = 4,   --  4/150 →  2.6%
  totem = 1,   --  1/150 →  0.6%
}

-- csprng are extremely hard to predict seeing outputs or brute forcing
local csprng = rng.new_secure("possibly known seed", HttpService:GetSecret("Salt"))

-- advance state as the same as another living servers
for i = 0, os.time() - RESET_INTERVAL, RESET_INTERVAL do
  for i = 1, 3 do csprng.number() end
end

-- generate market
while true do
  local choosen_items = {}
  for i = 1, 10 do
    choosen_items[i] = csprng.key_by_weight(possible_items)
  end
  market.set_items(choosen_items)
  task.wait(remaining_time_to_refresh())
end
```

### Numbers

```lua
local x = rng.number()                 -- [0, 1]
local y = rng.number(10)               -- [0, 10]
local w = rng.step(10, 2)              -- [0, 2, 4, 6, 8, 10]
local z = rng.range(5, 15)             -- [5, 15]
local s = rng.range(0, 1, 0.25)        -- one of {0.00, 0.25, 0.50, 0.75, 1.00}
```

### Booleans by probability

```lua
if rng.truth(0.2) then
  print("1/5 = 20% chance")
end

if rng.skip(1/3) then return end  -- 2/3 chance to return
print("1/3 = 33% chance")
```

### Vectors (Luau `vector` 3D type)

```lua
local v1 = rng.vector(100, 50, 100) -- x = [0, 100], y = [0, 50], z = [0, 100]
local v2 = rng.vector_range(vector.create(-10, 0, -20), vector.create(10, 0, 20), vector.one*5)
```

### Arrays

```lua
local items = {"a", "b", "c", "d"}
local pick = rng.value(items)   -- 'a' | 'b' | 'c' | 'd'
local index = rng.key{ a = 'cavalo', b = 'chama' }    -- 'a' | 'b'
rng.write_shuffle(items)        -- shuffles in place
```

### Buffers

```lua
local buf = rng.buffer(1024)           -- 1025 u32 values written starting at 0
-- or reuse an existing buffer, starting at an offset
local out = buffer.create(4096)
rng.buffer(512, out, 128)
```

## API

- `rng.new_secure(seed: string | any?): helper`
    - Returns a **C**ryptographically **S**ecure **P**seudo **R**andom **N**umber **G**enerator based on ChaCha20

- `rng.new(seed: string | any?): helper`
    - Returns a **P**seudo **R**andom **N**umber **G**enerator based on Shoroshiro128

- `rng.custom(generator: () -> 1..0): helper`
    - Returns the this same lib, but using a given generator

- `rng.rarest_keys(weights: { [K]: number }): { K }`
    - Returns a array of keys ordered by weight

- `rng.same_iter_order(weights: { [K]: number }): { [K]: number }`
    - Returns the given weight map with a `__iter` metamethod, keeping the iteration
      order of tables with similar weights. Changing lowest weights is more probably
      to break the iteration order, since lower weights is located first on array

- `helper.number(): number` — range \[0, 1]
- `helper.number(max: number): number` — range \[0, max]
- `helper.step(max: number, step: number): number` — one of { 0, step, 2\*step, .., max }
- `helper.range(min: number, max: number): number` — range \[min, max]
- `helper.range(min: number, max: number, step: number): number` — min + one of { 0, step, 2\*step, ..., max }

- `helper.int(max: int): int` — range \[0, max]
- `helper.int_range(min: int, max: int)` — range min + one of { 0, 1, 2, ..., max }
- `helper.int_range(min: int, max: int, step: int)` — range min + one of { 0, step, 2\*step, ..., max }

- `helper.vector(): vector` — each component in \[0, 1]
- `helper.vector(max: number): vector` — each component in \[0, max]
- `helper.vector(x: number, y: number, z: number?): vector` — x = \[0, x], y = \[0, y], z = \[0, z]
- `helper.vector_range(min: vector, max: vector): vector` — component-wise \[min, max]
- `helper.vector_range(min: vector, max: vector, step: vector): vector` — component-wise stepped values

- `helper.buffer(count: number, target?: buffer, offset?: number): buffer`
    - Fills a buffer with random 32-bit unsigned integers; creates one if not provided.

- `helper.truth(ratio: number): boolean`
- `helper.pass(ratio: number): boolean`
    - Returns true with probability `ratio` (e.g. 0.25 → 25% → 1/4).

- `helper.skip(ratio: number): boolean`
    - Returns false with probability `ratio` (e.g. 0.25 → 25% → 1/4).

- `helper.key_by_weight(weights: { [K]: number }): K`
    - Returns a key chosen by its weight (weights can be any positive decimal numbers).

- `helper.write_shuffle<T>(mut_arr: { T }): { T }`
    - In-place array shuffle. Returns the same array for convenience.

- `helper.value<T>(arr: { T }): T`
    - Random element from an array.

- `helper.key<K>(arr: { [K]: _ }): K`
    - Random key from an table.
