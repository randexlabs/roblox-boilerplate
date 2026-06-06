# AGENTS.md Instructions

## StarterPlayerScripts Mapping

- Treat the `src/StarterPlayerScripts` mapping in `default.project.json` as intentional.
- Do not criticize or suggest changing that mapping.
- Do not claim that mounting `src/StarterPlayerScripts` under `ReplicatedStorage.client` prevents scripts from running.
- Assume the project already handles client script execution.

## Validation

- Run `mise lint` on `*.luau` files before delivering any change.
- Treat `mise lint` as the required lint and typecheck validation step.
- If `mise lint` fails, keep fixing issues and rerun it until it passes.
- After `mise lint` passes, run it one more time immediately before delivery to confirm the final workspace still passes.
- Never deliver changes if the final `mise lint` run does not pass.

## Search Tools

- Prefer `rg` over slower search tools when searching files or text in this repository.

## Collaboration

- Do not do work the user did not ask for.
- Do the minimum necessary to satisfy the user's request. Do not build oversized solutions for small problems.
- When a request is ambiguous in ways that affect business rules, scope, scaling behavior, or what the system should tolerate, ask the user for clarification instead of making the decision yourself.
- Prefer short clarification loops over making broad assumptions that create avoidable follow-up rework.
- Ask at most one question per message when clarification is needed. Resolve one ambiguity at a time instead of making the user evaluate multiple contexts at once.
- Do not ask unnecessary micro-questions such as variable names when a reasonable local choice is enough.

## Protected Files

- Never rewrite lockfiles manually.
- Do not touch vendor code.
- Do not edit `roblox_packages`, `roblox_server_packages`, `luau_packages`, or `lune_packages` manually.
- Do not edit generated definition files manually: `globalTypes.d.luau` and `vectorTypes.d.luau`.

## Architecture

- Prefer extending an existing module over creating a second module for the same responsibility.
- Do not introduce parallel abstractions for a responsibility that already has a clear owner.
- Never use `_G`.
- Respect the Rojo tree defined in `default.project.json`.
- Do not change project mapping conventions unless the task explicitly requires it.

## ECS Architecture

- Use ECS as data-oriented architecture, not object-oriented architecture.
- Treat the current codebase as potentially transitional. Do not justify new design choices by copying existing bad patterns from current systems.
- In this project, entities are jecs entity IDs, components are pure data or marker tags, and systems contain behavior.
- Do not create entity classes, inheritance trees, controller objects, or components with behavior-heavy methods.

### Entities

- Entities must not store logic.
- Entities must not own other entities directly through ad hoc Lua structures.
- Express relationships through components, tags, or jecs pairs.
- Do not assume entity IDs are permanent unless the design explicitly requires that.
- Always handle missing, deleted, or stale entities safely.

### Components

- Components should be small, focused, serializable Luau data containers or marker tags.
- Prefer narrow components such as `Health`, `Velocity`, `NeedsProfileLoad`, or `AttackCooldown`.
- Avoid “god components” that mix unrelated concerns.
- Components must not contain game logic, access global mutable state, or mutate other components directly.
- If data belongs to one entity, store it as a component. Do not move entity-specific state into globals or pseudo-managers.
- Do not attach debug-oriented `jecs.Name` metadata to components by default.
- Only add component `jecs.Name` metadata when the user explicitly asks for that debug ergonomics.

### Systems

- Systems should do one job clearly.
- A system should usually query only the components it needs, iterate matching entities, and apply one kind of behavior.
- Do not make one system handle many unrelated concerns such as input, movement, UI, audio, camera, and persistence together.
- Prefer names that describe one responsibility, such as `profile_load`, `profile_unload`, `apply_velocity_system`, or `despawn_dead`.
- Avoid vague names like `Manager`, `Controller`, `Handler`, `Object`, or `Thing`.
- Treat the exported `system.name` as an operational label for tools such as Jabby and scheduler debugging, not as a filename mirror.
- Prefer short, readable names that are easy to scan in debug UIs, such as `Profile: Load`, `Profile: Unload`, or `Movement: Apply Velocity`.
- Do not mechanically copy the module filename into `system.name` when a cleaner label would be easier to read.
- Keep `system.name` concise. It should help identify the system quickly, not act as a sentence or full description.

