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
