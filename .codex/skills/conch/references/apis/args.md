# Argument And Type Helper API

## Main Namespace

The runtime exposes argument builders under `conch.args`.

Each type constructor generally follows:

```luau
conch.args.someType(name?: string, description?: string)
```

The return value is metadata used by `conch.register`.

## Scalar And Collection Builders

### `any`

Accept any value without conversion requirements.

### `string`

Convert with `tostring`.

### `strings`

Pluralized string type.

### `number`

Convert using numeric coercion.

### `numbers`

Pluralized number type.

### `boolean`

Convert booleans, numbers, and general truthy/falsy values.

### `booleans`

Pluralized boolean type.

### `vector`

Accept a `vector` or a numeric triple-like table.

### `vectors`

Pluralized vector type.

### `player`

Accept:

- `Player`
- player name string
- user id number
- `@s`

### `players`

Pluralized player type.

Special selectors:

- `@a` for all players
- `@o` for all players except the executor, when available

### `userid`

Accept:

- raw number
- `Player`
- player name string
- `@s`

### `userids`

Pluralized user id type.

Special selector:

- `@a`

### `color`

Convert from:

- hex string
- vector
- numeric triple-like table

### `colors`

Pluralized color type.

### `duration`

Convert from number or duration text with suffixes.

## Modifiers

### `variadic(type)`

Mark an argument as varargs.

### `optional(type)` / `opt(type)`

Turn an argument into a union with `nil`.

### `literal(value, name?, description?)`

Create a literal-valued argument or type.

Useful for overload discrimination.

## Composite Type Helpers

### `union(...)`

Create a union type.

### `intersect(...)`

Create an intersection-like type.

Caveat:

- The runtime helper currently emits `kind = "intersect"` rather than the `"intersection"` tag used elsewhere.

### `struct(input, indexer?, value?)`

Create a table shape from fields and optional indexer/value typing.

Use with caution and test behavior if relying on `indexer` and `value`, because the runtime implementation contains a suspicious value assignment path.

## Enum And Dynamic Helpers

### Runtime names

- `enum_from_array(id, array, name?, description?)`
- `enum_from_map(id, map, name?, description?)`
- `dynamic(id, fn, name?, description?)`

### Older documented names

- `enum_new(options, name?, description?)`
- `enum_map(map, name?, description?)`

Interpretation:

- `enum_from_array` is the runtime equivalent of the documented `enum_new`.
- `enum_from_map` is the runtime equivalent of the documented `enum_map`.
- `dynamic` regenerates possible options from a function at suggestion/conversion time.

## Custom Type Plumbing

### `register_strange_type(data)`

Register a low-level “strange type” used by the language analysis and coercion system.

Shape:

```luau
{
	type: string,
	id: string,
	convert: ((unknown) -> T)?,
	suggestions: language.Type | ((string) -> { Suggestion })?,
	match: language.Type | ((unknown) -> boolean)?,
	exact_match: language.Type | ((unknown) -> boolean)?,
}
```

### `get_strange_type(id: string)`

Fetch a previously registered strange type by id.

### `wrap_type(type, name?, description?)`

Turn a raw analysis type into a command-argument builder.

### `pluralize(type, additional?)`

Build a plural type from a scalar strange type, optionally with extra matching and conversion behavior.

## Overloads

### `overload(overloads)`

Build an overload group.

Each overload entry is effectively:

```luau
{
	description: string,
	arguments: { Type }
}
```

The command runtime chooses the matching overload at call time based on argument type compatibility.
