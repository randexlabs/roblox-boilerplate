## Output guidelines

After completing a task:

- Summarize changes in a few bullet points
- Mention important decisions or trade-offs
- Keep it short and direct
- Do not explain obvious steps

## Docs entrypoint

Before performing repo-specific tasks, first check `docs/index.md` and follow the relevant indexes to verify whether the repository documents conventions, workflows, or constraints that apply to the task.
If the documentation defines a convention or workflow relevant to the task, follow it.

## Security

For security-sensitive work, read `SECURITY.md`.
Use it when touching server authority, persistence/session flows, Lune tooling with filesystem/process/network access, CI/release behavior, or dependency/update surfaces.

## Git

Do not create commits unless explicitly asked.
Require confirmation before `git push`.
When the user invokes `$git-commit` followed by one or more file paths, interpret that as an explicit request to create a commit scoped to those paths.
For commit-message tasks, use the `git-commit` skill at `.codex/skills/git-commit`.
When a commit primarily changes files under `.codex/skills`, use the scope `skills`.
If `AGENTS.md` is part of the same commit, prefer `docs(agents)` over `docs(skills)`.
When creating commits, follow Conventional Commits through that skill.
Never bypass pre-commit hooks.
In this environment, run `git commit` with escalated permissions so hooks can execute outside the sandbox.

## Verification

After editing any `*.md`, `*.json`, or `*.toml` file, run `prettier --write .`.
