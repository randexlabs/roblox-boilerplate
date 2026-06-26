---
name: services
description: Project specification for domain Services in this Roblox codebase. Use when creating, reviewing, refactoring, or reasoning about `*Service` modules, their public APIs, domain ownership, validation rules, dependencies, lifecycle, or server authority boundaries.
---

# Services

Use this skill as the project-local specification for `Service` modules.

## Guidelines

### Identity

- Treat a `Service` as a singleton.
- Do not instantiate services with `.new()`.
- Treat a service as the authoritative owner of a domain. It exposes a clear public API and owns all mutations to its domain state.

### Domain Responsibility

- Make each service own one domain responsibility.
- Treat `PetService` as the owner of pets.
- Treat `EggService` as the owner of eggs.
- Treat `CurrencyService` as the owner of currency.
- Do not create generic services such as `HelperService`.
- Do not turn a service into a bag of unrelated functions.
- If a service grows too large, first split internal implementation into regular domain modules, not additional services by default.
- Only create another service when there is a separate authoritative domain.

### Public API

- Expose a clear public API.
- Make other modules talk to a service through methods, not by mutating its internal state.
- Example public API:

```luau
PetService:GivePet(player, pet_id)
PetService:GetPets(player)
PetService:DeletePet(player, pet_uid)
```

### Encapsulation

- Keep internal state private.
- Do not expose internal tables for other modules to mutate.
- Bad:

```luau
PetService.PlayerPets[player] = {}
```

- Good:

```luau
PetService:GivePet(player, pet_id)
PetService:DeletePet(player, pet_uid)
```

### Authority

- Make services own the authoritative business logic for their domain.
- Keep authoritative game state on the server in the service or profile layer.
- Treat the client as a caller that only requests data or actions and renders the result.
- Make a service the only module allowed to mutate the state of its own domain.
- Do not bypass a service by mutating another domain's state directly.
- Let other services request changes through a service's public API, but do not let them mutate its internal state directly.

### Validation

- Do not assume the caller already validated domain rules.
- Make every public mutating service API validate domain preconditions before applying effects or mutating state.
- Do not add redundant data type checks for network payloads when Blink already enforces the networking contract.
- Treat Blink or type schemas as the answer to "is the message shape correct?"
- Treat services as the answer to "is this action valid in the current game state?"
- Validate real sanity constraints such as ownership, existence, ranges, cooldowns, progression state, currency availability, inventory capacity, duplication attempts, and impossible actions.

### Dependencies

- Allow services to depend on other services only when dependency direction stays clear and acyclic.
- Good dependency direction:

```text
EggService -> CurrencyService
EggService -> PetService
EggService -> ProfileService
```

- Bad dependency direction:

```text
EggService -> PetService -> EggService
```

### UI Boundaries

- Do not let services own UI behavior.
- Keep UI in client-side controllers or components.
- Do not let a service manipulate buttons, frames, or visual tweens.

### Lifecycle

- If a service must do setup work to become operational, such as connecting events, binding remotes, or starting timers, implement `Start()`.
- If a service does not need setup work, do not implement `Start()`.
