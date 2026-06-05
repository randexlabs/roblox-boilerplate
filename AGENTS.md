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

## Require Resolution

- Focus on how a `require` is resolved, not on guessed textual similarity.
- Separate Luau static resolution from Roblox runtime resolution. They are related, but they are not the same thing.
- In Luau analysis, a `require` is only statically resolved when the target is statically knowable from the source expression.
- The Luau docs' `require("./bar")` example is a file-based Luau example: `./bar` is resolved relative to the current file to a sibling module. Do not project that behavior onto plain Roblox requires unless the project explicitly implements it.
- In this repository, assume plain Roblox runtime `require` resolution is Instance-based unless the project proves otherwise.
- Treat `require(script.foo)`, `require(script.Parent.foo)`, and `require(game:GetService("ServerScriptService").Folder.Module)` as normal resolvable forms when those Instances actually exist in the Rojo/DataModel tree.
- Treat a `require` target as valid only when it names or computes a real ModuleScript in the mounted DataModel hierarchy, or uses a documented project-specific require helper.
- Do not invent string-based require syntaxes such as `"src/foo"`, `"ReplicatedStorage.foo"`, `"ServerScriptService/foo"`, or alias-like filesystem paths unless the repository already defines a concrete require-by-string layer.
- Do not claim that Luau or Roblox will normalize guessed paths for us. No assumptions about implicit extension insertion, dotted-path rewriting, slash rewriting, alias expansion, or service lookup are allowed without project evidence.
- If the expression is dynamic, treat it as not statically resolved. This includes concatenated strings, conditionally selected parents, table lookups, and other computed require targets.
- If a require form is unfamiliar, verify it against the actual codebase, Rojo mapping, or documented tooling before describing it as valid.
- Prefer the existing local require style in the surrounding code instead of rewriting modules into a new access pattern.

## Luau Style

- In `*.luau`, use `snake_case` for variables, fields, function names, and function parameters.
- In `*.luau`, use `SCREAMING_SNAKE_CASE` for constants.
- In `*.luau`, use `PascalCase` for Roblox services and types.

## Generated Artifacts

- If dependency or sourcemap-related changes require regeneration, use project commands instead of manual edits.
