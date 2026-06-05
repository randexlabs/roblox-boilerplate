---
name: axis
description: Practical reference for Axis, a Luau input-axis library for Roblox and ECS-style game loops. Use when Codex needs to answer questions about Axis input maps, scalar and vector axes, per-frame updates, controller indexing, touch integration with hold/move, device detection, deadzones, or doc/runtime caveats.
---

# Axis

Use this skill for practical questions about the `Axis` Luau input library. Favor the exported runtime API and the observed behavior from the implementation when docs, examples, and comments disagree.

## Quick Routing

- For what Axis models, which inputs it supports well, and which parts of the API are everyday usage, read [references/overview.md](references/overview.md).
- For installation, first setup, frame-loop usage, and input-map organization patterns, read [references/getting-started.md](references/getting-started.md).
- For mental models around axis summation, vector detection, special keys, manual mobile input, and multi-controller behavior, read [references/conceptual-guides.md](references/conceptual-guides.md).
- For sharp edges, device quirks, mixed scalar/vector failures, and docs/runtime mismatches, read [references/troubleshooting.md](references/troubleshooting.md).

## API References

- Runtime constructors, helpers, and `Input` methods: [references/apis/runtime.md](references/apis/runtime.md)
- Public types, keymap shape, supported input kinds, and value rules: [references/apis/types-and-keymaps.md](references/apis/types-and-keymaps.md)

## Working Rules

- Treat `Axis.input`, `Axis.update`, and `Axis.device` as the public top-level API.
- Treat `Input` objects as frame-driven state containers. Most confusion comes from forgetting to call `update()` every frame before reading transitions.
- Be explicit about whether an axis is scalar or vector. Axis auto-detects this from the mapped values and throws if one map mixes both models.
- Preserve the distinction between persistent manual input via `hold()` and one-frame manual input via `move()`.
- Call out that some inputs are special event-driven axes: mouse movement, mouse wheel, thumbsticks, touch swipe, and touch pinch do not behave like plain digital buttons.
- When docs and implementation disagree, mention the mismatch explicitly. In particular, installation docs are inconsistent, and the controller deadzone implementation has a negative-value caveat.
