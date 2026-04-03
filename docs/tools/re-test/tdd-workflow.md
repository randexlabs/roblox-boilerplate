# TDD Workflow

## Rule

- Create the `.spec.luau` file before implementing logic.
- Cover the happy path and edge cases.
- Implementation is complete only when specs pass.

## Runner

Use Re-Test:

```bash
pesde x ernisto/test -- tests
```

## Test Layout

The structure under `tests/` should mirror the structure under `src/`.

Example:

- `src/ServerScriptService/profiles/init.luau`
- `tests/ServerScriptService/profiles/init.spec.luau`

## Roblox Instance Mocks

When a test needs Roblox instances, prefer `@lune/roblox` over handwritten `:: any` tables.

Use plain table doubles only for non-Roblox collaborators such as stores, adapters, and pure contracts.

See `docs/tools/lune/api/roblox.md`.