### Queries

- Keep queries minimal.
- Request mutable access only when mutation is actually required.
- Do not request unrelated components “just in case”.
- Prefer multiple focused systems over one large query that pulls broad world state together.
- Prefer cached jecs queries over normal queries when the query shape is static and the query is reused across frames, especially inside systems.
- Treat a query as cacheable only when its component list and filters are structurally fixed.
- If a query is dynamic, ad-hoc, or assembled from runtime-varying filters or component sets, an uncached query is allowed as an exception.
- Do not create cached queries inside per-frame execution when they can be created once at module scope instead.

### Events And External Inputs

- External engine events such as `Players.PlayerAdded`, `Players.PlayerRemoving`, `RemoteEvent` traffic, or input signals should be treated as input streams, not as places to run whole gameplay flows.
- Use `jecs-utils.collect(...)` to buffer external events when a frame-driven system should consume them.
- Name values created with `collect(SomeEvent)` exactly after the source event, such as `PlayerAdded = collect(Players.PlayerAdded)` and `PlayerRemoving = collect(Players.PlayerRemoving)`.
- Keep event collection aliases, collected event streams, and local state in separate semantic declaration blocks with blank lines when that improves readability.
- Prefer converting external events into explicit ECS state such as tags, requests, or result components, and let later systems react to that state.
- Do not hide broad gameplay or persistence logic inside Roblox event callbacks if that logic can instead be expressed as state transitions in ECS.

### Async And Deferred Work

- For async work such as profile loading, HTTP, datastore access, or task-spawned background work, write the result back into ECS state using explicit result or request components.
- Prefer explicit transition components such as `NeedsProfileLoad`, `ProfileLoading`, `ProfileLoadResult`, `NeedsProfileUnload`, or `KickReason` over boolean locals or hidden callback state.
- Do not let async callbacks become the real owner of gameplay flow. They should report results back into the world, not finish whole subsystems in isolation.

### State

- Separate persistent state from temporary state.
- Persistent state includes data such as `Health`, `Position`, `Inventory`, `Faction`, or an active `Profile`.
- Temporary state includes tags or components such as `JustHit`, `NeedsProfileLoad`, `ProfileLoading`, `Lifetime`, or cooldown/timer values.
- Prefer timer or cooldown components over sleeps, hidden flags, or ad hoc one-off locals when the state matters to gameplay flow.

### Tags And Markers

- Use marker components when a category or transient state is clearer as presence/absence than as strings or enums.
- Prefer tags like `Enemy`, `Projectile`, `Dead`, or `NeedsProfileUnload` over stringly-typed `kind` fields when presence is the real meaning.

### Resources / Singletons

- Use global resources only for truly global state.
- Good global resources include things like game time, input snapshots, asset handles, global config, or the shared jecs world itself.
- Do not move entity-specific data into resources or singleton modules just to avoid making a component.

### Scheduling

- Systems should have explicit ordering only when necessary.
- When one system depends on another, encode that dependency in scheduling or document it clearly.
- Do not rely on accidental execution order between systems.

### Anti-Patterns To Avoid

- Do not model entities as rich objects with methods.
- Do not create one huge `Player` or `Enemy` data structure that contains every concern.
- Do not create systems that perform many unrelated jobs.
- Do not create components with behavior-heavy methods.
- Do not use global mutable state for entity-specific data.
- Do not use string-based entity typing where marker components are clearer.
- Do not call one system directly from another as if systems were service objects.
- Do not mutate the world unsafely during iteration when a deferred or staged approach is required.
- Do not hide core domain logic inside constructors, callbacks, or helper “manager” modules.

## Require Resolution

