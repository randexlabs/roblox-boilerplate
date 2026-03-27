---

name: conventional-commits
description: |
  Write and review Git commit messages using the Conventional Commits spec. Use when you need a commit message suggestion, need to convert an existing message to Conventional Commits, or want to validate that a message correctly signals type/scope/breaking changes.
---

---

# Conventional Commits

## Goal

Produce Conventional Commits messages that are accurate, consistent, and informative.

## Inputs to request (only if missing)

- What changed (1–3 sentences or diff summary)
- Desired scope (if any)
- Whether it is a breaking change

## Workflow

1. Determine `type`
   - Prefer the smallest truthful type: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `build`, `ci`, `perf`, `style`, `revert`.
2. Determine optional `scope`
   - Use a concrete subsystem/package (e.g., `docs`, `api`, `cli`, `auth`), not vague nouns.
3. Determine breaking change marker
   - If breaking: add `!` and include a `BREAKING CHANGE:` footer (or equivalent per the repo guide).
4. Write the subject
   - Imperative, present tense, no trailing period, keep it short and specific.
5. Add body/footers only when they add value
   - Body: why / context / notable constraints.
   - Footers: issue refs, breaking change explanation.

## Output

- Provide 1 recommended commit message.
- If ambiguous, provide up to 3 alternatives and explain the trade-off (type vs scope vs breaking).

## Reference

Follow this repo’s guide as the source of truth:

- `docs/guides/git/conventional-commits/index.md`
