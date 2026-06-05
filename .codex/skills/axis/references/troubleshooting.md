# Troubleshooting

## `pressed()` or `released()` never fires correctly

Cause:

- `update()` was not called every frame before reading transitions

Fix:

- call `input:update()` for each axis
- or call `Axis.update(inputMap)` once per frame for the whole map

Transition helpers compare `current` against `previous`, so stale frame state breaks them immediately.

## "Input axis cannot be both vector and scalar"

Cause:

- one keymap mixed vector-style contributors and scalar-style contributors

Examples that can fail:

- `Thumbstick1` plus plain numeric keys
- `MouseMovement` plus scalar button weights
- a vector weight on one entry and numeric weights on another

Fix:

- keep one axis purely scalar or purely vector
- if needed, split one conceptual action into two axes and combine them in gameplay code

## Touch button does nothing

Common causes:

- the touch button input is being treated as processed and ignored by the gameplay-side input axis
- the UI event wiring uses the wrong event for a hold-style interaction
- `hold()` was called but its release function was never invoked

Practical fix pattern:

- use `InputBegan` and `InputEnded`
- allow touch or `MouseButton1`
- call `hold()` on begin and release the returned function on end

The example docs also note a UI caveat:

- if a touch button must allow simultaneous camera dragging, setting `Active` the wrong way can make input count as processed

## `move()` feels like it "stops working"

Cause:

- `move()` only lasts for one update cycle by design

Fix:

- call `move(...)` again each frame while the external state remains true
- use `hold()` instead if the state should persist until explicit release

## Device prompts flicker or seem wrong after an unusual input

Cause:

- `Axis.device()` keeps the last recognized device when it sees an unknown input name

Implication:

- unsupported or custom input names do not produce a neutral fallback

Use this mental model:

- Axis device detection is "last known major device class", not an exhaustive input taxonomy

## Negative thumbstick values disappear near the deadzone

Observed runtime caveat:

- the deadzone helper checks `value < deadzone`, not `math.abs(value) < deadzone`

Implication:

- any negative thumbstick component less than the deadzone threshold is zeroed, including large negative magnitudes
- example: `-0.8` is still `< 0.3`, so it becomes `0`

Treat this as an implementation bug or at least a behavioral footgun. If the question is about current runtime behavior, describe it exactly. If the user wants a fix, recommend changing the deadzone logic to use absolute value or vector magnitude.

## Installation docs disagree

Observed mismatch:

- overview docs mention both `pesde` and `Wally`
- one getting-started guide says only `pesde`
- package manifests show both `pesde` and `Wally` packaging at version `0.2.4`

Interpretation:

- Wally support exists
- the "only available on pesde" note is stale documentation

## Empty `map {}` seems to remove all input

This is expected.

The implementation intentionally treats an empty keymap as "clear all mappings". It disconnects old listeners and returns early without building new ones.

## Sunk input on `InputBegan` is ignored

Observed behavior:

- grouped digital inputs are ignored when Roblox reports `processed = true` during `InputBegan`

Implication:

- if another system or UI consumes the input first, Axis may never register the press

This matters most for touch UI, mouse-driven widgets, and games with layered input handlers.
