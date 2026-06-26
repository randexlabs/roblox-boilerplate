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
