---
name: git-commit
description: Write, review, or create commits that follow Conventional Commits. Use when Codex needs to choose a semantic commit type, decide whether a change is breaking, rewrite a commit message to the correct format, split a mixed worktree into atomic commits, or handle `$git-commit` requests including path-scoped commits for specific files.
---

# Git Commit

## Determine the change intent

Inspect the requested diff or file scope before writing anything.
Choose the commit type from the primary intent of the change, not from filenames alone.
Do not allow mixed concerns to collapse into one commit.
Commits must be atomic and carry one responsibility.
If the requested diff mixes responsibilities, split it into separate commits or stop and say that the branch needs to be separated first.

Treat "commit everything" as permission to commit all pending work, not permission to merge unrelated changes into one commit.
Default to partitioning the worktree by responsibility before staging anything.

## Partition the worktree first

When the user asks to commit changes, inspect the full staged or unstaged scope first.

1. Group files by one user-visible responsibility.
2. Prefer multiple small commits over one broad commit when the groups are meaningfully separable.
3. Stage only one responsibility at a time.
4. Commit each group with its own Conventional Commit header.
5. Re-check `git status` after each commit before deciding the next one.

Useful grouping heuristics:

- keep tooling/config changes separate from product code
- keep dependency changes separate from feature code unless the dependency bump is inseparable from that exact feature
- keep generated docs, skills, or references separate from runtime logic
- keep refactors separate from behavior changes unless the refactor is required to express the fix
- keep file moves/renames separate when they are the main point of the change

Only collapse groups when they are one inseparable change and would become misleading if split.

## Handle `$git-commit` invocations

Treat `$git-commit` plus one or more file paths as a request to:

1. inspect only that scope
2. stage only those paths
3. choose the appropriate Conventional Commit message
4. create the commit

Treat `$git-commit` without paths as a commit-message task unless the surrounding request clearly asks to perform the commit.

When no file paths are provided and the user clearly wants an actual commit, inspect the whole worktree and split it into atomic commits when needed.

## Format the message

Write the header as `<type>[optional scope]: <description>`.
Keep the description short, imperative, and easy to scan.
Add a scope only when it improves clarity.

Name the commit like a developer explaining the concrete change, not like a generic diff summarizer.
Prefer titles that mention the exact artifact, behavior, or operation that changed.
Avoid titles that could apply to many unrelated diffs.

Default naming rules:

- prefer `add`, `remove`, `rename`, `move`, `fix`, `handle`, `detect`, `document`, `split`, or another concrete verb tied to the actual change
- prefer naming the changed thing directly: dependency, command, module, alias, endpoint, workflow, rule, or behavior
- prefer the user-visible effect or maintainer-relevant change over the file list
- if the description could plausibly fit twenty different commits, it is too generic

Avoid vague descriptions such as:

- `update project`
- `improve docs`
- `adjust config`
- `refactor code`
- `clean up`
- `misc fixes`

These are acceptable only if the missing object is made concrete, for example:

- `docs(skills): document tint color detection caveats`
- `refactor(template): move bootstrap script to create folder`
- `chore(tooling): add luau package alias`

Use these types:

- `feat`
- `fix`
- `docs`
- `refactor`
- `perf`
- `test`
- `chore`
- `style`

## Mark breaking changes correctly

Use `!` in the header, `BREAKING CHANGE:` in the body or footer, or both.
Keep `BREAKING CHANGE:` uppercase.

## Apply repository conventions

Task branches should follow `<type>/<slug>`.
Use the scope `skills` when the commit primarily changes files under `.codex/skills`.
Use `docs(agents)` for commits that change `AGENTS.md`.
Prefer `docs(agents)` if the same commit changes both `.codex/skills` and `AGENTS.md`.

## Load references only when needed

Read the matching file under `references/` for deeper guidance:

- `types.md` for selecting the commit type
- `format.md` for message structure
- `breaking-changes.md` for breaking-change markers
- `examples.md` for concrete examples
- `faq.md` for edge cases

## Output contract

Return a Conventional Commit message.
When it adds value, include a brief note on the chosen type or scope.
When creating commits from a mixed worktree, prefer reporting the sequence of commits created rather than pretending there was a single correct umbrella message.
Prefer commit titles that sound like something a careful human maintainer would actually leave in project history.
