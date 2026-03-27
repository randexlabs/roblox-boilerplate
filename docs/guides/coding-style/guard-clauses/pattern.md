# Guard clauses pattern

## The basic steps

1. Validate preconditions near the entry point.
2. `return` (or `continue`) when a precondition fails.
3. Keep the core logic unindented.

## Example (Luau)

```luau
local function awardCoins(player: Player?, amount: number?)
	if player == nil then return end
	if type(amount) ~= "number" then return end
	if amount <= 0 then return end

	print(("Award %d coins to %s"):format(amount, player.Name))
end
```

