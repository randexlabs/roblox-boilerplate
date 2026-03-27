# Compatibility: behavioral differences from Lua

## When to read this

- You expect Lua 5.x semantics and see behavior differences in Luau.

## Commonly noted differences

- Tail calls may be disabled in some Luau implementations to improve debugging/stack predictability and security checks.
- Mixed table literal assignment order can follow program order.
- Equality can call `__eq` even when `rawequal` holds (helps with NaN checking and consistent metamethod behavior).
- Some closure expressions may reuse closures in specific scenarios for efficiency (affects object identity, not call semantics).
- Some time APIs may use UTC conventions (depending on embedder).

