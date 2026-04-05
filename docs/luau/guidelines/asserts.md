# Asserts and Validation

## Always give `assert` an error message

Avoid:

```luau
assert(hasGold)
```

Prefer:

```luau
assert(hasGold, "Player has no gold")
```

Without a message, the resulting error is too generic.

## `assert` should only take constant error messages

Avoid interpolating messages directly inside `assert`, because the argument is always evaluated.

```luau
assert(gold > 10, `Player has {gold} gold`)
```

Better:

```luau
if gold < 10 then
	error(`Player has {gold} gold`)
end
```

## Have a point to asserting `typeof`

Do not use `assert(typeof(x) == "...")` out of paranoia in already strictly typed code.

```luau
local function spendGold(player: Player, gold: number)
	assert(typeof(player) == "Instance" and player:IsA("Player"), "player isn't a Player")
	assert(typeof(gold) == "number", "Gold isn't a number")
end
```

This should only fail if the typing is already broken.

That kind of assert does make sense at `uncontrolled boundaries`, such as `RemoteEvents`.

Prefer receiving values as `unknown` and then doing `narrowing`.

Bad:

```luau
HurtMe.OnServerEvent:Connect(function(player, damage: unknown)
	if damage < 0 then
		error("Player is trying to heal themselves!")
	end

	assert(typeof(damage) == "number", "Player sent invalid damage")
	dealDamage(player, damage)
end)
```

The problem above is that the comparison happens before the `narrowing`.

Correct:

```luau
HurtMe.OnServerEvent:Connect(function(player, damage: unknown)
	assert(typeof(damage) == "number", "Player sent invalid damage")

	if damage < 0 then
		error("Player is trying to heal themselves!")
	end

	dealDamage(player, damage)
end)
```
