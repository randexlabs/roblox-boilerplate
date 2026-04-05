# Principles

## Code should be strictly typed

All code should use Luau types and `strict mode`.

You can enable `strict mode` for the whole codebase with `.luaurc` containing:

```json
{ "languageMode": "strict" }
```

If the codebase is already too large to migrate at once, still enable `strict` and add `--!nonstrict` to the top of each legacy script. Migrate over time.

Do not use `--!nonstrict` or `--!nocheck` in new scripts.

## Bugs that can be caught statically should

If a bug can be caught statically, it should be caught statically.

Many APIs only allow errors to be caught at runtime because the API itself is weak. Better typing and better abstractions prevent that.

```luau
local function bad(x)
	assert(typeof(x) == "number", "I wanted a number!")
	return x + 10
end

local function good(x: number)
	return x + 10
end
```

In a properly typed codebase, it should not be possible to pass anything other than a `number` into `good`.

## Code should be simple

Avoid overly clever code. Code is not a showcase. Code is machinery.

Prefer small functions, obvious intent, and predictable behavior.

## Prefer immutability

Direct mutation of `state` makes code less predictable, especially when `yield` is involved.

If you use React, `immutability` is critical. Mutating `state` in the wrong place breaks the flow.

## Developer experience takes priority over performance

If there is no real evidence of a performance problem, prefer the code that is easiest to read and closest to how you think about the problem.

Overly clever or hard-to-read code tends to create more bugs and even more performance problems later.

When performance really does require uglier code, keep the `blast radius` as small as possible.

## Shallow, not deep copy

If code is actually immutable, you do not need `deep copy`.

`Deep copy` wastes work cloning data that did not change.

```luau
local items = {
	{
		name = "Sword",
		damage = 10,
		durability = 40,
	},

	{
		name = "Health Potion",
		color = {
			r = 255,
			g = 0,
			b = 0,
		},
		healthToRestore = 100,
	},
}
```

To change the sword `durability` without broad mutation:

```luau
items = table.clone(items)
items[1] = table.clone(items[1])
items[1].durability -= 10
```

This solves the problem without cloning the rest of the structure.
