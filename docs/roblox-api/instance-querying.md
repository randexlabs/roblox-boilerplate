# Instance Querying

Use `Instance:QueryDescendants(selector)` when the task is a filtered descendant search over the Roblox tree and the selector keeps the query clearer than manual loops.

Prefer it over `GetDescendants()` plus manual filtering when the filter combines any of these:

- `ClassName`
- `.Tag`
- `#Name`
- `[Property = value]`
- `[$Attribute]`
- `[$Attribute = value]`
- `>`
- `>>`
- `,`
- `:not(...)`
- `:has(...)`

Selector examples:

- `MeshPart`
- `.Fruit`
- `#RedTree`
- `[CanCollide = false]`
- `[$FuelCapacity]`
- `[$FuelCapacity = 75]`
- `Model > .SwordPart`
- `Model >> [$OnFire = true]`
- `MeshPart.SwordPart, MeshPart[$OnFire = true]`
- `MeshPart:has(> .SwordPart)`

Prefer `CollectionService:GetTagged()` when tag lookup is the primary need and hierarchy relationships do not matter.

Prefer `FindFirstChild`, `FindFirstDescendant`, or direct references when the lookup is simple and a selector string would be harder to read than the code it replaces.

Do not use `QueryDescendants` just to be clever. If the selector becomes cryptic, use explicit code instead.
