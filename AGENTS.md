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

Never work directly on `main`.
If a task starts while on `main`, create a task branch before making any repo changes.
Name task branches as `<type>/<slug>`, such as `fix/player-cache-leak` or `docs/agents-git-policy`.

Never commit directly on `main`.
Commits must be atomic and carry a single responsibility.
If a change mixes responsibilities, split it into multiple commits or multiple pull requests.

Pull requests must stay scoped to one responsibility.
Open pull requests in draft mode by default.
Pull request titles must follow Conventional Commits because this repository uses squash and merge.

After a pull request is merged, switch back to `main` and sync with `origin/main`.
