# Foreign types from the embedder (Roblox-style)

## When to read this

- You’re using Luau in an environment with host-provided classes/enums (e.g. Roblox).

## Key points

- Host classes and datatypes can be exposed as named types (e.g. `Part`, `RaycastResult`).
- Inheritance relationships are modeled (subclass can flow into parent types).
- Enums can be exposed via an `Enum` type library (e.g. `Enum.Material`).
- Host APIs like `Instance.new` / `game:GetService` can be modeled for return types.
- `IsA` can be used to refine class types.

