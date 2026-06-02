# FAQ

## Do all contributors need to write conventional commits?

No. If the team uses squash merges, maintainers can adjust the final message during merge.

## Are types case-sensitive?

Teams should stay consistent, but `BREAKING CHANGE` should remain uppercase.

## What if a change fits multiple types?

Prefer splitting into multiple commits whenever reasonable.

## What if the user says "commit everything"?

Interpret that as scope permission, not as a request for one giant commit.

Inspect the whole worktree, separate unrelated responsibilities, and create multiple atomic commits when the split is defensible.

## When is one commit acceptable?

Use one commit only when the staged changes express one responsibility and splitting them would make the history less truthful or harder to understand.

## How small should atomic commits be?

Small enough that each commit answers one clear "why was this done?" question.

Do not split so aggressively that a single behavior change is scattered across meaningless micro-commits.

## What makes a commit title feel too generic?

If the title could describe many unrelated diffs, it is probably too generic.

Common weak patterns:

- `update project`
- `improve docs`
- `adjust config`
- `refactor code`

Prefer naming the exact changed thing and operation instead.

## Is `update` always bad?

No, but it is often lazy.

Use it only when it is genuinely the most truthful verb and the object is specific enough, such as a versioned dependency or a named generated artifact.
