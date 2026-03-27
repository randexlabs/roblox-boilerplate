# Structural typing (tables)

## When to read this

- You’re reasoning about whether one table type can be assigned to another.

## Key idea

Luau is structural by default: compatibility is based on the *shape* of values, not nominal names.

Example intuition:

- A table with *more* fields can often be used where a table with *fewer* fields is expected (width subtyping), depending on whether the target is sealed/unsealed.

See also:

- `types/tables.md` for unsealed vs sealed behavior.

