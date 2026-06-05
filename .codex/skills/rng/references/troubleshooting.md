# Troubleshooting

## README And Runtime Do Not Fully Match

There are several public-surface mismatches worth calling out explicitly:

- `direction()` exists in the runtime and typings but is missing from the README API section.
- The README says `custom(generator: () -> 1..0)`. Treat that as a typo; the wrapper expects a ratio-like random function.
- The README describes `new(seed: string | any?)` and `new_secure(seed: string | any?)`, while `index.d.ts` narrows the supported seed type to `number | string | buffer`.
- The README's buffer example comment claims `rng.buffer(1024)` writes `1025 u32 values`. The implementation does not do that; it writes 4-byte chunks across the requested byte span.

## Empty Inputs Are Not Guarded Well

Avoid calling these with empty containers:

- `value({})`
- `key({})`
- `key_by_weight({})`

Observed behavior:

- `key_by_weight({})` raises an error
- `value({})` and `key({})` can end up returning `nil`, despite the typed surface implying a value is returned

## `key_by_weight` Assumes Sensible Weights

The README says weights can be positive decimal numbers. The runtime does not enforce that.

If weights are zero, negative, or otherwise pathological:

- selection semantics become hard to reason about
- the function may fail to match during the subtraction loop
- in that fallback case it prints a warning and returns an arbitrary first key if one exists

Treat positive weights as a real requirement, not just a suggestion.

## `vector(x, y, z?)` Has A Sharp Edge

When you call `vector(x, y)` without `z`, the implementation uses `0` for the `z` component.

That means:

```lua
local v = rng.vector(10, 5)
```

does not produce a random `z`; it produces `z = 0`.

## Root Module Versus Constructed Helpers

The root module's direct helpers are built from `math.random`, while constructed helpers come from the seeded PRNG, secure generator, or a custom generator.

If results differ across environments, first confirm which helper source is being used.

## Pure Luau Still Needs The Right Runtime Features

The package is presented as usable in pure Luau, but the implementation still expects Luau/Roblox primitives such as:

- `vector`
- `buffer`
- `bit32`
- `math.ldexp`
- `math.lerp`

If those are missing, the package will not run unchanged.

## Seed Failures Can Raise Errors

Both `new()` and `new_secure()` can raise an error if an internal generated value reaches a forbidden zero case. The code treats that as an invalid state, potentially caused by a bad seed.

This should be rare, but if a seed appears to break generation, try:

- a different seed format
- a different salt for `new_secure`
- reproducing with the same seed to confirm determinism
