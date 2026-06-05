# Runtime API

## Top-Level `Axis` API

## `Axis.input(keyMap) -> Input<T>`

Creates a new input axis from a keymap.

Typical forms:

```luau
local jump = Axis.input {
	Enum.KeyCode.Space,
	Enum.KeyCode.ButtonA,
}

local move = Axis.input {
	[Enum.KeyCode.W] = Vector2.new(0, 1),
	[Enum.KeyCode.S] = Vector2.new(0, -1),
	Enum.KeyCode.Thumbstick1,
}
```

Behavior notes:

- plain array-style enum entries default to weight `1`
- keyed entries use the provided modifier or vector value
- empty maps are allowed later through `input:map({})`, but they effectively clear all mappings
- vector/scalar compatibility is checked while the map is installed

## `Axis.update(inputs: { [any]: Input<any> })`

Calls `update()` on every input object in the table.

Example:

```luau
Axis.update(inputMap)
```

This is just a convenience helper, but it is the preferred pattern when inputs are collected in one module.

## `Axis.device(inputType?) -> "Desktop" | "Touch" | "Controller"`

Returns the device class for a provided input type, or for `UserInputService:GetLastInputType()` when no argument is provided.

Recognized mappings:

- keyboard and mouse input types -> `"Desktop"`
- `Touch` -> `"Touch"`
- `Gamepad1` through `Gamepad8` -> `"Controller"`

Runtime caveat:

- unknown input names return the previous recognized device class

## `Input` Methods

## `input:read(controller?) -> (current, previous)`

Returns current and previous values for the axis on the selected controller.

Defaults:

- scalar axes default to `0`
- vector axes default to `vector.zero`

Use when you need the actual axis value, not just button-style transitions.

## `input:pressing(controller?) -> boolean`

Returns whether the current axis value is active.

Rules:

- scalar axis: active when value is not `0`
- vector axis: active when magnitude is not `0`

## `input:changed(controller?) -> boolean`

Returns whether the current value differs from the previous value.

## `input:pressed(controller?) -> boolean`

Returns true only on the frame where the axis became active.

Equivalent mental model:

- `changed() and pressing()`

## `input:released(controller?) -> boolean`

Returns true only on the frame where the axis stopped being active.

Equivalent mental model:

- `changed() and not pressing()`

## `input:hold(value?, controller?) -> () -> ()`

Adds a persistent manual value to the axis and returns a function that removes it.

Defaults:

- omitted `value` becomes `1`
- omitted `controller` becomes `1`

Typical use:

```luau
local release = aim:hold()
release()
```

Multiple holds stack by summation.

## `input:move(value?, controller?)`

Adds a manual value for one update cycle.

Defaults:

- omitted `value` becomes `1`
- omitted `controller` becomes `1`

This is the right tool for:

- toggle buttons
- per-frame gesture translation
- state-driven UI frameworks that evaluate once per frame

## `input:map(keyMap)`

Replaces the input's mappings.

Observed behavior:

- disconnects previous event connections first
- resets vector detection and rebuilds listeners
- `map({})` is treated as "clear all mappings"

## `input:update()`

Advances the axis by one frame.

What it does:

- moves `current` into `previous`
- sums active inputs into the new `current`
- clears any one-frame reset entries created by `move()`, mouse movement, mouse wheel, and other reset-style sources

## Special Source Behavior

### `MouseMovement`

- reads from `InputChanged`
- stores `vector.create(delta.X, -delta.Y) * modifier`
- clears automatically on the following update

### `MouseWheel`

- reads from `InputChanged`
- stores `object.Position.Z * modifier`
- clears automatically on the following update
- ignores processed wheel events

### `Thumbstick1` / `Thumbstick2`

- read from `InputChanged`
- store vector values per gamepad index
- pass both components through the deadzone helper

### `TouchSwipe`

- maps swipe directions to cardinal vectors
- stores the weighted vector result

### `TouchPinch`

- stores live scale while pinch is active
- clears itself when the pinch state ends
