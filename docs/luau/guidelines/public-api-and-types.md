# Public APIs and Types

## Don't hide builtins

Avoid this:

```luau
local insert = table.insert
local max = math.max
local min = math.min
```

Today this does not deliver consistent practical gains and it hurts readability.

Better:

```luau
table.insert(items, sword)
```

## Type publicly exposed functions fully

Luau infers types very well, but publicly exposed functions should have fully explicit signatures.

```luau
local function attack(player, item, target)
	local damage = item.attack(target)
	print(`{player} dealt {damage} damage!`)
	return damage
end

return attack
```

This may work, but it creates implicit types that are harder to understand and easier to misuse.

```luau
local function attack(player: Player, item: Item, target: Attackable): number
	local damage = item.attack(target)
	print(`{player} dealt {damage} damage!`)
	return damage
end
```

Internal functions can stay inferred if they remain clear:

```luau
local function attackMessage(player, damage)
	print(`{player} dealt {damage} damage!`)
end

local function attack(player: Player, item: Item, target: Attackable): number
	local damage = item.attack(target)
	attackMessage(player, damage)
	return damage
end

return attack
```

## Prefer `{ [K]: V? }` over `{ [K]: V }` where invalid keys are expected to index

If a table can be indexed with missing keys, the `value type` should reflect that.

```luau
local playerPoints: { [Player]: number } = {}

local function givePoints(player: Player, amount: number)
	local currentPoints = playerPoints[player]
	currentPoints += amount
end
```

If the key does not exist, this breaks.

```luau
local playerPoints: { [Player]: number? } = {}

local function givePoints(player: Player, amount: number)
	local currentPoints = playerPoints[player]

	if currentPoints == nil then
		playerPoints[player] = amount
	else
		playerPoints[player] += amount
	end
end
```

## `nil` does not mean "nothing"

These functions are different:

```luau
local function returnsNothing()
end

local function returnsNil()
	return nil
end
```

The first returns zero values. The second returns one value: `nil`.

```luau
print(returnsNothing())
print(returnsNil())
```

Because of that, return semantics should be explicit.

```luau
local function doSomething()
	print("I'm a function that performs a side effect, and I have no sensible return value")
end

local function getAmmo(inventory)
	if inventory.selectedWeapon ~= nil and inventory.selectedWeapon.type == "gun" then
		return inventory.selectedWeapon.ammo
	end

	return nil
end
```

Practical rule:

- keep the number of `return values` consistent across branches
- do not mix `return x` in one place with an empty `return` elsewhere
