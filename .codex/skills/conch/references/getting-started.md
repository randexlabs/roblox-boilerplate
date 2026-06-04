# Getting Started

## Installation Modes

Available install routes mentioned in the material:

- Wally:
    ```toml
    conch = "alicesaidhi/conch@0.3.1"
    conch_ui = "alicesaidhi/conch-ui@0.3.1"
    ```
- pesde:
    ```sh
    pesde add alicesaidhi/conch
    pesde add alicesaidhi/conch_ui
    ```
- Standalone model:
    - Download the packaged model.
    - Keep all bundled packages together.
    - Place them where both client and server can access them, ideally a shared storage location.

## Minimal Setup

### Server

```luau
local conch = require(path.to.conch)

conch.initiate_default_lifecycle()
```

### Client

```luau
local conch = require(path.to.conch)
local ui = require(path.to.conchui)

conch.initiate_default_lifecycle()
ui.bind_to(Enum.KeyCode.F4)
```

## Why The Lifecycle Matters

`initiate_default_lifecycle()` is the glue that makes the runtime usable:

- On the server, it creates and tracks users for players, wires network handlers, replicates roles, and registers command availability per user.
- On the client, it initializes the client networking side, receives replicated commands and permissions, and announces readiness.

If you skip the lifecycle, Conch may still load as a module, but command replication, local user creation, and command execution flow will be incomplete.

## Default Commands

The default bootstrap registers basic console helpers:

- `license`
- `print`
- `sleep`
- `error`
- `warn`
- `info`
- `set`

Published docs still list `license`, `print`, `info`, `warn`, and `error`, but the runtime currently includes `sleep` and `set` as well.

## When To Use Standalone

Use the standalone bundle when you want one entry point instead of separately requiring runtime and UI:

```luau
local conch = require(path.to.standalone)

conch.initiate_default_lifecycle()
conch.ui.bind_to(Enum.KeyCode.F4)
```
