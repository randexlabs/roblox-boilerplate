# Runtime API

## `version`

Vide exports a version table:

```luau
vide.version = {
    major = number,
    minor = number,
    patch = number,
}
```

The observed exported version is `0.4.0`.

## `spring(source, period?, dampingRatio?)`

Creates a spring-following source and a control function.

```luau
function spring<T>(
    source: () -> T,
    period: number?,
    dampingRatio: number?
): (() -> T, SpringControl<T>)
```

Supported animatable shapes include:

- `number`
- `CFrame`
- `Color3`
- `UDim`
- `UDim2`
- `Vector2`
- `Vector3`
- `Rect`
- numeric arrays interpreted as packed vector data

Control function:

```luau
type SpringControl<T> = (options: {
    position: T?,
    velocity: T?,
    impulse: T?,
}) -> ()
```

Behavior:

- the spring tracks the input source reactively
- default solver stepping is tied to `RunService.Heartbeat`
- the second return value can directly override spring state or inject impulse

Parameter meaning:

- `period`: undamped cycle duration in seconds
- `dampingRatio > 1`: overdamped
- `dampingRatio = 1`: critically damped
- `dampingRatio < 1`: underdamped
- `dampingRatio = 0`: undamped oscillation

Warning:

- very large periods or damping ratios can destabilize the solver

## `step(dt)`

Advances Vide's scheduled runtime systems manually.

```luau
function step(dt: number)
```

Behavior:

- updates active springs
- updates scheduled timeouts used by delayed destruction
- on first manual use, disconnects the automatic Heartbeat stepping for the currently loaded runtime

Use this when you want deterministic manual stepping instead of Heartbeat-driven stepping.

## Scheduler Implications

Several APIs depend on runtime stepping:

- `spring()`
- delayed destruction returned from `show()`, `switch()`, `indexes()`, or `values()`

If those features appear frozen after switching to manual stepping, ensure `vide.step(dt)` continues being called.
