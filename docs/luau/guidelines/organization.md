# Organization

## Prefer individual files for libraries and not huge utility libraries

Avoid giant `utility libraries` with unrelated functions mixed together.

Bad:

```luau
-- TableUtil.luau
local TableUtil = {}

function TableUtil.flatten()
	-- etc
end

function TableUtil.reverse()
	-- etc
end

return TableUtil
```

Better:

```luau
-- flatten.luau
local function flatten()
	-- etc
end

return flatten
```

```luau
-- reverse.luau
local function reverse()
	-- etc
end

return reverse
```

Splitting into individual files improves:

- smaller tests
- sharing across codebases
- `dependency cycle` risk
- autocomplete

## Put scripts inside scripts as implementation details

If you are only splitting internal implementation without changing consumer behavior, put those implementation details inside the main script.

```luau
-- src/shared/Ui/Toolbar.luau
local function ToolbarButton()
	-- etc
end

local function ToolbarRow()
	-- etc
end

local function Toolbar()
	-- etc
end

return Toolbar
```

Can become:

```text
src/shared/Ui/Toolbar
├─ init.luau
├─ ToolbarButton.luau
└─ ToolbarRow.luau
```
