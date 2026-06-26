---
name: error-handling
description: Project specification for error handling in this Roblox codebase. Use when designing, reviewing, refactoring, or implementing fallible APIs, service failure contracts, structured gameplay errors, external boundary handling, or programmer-error assertions.
---

# Error Handling

Use this skill as the project-local specification for error handling.

## Guidelines

### Failures

- Expected operation failures must not throw.
- Unexpected programmer errors may throw.
- External failures must be handled explicitly.
- Expected operation failures must be returned as structured errors, whether they are gameplay failures, validation failures, or external failures.

### API Contract

- APIs that can fail must expose expected failures as values, not exceptions.
- Prefer a shared `Result` shape for public service APIs that can fail.
- Do not mix thrown errors with returned gameplay failures in the same API.
- Keep the failure contract explicit and consistent for each public API.
- Public APIs that return expected failures must return structured error values with a stable `code` field.

### Shared Result

- Use `ReplicatedStorage/Shared/Result.luau` to standardize the result contract for public fallible APIs.
- Public APIs with expected failures should return success values through `Result.Ok(...)` and failure values through `Result.Err(...)`.
- `Result.luau` standardizes the return shape, while this specification defines the error-handling rules and caller responsibilities.

### Error Code Catalogs

- Store shared domain error code catalogs under `ReplicatedStorage/Errors`.
- Prefer one module per domain, such as `WebhookErrors`, `CurrencyErrors`, or `ProfileErrors`.
- Let error code modules own stable code names, but do not turn them into UI, localization, or logging modules.
- Keep `Result.luau` focused on the result contract; domains own their error codes.
- Good:

```luau
local result = EggService:Hatch(player, egg_id)

if not result.ok then
	return Result.Err(result.error)
end

return Result.Ok(result.value)
```

- Bad:

```luau
local result = EggService:Hatch(player, egg_id)

if result.error == "NotEnoughCurrency" then
	error(result)
end
```

### Error Representation

- Gameplay failures must return structured errors, not free-form strings.
- Validation failures and external failures should also return structured errors, not free-form strings.
- Errors should be machine-readable before being human-readable.
- Prefer stable error codes over localized messages.
- Error codes should describe the failure reason, not the UI response.
- Treat `code` as a required part of the contract for expected failures in public APIs.
- Prefer structured diagnostic context over verbose human-facing messages.
- When an expected failure benefits from investigation, include useful structured context such as operation name, relevant inputs, and original cause.
- Human-readable text is secondary to stable `code` values and actionable diagnostic context.
- Include only diagnostic context that materially helps investigation.
- Do not attach large payload dumps, unrelated state, or noisy context to structured errors.
- Do not include sensitive data in diagnostic context.
- Keep diagnostic context focused, intentional, and bounded.
- Good:

```luau
return Result.Err({
	code = "NotEnoughCurrency",
	currency = "Coins",
	required = price,
})
```

- Bad:

```luau
return Result.Err("not enough coins")
```

### Responsibility

- A service is responsible for deciding whether an operation succeeds or fails.
- Callers are responsible for deciding how to react to the failure.
- Services must not decide UI reactions to domain failures.

### Callers

- Callers of public fallible APIs must handle the failure branch explicitly before using the success payload.
- Do not assume success when calling a public API that returns a shared `Result`.
- Branch on `result.ok` first, then treat the payload as either `result.value` or `result.error`.
- Callers should `warn()` when a failed operation needs local diagnostic visibility and no better logging path exists.
- Prefer warning on unexpected, fallback, or externally-caused failures.
- Do not spam `warn()` for every routine domain failure that is already intentionally handled.
- When warning, include stable `code` values and relevant diagnostic context.

### External APIs

- Calls to external systems such as `DataStore`, `MessagingService`, `MarketplaceService`, `TeleportService`, and `HttpService` must be treated as fallible.
- Handle external failures explicitly instead of assuming success.
- Use `pcall` only around fallible external calls or boundaries that may throw unexpectedly, not around normal gameplay control flow.

### Programmer Errors

- Impossible states indicate bugs and should fail loudly.
- Do not silently recover from violated internal invariants.
