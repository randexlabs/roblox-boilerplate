# Numbers And Vectors

## Numeric Helpers

### `number()`

Signature:

```lua
helper.number(): number
helper.number(max: number): number
```

Behavior:

- with no arguments, returns the next ratio-like sample from the underlying generator
- with `max`, scales that sample by `max`

The README presents this as `[0, 1]` and `[0, max]`. In practice, exact endpoint behavior depends on the underlying generator.

### `step(max, step?)`

Signature:

```lua
helper.step(max: number, step?: number): number
```

Behavior:

- samples a stepped value starting from `0`
- uses multiples of `step`
- clamps to `max`

Typical use:

```lua
local n = rng.step(10, 2) -- 0, 2, 4, 6, 8, or 10
```

### `range(min, max, step?)`

Signature:

```lua
helper.range(min: number, max: number): number
helper.range(min: number, max: number, step: number): number
```

Behavior:

- swaps bounds internally if `min > max`
- without `step`, interpolates continuously between the bounds
- with `step`, samples stepped values and clamps to `max`

The stepped form also handles negative intervals.

## Integer Helpers

### `int(max)`

Signature:

```lua
helper.int(max: number): number
```

Behavior:

- discrete integer-like wrapper over `step(max, 1)`
- intended range is from `0` to `max`

### `int_range(min, max, step?)`

Signature:

```lua
helper.int_range(min: number, max: number): number
helper.int_range(min: number, max: number, step: number): number
```

Behavior:

- floors all bounds with `// 1`
- defaults `step` to `1`
- swaps bounds if necessary

## Vector Helpers

### `vector()`

Signature:

```lua
helper.vector(): vector
helper.vector(max: number): vector
helper.vector(x: number, y: number, z?: number, step?: number): vector
```

Behavior:

- `vector()` gives three ratio-like components
- `vector(max)` gives three components scaled to the same maximum
- `vector(x, y, z?, step?)` gives per-axis maxima, optionally stepped

Sharp edge:

- if `y` is provided and `z` is omitted, the `z` component is `0`

### `vector_range(min, max, step?)`

Signature:

```lua
helper.vector_range(min: vector, max: vector, step?: vector): vector
```

Behavior:

- samples each component independently
- supports per-axis stepping
- swaps numeric bounds component-wise through the underlying range helper when necessary

### `direction()`

Signature:

```lua
helper.direction(): vector
```

Behavior:

- generates a unit direction over the sphere
- is implemented through spherical-coordinate sampling
- is part of the public runtime and typings even though the README's API section omits it

## Buffer Helper

### `buffer(count, target?, offset?)`

Signature:

```lua
helper.buffer(count: number, target?: buffer, offset?: number): buffer
```

Behavior:

- creates a new buffer if `target` is omitted
- otherwise writes into the supplied `target`
- writes random unsigned 32-bit values at 4-byte intervals
- starts at `offset` when provided, otherwise at `0`

Important details:

- `count` is a byte count
- trailing bytes are untouched when `count` is not divisible by `4`
- the returned value is always the target buffer that was written into

## Probability Helpers

### `truth(chance)` and `pass(chance)`

Signature:

```lua
helper.truth(chance: number): boolean
helper.pass(chance: number): boolean
```

Behavior:

- `pass` is just an alias for `truth`
- returns `true` when the sampled ratio is less than or equal to `chance`

### `skip(chance)`

Signature:

```lua
helper.skip(chance: number): boolean
```

Behavior:

- returns `true` when the sampled ratio is greater than `chance`
- use it when "skip this branch" reads more naturally than "pass this branch"
