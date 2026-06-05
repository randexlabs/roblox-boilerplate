# Types And Keymaps

## Public Types

## `DeviceType`

```luau
type DeviceType = "Desktop" | "Touch" | "Controller"
```

This is the return type of `Axis.device(...)`.

## `Map<T>`

Implementation-facing public shape:

```luau
type Map<T> = { [any]: T } | { [number]: any }
```

Practical meaning:

- array-style entries are allowed for "just map this key with weight 1"
- dictionary-style entries are allowed for explicit scalar or vector values

Examples:

```luau
{
	Enum.KeyCode.E,
	Enum.KeyCode.ButtonA,
}
```

```luau
{
	[Enum.KeyCode.A] = -1,
	[Enum.KeyCode.D] = 1,
}
```

```luau
{
	[Enum.KeyCode.W] = Vector2.new(0, 1),
	[Enum.KeyCode.S] = Vector2.new(0, -1),
}
```

## `Input<T>`

Public methods:

- `read(controller?) -> (T, T)`
- `pressing(controller?) -> boolean`
- `pressed(controller?) -> boolean`
- `released(controller?) -> boolean`
- `changed(controller?) -> boolean`
- `hold(value: T?, controller?) -> () -> ()`
- `move(value: T?, controller?) -> ()`
- `map(keyMap: Map<T>) -> ()`
- `update() -> ()`

Publicly visible fields also exist on the runtime object:

- `deadzone`
- `vector`
- `current`
- `previous`
- `active`
- `resets`
- `connections`
- `keyMap`
- `inputMap`

Practical note:

- gameplay code should usually treat these fields as readable internals, not as the primary API
- the stable usage path is through methods

## `Axis`

```luau
type Axis = {
	device: (any?) -> DeviceType,
	update: (inputs: { [any]: Input<any> }) -> nil,
	input: <T>(Map<T> | (Map<T> & { deadzone: number? })) -> Input<T>,
}
```

## Accepted Keymap Inputs

Common supported entries:

- `Enum.KeyCode.*`
- `Enum.UserInputType.MouseButton1/2/3`
- `Enum.UserInputType.MouseMovement`
- `Enum.UserInputType.MouseWheel`
- `Enum.KeyCode.Thumbstick1`
- `Enum.KeyCode.Thumbstick2`
- `UserInputService.TouchSwipe`
- `UserInputService.TouchPinch`

## Value Rules

Array-style entries:

- `Enum.KeyCode.E`
- `Enum.UserInputType.MouseWheel`

These default to modifier `1`.

Scalar keyed entries:

- `[Enum.KeyCode.A] = -1`
- `[Enum.UserInputType.MouseWheel] = 10`

Vector keyed entries:

- `[Enum.KeyCode.W] = Vector2.new(0, 1)`
- `[Enum.KeyCode.Left] = vector.create(-2, 0)`

Auto-detection rule:

- `type(modifier) ~= "number"` is treated as vector-like for several special input branches

## Deadzone Configuration

The constructor accepts `deadzone` on the keymap table:

```luau
local look = Axis.input({
	Enum.KeyCode.Thumbstick2,
	deadzone = 0.3,
})
```

Observed behavior:

- if omitted, thumbstick deadzone defaults to `0.3`
- deadzone is applied component-wise inside the thumbstick path
- the current implementation compares raw component value to the threshold rather than absolute magnitude

## Controller Parameter Semantics

Methods that accept `controller: number?` use:

- `1` for keyboard, mouse, touch, and other non-gamepad inputs
- `1` through `8` for gamepads corresponding to `Gamepad1` through `Gamepad8`

This applies to:

- `read`
- `pressing`
- `pressed`
- `released`
- `changed`
- `hold`
- `move`
