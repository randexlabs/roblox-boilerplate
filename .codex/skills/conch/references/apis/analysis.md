# Analysis API

## Purpose

The analysis layer powers:

- autocomplete suggestions
- replacement ranges
- inline metadata about expected arguments
- type-driven command authoring feedback

## Key Types

### `Metadata`

```ts
{
	name: string,
	description: string,
	type: string
}
```

### `Suggestion`

```ts
{
	kind?: "expression" | "assign",
	replace: vector,
	text: string,
	display: string,
	metadata?: Metadata
}
```

### Primitive And Composite Types

- `LiteralType`
- `StrangeType`
- `UnionType`
- `IntersectionType`
- `TableType`
- `FunctionType`
- `CommandType`

These combine into:

```ts
type Type =
    | LiteralType
    | TableType
    | StrangeType
    | FunctionType
    | CommandType
    | IntersectionType
    | UnionType;
```

## Command Modeling

### `CommandArgument`

```ts
{
	kind: "argument",
	name: string,
	description: string,
	type?: Type,
	varargs: boolean
}
```

### `CommandType`

```ts
{
	kind: "command",
	name: string,
	description?: string,
	arguments: CommandArgument[]
}
```

## AnalysisArgument

Used when defining analysis information for custom registered types.

Two shapes matter:

### Literal analysis argument

```ts
{
	kind: "literal",
	name: string,
	description?: string,
	value: string | boolean,
	optional: boolean
}
```

### Dynamic/custom argument

```ts
{
	kind: "argument",
	name: string,
	description?: string,
	type: string,
	unique_identifier: string,
	suggestions?: (text: string) => Suggestion[],
	optional: boolean,
	vararg: boolean
}
```

## AnalysisResult

```ts
{
	result?: {
		replace: vector,
		suggestions: Suggestion[],
		additional_info?: {
			name: string,
			description: string,
			optional: boolean,
			type: string
		}
	},
	issues: Issue[]
}
```

The runtime-facing `conch_language.analyze()` surface effectively exposes:

- `replace`
- `suggestions`
- `additional_info`
- `issues`

## Strange Types

`StrangeType` is the bridge between plain language values and Roblox/game-specific values.

Key fields:

- `type`
- `id`
- `convert`
- `suggestions`
- `match`
- `exact_match`

This is the core mechanism behind Conch’s built-in player, userid, duration, vector, and color behaviors.
