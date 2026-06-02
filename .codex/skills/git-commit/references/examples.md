# Examples

## Simple

- `docs: fix typos in README`
- `chore(mise): add ghgrab`
- `feat(auth): add token refresh`
- `fix(parser): handle empty input`
- `docs(skills): document tint color detection caveats`
- `refactor(template): move bootstrap script to create folder`
- `chore(tooling): add luau package alias`

## With breaking change

```text
refactor(api)!: rename user endpoint

BREAKING CHANGE: `/v1/user` is now `/v1/users`
```

## Split a mixed worktree

If the pending worktree contains:

- a new dependency
- a local tooling alias
- a new documentation skill

prefer:

- `chore(tooling): add luau package alias`
- `feat(deps): add tint package dependency`
- `docs(skills): add tint docs skill`

not:

- `feat: update project with tint and docs`

## Prefer concrete names over generic ones

prefer:

- `feat(deps): add tint package dependency`
- `docs(skills): add tint docs skill`
- `fix(cli): handle --dry-run before destructive reset`

not:

- `feat: update tint integration`
- `docs: improve skill documentation`
- `fix: fix bootstrap issues`
