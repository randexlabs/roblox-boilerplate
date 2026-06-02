# Packaging And Compatibility

## Package Metadata

`pesde.toml` currently declares:

```toml
name = "omarcoaraujo/tint"
version = "0.1.1"
description = "Terminal string styling library for Luau"

[target]
environment = "luau"
lib = "lib/init.luau"
```

Practical implications:

- the distributed package target is `luau`
- the package entrypoint is `lib/init.luau`
- normal consumption uses `require("@pkg/tint")`

## Included Files

The package includes:

- `pesde.toml`
- `README.md`
- `LICENSE`
- `lib/**/*`

That means tests and assets are not part of the distributed runtime payload, even though they are useful for understanding behavior locally.

## Runtime-Agnostic Claim

The README describes Tint as runtime agnostic and compatible with:

- Zune
- Lune
- Lute

That claim is backed by runtime probing logic, but there are important nuances:

- Zune has explicit TTY detection
- Lune and Lute use process APIs but assume TTY
- if the expected process module cannot be required, Tint falls back to empty env/args and `"unknown"` OS

So “runtime agnostic” is best interpreted as:

- the library is designed to run across multiple Luau runtimes
- color detection quality is not identical across those runtimes

## CLI Examples In Documentation

The README uses `zune run script.luau` in examples for color-related CLI flags:

```sh
zune run script.luau --no-color
zune run script.luau --color=256
```

Those examples illustrate argument handling, not a Zune-only contract. The actual parser just reads `args` from the current runtime.

## Compatibility Caveats

- Because the package target is `luau`, package-manager tooling may not expose it as a dedicated `lute` target even though the runtime code attempts to support Lute.
- If a user asks whether Tint has a separate Lute package flavor, the accurate answer is no based on the package metadata in this repo.
- If a user asks whether Tint can still run under Lute, the accurate answer is yes by intent and implementation, subject to the runtime assumptions documented elsewhere.
