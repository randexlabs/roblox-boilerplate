# SRP (Single Responsibility Principle)

## What it means

A module/function should have one reason to change. SRP is about aligning code boundaries with change boundaries (ownership, policy, and volatility).

## When to apply

- One file mixes unrelated concerns (e.g., parsing + I/O + domain rules).
- Changes for one feature keep breaking other behavior.
- Tests are hard because everything is entangled.

## Smells

- A function that both *decides* and *does* (policy + side effects).
- A module that touches many subsystems (network + storage + UI).
- “God objects” that know too much.
- Long parameter lists that indicate too many responsibilities.

## Refactor moves that help

- Split policy from mechanism (pure “compute” vs “apply”).
- Separate orchestration from domain logic.
- Extract adapters for external systems (Datastore, HTTP, UI).
- Create small, explicit interfaces between layers.

## Quick check

If two different stakeholders could ask for changes in this code, it probably needs splitting.

