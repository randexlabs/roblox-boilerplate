# Dependency Injection

## Rule

Use dependency injection aggressively. Treat direct access to services, packages, caches, clocks, and side effects as a composition-root concern.

This is a project convention that should be followed strictly across domains.

## Why it matters

Injectable dependencies make it easier to exercise code outside Roblox Studio. That shortens feedback loops, keeps domain logic deterministic, and prevents modules from silently reaching across boundaries.

## Apply it here

- Build domain modules as factories that receive their collaborators explicitly.
- Keep `game:GetService`, package `require`s, time, waiting, and player side effects in a small composition root.
- Pass caches, stores, and policy functions into behavior modules instead of reading globals or singleton modules directly.
- Prefer extra wiring over hidden dependencies when the trade-off is clearer ownership and easier tests.

## Domain file convention

Every domain should follow this layout consistently:

- `runtime.luau`: the composition root for the domain
- `public_api.luau`: the domain's public API implementation
- `init.luau`: the stable entrypoint that reexports the public API
- `start.server.luau`: the domain boot file that registers Roblox events and starts server-side domain behavior

These roles are not optional naming suggestions. They are the default domain structure the project should follow.

## Enforcement intent

- Do not put composition logic inside `init.luau`.
- Do not expose the domain directly from `runtime.luau`.
- Do not register Roblox events or start server boot logic inside `runtime.luau`; keep that in `start.server.luau`.
- Do not turn `start.server.luau` into another public API; it exists to wire Roblox lifecycle events into the domain.
- Do not invent alternate filenames for the same responsibilities unless the architecture docs are updated first.
- Prefer consistency across all domains over local naming preferences.

## Good outcome

Core logic can be validated quickly without depending on full runtime bootstrapping, and each module stays narrow because it only knows the collaborators it was given.
