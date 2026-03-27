# Luau linter overview

## When to read this

- You want to understand lint warnings vs type errors.
- You need to disable or suppress lints.

## Key points

- The linter is opinionated and produces warnings; the type checker models runtime behavior more thoroughly.
- Many lints are enabled by default.

## Suppressing warnings

At the top of a file:

- Disable one warning: `--!nolint <NAME>`
- Disable all lints: `--!nolint`

Note: `--!nolint` does not disable type checking; `--!nocheck` is separate.

