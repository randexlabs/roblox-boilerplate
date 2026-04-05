# Control Flow

## Prefer to avoid the idea of truthiness and falsiness in favor of explicit checks

In Luau, a value is `falsy` if it is `false` or `nil`. Any other value is `truthy`.

So this:

```luau
if x.Parent then
```

is equivalent to:

```luau
if x.Parent ~= nil then
```

Prefer the second form because it communicates intent more precisely.

Bad:

```luau
if not x.Parent then
```

Good:

```luau
if x.Parent == nil then
```

## Exception - If expressions

With `if expressions`, readability is a trade-off.

Both are acceptable:

```luau
local name = if character then character.Name else "Unknown"
local name = if character == nil then "Unknown" else character.Name
```

## Use `and` and `or` for short circuiting and defaults

In Luau, `and` and `or` do not return `boolean`. They return values.

```luau
print(1 and 2) -- 2
print(1 or 2) -- 1
print(nil or "default") -- default
print(nil and "second") -- nil
```

The right-hand side is only evaluated when needed.

```luau
local function f()
	print("calculating f...")
	return 100
end

print(true and f())
print(false and f())
```

This is useful for defaults:

```luau
local function playSound(sound: Sound, volume: number?)
	local soundClone = sound:Clone()
	soundClone.Volume = volume or 0.5
	soundClone.Parent = SoundService
	soundClone:Play()
end
```

It is also acceptable for `short-circuit chain` logic:

```luau
local function killPlayer(player: Player)
	local humanoid = player
		and player.Character
		and player.Character:FindFirstChild("Humanoid")

	if humanoid == nil then
		return
	end

	humanoid.Health = 0
end
```

## Exception - Don't use `x and y or z`

Do not use `and/or` as a fake `ternary`:

```luau
local goldAmount = giveDoubleGold and 1000 or 500
```

This breaks when one of the values is `falsy`.

```luau
local goldAmount = gamemode == "arena" and nil or 100
```

If `gamemode == "arena"`, the result is still `100`, which is wrong.

Use `if-then-else expression`:

```luau
local goldAmount = if gamemode == "arena" then nil else 100
```

For simple defaults, `or` is still better:

```luau
local goldAmount = gamemode.goldToGive or 100
```
