# DRY (Don’t Repeat Yourself)

## What it means

DRY is about reducing duplicated *knowledge* in a codebase. Repeating the same idea in multiple places makes changes risky and inconsistent.

## When to apply

- The same business rule exists in multiple files/functions.
- You need to update several call sites every time a rule changes.
- “Fix here, forget there” bugs happen.

## When not to apply

- You’re only seeing a one-off duplication and the abstraction would be guessy.
- The shared part is tiny and the coupling would be worse than the repetition.
- The code paths look similar but have different reasons to change (different “owners”).

## Smells

- Copy/paste with tiny edits.
- Multiple validators for the same input shape.
- Same conditional logic repeated in different layers.
- “Magic constants” duplicated.

## Refactor moves that help

- Extract pure helper functions for shared rules.
- Centralize configuration/constants.
- Introduce a small module that owns the rule (single source of truth).
- Prefer data-driven tables/maps over repeated branching when it clarifies.

## Quick check

If you can explain the rule once, you should usually implement it once.

