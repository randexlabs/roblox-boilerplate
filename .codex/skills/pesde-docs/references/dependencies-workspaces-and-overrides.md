# Dependencies, Workspaces, And Overrides

Dependency specifiers, workspace layout, override semantics, patching, and engine constraints.

## Specifying Dependencies

- Source: `docs/src/content/docs/guides/dependencies.mdx`
- Original description: Learn how to specify dependencies in your pesde project.

The `[dependencies]` section of your `pesde.toml` file is where you specify the
dependencies of your project.

pesde supports multiple types of dependencies.

## pesde Dependencies

The most common type of dependency are pesde dependencies. These are
dependencies on packages published to a [pesde registry](https://pesde.daimond113.com).

```toml title="pesde.toml"
[indices]
default = "https://github.com/pesde-pkg/index"

[dependencies]
hello = { name = "pesde/hello", version = "^1.0.0" }
```

In this example, we're specifying a dependency on the `pesde/hello` package on
the official pesde registry with a version constraint of `^1.0.0`.

You can also add a dependency by running the following command:

```sh
pesde add pesde/hello
```

## Git Dependencies

Git dependencies are dependencies on packages hosted on a Git repository.

```toml title="pesde.toml"
[dependencies]
acme = { repo = "acme/package", rev = "aeff6" }
```

In this example, we're specifying a dependency on the package contained within
the `acme/package` GitHub repository at the `aeff6` commit.

You can also use a URL to specify the Git repository and a tag for the revision.

```toml title="pesde.toml"
[dependencies]
acme = { repo = "https://git.acme.local/package.git", rev = "v0.1.0" }
```

You can also specify a path if the package is not at the root of the repository.

```text
- acme/package.git
  - pkgs/
    - **foo/**
      - pesde.toml
      - ...
```

```toml title="pesde.toml"
[dependencies]
foo = { repo = "acme/package", rev = "main", path = "pkgs/foo" }
```

The path specified by the Git dependency must either be a valid pesde package or
a [Wally][wally] package.

You can also add a Git dependency by running the following command:

```sh
# From Git URL
pesde add https://git.acme.local/package.git#aeff6

# From GitHub repository
pesde add gh#acme/package#main
```

## Wally Dependencies

Wally dependencies are dependencies on packages published to a
[Wally registry][wally]. Wally is a package manager for Roblox and thus Wally
dependencies should only be used in Roblox projects.

```toml title="pesde.toml"
[wally_indices]
default = "https://github.com/UpliftGames/wally-index"

[dependencies]
foo = { wally = "acme/package", version = "^1.0.0" }
```

In this example, we're specifying a dependency on the `acme/package` package
on the official Wally registry with a version constraint of `^1.0.0`.

> [!NOTE]
> In order to get proper types support for Wally dependencies, you need to have
> a [`sourcemap_generator` script](/reference/manifest#sourcemap_generator)
> specified in your `pesde.toml` file.

You can also add a Wally dependency by running the following command:

```sh
pesde add wally#acme/package
```

[wally]: https://wally.run/

## Workspace Dependencies

Packages within a workspace can depend on each other. For example, if `foo`
and `bar` are both packages in the same workspace, you can add a dependency to
`bar` in the `foo/pesde.toml` file:

```toml title="foo/pesde.toml"
[dependencies]
bar = { workspace = "acme/bar", version = "^" }
```

You can also add a workspace dependency by running the following command:

```sh
pesde add workspace:acme/bar
```

**See also:** [Workspaces](/guides/workspaces/) - Learn more about using workspaces in pesde.

## Path Dependencies

Path dependencies are dependencies found anywhere available to the operating system.
They are useful for local development, but are forbidden in published packages.

The path must be absolute and point to a directory containing a `pesde.toml` file.

```toml title="pesde.toml"
[dependencies]
foo = { path = "/home/user/foo" }
```

You can also add a path dependency by running the following command:

```sh
pesde add path:/home/user/foo
```

## Peer Dependencies

Peer dependencies are dependencies that are not installed automatically when
used by another package. They need to be installed by the user of the package.

```toml title="pesde.toml"
[peer_dependencies]
foo = { name = "acme/foo", version = "^1.0.0" }
```

You can add a peer dependency by passing `--peer` to the `pesde add` command:

```sh
pesde add --peer acme/foo
```

## Dev Dependencies

Dev dependencies are dependencies that are only used during development. They
are not installed when the package is used as a dependency.

```toml title="pesde.toml"
[dev_dependencies]
foo = { name = "acme/foo", version = "^1.0.0" }
```

You can add a dev dependency by passing `--dev` to the `pesde add` command:

```sh
pesde add --dev acme/foo
```

---

## Workspaces

- Source: `docs/src/content/docs/guides/workspaces.mdx`
- Original description: Learn how to use workspaces in pesde.

Workspaces allow you to work with multiple pesde projects within a single
repository. Packages within a workspace can depend on each other. And you can
run commands like install or publish on every package in the workspace at once.

Let's say you have a repository with the following structure:

```text
- pesde.toml
- pkgs/
  - foo/
    - pesde.toml
    - ...
  - bar/
    - pesde.toml
    - ...
```

Within the root `pesde.toml` file, we can define a workspace:

```toml title="pesde.toml"
name = "acme/root"
version = "0.0.0"
private = true

workspace_members = ["pkgs/*"]

[target]
environment = "luau"
```

Now, each folder within the `pkgs/` directory is considered a package in the
workspace. You can run commands like `pesde install` or `pesde publish` from
the root of the repository to run them on every package in the workspace.

## Workspace Dependencies

Packages within a workspace can depend on each other. For example, if `foo`
depends on `bar`, you can add a dependency to `bar` in the `foo/pesde.toml` file:

```toml title="pkgs/foo/pesde.toml"
name = "acme/foo"
version = "1.0.0"

[dependencies]
bar = { workspace = "acme/bar", version = "^" }
```

Workspace dependencies are replaced with normal pesde dependencies when
publishing.

The `version` field can either contain `^`, `*`, `=`, `~`, or a specific version
requirement, such as `^1.0.0`. If you use `^`, `=`, or `~`, it will be replaced
with the version of the package in the workspace when publishing.

For example, if you had the following:

```toml title="pesde.toml"
[dependencies]
bar = { workspace = "acme/bar", version = "^" }
qux = { workspace = "acme/qux", version = "=" }
qar = { workspace = "acme/qar", version = "~" }
zoo = { workspace = "acme/zoo", version = "^2.1.0" }
baz = { workspace = "acme/baz", version = "*" }
```

If `bar`, `baz`, `qux`, `qar`, and `zoo` are all at version `2.1.5` in the
workspace, the `pesde.toml` file will be transformed into the following when
publishing.

```toml title="pesde.toml"
[dependencies]
bar = { name = "acme/bar", version = "^2.1.5" }
qux = { name = "acme/qux", version = "=2.1.5" }
qar = { name = "acme/qar", version = "~2.1.5" }
zoo = { name = "acme/zoo", version = "^2.1.0" }
baz = { name = "acme/baz", version = "*" }
```

A `target` field can be added to the `dependencies` table to specify a target
environment for the dependency.

```toml title="pesde.toml"
[dependencies]
bar = { workspace = "acme/bar", version = "^", target = "luau" }
```

**See also:** [Specifying Dependencies](/guides/dependencies/) - Learn more about specifying dependencies in pesde.

---

## Overriding Dependencies

- Source: `docs/src/content/docs/guides/overrides.mdx`
- Original description: Learn how to override and patch dependencies in pesde.

pesde has several ways to override or patch dependencies in your project.

## Dependency Overrides

Dependency overrides allow you to replace a dependency of a dependency with a
different version or package.

Let's say you have a project with the following dependencies:

```toml title="pesde.toml"
[dependencies]
foo = { name = "acme/foo", version = "^1.0.0" }
```

But `foo` depends on `bar` 1.0.0, and you want to use `bar` 2.0.0 instead. You
can override the `bar` dependency in your `pesde.toml` file:

```toml title="pesde.toml"
[dependencies]
foo = { name = "acme/foo", version = "^1.0.0" }

[overrides]
"foo>bar" = { name = "acme/bar", version = "^2.0.0" }
```

Now, when you run `pesde install`, `bar` 2.0.0 will be used instead of 1.0.0.

Overrides are also able to use aliases to share the specifier you use for your
own dependencies:

```toml title="pesde.toml"
[dependencies]
foo = { name = "acme/foo", version = "^1.0.0" }
bar = { name = "acme/bar", version = "^2.0.0" }

[overrides]
"foo>bar" = "bar"
```

This is the same as if you had written:

```toml title="pesde.toml"
[dependencies]
foo = { name = "acme/foo", version = "^1.0.0" }
bar = { name = "acme/bar", version = "^2.0.0" }

[overrides]
"foo>bar" = { name = "acme/bar", version = "^2.0.0" }
```

You can learn more about the syntax for dependency overrides in the
[reference](/reference/manifest#overrides).

## Patching Dependencies

Patching allows you to modify the source code of a dependency.

To patch a dependency, you can use the `pesde patch` and `pesde patch-commit`
commands.

Let's say you have the following dependency in your `pesde.toml` file:

```toml title="pesde.toml"
[target]
environment = "luau"

[dependencies]
foo = { name = "acme/foo", version = "^1.0.0" }
```

And you want to patch `foo` to fix a bug. You can run the following command:

```sh
pesde patch "acme/foo@1.0.0 luau"

# done! modify the files in the directory, then run `pesde patch-commit /x/y/z`
# to apply.
# warning: do not commit these changes
# note: the pesde.toml file will be ignored when patching
```

pesde will copy the source code of `foo` to a temporary directory, in this case
`/x/y/z`. You can then modify the files in this directory. Once you're done,
run `pesde patch-commit /x/y/z` to apply the changes.

This will create a patch within the `patches` directory of your project, and
add an entry to `[patches]`. Then, next time you run `pesde install`, the patch
will be applied to the dependency.

> [!CAUTION]
> Make sure not to commit or stage the changes made in the temporary directory.
> Otherwise pesde may not be able to create the patch correctly.

> [!NOTE]
> If you sync your patch files to a Git repository it is advised to mark said
> files as binary so the line endings don't get changed, which can cause
> cryptic errors when applying.
>
> ```txt title=".gitattributes"
> *.patch binary
> ```

---

## Engines

- Source: `docs/src/content/docs/guides/engines.mdx`
- Original description: Learn what engines are and how to use them

Since pesde runs binary packages using a Luau runtime, we need a way to get one.
pesde 0.6 has introduced a mechanism for this: engines.

An engine is either a Luau runtime or pesde itself. Engines allow your
package to specify what versions it's compatible with.

To specify that your package is compatible with Lune ^0.8.9 and pesde ^0.6.0:

```toml
[engines]
pesde = "^0.6.0"
lune = "^0.8.9"
```

After you add the engines to your manifest run `pesde install` to set up the
necessary files in pesde's bin directory.

> [!NOTE]
> You can also use engines outside projects. They will run the latest version installed locally when
> executed.

The benefit of engines is that users will be immediately warned if they install
a package which uses an incompatible version of a runtime. For example, if we
publish a package with the engines we've written before and a user with
`lune = "=0.9.0"` installs our package they'll get the following message:

```
warn: package acme/bar@0.1.0 lune requires lune ^0.8.9, but 0.9.0 is installed
```
