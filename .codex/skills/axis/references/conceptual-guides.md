# Conceptual Guides

## Axis Values Are Sums

Axis does not model "one key equals one action result". It models an action as the sum of all currently active mapped values.

Examples:

- `A = -1`, `D = 1` means pressing both yields `0`
- two holds of `1` and `2` on the same scalar axis yield `3`
- a mouse wheel axis can read `-1`, `0`, or `1`
- a vector movement axis adds directional vectors together

This explains why `read()` can return magnitudes larger than `1` when weighted inputs stack.

## Scalar vs Vector Axes Are Auto-Detected

Axis inspects mapped values to decide whether an input is scalar or vector.

Rules from the implementation:

- plain enum entries default to scalar weight `1`
- keyed entries with numeric weights stay scalar
- thumbsticks and mouse movement are treated as vector sources
- mouse wheel and touch pinch can be scalar or vector depending on the supplied modifier type
- mixing scalar and vector contributors in one keymap throws an error

The runtime error is explicit: one input axis cannot be both vector and scalar.

## Special Keys Behave Differently

Some mapped inputs are not normal press/release buttons.

### Mouse Movement

- value is the mouse delta for the frame
- it resets automatically after update
- the Y component is inverted in the implementation

### Mouse Wheel

- value is based on wheel delta direction or magnitude provided by Roblox
- it resets automatically after update
- can be weighted to fit existing zoom logic

### Thumbsticks

- `Thumbstick1` and `Thumbstick2` read from `InputChanged`
- they use the gamepad number from `UserInputType.Gamepad1` through `Gamepad8`
- values pass through a deadzone helper before being stored

### Touch Swipe

- mapped to four cardinal vectors using swipe direction
- useful as a discrete vector action, not as a freeform drag axis

### Touch Pinch

- stores the live pinch scale while the gesture is active
- clears itself when the gesture ends
- can be used directly, or translated into per-frame `move()` input in custom mobile code

## `hold()` vs `move()`

These two methods solve different problems.

`hold()`:

- adds a value and keeps it active
- returns a release function
- best for "button is still being held" semantics

`move()`:

- adds a value for one update cycle
- is auto-cleared by the library after the next `update()`
- best for per-frame state bridges or toggle-style touch buttons

The example game uses both:

- crouch toggle button uses `move(1)`
- jump button uses `hold()`
- mobile drag and pinch logic use `move(...)` every frame

## Multi-Controller Model

Axis stores separate active/current/previous values per controller index.

Key points:

- non-gamepad input is treated as controller `1`
- gamepads are indexed from `1` to `8`
- most `Input` methods accept `controller: number?`
- `Axis.update({ ... })` updates all controllers already represented inside each input object

Typical local-multiplayer pattern:

```luau
for i = 1, 8 do
	if jump:pressed(i) then
		-- handle controller i
	end
end
```

## Device Detection Is Sticky

`Axis.device()` delegates to a helper that remembers the last recognized device.

That means:

- known desktop input returns `"Desktop"`
- known touch input returns `"Touch"`
- known gamepad input returns `"Controller"`
- unknown or unsupported input names keep the previously recognized device instead of resetting

This is useful for prompt switching, but it is not the same as a full "device capabilities" model.

## Touch UI Integration Pattern

Axis is especially useful when touch UI should feed the same gameplay systems as keyboard/mouse/controller input.

Two strong patterns from the docs and example game:

- use `InputBegan`/`InputEnded` instead of `Activated` when the player must keep dragging the camera while holding the button
- keep mobile-specific gesture interpretation outside the main gameplay systems, then feed the resulting values into shared axes

That lets the gameplay system ask only:

- `jump:released()`
- `drag:read()`
- `zoom:read()`

instead of branching deeply by device.
