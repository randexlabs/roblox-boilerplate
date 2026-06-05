# Overview

## What jecs-utils Is

`jecs-utils` is a small helper package layered on top of `jecs`.

It does not replace the ECS core. Instead, it adds a set of convenience helpers around common query workflows, reactive observation, entity lookup by external keys, simple time throttling, and a lightweight inheritance relation.

## Core Use Cases

Use it when raw `jecs` gives you the right data model but you want less boilerplate for:

- getting the first matching entity from a query
- counting or gathering query matches without manual loops
- picking one random match from a query
- reacting to component changes or query membership changes
- collecting event payloads into an iterable queue
- mapping stable external keys to ECS entities
- propagating parent-tag or parent-value relationships through an `is_a` relation

## Public Surface

The package exports a mutable module table with:

- `query_first`
- `query_count`
- `query_entities`
- `query_random`
- `query_changed`
- `query_monitor`
- `collect`
- `interval`
- `ref`
- `is_a`
- `IsA`
- `observer`
- `monitor`
- `world`
- `__world`
- `default`

The TypeScript declarations also expose named exports for these helpers plus a default export.

## Dependency Model

The package assumes normal `jecs` usage:

- queries come from `world:query(...)`
- component ids come from `world:component()` or compatible APIs
- observer logic depends on `world:added`, `world:removed`, and `world:changed`
- `is_a` uses `jecs` pair helpers and tag detection internally

## Design Character

This package is intentionally stateful:

- `query_*` helpers are pure over the query you pass
- `observer` and `monitor` derive behavior from the world attached to that query
- `ref` stores a module-global key-to-entity table
- `is_a` allocates one module-global relation id when you bind a world
- `world(world)` mutates shared state rather than creating an isolated instance

That makes it lightweight, but it also means multi-world usage needs care.
