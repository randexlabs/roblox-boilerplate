# Project Structure and Sync

## Contents

1. Core mapping rules
2. Live sync limitations
3. Folder behavior
4. Script naming and `init` semantics
5. Models
6. Data files
7. Nested projects
8. Meta files
9. Practical implications

## Core Mapping Rules

This reference explains how Rojo maps filesystem entries into Roblox instances.

### High-Level Mapping Table

| Filesystem concept | File pattern     | Roblox result                              |
| ------------------ | ---------------- | ------------------------------------------ |
| Folder             | any directory    | `Folder` by default                        |
| Server script      | `*.server.lua`   | `Script`                                   |
| Client script      | `*.client.lua`   | `LocalScript`                              |
| Module script      | `*.lua`          | `ModuleScript`                             |
| XML model          | `*.rbxmx`        | imported model                             |
| Binary model       | `*.rbxm`         | imported model                             |
| Localization table | `*.csv`          | `LocalizationTable`                        |
| Plain text         | `*.txt`          | `StringValue`                              |
| JSON module        | `*.json`         | `ModuleScript` returning a Lua table       |
| TOML module        | `*.toml`         | `ModuleScript` returning a Lua table       |
| JSON model         | `*.model.json`   | hand-authored model description            |
| Project file       | `*.project.json` | project tree definition                    |
| Meta file          | `*.meta.json`    | Rojo metadata attached to adjacent content |

## Live Sync Limitations

The docs are explicit that build support and live sync support are not identical.

Some types cannot be synchronized in real time because of Roblox Studio plugin API limitations.

Examples called out directly:

- binary data such as Terrain and CSG parts
- `MeshPart.MeshId`
- `HttpService.HttpEnabled`

When this happens, the docs recommend falling back to generating a place file and opening that output in Studio.

The docs also point users to `rbx-dom`'s type coverage chart for authoritative coverage details.

## Folder Behavior

Any directory becomes a `Folder` by default.

However, a directory can change meaning if it contains special files:

- `init.lua`
- `init.server.lua`
- `init.client.lua`
- `init.meta.json`
- `default.project.json`

These files can turn the folder into a script-like instance, attach metadata, or replace the raw folder mapping with a nested project definition.

## Script Naming and `init` Semantics

Rojo maps `.lua` files by suffix:

| Pattern           | Result         |
| ----------------- | -------------- |
| `*.server.lua`    | `Script`       |
| `*.client.lua`    | `LocalScript`  |
| any other `*.lua` | `ModuleScript` |

Rojo also reserves special `init` filenames that change the containing directory itself:

| Special file      | Result for the containing directory |
| ----------------- | ----------------------------------- |
| `init.server.lua` | `Script`                            |
| `init.client.lua` | `LocalScript`                       |
| `init.lua`        | `ModuleScript`                      |

This means a directory can stop materializing as a `Folder` and instead materialize as a script instance with children beneath it.

Important rule preserved from the docs:

- only one `init` script can exist in the same folder

## Models

Rojo supports:

- binary models: `.rbxm`
- XML models: `.rbxmx`

The docs frame these as useful for content generated in Studio or other tools. For exact property-type coverage, they defer to `rbx-dom`.

## Data Files

### Localization Tables

Any `*.csv` becomes a `LocalizationTable`.

The docs expect the CSV to use the same import/export format as Roblox localization tooling.

Example:

```csv
Key,Source,Context,Example,es
Ack,Ack!,,An exclamation of despair,¡Ay!
```

### Plain Text

Any `*.txt` becomes a `StringValue`.

The docs position this as useful for runtime-readable text data.

### JSON Modules

Any `*.json` that is not:

- a `*.model.json`
- a `*.project.json`

is turned into a `ModuleScript` that returns a Lua table matching the JSON structure.

Example JSON:

```json
{
    "Hello": "world!",
    "bool": true,
    "array": [1, 2, 3],
    "object": {
        "key 1": 1337,
        "key 2": []
    }
}
```

Expected Lua output:

```lua
return {
	Hello = "world!",
	array = {1, 2, 3},
	bool = true,
	object = {
		["key 1"] = 1337,
		["key 2"] = {},
	},
}
```

### TOML Modules

Any `*.toml` becomes a `ModuleScript` returning a Lua table, similar in spirit to JSON modules.

Specific caveat preserved from the docs:

- TOML `DateTime` values become strings, not Roblox/Luau date objects

The docs present TOML as convenient for editable configuration files.

### JSON Models

Files ending in `*.model.json` describe simple hand-authored models and are especially useful for lightweight structures such as `RemoteEvent` definitions.

Example:

```json
{
    "ClassName": "Folder",
    "Children": [
        {
            "Name": "RootPart",
            "ClassName": "Part",
            "Properties": {
                "Size": [4, 4, 4]
            }
        },
        {
            "Name": "SendMoney",
            "ClassName": "RemoteEvent"
        }
    ]
}
```

## Nested Projects

Starting in Rojo 6, project files can be included inside other project files.

The docs explain that:

- nested project reuse is supported
- projects intended to be included should describe models, not places
- if a directory contains `default.project.json`, Rojo uses that project file instead of the rest of the directory contents

This rule matters because it changes the source of truth for that subtree.

## Meta Files

Meta files were introduced in Rojo 0.5 and are named `*.meta.json`.

They let you attach Rojo-specific metadata to content defined in other formats, including scripts and imported models.

Supported metadata fields called out in the docs:

| Field                    | Purpose                                                 | Limits                                                                             |
| ------------------------ | ------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `className`              | Change a containing folder into another class           | Only valid in `init.meta.json`                                                     |
| `properties`             | Set instance properties like in project files           | Not for `.rbxm`, `.rbxmx`, or `.model.json` because those already carry properties |
| `ignoreUnknownInstances` | Same role as `$ignoreUnknownInstances` in project files | General metadata flag                                                              |

### Example: Ignoring unknown descendants

```json
{
    "ignoreUnknownInstances": true
}
```

### Example: Disabling a script

If `foo.server.lua` exists, the docs show `foo.meta.json` like this:

```json
{
    "properties": {
        "Disabled": true
    }
}
```

### Example: Turning a folder into a `Tool`

`init.meta.json`:

```json
{
    "className": "Tool",
    "properties": {
        "Grip": [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]
    }
}
```

The docs explain that the directory becomes a `Tool` instead of a `Folder`.

## Practical Implications

- Use build output when live sync limitations block a property or asset type.
- Be careful with `default.project.json`, because it replaces the default folder scan for that directory.
- `init.*` files change both instance class and hierarchy shape, so they matter for how children appear in Studio.
- Meta files are the escape hatch for attaching Rojo-specific behavior to filesystem-defined content without fully rewriting the tree into project JSON.
