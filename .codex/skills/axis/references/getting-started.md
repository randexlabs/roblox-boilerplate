# Getting Started

## Installation

Observed installation paths:

- `pesde`: `pesde add killergg/axis`
- `Wally`: `axis = "neond00m/axis@0.2.4"`

Important note:

- the package manifests support both `pesde` and `Wally`
- one guide still says "currently only available on pesde"
- treat that sentence as stale documentation, not as a real packaging limitation

## Minimum Usage

```luau
local RunService = game:GetService("RunService")
local Axis = require(path.to.Axis)

local attack = Axis.input {
	Enum.KeyCode.E,
	Enum.UserInputType.MouseButton1,
	Enum.KeyCode.ButtonR2,
}

RunService.RenderStepped:Connect(function()
	attack:update()

	if attack:pressed() then
		print("attack")
	end
end)
```

## Recommended Project Shape

Axis works best when input objects live in one shared input-map module and all systems read from that map:

```luau
local Axis = require(path.to.Axis)
local input = Axis.input

return {
	crouch = input {
		Enum.KeyCode.C,
		Enum.KeyCode.ButtonR3,
	},
	jump = input {
		Enum.KeyCode.Space,
		Enum.KeyCode.ButtonA,
	},
	drag = input {
		Enum.UserInputType.MouseMovement,
		Enum.KeyCode.Thumbstick2,
	},
}
```

Then update all inputs once per frame:

```luau
RunService.RenderStepped:Connect(function(dt)
	Axis.update(inputMap)
	cameraSystem(dt)
	jumpSystem(dt)
	crouchSystem(dt)
end)
```

This pattern is used by the example game and keeps device-specific input setup separate from gameplay logic.

## First Mental Model To Keep

Every frame:

1. input events modify the axis's internal active inputs
2. `update()` sums those active inputs into `current`
3. transition helpers compare `current` to `previous`

If `update()` is skipped, `pressed()`, `released()`, and `changed()` cannot behave correctly.

## Typical Axis Shapes

Simple button:

```luau
local attack = Axis.input {
	Enum.KeyCode.E,
}
```

Weighted scalar:

```luau
local zoom = Axis.input {
	[Enum.KeyCode.I] = 2,
	[Enum.KeyCode.O] = -2,
	[Enum.UserInputType.MouseWheel] = 10,
}
```

Vector movement:

```luau
local move = Axis.input {
	[Enum.KeyCode.W] = Vector2.new(0, 1),
	[Enum.KeyCode.S] = Vector2.new(0, -1),
	[Enum.KeyCode.A] = Vector2.new(-1, 0),
	[Enum.KeyCode.D] = Vector2.new(1, 0),
	Enum.KeyCode.Thumbstick1,
}
```

## Mobile Integration Pattern

For touch UI, do not fork gameplay logic into a separate "mobile-only action" path when a shared axis is enough.

Preferred patterns:

- `hold()` for press-and-hold buttons like aim, jump charge, or drag-hold state
- `move()` for one-frame signals driven by external UI state or per-frame gesture logic

Example:

```luau
local releaseJump: (() -> ())? = nil

jumpButton.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	releaseJump = inputMap.jump:hold()
end)

UserInputService.InputEnded:Connect(function(input)
	if releaseJump and input.UserInputState == Enum.UserInputState.End then
		releaseJump()
		releaseJump = nil
	end
end)
```
