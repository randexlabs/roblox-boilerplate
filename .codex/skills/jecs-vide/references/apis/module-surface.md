# Module Surface

## Export Table

The default module table contains:

| Export            | Kind     | Notes                                                                                     |
| ----------------- | -------- | ----------------------------------------------------------------------------------------- |
| `world`           | function | Binds the active `jecs.World` into all hook modules and syncs `jecs-utils` if needed      |
| `useEntityGet`    | function | CamelCase alias of `use_entity_get`                                                       |
| `useEntityHas`    | function | CamelCase alias of `use_entity_has`                                                       |
| `useQueryFirst`   | function | CamelCase alias of `use_query_first`                                                      |
| `useQuery`        | function | CamelCase alias of `use_query`                                                            |
| `useTarget`       | function | CamelCase alias of `use_target`                                                           |
| `use_entity_get`  | function | Snake_case export                                                                         |
| `use_entity_has`  | function | Snake_case export                                                                         |
| `use_query_first` | function | Snake_case export                                                                         |
| `use_query`       | function | Snake_case export                                                                         |
| `use_target`      | function | Snake_case export                                                                         |
| `default`         | table    | Self-reference to the same export table                                                   |
| `__world`         | field    | Present on the table but initialized as `nil`; not used by the implementation after setup |

## Initialization API

### `world(world: jecs.World)`

Binds the package to the provided world.

Observed behavior:

```luau
function jecs_vide.world(world: jecs.World)
	if jecs_utils.__world ~= world then
		jecs_utils.world(world)
	end

	use_entity_get.world = world
	use_entity_has.world = world
	use_query_first.world = world
	use_query.world = world
	use_target.world = world
end
```

Practical implications:

- `jecs-utils` is kept on the same world when necessary.
- The package does not return a new adapter object per world.
- Rebinding changes the behavior of all existing hook closures that depend on module state.

## TypeScript Surface

The declaration file publishes:

```ts
export function world(world: World): void;
export default jecs_vide;
```

and both snake_case and camelCase hook names.

## Aliasing Rules

The library intentionally exposes both naming styles:

- snake_case for Lua/Luau callers that prefer package-local naming consistency
- camelCase for callers and generated surfaces that mirror TypeScript conventions

Explain both when documenting usage, but do not imply they are separate implementations. They point to the same underlying functions.
