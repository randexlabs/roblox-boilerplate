# Strictness / type checking modes

## When to read this

- You see `--!nocheck`, `--!nonstrict`, or `--!strict` at the top of a file.
- You need to choose a mode for a module or understand analyzer output.

## File directives

Place one of these at the top of a Luau file:

- `--!nocheck`: disables the type checker for the file.
- `--!nonstrict` (default): more forgiving; ambiguous values often become `any`.
- `--!strict`: tracks types across statements more precisely; surfaces more errors.

## Practical guidance

- Use `--!strict` for library code where you want early bug detection and stable APIs.
- Use `--!nonstrict` for incremental migration or scripts with highly dynamic behavior.
- Use `--!nocheck` only as a last resort; it removes most static feedback.

