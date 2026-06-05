# Constructors And Root API

## Top-Level Exports

The root module exposes both constructors and ready-to-use helper methods.

| Export                                                                                                                                                                    | Kind           | Notes                                                                 |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | --------------------------------------------------------------------- |
| `new_secure(seed?, salt?)`                                                                                                                                                | constructor    | Returns a secure helper built on a ChaCha20-style generator.          |
| `new(seed?)`                                                                                                                                                              | constructor    | Returns a deterministic non-cryptographic helper.                     |
| `custom(generator)`                                                                                                                                                       | constructor    | Wraps a custom random source in the standard helper API.              |
| `same_iter_order(weights)`                                                                                                                                                | table helper   | Returns the same weight map with a deterministic `__iter` metamethod. |
| `rarest_keys(weights)`                                                                                                                                                    | table helper   | Returns keys ordered from lowest weight to highest weight.            |
| `number`, `step`, `range`, `int`, `int_range`, `vector`, `vector_range`, `direction`, `buffer`, `truth`, `pass`, `skip`, `write_shuffle`, `key_by_weight`, `value`, `key` | helper methods | Root-level convenience helpers backed by `math.random`.               |

## `new(seed?)`

Signature:

```lua
rng.new(seed?: number | string | buffer): helper
```

Behavior:

- hashes the seed into internal 32-bit state words
- returns a helper object with the standard runtime methods
- is deterministic for the same seed and implementation

Use it for:

- reproducible tests
- deterministic gameplay rolls
- replayable simulations
- seeded procedural generation

## `new_secure(seed?, salt?)`

Signature:

```lua
rng.new_secure(seed?: number | string | buffer, salt?: buffer): helper
```

Behavior:

- derives a 32-byte key from the seed
- derives a nonce from the salt
- generates outputs from a ChaCha20-style block function
- returns the same helper surface as `new`

Use it for:

- daily rotations
- hard-to-predict weighted choice
- cases where observed outputs should not make future outputs easy to infer

## `custom(generator)`

Signature:

```lua
rng.custom(generator: () -> number): helper
```

Behavior:

- takes a caller-supplied function
- exposes the standard helper methods on top of it
- assumes the function behaves like a random ratio source
- does not validate range, entropy, or distribution quality

If the custom generator returns values outside the expected ratio-like range, higher-level helpers may behave unexpectedly.

## Shared Helper Shape

Both the root module and constructed helpers expose this operational surface:

```lua
number
step
range
int
int_range
vector
vector_range
direction
buffer
truth
pass
skip
write_shuffle
key_by_weight
value
key
```

That symmetry is the main API convenience of the package.
