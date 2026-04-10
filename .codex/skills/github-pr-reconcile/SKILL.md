---
name: github-pr-reconcile
description: Reconcile the local repository against the real remote GitHub pull request state after pull requests are merged or left open. Use when Codex needs to inspect the user's pull requests in this repository, fast-forward `main` from `origin/main`, delete local branches whose PRs were already merged, restore or recreate the branch for an open PR, and leave the workspace on the correct branch without relying on the user to report merge status manually.
---

# GitHub PR Reconcile

Inspect local Git state and the user's GitHub pull requests before changing branches.
Treat GitHub PR state as the source of truth for deciding which local branches are stale and which branch should remain checked out at the end.

## Required behavior

Use this workflow:

1. Run `git status -sb`, inspect the current branch, and list local branches with tracking info.
2. Resolve the GitHub login when needed and list the user's recent pull requests in the repository with state `all`.
3. Map local branches to the user's PR heads.
4. If the worktree is dirty, stop all branch switching, sync, and deletion work. You may still report what would happen.
5. If the worktree is clean, switch to `main`.
6. Run `git fetch origin`.
7. Fast-forward `main` from `origin/main` only. Do not merge, rebase, stash, or reset hard.
8. Detect local branches whose matching PRs are `merged=true` and delete only those local branches.
9. Detect the user's open PRs and decide the final checked out branch:
    - If none are open, stay on `main`.
    - If exactly one is open, check out that branch.
    - If more than one is open and the starting branch matches one of them, keep that branch.
    - If more than one is open and the starting branch does not match any of them, stop and list the candidate branches.
10. If one open PR should become active but its local branch is missing, recreate it from `origin/<head>` and check it out.

## Safety rules

- Never act on pull requests that do not belong to the authenticated user.
- Never delete remote branches.
- Never delete local branches for PRs that are closed without merge.
- Never guess between multiple open PR branches unless the current branch already matches one of them.
- Never use `git pull` without an explicit fast-forward-only policy.
- Never use `git stash`, `git reset --hard`, or any destructive recovery shortcut.
- If local `main` is ahead of `origin/main`, stop and report the anomaly directly.

## Expected output

Return a short factual summary with:

- whether `main` was already current or fast-forwarded
- which local branches were deleted because their PRs were merged
- which PR branches are still open
- which branch remains checked out at the end
- any blocker that prevented sync, deletion, or branch switching

## Tool preference

Prefer local `git` for branch status, fetch, fast-forward sync, and deletion.
Use the GitHub app connector to read the user's PR states in the repository.
