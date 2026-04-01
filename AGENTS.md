## Output guidelines

After completing a task:

- Summarize changes in a few bullet points
- Mention important decisions or trade-offs
- Keep it short and direct
- Do not explain obvious steps

## Docs entrypoint

Before performing repo-specific tasks, first check `docs/index.md` and follow the relevant indexes to verify whether the repository documents conventions, workflows, or constraints that apply to the task.
If the documentation defines a convention or workflow relevant to the task, follow it.

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
Do not extract one-off helpers for simple checks, value selection, or obvious branching.
Extract a function only for reuse, real duplication reduction, or to clarify a non-obvious rule.
Do not add defensive abstractions, `pcall`, or runtime helpers without proven need.

## Luau strictness

The repo already enables strict mode globally via `.config.luau`.
Do not add `--!strict` to `*.luau` files.
