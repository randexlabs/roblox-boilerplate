# Manifest And CLI Reference

Command reference and manifest behavior, including fields, flags, script execution, publishing commands, and command-specific notes.

## pesde.toml

- Source: `docs/src/content/docs/reference/manifest.mdx`
- Original description: Reference for `pesde.toml`

`pesde.toml` is the manifest file for a pesde package. It contains metadata about
the package and its dependencies.

## Top-level fields

```toml
name = "acme/package"
version = "1.2.3"
description = "A package that does foo and bar"
license = "MIT"
authors = ["John Doe <john.doe@acme.local> (https://acme.local)"]
repository = "https://github.com/acme/package"
```

### `name`

The name of the package. This is used to identify the package in the registry.

The name consists of a scope and a package name, separated by a slash (`/`). It
may only contain lowercase letters, numbers, and underscores.

The first one to publish to a given scope gets to own it. If you want multiple
people to be able to publish to the same scope, you can send a pull request to
the [pesde-index GitHub repository](https://github.com/pesde-pkg/index)
and add the GitHub user ID of the other person to the `owners` field of the
`scope.toml` file of the given scope. For more information, see
[policies](/registry/policies#package-ownership).

### `version`

The version of the package. This must be a valid [SemVer](https://semver.org/)
version, such as `1.2.3`.

### `description`

A short description of the package. This is displayed on the package page in the
registry.

### `license`

The license of the package. It is recommended to use a
[SPDX license identifier](https://spdx.org/licenses/), such as `MIT` or
`Apache-2.0`.

### `authors`

A list of authors of the package. Each author is a string containing the name of
the author, optionally followed by an email address in angle brackets, and a
website URL in parentheses. For example:

```toml
authors = ["John Doe <john.doe@acme.local> (https://acme.local)"]
```

### `repository`

The URL of the repository where the package is hosted. This is displayed on the
package page in the registry.

### `private`

A boolean indicating whether the package is private. If set to `true`, the
package cannot be published to the registry.

### `includes`

List of globs to include in the package when publishing. Files and directories
not listed here will not be published.

```toml
includes = ["pesde.toml", "README.md", "LICENSE", "init.luau", "docs/**/*.md"]
```

### `workspace_members`

A list of globs containing the members of this workspace.

**See also:** [Workspaces](/guides/workspaces/) - Learn more about workspaces in pesde.

## `[target]`

The `[target]` section contains information about the target platform for the
package.

```toml
[target]
environment = "luau"
lib = "init.luau"
```

### `environment`

The target environment for the package. This can be one of the following:

- `luau`: Standalone Luau code that can be run using the `luau` CLI.
- `lune`: Luau code that requires the Lune runtime.
- `roblox`: Luau code that must be run in Roblox.
- `roblox_server`: Same as `roblox`, but only for server-side code.

### `lib`

**Allowed in:** `luau`, `lune`, `roblox`, `roblox_server`

The entry point of the library exported by the package. This file is what will
be required when the package is loaded using `require`.

### `bin`

**Allowed in:** `luau`, `lune`

The entry point of the binary exported by the package. This file is what will be
run when the package is executed as a binary.

**See also:** [Using Binary Packages](/guides/binary-packages/) - Learn more about using binary packages in pesde.

### `scripts`

**Allowed in:** `luau`, `lune`

A list of scripts that will be linked to the dependant's `.pesde` directory, and
copied over to the [scripts](#scripts-1) section when initialising a project with
this package as the scripts package.

```toml
[target.scripts]
roblox_sync_config_generator = "scripts/roblox_sync_config_generator.luau"
```

## `[scripts]`

The `[scripts]` section contains scripts that can be run using the `pesde run`
command. These scripts are run using [Lune](https://lune-org.github.io/docs).

```toml
[scripts]
build = "scripts/build.luau"
test = "scripts/test.luau"
```

There are also a few special scripts that are run in certain cases by pesde.

### `sourcemap_generator`

This is responsible for generating source maps for packages that are installed.
This is required to get proper types support when using
[Wally dependencies](/guides/dependencies/#wally-dependencies).

The script will receive the path to the package directory as the first argument
through `process.args`.

**See also:** [Example script for Rojo](https://github.com/pesde-pkg/scripts/blob/master/src/generators/rojo/sourcemap.luau) - An example script for generating configuration for Rojo.

## `[indices]`

The `[indices]` section contains a list of pesde indices where packages can be
installed from.

```toml
[indices]
default = "https://github.com/pesde-pkg/index"
acme = "https://github.com/acme/pesde-index"
```

These can then be referenced in the [`dependencies`](#dependencies) of the
package. The `default` index is used if no index is specified.

```toml
[dependencies]
foo = { name = "acme/foo", version = "1.2.3", index = "acme" }
```

## `[wally_indices]`

The `[wally_indices]` section contains a list of Wally indices where packages
can be installed from. This is used for
[Wally dependencies](/guides/dependencies/#wally-dependencies).

```toml
[wally_indices]
default = "https://github.com/UpliftGames/wally-index"
acme = "https://github.com/acme/wally-index"
```

These can then be referenced in the [`dependencies`](#dependencies) of the
package. The `default` index is used if no index is specified.

```toml
[dependencies]
foo = { wally = "acme/foo", version = "1.2.3", index = "acme" }
```

## `[overrides]`

The `[overrides]` section contains a list of overrides for dependencies. This
allows you to replace certain dependencies with different versions or even
different packages.

```toml
[overrides]
"bar>baz" = { name = "acme/baz", version = "1.0.0" }
"foo>bar,baz>bar" = { name = "acme/bar", version = "2.0.0" }
```

The above example will replace the `baz` dependency of the `bar` package with
version `1.0.0`, and the `bar` and `baz` dependencies of the `foo` package with
version `2.0.0`.

Each key in the overrides table is a comma-separated list of package paths. The
path is a list of aliases separated by `>`. For example, `foo>bar>baz`
refers to the `baz` dependency of the `bar` package, which is a dependency of
the `foo` package.

The value of an override entry can be either a specifier or an alias. If it is an
alias (a string), it will be equivalent to putting the specifier of the dependency
under that alias. For example, the following two overrides are equivalent:

```toml
[dependencies]
bar = { name = "acme/bar", version = "2.0.0" }

[overrides]
"foo>bar" = "bar"
```

```toml
[overrides]
"foo>bar" = { name = "acme/bar", version = "2.0.0" }
```

**See also:** [Overrides](/guides/overrides/) - Learn more about overriding and patching packages.

## `[patches]`

The `[patches]` section contains a list of patches for dependencies. This allows
you to modify the source code of dependencies.

```toml
[patches]
"acme/foo" = { "1.0.0 luau" = "patches/acme+foo-1.0.0+luau.patch" }
```

The above example will patch version `1.0.0` with the `luau` target of the
`acme/foo` package using the `patches/acme+foo-1.0.0+luau.patch` file.

Each key in the patches table is the package name, and the value is a table
where the keys are the version and target, and the value is the path to the
patch.

The patches can be generated using the `pesde patch` command.

**See also:** [Overrides](/guides/overrides/) - Learn more about overriding and patching packages.

## `[place]`

This is used in Roblox projects to specify where packages are located in the
Roblox datamodel.

```toml
[place]
shared = "game.ReplicatedStorage.Packages"
server = "game.ServerScriptService.Packages"
```

## `[dependencies]`

The `[dependencies]` section contains a list of dependencies for the package.

```toml
[dependencies]
foo = { name = "acme/foo", version = "1.2.3" }
bar = { wally = "acme/bar", version = "2.3.4" }
baz = { repo = "acme/baz", rev = "main" }
```

Each key in the dependencies table is the name of the dependency, and the value
is a dependency specifier.

There are several types of dependency specifiers.

### pesde

```toml
[dependencies]
foo = { name = "acme/foo", version = "1.2.3", index = "acme", target = "lune" }
```

**pesde dependencies** contain the following fields:

- `name`: The name of the package.
- `version`: The version of the package.
- `index`: The [pesde index](#indices) to install the package from. If not
  specified, the `default` index is used.
- `target`: The target platform for the package. If not specified, the target
  platform of the current package is used.

### Wally

```toml
[dependencies]
foo = { wally = "acme/foo", version = "1.2.3", index = "acme" }
```

**Wally dependencies** contain the following fields:

- `wally`: The name of the package.
- `version`: The version of the package.
- `index`: The [Wally index](#wally_indices) to install the package from. If not
  specified, the `default` index is used.

### Git

```toml
[dependencies]
foo = { repo = "acme/packages", rev = "aeff6", path = "foo" }
```

**Git dependencies** contain the following fields:

- `repo`: The URL of the Git repository.
  This can either be `<owner>/<name>` for a GitHub repository, or a full URL.
- `rev`: The Git revision to install. This can be a tag or commit hash.
- `path`: The path within the repository to install. If not specified, the root
  of the repository is used.

### Workspace

```toml
[dependencies]
foo = { workspace = "acme/foo", version = "^" }
```

**Workspace dependencies** contain the following fields:

- `workspace`: The name of the package in the workspace.
- `version`: The version requirement for the package. This can be `^`, `*`, `=`,
  `~`, or a specific version requirement such as `^1.2.3`.

**See also:** [Workspaces](/guides/workspaces/#workspace-dependencies) - Learn more about workspace dependencies in pesde.

### Path

```toml
[dependencies]
foo = { path = "/home/user/foo" }
```

**Path dependencies** contain the following fields:

- `path`: The path to the package on the local filesystem.

Path dependencies are forbidden in published packages.

## `[dev_dependencies]`

The `[dev_dependencies]` section contains a list of development dependencies for
the package. These are dependencies that are only required during development,
such as testing libraries or build tools. They are not installed when the
package is used by another package.

```toml
[dev_dependencies]
foo = { name = "acme/foo", version = "1.2.3" }
```

**See also:** [Specifying Dependencies](/guides/dependencies/) - Learn more about specifying dependencies in pesde.

## `[peer_dependencies]`

The `[peer_dependencies]` section contains a list of peer dependencies for the
package. These are dependencies that are required by the package, but are not
installed automatically. Instead, they must be installed by the user of the
package.

```toml
[peer_dependencies]
foo = { name = "acme/foo", version = "1.2.3" }
```

## `[engines]`

The `[engines]` section contains a list of engines that the package is compatible
with.

```toml
[engines]
pesde = "^0.6.0"
lune = "^0.8.9"
```

Currently, the only engines that can be specified are `pesde` and `lune`.
Additionally, the engines you declared in your project will be installed when
you run `pesde install`. Then, a version of the engine that satisfies the
specified version range will be used when you run the engine.

---

## pesde CLI

- Source: `docs/src/content/docs/reference/cli.mdx`
- Original description: Reference for the pesde CLI.

The pesde CLI is the primary way to interact with pesde projects. It provides
commands for installing dependencies, running scripts, and more.

## `pesde auth`

Authentication-related commands.

- `-i, --index`: The index of which token to manipulate. May be a URL or an alias.
  Defaults to the default
  index of the current project or the default index set in the config.

### `pesde auth login`

Sets the token for the index.

- `-t, --token`: The token to set.

If no token is provided, you will be prompted to authenticate with GitHub. A
code will be provided that you can paste into the GitHub authentication prompt.

### `pesde auth logout`

Removes the stored token for the index.

### `pesde auth whoami`

Prints the username of the currently authenticated user of the index. Only
works if the token is a GitHub token.

### `pesde auth token`

Prints the token for the index.

## `pesde config`

Configuration-related commands.

### `pesde config default-index`

```sh
pesde config default-index [INDEX]
```

Configures the default index. If no index is provided, the current default index
is printed.

- `-r, --reset`: Resets the default index.

The default index is [`pesde-index`](https://github.com/pesde-pkg/index).

## `pesde cas`

Content-addressable storage (CAS) related commands.

### `pesde cas prune`

Removes unused CAS files and packages.

## `pesde init`

Initializes a new pesde project in the current directory.

## `pesde add`

```sh
pesde add <PACKAGE>
```

Adds a package to the dependencies of the current project.

- `-i, --index <INDEX>`: The index in which to search for the package.
- `-t, --target <TARGET>`: The target environment for the package.
- `-a, --alias <ALIAS>`: The alias to use for the package, defaults to the
  package name.
- `-p, --peer`: Adds the package as a peer dependency.
- `-d, --dev`: Adds the package as a dev dependency.

The following formats are supported:

```sh
pesde add pesde/hello
pesde add pesde/hello@1.2.3
pesde add wally#pesde/hello
pesde add wally#pesde/hello@1.2.3
pesde add gh#acme/package#main
pesde add https://git.acme.local/package.git#aeff6
pesde add workspace:pesde/hello
pesde add workspace:pesde/hello@1.2.3
pesde add path:/home/user/package
```

## `pesde remove`

```sh
pesde remove <ALIAS>
```

Removes a package from the dependencies of the current project.

## `pesde install`

Installs dependencies for the current project.

- `--locked`: Whether to error if the lockfile is out of date.
- `--prod`: Whether to not linking dev dependencies.
- `--dev`: Whether to only link dev dependencies.
- `--network-concurrency <CONCURRENCY>`: The number of concurrent network
  requests to make at most. Defaults to 16.
- `--force`: Whether to force reinstall all packages even if they are already
  installed (useful if there is any issue with the current installation).

## `pesde update`

Updates the dependencies of the current project.

- `--no-install`: Whether to only update the lockfile without installing the
  dependencies.
- `--network-concurrency <CONCURRENCY>`: The number of concurrent network
  requests to make at most. Defaults to 16.
- `--force`: Whether to force reinstall all packages even if they are already
  installed (useful if there is any issue with the current installation).

## `pesde outdated`

Lists outdated dependencies of the current project.

## `pesde list`

Lists the dependencies of the current project.

## `pesde run`

Runs a script from the current project using Lune.

```sh
pesde run [SCRIPT] [ -- <ARGS>...]
```

If no script is provided, it will run the script specified by `target.bin`
in `pesde.toml`.

If a path is provided, it will run the script at that path.

If a script defined in `[scripts]` is provided, it will run that script.

If a package name is provided, it will run the script specified by `target.bin`
in that package.

Arguments can be passed to the script by using `--` followed by the arguments.

```sh
pesde run foo -- --arg1 --arg2
```

## `pesde publish`

Publishes the current project to the pesde registry.

- `-d, --dry-run`: Whether to perform a dry run. This will output a
  tarball containing the package that would be published, but will not actually
  publish it.
- `-y, --yes`: Whether to skip the confirmation prompt.
- `-i, --index`: Name of the index to publish to. Defaults to `default`.
- `--no-verify`: Whether to skip syntax validation of the exports of the
  package.

## `pesde yank`

Yanks a version of a package from the registry.

- `--undo`: Whether to unyank the package.
- `-i, --index`: Name of the index to yank from. Defaults to `default`.

## `pesde deprecate`

```sh
pesde deprecate <PACKAGE> [REASON]
```

Deprecates a package in the registry. A non-empty reason must be provided.

- `--undo`: Whether to undepricate the package.
- `-i, --index`: Name of the index to deprecate from. Defaults to `default`.

## `pesde patch`

```sh
pesde patch <PACKAGE>
```

Prepares a patching environment for a package. This will copy the source code of
the package to a temporary directory.

The package specified must be in the format `<name>@<version> <target>`.

**See also:** [Overrides](/guides/overrides/) - Learn more about overriding and patching packages.

## `pesde patch-commit`

```sh
pesde patch-commit <PATH>
```

Applies the changes made in the patching environment created by `pesde patch`.

## `pesde x`

Runs a one-off binary package.

```sh
pesde x <PACKAGE>
```

This is useful for running a binary package without installing it or outside of
a pesde project.

```sh
pesde x pesde/hello
```

## `pesde self-install`

Performs the pesde installation process. This should be the first command run
after downloading the pesde binary.

## `pesde self-upgrade`

Upgrades the pesde binary to the latest version.

- `--use-cached`: Whether to use the version displayed in the "upgrade available"
  message instead of checking for the latest version.
