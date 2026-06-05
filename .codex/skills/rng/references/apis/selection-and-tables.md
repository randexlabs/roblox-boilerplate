# Selection And Tables

## Weighted Selection

### `key_by_weight(weights)`

Signature:

```lua
helper.key_by_weight<K>(weights: { [K]: number }): K
```

Behavior:

- sums all weights
- samples one random number against that total
- walks the table until a key claims the sampled interval

Expected usage:

- weights should be positive numbers
- decimal weights are supported

Failure and edge cases:

- an empty table raises an error
- zero or negative weights are not rejected but can make results nonsensical
- if subtraction falls through unexpectedly, the function logs a warning and falls back to any key

## Shuffle

### `write_shuffle(array)`

Signature:

```lua
helper.write_shuffle<T>(array: { T }): { T }
```

Behavior:

- shuffles the input array in place
- returns the same array reference for convenience

Use it when mutation is acceptable. If you need a non-mutating shuffle, copy the array first.

## Array Value Selection

### `value(array)`

Signature:

```lua
helper.value<T>(array: { T }): T
```

Behavior:

- returns one random element from the array
- internally samples an integer-like index

Avoid empty arrays. The runtime does not guard this well and can end up returning `nil`.

## Table Key Selection

### `key(map)`

Signature:

```lua
helper.key<K>(map: { [K]: any }): K
```

Behavior:

- collects all keys into an array
- delegates to `value(keys)`
- returns one key uniformly across the collected keys

Avoid empty maps for the same reason as `value({})`.

## Weight Ordering Helpers

### `rarest_keys(weights)`

Signature:

```lua
rng.rarest_keys<K>(weights: { [K]: number }): { K }
```

Behavior:

- returns keys sorted from the smallest weight to the largest weight
- preserves ties according to the traversal order observed while building the list

This is useful on its own when you need to inspect or prioritize rare entries.

### `same_iter_order(weights)`

Signature:

```lua
rng.same_iter_order<K>(weights: { [K]: number }): { [K]: number }
```

Behavior:

- returns the original weight map, not a copy
- attaches a custom `__iter` metamethod
- iterates keys using the order produced by `rarest_keys`

Use it when deterministic traversal order matters to later logic, especially when repeated weighted choice must stay aligned across equivalent data sets.
