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
When creating commits, use Conventional Commits as documented in `docs/guides/git/conventional-commits/index.md`.

## Verification

After completing changes to `*.luau` files, run `mise lint` and fix any reported errors before finishing the task.
If `mise lint` passes, run `mise format` to format `*.luau` files before finishing the task.

## Luau strictness

The repo already enables strict mode globally via `.config.luau`.
Do not add `--!strict` to `*.luau` files.
