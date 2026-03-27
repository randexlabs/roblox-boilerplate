# Primitives and “top/bottom” types

## When to read this

- You need the set of builtin primitive types.
- You’re deciding between `any` vs `unknown`, or trying to understand `never`.

## Primitive runtime types

Common builtin runtime types include:

`nil`, `string`, `number`, `boolean`, `table`, `function`, `thread`, `userdata`, `vector`, `buffer`

Notes:

- `table` and `function` have dedicated type syntax; `userdata` is represented by concrete types; `vector` is not representable by name in plain annotations.

## `any` vs `unknown`

- `any`: opt-out of type safety; can be used as any other type.
- `unknown`: “top” type; you must refine it before using it as a more specific type.

## `never`

`never` is the “bottom” type: no values inhabit it; it can appear after impossible refinements.

## Type packs (variadics / multi-return)

Luau models variadics and multi-return with “type packs” (lists of types), e.g. generic packs like `U...`.

