# Getting Started

## Client-Side Requirement

TopbarPlus should be required from `LocalScript` context. The docs show the standard usage from `StarterPlayerScripts`, requiring the module from `ReplicatedStorage`.

```lua
local Icon = require(game:GetService("ReplicatedStorage").Icon)
local icon = Icon.new()
```

That constructs an empty `32x32` topbar icon.

## Installation Paths

Documented installation options:

- Roblox model/package
- GitHub release `.rbxm`
- Rojo workflow
- Wally package

## Package Model Caveat

The installation docs note a specific package limitation: as of June 7, 2025, Roblox public packages had not fully rolled out, so package update features like `Get Latest Package` could error even though the library was structured as a package.

That note is historical documentation context, not a runtime API behavior.

## Basic Construction

Typical first icon:

```lua
Icon.new()
    :setImage(imageId)
    :setLabel("Shop")
```

The API is heavily chainable, so most setup is written in one fluent expression.

## Ordering

Icons appear in construction order by default. Earlier icons get slightly lower order values and therefore appear before later ones. If needed, call `icon:setOrder(...)`.

## Placement Guidance

The docs say you can place the package in `ReplicatedStorage` or `Workspace`, but the common pattern is requiring it from `ReplicatedStorage` inside client code.

## First Rules

- Create icons from client code.
- Use chaining for readability.
- Prefer documented methods like `align`, `setLabel`, `setImage`, `bindToggleItem`, and `modifyTheme` before reaching for lower-level runtime helpers.
- If you are using package-based installation, avoid editing code inside the package if you intend to preserve package linkage.
