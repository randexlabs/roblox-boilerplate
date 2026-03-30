# Breaking changes

Breaking changes can be indicated in either of these ways:

## `!` in the header

```text
chore!: drop Node 6 from testing matrix
```

## `BREAKING CHANGE:` in body or footer

```text
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` now refers to other config files
```

You can use both together.
