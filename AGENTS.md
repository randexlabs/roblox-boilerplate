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
For git-related tasks, check `docs/guides/index.md` and then follow the relevant guide under `docs/guides/git/`.
When creating commits, use Conventional Commits as documented under `docs/guides/git/`.

## Verification

After completing changes to `*.luau` files, run `mise check` and keep fixing issues and rerunning it recursively until it completes with no errors.

## Functions

Every function must prioritize Early Returns.

## Luau strictness

The repo already enables strict mode globally via `.config.luau`.
Do not add `--!strict` to `*.luau` files.
