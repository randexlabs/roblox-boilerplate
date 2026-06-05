# Overview

`Axis` is a Roblox Luau input library that models input as weighted axes instead of isolated button callbacks. It works well for ECS-style systems because each input object is updated once per frame and then read by gameplay systems as data.

## What It Models

- An input axis is the sum of all active mapped inputs for one action or control channel.
- Axes can be scalar, like attack, crouch, or zoom direction.
- Axes can also be vector-valued, like WASD movement, camera drag, or thumbstick look.
- Inputs from keyboard, mouse, controller, and touch-adjacent helpers can feed the same axis.
- Manual inputs can be injected into an axis with `hold()` or `move()`, which is the main bridge for UI touch controls.

## Main Strengths

- Cross-device input can be unified behind one read path.
- Weighted mappings let different devices contribute different magnitudes or directions.
- Vector axes make camera and movement code much cleaner than per-key branching.
- The library can be used without ECS, but it fits best in per-frame systems.
- Touch UI can stay outside core game logic by writing to the same axes through `hold()` and `move()`.

## Everyday API

Most day-to-day usage is:

- `Axis.input(keyMap)`
- `Axis.update(inputMap)`
- `Axis.device(inputType?)`
- `input:read()`
- `input:pressing()`
- `input:pressed()`
- `input:released()`
- `input:changed()`
- `input:hold(value?, controller?)`
- `input:move(value?, controller?)`
- `input:map(newKeyMap)`

## Supported Input Sources

Standard digital inputs:

- `Enum.KeyCode.*`
- `Enum.UserInputType.MouseButton1/2/3`

Special event-driven inputs:

- `Enum.UserInputType.MouseMovement`
- `Enum.UserInputType.MouseWheel`
- `Enum.KeyCode.Thumbstick1`
- `Enum.KeyCode.Thumbstick2`
- `UserInputService.TouchSwipe`
- `UserInputService.TouchPinch`

The special inputs are important because they produce per-frame or analog-style values instead of simple begin/end button states.

## Device Model

Axis exposes three public device labels:

- `"Desktop"`
- `"Touch"`
- `"Controller"`

`Axis.device()` resolves from the provided `UserInputType`, or from `UserInputService:GetLastInputType()` when called without arguments.

One subtle behavior from the implementation:

- unknown input types do not produce a new fallback label
- instead, Axis keeps and returns the previously known device

## Public Surface vs Internal Helpers

The exported public surface is small. The package mainly exposes the Axis table and its associated types. Internal modules such as `match` and `getInputDevice` are implementation details, not standalone public APIs.
