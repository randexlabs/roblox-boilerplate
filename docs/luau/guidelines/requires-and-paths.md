# Requires and Paths

## Avoid dynamic requires

Luau `static typechecking` works through `require`, but only when the required value is static.

Good:

```luau
local Library = require(Modules.Library)

return {
	Library = Library,
}
```

Bad:

```luau
local modules = {}

for _, module in Modules:GetChildren() do
	modules[module.Name] = require(module)
end

return modules
```

In the second case, the values become `any`. In `strict mode`, this may even error because `require` expects static values.

Avoid `dynamic require` whenever possible. It immediately degrades `developer experience` and weakens typing for a DRY gain that usually is not worth it.

## Sort requires alphabetically, and do not section them

Avoid splitting `require` blocks into arbitrary groups.

This kind of organization:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)

local MyComponent = require(ReplicatedStorage.Ui.MyComponent)
local MyComponent2 = require(ReplicatedStorage.Ui.MyComponent2)

local useStuff = require(ReplicatedStorage.Ui.Hooks.useStuff)

local InnerComponent = require(script.InnerComponent)
```

looks organized, but in practice it only adds noise.

Prefer simple alphabetical order:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InnerComponent = require(script.InnerComponent)
local MyComponent = require(ReplicatedStorage.Ui.MyComponent)
local MyComponent2 = require(ReplicatedStorage.Ui.MyComponent2)
local React = require(ReplicatedStorage.Packages.React)
local useStuff = require(ReplicatedStorage.Ui.Hooks.useStuff)
```

Use `Luau LSP` with auto-require and `StyLua` with:

```toml
[sort_requires]
enabled = true
```

## Use absolute paths, avoid `script.Parent` outside of implementations, and avoid going up more than one `Parent`

Prefer:

```luau
local library1 = require(ReplicatedStorage.Libraries.library1)
```

instead of:

```luau
local library1 = require(script.Parent.library1)
```

`Absolute paths` make moving files easier and expose less of the script position as an implementation detail.

It is also acceptable to use `FindFirstAncestor` as a root:

```luau
local Plugin = script:FindFirstAncestor("MyPlugin")
local PluginButton = require(Plugin.Components.PluginButton)
```

Using `script` in the main script and `script.Parent` in internal sub-scripts is acceptable when that is an implementation detail. Avoid going up more than one `Parent`.

## Exception - Stories and tests

`Stories` and `tests` are companion files for a specific script. They should live next to the corresponding script.

In those cases, using `script.Parent` is the correct pattern.
