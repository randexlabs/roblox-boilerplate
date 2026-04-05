# Roblox-Specific

## GetService everything

At the top of the file, declare services in alphabetical order with `GetService`.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")
```

Do not use `game.ServiceName`.

Not every service exists by default at script runtime, and not every service shares its exposed name. `RunService`, for example, is named `"Run Service"`.

Also do not scatter `GetService` throughout the rest of the file. That is just noise.

Do not use the global `workspace`. Use `Workspace` like any other service.

## Use `UDim2.fromOffset` and `UDim2.fromScale`

Prefer:

```luau
UDim2.fromOffset(x, y)
UDim2.fromScale(x, y)
```

instead of:

```luau
UDim2.new(0, x, 0, y)
UDim2.new(x, 0, y, 0)
```

This is less noisy and more readable.
