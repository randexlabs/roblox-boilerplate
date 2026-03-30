---
name: semantic-commit
description: Write commit messages that follow Conventional Commits. Use when creating, reviewing, or suggesting git commit messages and the result should use a semantic type such as feat, fix, docs, refactor, perf, test, chore, or style.
---

# Semantic Commit

## Goal

Choose and format Conventional Commit messages consistently, and create scoped commits when the invocation includes file paths.

## When to use

Use this skill when:

- writing a new commit message
- rewriting a commit message to follow Conventional Commits
- choosing the right commit type for a change
- deciding whether a change is breaking
- giving commit-message suggestions during git workflows
- invoking `$semantic-commit` followed by one or more file paths to request a commit for those paths

## Invocation convention

If the user invokes `$semantic-commit` and then provides one or more file paths, treat that as a request to:

1. inspect the changes for those paths
2. stage only that scope
3. choose an appropriate Conventional Commit message
4. create the commit

If the user invokes `$semantic-commit` without paths, treat it as a commit-message task unless the surrounding request makes a full commit action explicit.

## Instructions

1. Identify the primary intent of the change before writing the message.
2. Choose a single type for that intent:
    - `feat`: new feature
    - `fix`: bug fix
    - `docs`: documentation-only change
    - `refactor`: code change that is neither a fix nor a feature
    - `perf`: performance improvement
    - `test`: add or update tests
    - `chore`: maintenance or tooling work
    - `style`: formatting-only change
3. Add an optional scope only when it makes the message clearer. Keep it short and noun-based.
4. Write the header as `<type>[optional scope]: <description>`.
5. Keep the description short, imperative, and easy to scan.
6. If the change is breaking, mark it with `!` in the header, `BREAKING CHANGE:` in the body or footer, or both.
7. If a change mixes concerns, prefer multiple commits over one overloaded message.
8. When paths are provided, stage and commit only those paths unless the user clearly asks for a wider scope.

## Rules

- Do not omit the `type`.
- Do not use a long or narrative summary line.
- Do not pick a type based on file extension alone; pick it from the actual intent.
- Do not force a scope when it adds no value.
- Use `docs(agents)` for commits that change `AGENTS.md`.
- Keep `BREAKING CHANGE:` uppercase.

## References

Read these only when needed:

- `references/types.md`: commit types and how to pick one
- `references/format.md`: message structure
- `references/breaking-changes.md`: breaking-change markers
- `references/examples.md`: concrete examples
- `references/faq.md`: edge cases

## Expected Output

Return a commit message that follows Conventional Commits, and when useful, briefly state why that type was chosen.
