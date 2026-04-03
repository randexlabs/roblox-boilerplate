# Runtime Portability

## Rule

Keep domain modules portable by isolating Roblox runtime access and package-bound types at the runtime boundary.

## Requires

- Use require-by-string for local module dependencies inside a domain.
- Use Roblox-style `require` only where the domain is composed and runtime dependencies are injected.

## Types

- `types.luau`: runtime-agnostic domain types only.
- `runtime_types.luau`: Roblox/package-bound types only.

Portable modules should depend on `types.luau`.
Modules that depend on `runtime_types.luau` are part of the runtime boundary and should stay narrow.

## Good outcome

Core domain code can run under Lune and unit tests without pulling Roblox services or package aliases into every module.
