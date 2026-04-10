---
name: Pull Request
description: Inspect the current branch, create atomic commits when needed, push the branch, and open a technical draft pull request with a concise Conventional Commit title and a lowercase body.
---

# Pull Request

## Determine the PR intent

Inspect the local diff, branch, and target scope before writing anything.
Base the PR text on the actual change intent, not on filenames alone.
Pull requests in this repository must carry one responsibility only.
If the branch contains unrelated changes, stop and split the work before opening the PR.

## Handle `Pull Request` requests

Treat requests to use this skill as a request to:

1. inspect the current branch and diff
2. create atomic commit(s) when there are uncommitted changes
3. push the branch to the remote
4. write a Conventional Commit PR title
5. write a technical PR body in lowercase
6. open the PR as draft when the remote state allows it

If the current branch is `main`, stop and require a task branch before opening any PR.
If the repository is not connected to an accessible GitHub remote, stop and state the blocker directly.
If the local changes mix responsibilities, stop and split them into separate atomic commits or separate PRs before opening anything.

## Prefer the right tools

Use local `git` to inspect branch state, remotes, staged and unstaged diffs, and push status.
Prefer the GitHub app connector for PR creation when the repository and branch can be identified cleanly.
Use `gh` only as a fallback when connector coverage is insufficient or branch/repo inference is ambiguous.

## Write the PR title

The PR title must follow Conventional Commits because this repository uses squash and merge.
Write the header as `<type>[optional scope]: <description>`.
Keep the description short, specific, and technical.
Add a scope only when it improves clarity.

Valid examples:

- `fix: stop leaking profile cache on disconnect`
- `docs(agents): add repository git workflow policy`
- `refactor(session): separate ownership of player cleanup`

## Write the PR body

Write for fast technical review.
Keep it objective, compact, and easy to scan.
Prefer short sections with plain language over bloated templates.
Write the PR body in lowercase.

Default structure:

```md
## Summary

- ...

## Why

- ...

## Validation

- ...
```

Rules:

- State what changed in concrete terms.
- State why the change exists when the reason is not obvious from the diff.
- State validation that was actually run. Do not invent checks.
- Mention user-visible or developer-visible impact when relevant.
- Omit empty sections instead of filling them with noise.
- Do not mention AI, the assistant, generation, drafting, or any similar authorship framing.
- Keep section content technical and direct.
- Do not mention that pre-commit hooks, formatters, or routine local automation passed unless that information is unusually relevant to the review.
- Prefer the PR body to focus on the objective and scope of the change instead of routine workflow noise.

## Opening workflow

1. Inspect `git status -sb`, current branch, and the relevant diff.
2. Stop if the current branch is `main`.
3. Confirm the base branch from user input when provided; otherwise infer the repository default branch.
4. If there are uncommitted changes, group them by responsibility and create atomic commit(s) before proceeding.
5. Stop if the branch or commit set still mixes responsibilities after inspection.
6. Push the branch to the remote.
7. Open the PR as draft by default unless the user explicitly asks for ready-for-review.
8. Return the PR URL and a short factual summary of what was opened.

## Safety rules

- Never open a PR from `main`.
- Never create a single commit for mixed responsibilities.
- Never include unrelated changes in the PR description as if they were intentional.
- Never write promotional or sentimental PR copy.
- Never claim testing or validation that did not happen.
- Never mention AI authorship or assistant-driven drafting in the PR body.
- Never hide blockers such as missing auth, missing remote, or mixed-scope changes.

## Post-merge workflow

After merge, switch back to `main` and sync with `origin/main`.

## Output contract

When not opening the PR directly, return:

- the proposed PR title
- the proposed PR body
- the exact blocker or missing prerequisite

When opening the PR succeeds, return:

- the PR title
- the target base branch
- whether it was opened as draft or ready-for-review
- the PR URL
