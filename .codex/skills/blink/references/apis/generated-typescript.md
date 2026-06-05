# Generated TypeScript API

## Purpose

When `Typescript = true`, Blink emits `.d.ts` files for the client and server outputs.

These declarations mirror the generated Luau runtime shape closely enough for everyday use, but they do not describe every compatibility helper present in Luau output.

## Top-Level Surface

Each declaration file includes:

- `export declare const StepReplication: () => void`
- exported `type` aliases for Blink declarations
- exported `const` entries for events, functions, and exported serializers
- nested `namespace` blocks for scopes and imports

## Event Declarations

Send-side declarations mirror Luau ownership:

- client-owned event on client: `Fire(...)`
- server-owned event on server: `Fire`, `FireAll`, `FireExcept`, `FireList`

Receive-side declarations expose:

- `On(listener)` for callback mode
- `Iter()` for polling mode

Typing notes:

- polling iterators are typed as `IterableFunction<LuaTuple<[...]>>`
- server receive-side listener signatures prepend `Player`

## Function Declarations

Server side:

- `On(listener: (Player, ...) => Return) => void`

Client side:

- `Invoke(...) => Return`
- `Invoke(...) => Promise<Return>` for `Yield: Promise`

Caveat:

- the generator does not wrap `Yield: Future` in a specific future generic type in the declaration file the way Luau runtime behavior implies; verify your version if exact TS future typing matters

## Exported Serializer Declarations

For exported types:

```ts
const Payload: {
    Read: (Buffer: buffer) => Payload;
    Write: (Value: Payload) => buffer;
};
```

## Type Mapping Notes

- Blink `unknown` becomes TypeScript `unknown`
- tuples become `LuaTuple<[...]>`
- maps become `Map<K, V>`
- optionals become `T | undefined`
- structs become object types

## Notable Mismatch vs Luau Output

Luau polling events expose deprecated `Next()` in addition to `Iter()`. The generated TypeScript declarations only expose `Iter()`.
