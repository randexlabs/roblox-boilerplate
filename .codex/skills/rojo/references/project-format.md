# Project Format

## Contents

1. Project file schema
2. Instance descriptions
3. Property value encoding
4. Implicit vs explicit properties
5. Example layouts
6. Practical guidance

## Project File Schema

Rojo project files use the `*.project.json` extension.

The current docs describe these top-level fields:

| Field               | Required | Meaning                                                                            | Default |
| ------------------- | -------- | ---------------------------------------------------------------------------------- | ------- |
| `name`              | Yes      | Name used when building a model or place                                           | none    |
| `tree`              | Yes      | Root instance description                                                          | none    |
| `servePort`         | No       | Port used by `rojo serve` unless overridden by CLI flags                           | `34872` |
| `servePlaceIds`     | No       | Allowed place IDs for live sync, used as a safety guard                            | `null`  |
| `placeId`           | No       | Current place ID for Studio connections                                            | `null`  |
| `gameId`            | No       | Current game ID for Studio connections                                             | `null`  |
| `serveAddress`      | No       | Server bind address unless overridden by CLI flags                                 | `null`  |
| `globIgnorePaths`   | No       | Glob patterns to ignore                                                            | `[]`    |
| `emitLegacyScripts` | No       | Whether to emit `Script` and `LocalScript` instead of relying only on `RunContext` | `true`  |

## Instance Descriptions

An instance description corresponds to one Roblox instance.

### Supported Special Keys

| Key                       | Meaning                                      | Notes                                                                       |
| ------------------------- | -------------------------------------------- | --------------------------------------------------------------------------- |
| `$className`              | Roblox class name                            | Optional if `$path` is present or the node is a Roblox service              |
| `$path`                   | Filesystem path to pull from                 | Optional if `$className` is present; relative to the project file directory |
| `$properties`             | Properties to set                            | Uses Rojo property encoding                                                 |
| `$ignoreUnknownInstances` | Whether Rojo should delete unknown instances | Defaults depend on whether `$path` exists                                   |

Default behavior preserved from the docs:

- `$ignoreUnknownInstances` defaults to `false` when `$path` is specified
- otherwise it defaults to `true`

Every non-special field in an instance description becomes a child instance whose key is the instance name and whose value is another instance description.

## Property Value Encoding

Rojo supports two styles for property values:

- implicit values
- explicit values

### Implicit Values

Implicit values rely on Rojo's understanding of Roblox APIs. Rojo infers the expected property type from the class and property name.

Example from the docs:

```json
{
    "$className": "Part",
    "$properties": {
        "Anchored": true
    }
}
```

### Explicit Values

Explicit values encode the property type directly. In current Rojo docs, the property value is an object with a single key:

- the key is the property type
- the value is the encoded value for that type

Example:

```json
{
    "$className": "Part",
    "$properties": {
        "Anchored": {
            "Bool": true
        }
    }
}
```

Important caveat preserved from the docs:

- explicit values are not validated against Roblox's API by Rojo

That means a property can be encoded with a mismatched type if the user forces it.

Example preserved from the docs:

```json
{
    "$className": "Part",
    "$properties": {
        "Anchored": {
            "String": "Hello, world!"
        }
    }
}
```

The docs explain that explicit syntax is necessary when:

- Rojo does not know about a property yet
- Roblox added something newer than Rojo's API knowledge
- the property must be represented with a type different from Rojo's expectation

## Implicit vs Explicit Properties

Use implicit syntax whenever possible for readability and forward compatibility.

Use explicit syntax when you need:

- unsupported or newly added property types
- an enum or value Rojo does not yet understand
- a deliberate override of Rojo's inferred type

The property-specific encodings live in the dedicated property references.

## Example Layouts

### Simple library or model project

```json
{
    "name": "AwesomeLibrary",
    "tree": {
        "$path": "src"
    }
}
```

### Larger game layout

```json
{
    "name": "Sisyphus Simulator",
    "globIgnorePaths": ["**/*.spec.lua"],
    "tree": {
        "$className": "DataModel",

        "HttpService": {
            "$className": "HttpService",
            "$properties": {
                "HttpEnabled": true
            }
        },

        "ReplicatedStorage": {
            "$className": "ReplicatedStorage",
            "$path": "src/ReplicatedStorage"
        },

        "StarterPlayer": {
            "$className": "StarterPlayer",

            "StarterPlayerScripts": {
                "$className": "StarterPlayerScripts",
                "$path": "src/StarterPlayerScripts"
            }
        },

        "Workspace": {
            "$className": "Workspace",
            "$properties": {
                "Gravity": 67.3
            },

            "Terrain": {
                "$path": "Terrain.rbxm"
            }
        }
    }
}
```

## Practical Guidance

- Reach for `globIgnorePaths` to keep generated or test-only files out of the live tree.
- Use `servePlaceIds` as a safety barrier when a project might connect to the wrong Roblox place.
- Keep in mind that `$path` changes the default behavior of `$ignoreUnknownInstances`.
- Pair this reference with `project-structure-and-sync.md` when reasoning about how real folders and files will materialize in Studio.
