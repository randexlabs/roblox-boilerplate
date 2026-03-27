# KISS (Keep It Simple, Stupid)

## What it means

Prefer the simplest solution that is correct, understandable, and maintainable. Simplicity is a feature: it reduces bugs and speeds up changes.

## When to apply

- You’re adding complexity “just in case”.
- A design requires a long explanation to justify itself.
- A small change ripples across many files.

## Trade-offs

Simple is not the same as “quick hack”. KISS still expects:

- clear boundaries
- tests where appropriate
- boring, readable code

## Smells

- Abstractions with only one user.
- Premature generalization (“framework-y” code without demand).
- Too many knobs (config options) for a small feature.
- Over-engineered patterns (factories/builders) for plain data.

## Refactor moves that help

- Delete code before adding abstractions.
- Inline indirections that don’t buy clarity.
- Replace “clever” with explicit.
- Prefer composition over inheritance-style patterns.

## Quick check

Could a new teammate understand this in a single read without context? If not, simplify.

