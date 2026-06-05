# Troubleshooting

## Nothing Draws

Check the setup order first:

- `jecs_gizmo.cframe`, `jecs_gizmo.position`, and `jecs_gizmo.direction` must be assigned before `jecs_gizmo.world(world)` if you want queries for those data sources.
- `jecs_gizmo.system()` must actually be running every frame.
- `jecs_gizmo.enabled` must be `true`.
- the entity must have both the required data component and the matching `gizmo.*` marker.

If you configured component ids after calling `world(world)`, call `world(world)` again so cached queries are rebuilt.

## Direction Gizmos Do Not Appear

`gizmo.direction` is stricter than `gizmo.position`.

The entity needs:

- the configured `direction` component
- plus either the configured `position` component or the configured `cframe` component

Supplying only a direction vector is not enough because the system needs an origin point.

## LookVector Gizmos Do Not Appear

`gizmo.lookvector` only queries against the configured `cframe` component.

If you only mapped `position`, or the entity only has a position component, no lookvector query exists and nothing will be drawn.

## Distance Gizmos Ignore My Custom Style

This is a real implementation mismatch.

The README says all `gizmo.*` components accept a style value, but `system()` currently calls `draw_distance(from, to)` without forwarding the style captured from the query. The helper then falls back to the default renderer style.

Practical consequence:

- custom `color`, `scale`, `alwaysOnTop`, and similar overrides do not affect distance gizmos right now

## README Style Example Uses `scale = true`

That example is wrong relative to both the TypeScript declarations and the renderer implementation.

`scale` is numeric, not boolean.

Use values such as:

- `scale = 0.1`
- `scale = 0.25`

not `scale = true`.

## The README Uses `c.cframe` In One Distance Example

That is another doc typo.

The module field for transform-like data is named `cframe`, but the README's setup section maps it from an external component often named `transform`. The distance example mixes those naming conventions.

What matters in practice is that the target entity must have whichever component id you assigned into `jecs_gizmo.cframe`.

## Reinitialization Is Global

Calling `world(world)` again overwrites module-local state and rebuilds generated component ids and cached queries on the same shared table.

If different systems assume they can configure separate worlds independently, they will step on each other.

## Undocumented Fields Exist On The Returned Lua Table

The Lua implementation exposes extra mutable fields such as:

- `default`, pointing back to the same module table
- `queries`, populated after `world(world)`

These are not part of the typed package surface and should be treated as internal bookkeeping, even though Lua callers can observe them.
