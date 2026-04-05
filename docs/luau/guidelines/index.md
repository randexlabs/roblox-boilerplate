# Luau Guidelines

Structured guide to conventions and preferred patterns for writing Luau with strong typing, better DX, and less ambiguity.

## Topics

- `principles.md`: baseline rules for typing, simplicity, immutability, and the DX versus performance trade-off
- `organization.md`: module organization, library splitting, and implementation-detail boundaries
- `requires-and-paths.md`: rules for `require`, import ordering, absolute paths, and exceptions for `stories` and `tests`
- `control-flow.md`: truthiness, explicit checks, defaults, short-circuiting, and ternary patterns
- `public-api-and-types.md`: typing public APIs, indexed tables, and the semantics of `nil` and return values
- `enums-and-iteration.md`: `string literal unions`, `exhaustive match`, and `generalized iteration`
- `asserts.md`: correct use of `assert`, `typeof`, and narrowing at uncontrolled boundaries
- `metatables.md`: why to avoid `metatables` and the exception for `weak tables`
- `roblox.md`: Roblox-specific rules for `GetService`, `workspace`, `UDim2`, and script layout
