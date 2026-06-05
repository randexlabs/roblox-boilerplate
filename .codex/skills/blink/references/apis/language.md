# Blink Language API

## Top-Level Statements

Blink source is composed from:

- `option`
- `import`
- `scope`
- `type`
- `struct`
- `map`
- `set`
- `enum`
- `event`
- `function`
- `export` prefix on exportable type declarations

Options must appear at the start of the file.

## Imports

```blink
import "./external"
import "./external" as "Common"
```

Behavior:

- imported files become child scopes
- CLI imports can resolve through the filesystem
- Studio editor docs only promise sibling `./` imports
- namespace defaults to the imported filename unless `as` is used

## Scopes

```blink
scope Example {
    type Inner = u8
}
```

Behavior:

- scopes create nested runtime tables
- inner scopes capture parent declarations
- events and functions declared in scopes are nested under that scope in generated output

## Type Declarations

## `type`

Aliases a primitive or referenced type:

```blink
type Health = u8(0..100)
type User = Instance(Player)
```

## `struct`

Named product types with fixed fields:

```blink
struct Entity {
    Health: u8,
    Name: string,
}
```

Supports:

- nested inline structs
- `..OtherStruct` merge entries
- generics
- quoted field names via `["field-name"]`

## `map`

Key-value table type:

```blink
map Inventory = { [string]: u16 }
```

Rules:

- keys and values cannot be optional
- supports generics
- may carry a length range after the declaration body

## `set`

Static string-key boolean bag:

```blink
set Flags = {
    FeatureA,
    FeatureB
}
```

## `enum`

Two forms:

- unit enum: `enum State = { Idle, Moving }`
- tagged enum: `enum Message = "Type" { Join { ... }, Leave { ... } }`

Tagged enum rules:

- supports generics
- the tag field name cannot also appear inside a variant struct
- variant names may use bracketed string form when needed

## Tuples

Tuples are only relevant in data or return positions:

```blink
Data: (u8, u16, string)
Return: (boolean, string)
```

## Optional Types

Append `?` to the full type:

```blink
type Username = string(3..20)?
```

Notes:

- optionals can wrap arrays after array suffix parsing
- `unknown` does not support optional wrapping
- maps cannot directly use optional keys or values

## Arrays

Append `[]` or ranged brackets:

```blink
string[]
u8[1..16]
```

Behavior:

- plain `[]` uses the full supported array bounds
- ranges are integer-only
- arrays can themselves be made optional

## Primitive Types

Supported primitives:

- `u8`, `u16`, `u32`
- `i8`, `i16`, `i32`
- `f16`, `f32`, `f64`
- `boolean`
- `string`
- `buffer`
- `vector`
- `CFrame`
- `Color3`
- `BrickColor`
- `DateTime`
- `DateTimeMillis`
- `Instance`
- `unknown`

Primitive modifiers:

- numeric-like ranges: `u8(0..100)`, `string(3..20)`, `buffer(..900)`, `vector(0..1)`
- components: `vector<i16>`, `CFrame<i16, f16>`
- instance class restriction: `Instance(Player)`

Rules enforced by the parser:

- only primitives marked as component-capable can be used in angle-bracket encoding modifiers
- `vector` allows one component type
- `CFrame` allows two component types
- `unknown` cannot be optional

## Events

```blink
event MyEvent {
    From: Server,
    Type: Reliable,
    Call: SingleAsync,
    Data: string
}
```

Fields:

- `From`: `Server` or `Client`
- `Type`: `Reliable` or `Unreliable`
- `Call`: `SingleSync`, `ManySync`, `SingleAsync`, `ManyAsync`, `Polling`
- `Poll`: legacy boolean alias that rewrites to polling mode
- `Data`: optional type or tuple

## Functions

```blink
function Double {
    Yield: Coroutine,
    Data: f64,
    Return: f64
}
```

Fields:

- `Yield`: `Coroutine`, `Future`, `Promise`
- `Data`: optional type or tuple
- `Return`: optional type or tuple

Functions are client-to-server request/response only in the generated API model.

## Exports

```blink
export struct Payload {
    Value: u8
}
```

Rules:

- only type-like declarations are exportable
- events, functions, and scopes are not exportable
- generic declarations cannot be exported
- practical support for `Instance` and `unknown` exports should be treated as unsupported
