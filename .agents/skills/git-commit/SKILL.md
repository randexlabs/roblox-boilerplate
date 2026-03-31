---
name: git-commit
description: Write, review, or create commits that follow Conventional Commits. Use when Codex needs to choose a semantic commit type, decide whether a change is breaking, rewrite a commit message to the correct format, or handle `$git-commit` requests including path-scoped commits for specific files.
---

# Git Commit

## Determine the change intent

Inspect the requested diff or file scope before writing anything.
Choose the commit type from the primary intent of the change, not from filenames alone.
Prefer splitting mixed concerns into separate commits instead of forcing one overloaded message.

## Handle `$git-commit` invocations

Treat `$git-commit` plus one or more file paths as a request to:

1. inspect only that scope
2. stage only those paths
3. choose the appropriate Conventional Commit message
4. create the commit

Treat `$git-commit` without paths as a commit-message task unless the surrounding request clearly asks to perform the commit.

## Format the message

Write the header as `<type>[optional scope]: <description>`.
Keep the description short, imperative, and easy to scan.
Add a scope only when it improves clarity.

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

Use the scope `skills` when the commit primarily changes files under `.agents/skills`.
Use `docs(agents)` for commits that change `AGENTS.md`.
Prefer `docs(agents)` if the same commit changes both `.agents/skills` and `AGENTS.md`.

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
