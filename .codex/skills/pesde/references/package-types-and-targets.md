# Package Types And Targets

Target-specific behavior across Luau, Lune, Roblox, binary packages, and scripts packages.

## Using Binary Packages

- Source: `docs/src/content/docs/guides/binary-packages.mdx`
- Original description: Learn how to use binary packages.

A **binary package** is a package that contains a binary export.

Binary packages can be run like a normal program. There are several ways to use
binary packages with pesde.

## Using a binary package

### With `pesde x`

The `pesde x` command can be used to run a one-off binary package. This is
useful for running a binary package without installing it or outside of a pesde
project.

```sh
pesde x pesde/hello
# Hello, pesde! (pesde/hello@1.0.0, lune)
```

### By installing

Binary packages can be installed using the `pesde add` and `pesde install`
commands.

This requires a `pesde.toml` file to be present in the current directory, and
will add the binary package to the `dependencies` section of the file.

```sh
pesde add pesde/hello
pesde install
```

This will add the binary package to your `PATH`, meaning that it can be run
anywhere in a project which has it installed under that alias!

```sh
hello
# Hello, pesde! (pesde/hello@1.0.0, lune)
```

Note that they are scoped to the nearest `pesde.toml` file. However, you can use
binaries of the workspace root from member packages.

## Making a binary package

To make a binary package you must use a target compatible with binary exports.
These currently are `lune` and `luau`.

Here is an example of a binary package:

```toml title="pesde.toml"
name = "pesde/hello"
version = "1.0.0"
license = "MIT"

[target]
environment = "lune"
bin = "main.luau"
```

The `bin` field specifies the entry point for the binary package. This file
will be run when the binary package is executed.

```luau title="main.luau"
print("Hello, pesde!")
```

Binary packages get access to custom variables provided by pesde. You can find
them in the `_G` table. These are:

- `PESDE_ROOT`: The root (where the pesde.toml is located) of where the package is
  installed. This will be in a temporary directory if the package is run with
  `pesde x`.

---

## Using Scripts Packages

- Source: `docs/src/content/docs/guides/scripts-packages.mdx`
- Original description: Learn how to use scripts packages.

> [!CAUTION]
> While scripts packages currently exist, it is intended that their functionality will be removed
> before pesde 1.0 in favour of binaries.
>
>     Take this into consideration when creating a scripts
>     package.

A **scripts package** is a package that contains scripts. The scripts provided
by the package are linked in `.pesde/{alias}/{script_name}.luau` of the project
that uses the package.

## Using a scripts package

Scripts packages can be installed using the `pesde add` and `pesde install`
commands.

This requires a `pesde.toml` file to be present in the current directory, and
will add the scripts package to the `dependencies` section of the file.

```sh
pesde add pesde/scripts_rojo
pesde install
```

This will add the scripts package to your project, and installing will put the
scripts at `.pesde/scripts_rojo/{script_name}.luau`. You can then add the scripts
to your manifest, for example:

```toml title="pesde.toml"
[scripts]
roblox_sync_config_generator = ".pesde/scripts_rojo/roblox_sync_config_generator.luau"
```

## Making a scripts package

To make a scripts package you must use a target compatible with scripts exports.
These currently are `lune` and `luau`.

Here is an example of a scripts package:

```toml title="pesde.toml"
name = "pesde/scripts_rojo"
version = "1.0.0"
license = "MIT"

[target]
environment = "lune"

[target.scripts]
roblox_sync_config_generator = "roblox_sync_config_generator.luau"
```

The `scripts` table in the target is a map of script names to the path of the
script in the package. The scripts will be linked in the project that uses the
package at `.pesde/{alias}/{script_name}.luau`.

---

## Roblox

- Source: `docs/src/content/docs/guides/roblox.mdx`
- Original description: Using pesde in a Roblox project.

pesde can be used in Roblox projects, however this requires some extra setup.
Namely, you need to specify a `roblox_sync_config_generator` script in order
to generate the adequate configuration for the sync tool you are using.

The [`pesde-scripts`](https://github.com/pesde-pkg/scripts)
repository contains a list of scripts for different sync tools. If the tool
you are using is not supported, you can write your own script and submit a PR
to get it added.

## Usage with Rojo

[Rojo](https://rojo.space/) is a popular tool for syncing files into Roblox
Studio.

Running `pesde init` will prompt you to select a target, select
`roblox` or `roblox_server` in this case. You will be prompted to pick out a
scripts package. Select `pesde/scripts_rojo` to get started with Rojo.

## Usage with other tools

If you are using a different sync tool, you should look for it's scripts
package on the registry. If you cannot find it, you can write your own and
optionally submit a PR to pesde-scripts to help others using the same tool as
you get started quicker.

Scaffold your project with `pesde init`, select the `roblox` or `roblox_server`
target, and then create a `.pesde/roblox_sync_config_generator.luau` script
and put it's path in the manifest.

When authoring packages for Roblox, it is recommended to have your code inside
of a `src` directory (or any other directory you prefer).

### Test place with Rojo

You might want to create a "test place" where you can test your package inside
Roblox, or to get proper LSP support when developing your package.

To do this, you can create a `test-place.project.json` file which includes your
package and the `roblox_packages` directory.

```json title="test-place.project.json"
{
    "tree": {
        "$className": "DataModel",
        "ReplicatedStorage": {
            "package": {
                "$className": "Folder",
                "src": {
                    "$path": "src"
                },
                "roblox_packages": {
                    "$path": "roblox_packages"
                }
            }
        }
    }
}
```

You can then run `rojo serve` with this project file:

```sh
rojo serve test-place.project.json
```

If you are using [Luau LSP](https://github.com/JohnnyMorganz/luau-lsp) you can
change the `luau-lsp.sourcemap.rojoProjectFile` extension setting to
`test-place.project.json` to get proper LSP support when developing your
package.

### Differences from Wally

Those coming from [Wally](https://wally.run/) may be a bit confused by the
way pesde handles Roblox packages.

In Wally, it is standard to have a `default.project.json` with the following:

```json
{
    "tree": {
        "$path": "src"
    }
}
```

This will cause the `src` directory to be directly synced into Roblox.

In pesde, you musn't not have a `default.project.json` file in your package.
Instead, you should have a 1:1 mapping between your file system and the
structure inside Roblox.

This has the effect that the structure of the files in the file system ends up
being reflected inside Roblox.

With Wally, the structure that ends up in Roblox ends up looking like this:

```text
- Packages/
  - \_Index/
    - acme_package@1.0.0/
      - package/ (src/init.luau)
        - foo (src/foo.luau)
        - bar (src/bar.luau)
        - ...
      - dependency
```

Whereas with pesde, it looks like this:

```text
- roblox_packages/
  - .pesde/
    - acme+package/
      - 1.0.0/
        - src/ (src/init.luau)
          - foo (src/foo.luau)
          - bar (src/bar.luau)
          - ...
        - roblox_packages/
          - dependency (roblox_packages/dependency.luau)
```

### The `roblox_server` target

Although optimizing your server-only dependency using the `roblox_server` target
might sound like a good idea it is not recommended, since it complicates
linking and makes your package unnecessarily harder to use. On a public registry
it is also redundant, since the package can be downloaded by anyone. Syncing
the scripts to the client may also come up as a reason, but it is a
micro-optimization which is very hard to observe, so it is unnecessary.

The target exists for a reason, that is
[private registries](/guides/self-hosting-registries). You might want to have
internal packages, such as configs or otherwise sensitive code which you do not
want clients to see. This is where the `roblox_server` target comes in handy.
If you're not using a private registry you should use the standard `roblox`
target instead.
