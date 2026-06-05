# Overview

`Blink` is a Luau-based IDL compiler for Roblox networking. You describe events, request/response functions, and shared data types in a `.blink` file, then Blink generates Luau modules for the client and server plus optional shared types and TypeScript declarations.

## What Blink Produces

- A client Luau module with fire or invoke helpers for client-owned traffic and listeners for server-owned traffic.
- A server Luau module with fire helpers for server-owned traffic and listeners for client-owned traffic.
- An optional shared Luau types module when `TypesOutput` is configured.
- Optional `.d.ts` files alongside the client and server outputs when `Typescript = true`.

## Core Model

- Events map to shared batched remote traffic over one reliable and one unreliable remote.
- Functions are request/response messages implemented on top of reliable traffic, not Roblox `RemoteFunction`.
- User-defined types are compiled into binary serializers and Luau type exports.
- Imports behave like nested scopes.
- Scopes let you organize declarations and change their generated table path.

## Main Strengths

- Bandwidth-conscious serialization with explicit type control.
- Different wire formats for reliable and unreliable traffic.
- Generated code is specialized to the schema instead of using generic serializers at runtime.
- Shared type exports can be reused outside networking.
- Optional TypeScript output helps mixed Roblox TS workflows.

## Everyday Surface Area

Most user-facing work with Blink falls into five buckets:

- Writing Blink declarations: `type`, `struct`, `map`, `set`, `enum`, `event`, `function`, `scope`, `import`, `option`, `export`
- Running the compiler: `blink file-name` or `blink file-name --watch`
- Choosing options: output paths, casing, polling, async library paths, replication mode
- Using generated modules: `Fire`, `FireAll`, `FireList`, `FireExcept`, `On`, `Invoke`, `Iter`, `StepReplication`
- Debugging parser or generated-runtime failures

## Important Behavioral Facts

- Blink always routes events through shared remotes named from `BASE_EVENT_NAME`, defaulting to the `BLINK_*_REMOTE` pattern.
- Server output auto-creates the shared reliable and unreliable remotes in `ReplicatedStorage` if they do not already exist.
- Client output expects those remotes to exist and waits for them.
- `SyncValidation` defaults to enabled when omitted.
- Generated modules export `StepReplication` even when automatic heartbeat replication is also enabled.
