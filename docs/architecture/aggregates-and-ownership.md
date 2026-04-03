# Aggregates And Ownership

## Rule

Define a clear owner for each group of state and behavior.

## Why it matters

Cross-domain changes become predictable when one root decides what is allowed. Without that ownership, scripts start reaching into each other directly and create arbitrary dependencies.

## Apply it here

- Treat `Profile` as an aggregate root when inventory mutations depend on player-level state.
- Route decisions that depend on player progression through the owning profile layer first.
- Avoid orphan scripts that coordinate shared state without an obvious owner.

## Good outcome

Inventory logic can stay focused on inventory rules while profile logic enforces player-level constraints.
