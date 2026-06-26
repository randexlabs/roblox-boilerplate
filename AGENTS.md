# AGENTS.md Instructions

## Services

- A `Service` is a singleton.
- Do not instantiate services with `.new()`.
- A service must own one domain responsibility.
- A service must expose a clear public API.
- Services own the authoritative business logic for their domain.
- On the server, authoritative game state lives in the service or profile layer.
- Every public mutating service API must validate domain preconditions before applying effects or mutating state.
- A service is the only module allowed to mutate the state of its own domain.
- Use `$services` in `.codex/skills/services` for the full project service specification, including domain ownership, encapsulation, validation boundaries, dependencies, UI boundaries, and `Start()` rules.

## Error Handling

- Expected operation failures must not throw.
- Unexpected programmer errors may throw.
- External failures must be handled explicitly.
- APIs that can fail must expose expected failures as values, not exceptions.
- Services must not decide UI reactions to domain failures.
- Use `$error-handling` in `.codex/skills/error-handling` for the full project error handling specification, including API contracts, structured errors, external failures, `pcall` boundaries, and programmer-error rules.

## Naming

- Public modules, classes, and services must use `PascalCase`.
- Public methods and functions must use `PascalCase`.
- Private and local functions must use `camelCase`.
- Variables and parameters must use `camelCase`.
- Types must use `PascalCase`.
- Constants must use `UPPER_SNAKE_CASE`.
- Error codes and enum-like strings must use `PascalCase`.
- Prefer names that make the intention of the code immediately clear.
- Choose names that describe responsibility, meaning, and role in the architecture, not just shape or implementation detail.
- Prefer naming that matches Roblox engine conventions when choosing between equivalent local styles.

## Luau Style

- Do not use `:` method syntax in project Luau code. Prefer `.` function declarations and calls.
- Do not model module APIs around implicit object receivers such as `self`.
- If a function genuinely needs an object-like value, pass it explicitly as a normal parameter named after its role, not `self`.
- Avoid explicit `self: typeof(ModuleName)` parameters in module functions. Prefer APIs that do not require typed `self` plumbing.
- Do not use metatables in project Luau code. Treat metatable-based design as a bad pattern unless the user explicitly asks for it.
