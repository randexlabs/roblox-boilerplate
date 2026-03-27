# Table types (unsealed / sealed / generic)

## When to read this

- You’re surprised that a table “gains” fields during inference, or stops allowing new ones.

## Unsealed tables

- Created from table literals.
- Can gain new properties as you assign them within the scope where they are constructed.

## Sealed tables

- Result from explicit annotations (or escaping the construction scope, e.g. returning from a function).
- Don’t allow adding new fields that aren’t in the type.

## Generic tables

When a parameter has no useful annotation and is used as a table, Luau infers a required interface from the accesses performed.

## Indexers (array-like tables)

Array-like tables can be written concisely as `{T}` (equivalent to `{ [number]: T }`).

