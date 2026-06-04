# Types And Command Authoring

## Registering Commands

The normal path is `conch.register(name, props)` with:

- `description`
- `permissions`
- `arguments`
- `callback`

Example:

```luau
conch.register("kick", {
	description = "Kicks the given player from the server",
	permissions = { "kick-player" },
	arguments = function()
		return
			conch.args.player("player", "The player to kick"),
			conch.args.string("reason", "Why the player is being kicked")
	end,
	callback = function(player, reason)
		player:Kick(reason)
	end
})
```

## Quick Commands

`conch.register_quick()` skips analysis metadata and argument modeling:

```luau
conch.register_quick("kick", function(player_name, reason)
	local player = Players:FindFirstChild(player_name)
	if not player then error(`{player_name} is not a real player`) end
	player:Kick(reason)
end, "kick-player")
```

Use it for temporary or throwaway commands, not polished developer UX.

## Built-In Argument Types

| Builder     | Result type          | Implicit inputs                                                                                               |
| ----------- | -------------------- | ------------------------------------------------------------------------------------------------------------- |
| `string`    | `string`             | Any `tostring`-able value                                                                                     |
| `strings`   | `string[]`           | Single string or string array shape                                                                           |
| `number`    | `number`             | Numeric text via `tonumber`                                                                                   |
| `numbers`   | `number[]`           | Single number or numeric array shape                                                                          |
| `boolean`   | `boolean`            | `boolean`, `number`, or truthy/falsy fallback                                                                 |
| `booleans`  | `boolean[]`          | Single boolean or boolean array shape                                                                         |
| `table`     | table-like           | Runtime docs mention it, but the current exported `args` table does not expose a ready-made `table()` builder |
| `vector`    | `vector`             | `vector` or table-like numeric triple                                                                         |
| `vectors`   | `vector[]`           | Single vector or vector array shape                                                                           |
| `player`    | `Player`             | Player instance, player name string, user id number, `@s`                                                     |
| `players`   | `Player[]`           | Player list plus `@a`, `@o`                                                                                   |
| `userid`    | `number`             | Player instance, player name string, user id number, `@s`                                                     |
| `userids`   | `number[]`           | User ids plus `@a`                                                                                            |
| `color`     | `Color3`             | Hex string, vector, numeric triple table                                                                      |
| `colors`    | `Color3[]`           | Pluralized color input                                                                                        |
| `duration`  | `number`             | Number or duration string with suffixes                                                                       |
| `userinput` | `Enum.UserInputType` | Documented in the old table and typings, but not present in the current runtime `args` export                 |

## Duration Suffixes

Supported suffix families:

- `ms`, `milisecond`, `miliseconds`
- `s`, `sec`, `second`, `seconds`
- `min`, `minute`, `minutes`
- `hr`, `hour`, `hours`
- `d`, `day`, `days`
- `wk`, `week`, `weeks`
- `mo`, `month`, `months`
- `y`, `yr`, `year`, `years`

Multi-part strings are additive:

```text
1hr 30min
2days 6hr
```

## Custom Types

Register custom types with `conch.register_type(typeId, data)`.

Use this when:

- The runtime language does not natively understand your type.
- You need custom conversion.
- You want autocomplete or analysis support.

Important rule:

- Register the type on both client and server before the command using it is registered.

## Enum Helpers

There is a naming mismatch across sources:

- Older docs and typings mention `enum_new` and `enum_map`.
- The runtime currently exports `enum_from_array` and `enum_from_map`.

Behavior:

- Array-style enum helper: produce suggestions from a list of values.
- Map-style enum helper: map string keys to arbitrary values during conversion.

## Advanced Helpers In Runtime

The runtime `conch.args` export also includes helpers not covered well by the published docs:

- `literal`
- `variadic`
- `opt`
- `struct`
- `union`
- `intersect`
- `overload`
- `dynamic`

Use these when building richer analysis models or overload-driven command signatures.

## Overloads

Overloads let one command accept different argument shapes. The runtime determines the chosen overload by checking which command type matches the provided arguments.

Caveat:

- If multiple overloads match, the runtime errors and asks the developer to differentiate them more clearly.
- Literal arguments are a good way to make overloads unambiguous.

## Practical Guidance

- Prefer `register` over `register_quick` when users need autocomplete, better docs, or stable long-term behavior.
- Put names and descriptions on arguments whenever command discoverability matters.
- Treat `super-user` and any role-modifying command as privileged design work, not convenience utilities.
