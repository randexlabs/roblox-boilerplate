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
For commit-message tasks, use the `semantic-commit` skill at `.agents/skills/semantic-commit`.
When creating commits, follow Conventional Commits through that skill.

## Verification

After completing changes to `*.luau` files, run `mise check` and keep fixing issues and rerunning it recursively until it completes with no errors.

## Functions

Every function must prioritize Early Returns.

## Comments

Avoid comments by default. Prefer clear names, small functions, explicit contracts, and simple control flow.
Add short comments only when they explain why, record a non-obvious invariant or trade-off, note a platform quirk or workaround, justify a performance choice, or reference an external protocol or issue.
Do not comment code that is already clear.

## Luau strictness

The repo already enables strict mode globally via `.config.luau`.
Do not add `--!strict` to `*.luau` files.
