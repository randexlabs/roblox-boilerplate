# Editor Setup

## Setup

```sh
lune setup
```

This generates type definitions and creates or updates `.luaurc`.

## Repo usage

- `.config.luau`: lint and language-server config
- `.luaurc`: runtime alias config for Lune `require`

If alias resolution works in lint but fails at runtime, check `.luaurc`.
