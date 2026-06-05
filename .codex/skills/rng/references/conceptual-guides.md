# Conceptual Guides

## One Helper Surface, Multiple Randomness Sources

The library's central design is "same helper API, different generator backends."

That gives three common workflows:

- use the root module for simple gameplay randomness
- create a seeded helper with `new` for reproducible runs or tests
- create a secure helper with `new_secure` for harder-to-predict rolls

## Probability Semantics

`truth(ratio)` and `pass(ratio)` are aliases. They return `true` with probability approximately equal to `ratio`.

`skip(ratio)` flips the mental model. It returns `true` with probability approximately `1 - ratio`, which is why code like this is idiomatic:

```lua
if rng.skip(1 / 3) then
    return
end
```

That line means "skip the rest about two-thirds of the time."

## Stepped Sampling Model

The stepped helpers are inclusive at the upper bound through clamping:

- `step(max, step)` samples from `0, step, 2*step, ...` and clamps to `max`
- `range(min, max, step)` samples stepped values between bounds and clamps to `max`
- `int` and `int_range` are integer-specialized wrappers over that same logic

If `min > max`, `range` and `int_range` swap the bounds internally.

## Vector Model

`vector` and `vector_range` are component-wise wrappers over the numeric helpers.

Important behavior:

- `vector()` produces three independent ratio-like components
- `vector(max)` applies the same maximum to all three components
- `vector(x, y, z?)` uses explicit per-axis maxima
- when `z` is omitted in the `vector(x, y, z?)` overload, the runtime uses `0` for the `z` axis instead of mirroring `x` or `y`

`direction()` is separate from `vector()`. It generates a unit direction distributed over the sphere rather than axis-wise random magnitudes.

## Weighted Selection Model

`key_by_weight(weights)`:

1. sums all weights
2. samples one random number from that total
3. iterates the table and subtracts each weight until a key matches

This means the function depends on the iteration order of the weight map. For equivalent maps across different runtimes or servers, pair it with `same_iter_order` if you need deterministic traversal order.

## Deterministic Iteration Helpers

### `rarest_keys(weights)`

Returns keys ordered from lowest weight to highest weight.

### `same_iter_order(weights)`

Returns the original table with a custom `__iter` metamethod that yields keys in the weight order produced by `rarest_keys`.

This is useful when you want similarly shaped weighted tables to iterate in a stable order before doing deterministic multi-step selection across servers.

## Buffer Filling Model

`buffer(count, target?, offset?)` writes random unsigned 32-bit values in 4-byte chunks.

The key implications are:

- `count` is treated as a byte length, not as a number of random integers
- writes happen at offsets `offset, offset + 4, ...`
- if `count` is not a multiple of 4, trailing bytes are left untouched
- supplying `target` lets you reuse an existing buffer instead of allocating a new one
