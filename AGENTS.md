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
- Respect the Rojo tree defined in `default.project.json`.
- Do not change project mapping conventions unless the task explicitly requires it.

## Generated Artifacts

- If dependency or sourcemap-related changes require regeneration, use project commands instead of manual edits.
