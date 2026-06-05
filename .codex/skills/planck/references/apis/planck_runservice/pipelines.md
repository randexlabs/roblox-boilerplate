# `planck_runservice` Pipelines

## `Pipelines`

| Export           | Meaning                               |
| ---------------- | ------------------------------------- |
| `Heartbeat`      | Multi-phase update pipeline           |
| `PreRender`      | Single-phase pre-render pipeline      |
| `PreAnimation`   | Single-phase pre-animation pipeline   |
| `PreSimulation`  | Single-phase pre-simulation pipeline  |
| `PostSimulation` | Single-phase post-simulation pipeline |

## Built-In Heartbeat Layout

The heartbeat pipeline is composed of:

- `First`
- `PreUpdate`
- `Update`
- `PostUpdate`
- `Last`

This is the main out-of-the-box ordering surface for most game logic.
