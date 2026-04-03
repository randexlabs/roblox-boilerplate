# Architecture index

Project-level architecture guidance for feature boundaries, ownership, and code growth.

Consult this topic when changing domain structure, crossing subsystem boundaries, or deciding whether a new abstraction is justified.

## Topics

- `bounded-contexts.md`: keep major domains separated so changes stay local
- `aggregates-and-ownership.md`: route cross-domain changes through an owning root
- `dependency-injection.md`: keep dependencies injectable for testability and faster iteration
- `evolution.md`: prefer YAGNI, just-in-time structure, and delayed abstractions
- `runtime-portability.md`: keep domain modules portable and isolate Roblox/package types at the runtime boundary
