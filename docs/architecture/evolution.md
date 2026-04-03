# Evolution

## Rules

- Solve the problem that exists today.
- Organize code so the next likely change still has a clean place to land.
- Delay abstractions until repetition or complexity justifies them.

## YAGNI

Do not build speculative systems for requirements that do not exist yet.

## Just-in-time structure

Add structure when a domain is real, not when it is hypothetical. Prepare code to grow by keeping boundaries clean instead of inventing extra layers early.

## Delay abstractions

Do not introduce base classes or broad hierarchies when simple tables or direct code already fit the current size of the problem.

Use the simplest representation that preserves typing and clarity. If the system grows enough that the shape becomes repetitive or hard to extend, refactor then.

When a module returns a table API, prefer declaring local functions and returning the table literal directly from `return { ... }`.
Avoid building `local module = {}` and mutating it with `function module.name()` assignments unless there is a concrete need for incremental assembly.
Wrap returned module API tables with `table.freeze({ ... })` to prevent accidental mutation of the public contract after construction.
When a `types.luau` module exists only to export types, return `nil` instead of an empty table or any other runtime value.

## Example

If there are only a few item types, keep the model simple. If dozens of item types start forcing repeated branching or duplicated contracts, that is the point to consider a larger abstraction.
