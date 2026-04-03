## Output guidelines

After completing a task:

- Summarize changes in a few bullet points
- Mention important decisions or trade-offs
- Keep it short and direct
- Do not explain obvious steps

## Docs entrypoint

Before performing repo-specific tasks, first check `docs/index.md` and follow the relevant indexes to verify whether the repository documents conventions, workflows, or constraints that apply to the task.
If the documentation defines a convention or workflow relevant to the task, follow it.

## Architecture

For project architecture guidance, read `docs/architecture/index.md`.
Use it when working on domain boundaries, ownership, dependency injection, or abstraction decisions.

## Git

Do not create commits unless explicitly asked.
Require confirmation before `git push`.
When the user invokes `$git-commit` followed by one or more file paths, interpret that as an explicit request to create a commit scoped to those paths.
For commit-message tasks, use the `git-commit` skill at `.codex/skills/git-commit`.
When a commit primarily changes files under `.codex/skills`, use the scope `skills`.
If `AGENTS.md` is part of the same commit, prefer `docs(agents)` over `docs(skills)`.
When creating commits, follow Conventional Commits through that skill.

## Verification

After completing changes to `*.luau` files, run `mise check` and keep fixing issues and rerunning it recursively until it completes with no errors.
Never claim the task is finished while `mise check` still reports errors.
After editing any `*.md`, `*.json`, or `*.toml` file, run `prettier --write .`.

## Documentation

Every top-level service under `src/` must have a `README.md`.
Each service `README.md` must list its domains and give one short sentence for each domain's responsibility.

Every domain folder must contain a `README.md`.
That file is the ultra-concise API manual for the domain.

Domain `README.md` files are for AI consumption.
They must describe how to use the domain without reading the implementation.
Keep them as short as possible and list only public API signatures and one-line role labels when needed.

If you change a public function signature or return type, you must update that domain's `README.md` before finishing.
If you add or update a domain, you must update the owning service `README.md` before finishing.

## Functions

Every function must prioritize Early Returns.

## Comments

Avoid comments by default. Prefer clear names, small functions, explicit contracts, and simple control flow.
Add short comments only when they explain why, record a non-obvious invariant or trade-off, note a platform quirk or workaround, justify a performance choice, or reference an external protocol or issue.
Do not comment code that is already clear.

## Globals

Never use `_G`, `shared`

## Simplicity

Prefer the simplest solution that preserves typing and passes `mise check`.
Prefer inline variables and explicit `if-then-else` over trivial helper functions.
Prefer alias variables for repeated or meaningful values instead of using raw expressions directly in control flow.
Prefer naming a decision once with a local alias and reusing it instead of repeating the source expression throughout the code.
Do not extract one-off helpers for simple checks, value selection, or obvious branching.
Extract a function only for reuse, real duplication reduction, or to clarify a non-obvious rule.
Do not add defensive abstractions, `pcall`, or runtime helpers without proven need.

## Naming

Use Action-Entity-Modifier naming for variables, functions, and constants: `[Action][Entity][Modifier]`.
Examples: `update_profile_async`, `is_inventory_slot_empty`, `get_currency_multiplier_total`.

Names must stay specific enough for reliable `Ctrl+F`.
Avoid generic identifiers like `user`, `data`, `info`, `item`, `val`, `res`, `result`, `temp`, `obj`, `table`, `v`, or `i`.
Prefer names like `active_session_user`, `rarity_probability_table`, and `inventory_item_metadata`.

Inside a clear domain, avoid repeating the domain name in local symbols when the file path already provides that context.
Repeat the domain name only when a symbol crosses boundaries and would lose context without it.
Prefer names specific enough for search without echoing the file path.

Boolean names must start with `is`, `has`, `can`, or `should`.
List values should end with `List` or `Collection`.
Result values should use `[Action][Entity]Outcome`.
Include measurement units in names such as `cooldown_seconds`, `walkspeed_studs`, and `debounce_milliseconds`.

## Control Flow

Prefer explicit `if-then-else` expressions over boolean operator shortcuts when selecting values or branching behavior.
Prefer `local value = if condition then a else b` over `local value = condition and a or b`.
Use boolean operators for boolean logic, not as a substitute for control flow.
Avoid redundant conditions and unnecessary nesting when the same behavior can be expressed with flatter early returns.

## Luau strictness

The repo already enables strict mode globally via `.config.luau`.
Do not add `--!strict` to `*.luau` files.
