# Overview

## What rng Is

`rng` is a small Luau random utility library that wraps one random source behind a consistent helper API.

It exposes:

- top-level convenience helpers backed by `math.random`
- seeded pseudo-random generators via `rng.new(...)`
- seeded cryptographically stronger generators via `rng.new_secure(...)`
- custom helper instances via `rng.custom(generator)`
- weighted-choice and table-selection helpers
- numeric, integer, vector, directional, and buffer utilities

## Main Value

The library gives one uniform helper surface regardless of where randomness comes from:

- Roblox's default random source through the root module
- a deterministic PRNG for reproducible sequences
- a ChaCha20-based secure generator for harder-to-predict outputs
- any caller-supplied generator that behaves like a random ratio source

That means most code can be written once against the helper methods and later switch to a different randomness source without rewriting call sites.

## Runtime Shape

The root module exports both:

- constructor-style functions such as `new`, `new_secure`, and `custom`
- direct helper functions such as `number`, `range`, `vector`, `key_by_weight`, and `write_shuffle`

Constructed helpers expose the same operational methods as the root module's helper subset.

## Supported Environments

The README presents two intended usage modes:

- Roblox, by requiring the package from `ReplicatedStorage.Packages`
- pure Luau, by requiring `@pkg/rng`

The implementation relies on Luau/Roblox-style primitives such as `buffer`, `vector`, `bit32`, `table.freeze`, and related standard library functions. In practice, "pure Luau" still needs an environment that provides these features.

## Generator Families

### `rng.new(seed?)`

Returns a deterministic helper powered by a 128-bit state PRNG. The README calls it "Shoroshiro128", while the implementation is an xoroshiro-style generator with four 32-bit state words. Treat it as the non-cryptographic deterministic option.

### `rng.new_secure(seed?, salt?)`

Returns a deterministic helper backed by a ChaCha20-style block generator. This is the option intended for outputs that should be much harder to predict from observed samples.

### `rng.custom(generator)`

Wraps a caller-supplied function and exposes the standard helper methods on top of it. The wrapper does not validate the generator's output range; it assumes the function behaves like a ratio source.