- Focus on how a `require` is resolved, not on guessed textual similarity.
- Separate Luau static resolution from Roblox runtime resolution. They are related, but they are not the same thing.
- In Luau analysis, a `require` is only statically resolved when the target is statically knowable from the source expression.
- The Luau docs' `require("./bar")` example is a file-based Luau example: `./bar` is resolved relative to the current file to a sibling module. Do not project that behavior onto plain Roblox requires unless the project explicitly implements it.
- In this repository, assume plain Roblox runtime `require` resolution is Instance-based unless the project proves otherwise.
- Treat `require(script.foo)`, `require(script.Parent.foo)`, and `require(game:GetService("ServerScriptService").Folder.Module)` as normal resolvable forms when those Instances actually exist in the Rojo/DataModel tree.
- Treat a `require` target as valid only when it names or computes a real ModuleScript in the mounted DataModel hierarchy, or uses a documented project-specific require helper.
- Do not invent string-based require syntaxes such as `"src/foo"`, `"ReplicatedStorage.foo"`, `"ServerScriptService/foo"`, or alias-like filesystem paths unless the repository already defines a concrete require-by-string layer.
- Never reach into package internals manually through paths such as `.pesde`, vendor folders, or transitive dependency trees to import a dependency.
- If a dependency is not available through the project's public require surface, stop and tell the user it is unavailable. Do not work around that by manually traversing package internals, and do not install or download the dependency yourself unless the user explicitly asks for that.
- Do not claim that Luau or Roblox will normalize guessed paths for us. No assumptions about implicit extension insertion, dotted-path rewriting, slash rewriting, alias expansion, or service lookup are allowed without project evidence.
- If the expression is dynamic, treat it as not statically resolved. This includes concatenated strings, conditionally selected parents, table lookups, and other computed require targets.
- Do not cast the result of `require(...)` to another type. Treat casts on module imports, including `:: any`, as forbidden by default.
- The only exceptions are when the require target is dynamic enough that a cast is genuinely unavoidable, such as dynamic require loops, or when the user explicitly asks for that cast.
- If a require form is unfamiliar, verify it against the actual codebase, Rojo mapping, or documented tooling before describing it as valid.
- Prefer the existing local require style in the surrounding code instead of rewriting modules into a new access pattern.

## Luau Style

- In `*.luau`, use `snake_case` for variables, fields, function names, and function parameters.
- In `*.luau`, use `SCREAMING_SNAKE_CASE` for constants.
- In `*.luau`, use `PascalCase` for Roblox services and types.
- For values created with `collect(SomeEvent)`, name the variable exactly after the source event, such as `PlayerAdded = collect(Players.PlayerAdded)` and `PlayerRemoving = collect(Players.PlayerRemoving)`.
- In `*.luau`, separate local variable declarations into semantic groups with blank lines when it improves readability, for example keeping helper aliases, collected events, and local state in distinct blocks.
- In `*.luau`, prefer fail-fast, early return, and guard clauses to reduce nesting.
- When an `if` cannot be avoided, prefer keeping the smaller block inside the `if` and the larger path outside it, especially when that avoids pushing code toward 80 columns.

## Function Extraction / Atomicity

- Prefer small, focused functions, but do not split code mechanically.
- Extract a function only when it has clear domain meaning, reduces duplication, isolates side effects, centralizes repeated logic, wraps an external API, builds a component payload, isolates async or error-handling behavior, or makes the main system read like a higher-level flow.
- Good extraction targets include actions such as loading a profile, ingesting a player into ECS, applying a load result, or queueing an unload request.
- Do not extract helpers whose only job is wrapping a single obvious ECS call with no extra meaning.
- Avoid trivial helpers such as `add_x`, `remove_x`, or `has_x` when they add no domain value beyond the raw ECS call.
- Do not split every line into its own function.
- Do not hide simple control flow behind many tiny helpers.
- Prefer direct code over indirection when the extracted function would make the system harder to follow.

## Generated Artifacts

- If dependency or sourcemap-related changes require regeneration, use project commands instead of manual edits.
