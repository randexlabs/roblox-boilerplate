# Enums and Iteration

## Use string style enums, and nothing else

The only enum pattern that is consistently useful in Luau is `string literal union`.

```luau
type Color = "red" | "blue" | "green"

local function setColor(color: Color)
	if color == "red" then
		-- red
	elseif color == "blue" then
		-- blue
	elseif color == "green" then
		-- green
	end
end

setColor("red")
```

To guarantee `exhaustive match`, use:

```luau
local function exhaustiveMatch(value: never): never
	error(`Unknown value in exhaustive match: {value}`)
end
```

Example:

```luau
local function setColor(color: Color)
	if color == "red" then
		-- red
	elseif color == "blue" then
		-- blue
	else
		exhaustiveMatch(color)
	end
end
```

Avoid libraries like:

```luau
local Color = makeEnum({ "red", "green", "blue" })
```

This worsens typing and pushes errors to runtime.

## Use generalized iteration

Avoid:

```luau
for i, v in pairs(t) do
for i, v in ipairs(t) do
for i, v in next, t do
```

Prefer:

```luau
for i, v in t do
```

`Generalized iteration` covers the common case with less noise.

`ipairs` may still be necessary for `holey` or `mixed` arrays, but those structures are usually fragile anyway.
