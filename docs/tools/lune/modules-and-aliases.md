# Modules And Aliases

## Relative require

Use file-relative paths:

```luau
require("./sibling")
require("../parent_sibling")
```

Rules:

- paths are case-sensitive
- use forward slashes
- supported prefixes are `./`, `../`, and `@`

## Directory modules

Requiring a directory resolves to `init.luau`.

```luau
require("./directory")
```

Inside `init.luau`, use `@self/...` to refer to files inside that directory:

```luau
require("@self/child")
```

## Alias config

Lune runtime aliases live in `.luaurc`.

Example:

```json
{
    "aliases": {
        "src": "./src"
    }
}
```

Use them with `@alias/...`:

```luau
require("@src/ServerScriptService/profiles/cache")
```

## Repo rule

- local domain modules: prefer string `require`
- runtime boundary: Roblox-style `require` is allowed
- keep `types.luau` portable
- keep runtime-bound types in `runtime_types.luau`
