# Moonwave Tags And Types API

## Supported Comment Forms

Moonwave recognizes:

1. Multi-line comments:

```lua
--[=[
	@class MyClass
]=]
```

2. Triple-dash comments:

```lua
--- @class MyClass
```

Descriptions are plain non-tag lines inside the comment and support Markdown.

## Core Doc Kinds

Each doc comment should resolve to one main kind:

| Tag                   | Purpose                                          |
| --------------------- | ------------------------------------------------ |
| `@class <name>`       | Declare a class page                             |
| `@prop <name> <type>` | Declare a property                               |
| `@type <name> <type>` | Declare a named type alias                       |
| `@interface <name>`   | Declare a table/interface type with fields       |
| `@function <name>`    | Declare a function not auto-detected from source |
| `@method <name>`      | Declare a method not auto-detected from source   |
| `@within <class>`     | Attach non-class docs to a class                 |

Important rule:

- non-class doc comments need `@within`

## Interface Fields

Interfaces support two equivalent field syntaxes:

```lua
--- .Name string -- The name
--- @field ID number -- Another field
```

## Function-Specific Tags

| Tag                                     | Meaning                     |
| --------------------------------------- | --------------------------- |
| `@param <name> [type] -- [description]` | Document a parameter        |
| `@return <type> -- [description]`       | Document a return value     |
| `@error <type> -- [description]`        | Document a possible error   |
| `@yields`                               | Mark a function as yielding |

Practical rules:

- Luau annotations can auto-fill parameter and return types
- if any `@return` tag is written manually, auto-detected returns are discarded
- missing parameter type info is a validation error unless provided via `@param`
- extra `@param` entries for nonexistent parameters are validation errors

## Usage And Lifecycle Tags

| Tag                                      | Meaning                               |
| ---------------------------------------- | ------------------------------------- |
| `@tag <name>`                            | Attach a visible tag to the item      |
| `@since <version>`                       | Version introduced                    |
| `@deprecated <version> -- [description]` | Deprecation marker and migration hint |
| `@unreleased`                            | Item is pre-release only              |

## Realm Tags

These can appear together:

| Tag       | Meaning     |
| --------- | ----------- |
| `@server` | Server-only |
| `@client` | Client-only |
| `@plugin` | Plugin-only |

## Visibility Tags

| Tag        | Meaning                                   |
| ---------- | ----------------------------------------- |
| `@private` | Hidden unless private items are shown     |
| `@ignore`  | Exclude from generated public site output |

## Property-Only Tag

| Tag         | Meaning               |
| ----------- | --------------------- |
| `@readonly` | Property is read-only |

## Class-Only Tags

| Tag               | Meaning                                                                                                   |
| ----------------- | --------------------------------------------------------------------------------------------------------- |
| `@__index <name>` | Tell Moonwave which table acts as the method container instead of the default `__index` naming assumption |

## Cross-Project Type Links

| Tag                      | Meaning                                        |
| ------------------------ | ---------------------------------------------- |
| `@external <name> <url>` | Register an external type name and link target |

That type name can then be reused in params, returns, props, and interfaces.

## Type Syntax

Moonwave generally follows Luau type syntax in docs.

Supported patterns emphasized in the public docs:

- arrays: `{string}`
- unions: `number | string`
- optional args: `(arg?: string) -> ()`
- nil unions: `string | nil`
- function types: `(a: number, b: string) -> string`
- multi-return functions: `(a: number) -> (string, boolean)`
- no-return functions: `() -> ()`
- generics: `<T>(arg: T) -> T`

The docs explicitly allow readability-oriented flexibility in type examples. For documentation purposes, types do not always need to be perfectly complete Luau declarations if the meaning is clearer that way.

## Short-Link Syntax In Descriptions

Moonwave descriptions can link using:

- `[ClassName]`
- `[ClassName:method]`
- `[ClassName.member]`
- Roblox API names like `[Part]` or `[CFrame]`
