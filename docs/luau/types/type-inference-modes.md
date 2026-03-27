# Type inference modes (`--!nocheck` / `--!nonstrict` / `--!strict`)

## When to read this

- You need intuition for how inference changes between modes.

## Summary

- `--!nocheck`: no type inference; analyzer feedback is disabled.
- `--!nonstrict`: unknown/ambiguous values often become `any`, allowing code that may fail at runtime.
- `--!strict`: more precise tracking across statements; catches more mismatches (e.g. reassigning a local from number to string).

## Common migration strategy

1. Start in `--!nonstrict`.
2. Add annotations for key public APIs and data shapes.
3. Move to `--!strict` once a module’s surface is stable.

