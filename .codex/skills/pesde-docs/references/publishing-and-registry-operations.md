# Publishing And Registry Operations

Package author workflows for publishing, package docs, yanking, deprecating, and related operational guidance.

## Publishing Packages

- Source: `docs/src/content/docs/guides/publishing.mdx`
- Original description: Learn how to publish packages to the pesde registry.

## Configuration

Before you can publish a package, you must configure the required fields in your
`pesde.toml` file.

### `includes`

The `includes` field is a list of globs that should be included in the package.

```toml
includes = ["pesde.toml", "README.md", "LICENSE", "src/**/*.luau"]
```

### `target`

The `target` field defines the environment where the package can be run.

Here, you must also specify the `lib` and/or `bin` fields to indicate the path
of the exported library or binary.

```toml
[target]
environment = "luau"
lib = "init.luau"
```

#### Roblox

`bin` is not supported in Roblox packages.

## Authentication

Before you can publish a package, you must authenticate with your GitHub
account.

```sh
pesde auth login
```

You will be given a code and prompted to open the GitHub authentication page in
your browser. You must enter the code to authenticate.

## Publishing

To publish a package, run the following command:

```sh
pesde publish
```

You will be prompted to confirm the package details before publishing.

Once a package is published, others will be able to install it. You may not
remove a package once it has been published. You may not publish a package with
an already existing version.

## Multi-target Packages

You may publish packages under the same name and version but with different
targets. This allows you to publish a package that can be used in multiple
environments.

For example, you may publish a package that can be used in both Roblox and
Luau environments by publishing two versions of the package, one for each
environment.

> [!CAUTION]
> Packages for different targets but on the same version must have
> the same description.

## Documentation

The `README.md` file in the root of the package will be displayed on the
[pesde registry website](https://pesde.daimond113.com/).

You can include a `docs` directory in the package containing markdown files
and they will be available on the pesde registry website. You can see an example
in [`pesde/hello`](https://pesde.daimond113.com/packages/pesde/hello/latest/any/docs).

### Customizing the sidebar

You can include frontmatter with a `sidebar_position` to customize the order
of the pages on the sidebar.

```md title="docs/getting-started.md"
---
sidebar_position: 2
---

# Getting Started

Lorem ipsum odor amet, consectetuer adipiscing elit. Eleifend consectetur id
consequat conubia fames curae?
```

You can have directories in the `docs` directory to create nested pages. These
will show up as collapsible sections in the sidebar. You can include a
`_category_.json` file inside the nested directories to customize the label and
the ordering in the sidebar.

```json title="docs/guides/_category_.json"
{
    "label": "Guides",
    "position": 3
}
```

> [!TIP]
> Make sure to include `docs` inside the `includes` field in `pesde.toml`
> otherwise they won't be published with your package.

---

## Removing Packages

- Source: `docs/src/content/docs/guides/removing-packages.mdx`
- Original description: Learn how to remove packages from the registry.

pesde doesn't support removing packages from the registry. This is to ensure
that the registry remains a reliable source of packages for everyone. However,
pesde provides other mechanisms to handle packages that are no longer needed.

## Yanking

Yanking is limited to a specific version (and target) of a package. It is used
to mark a version as broken or deprecated. Yanked versions are unavailable
to download fresh, but they can still be installed if they are present in the
lockfile of a project.

To yank a package, you can use the `pesde yank` command:

```sh
pesde yank <PACKAGE>@<VERSION> <TARGET>
```

You can leave out the target if you want to yank all targets of the version:

```sh
pesde yank <PACKAGE>@<VERSION>
```

## Deprecating

On the other hand, deprecating a package is used to mark a package as deprecated
in the registry. This is useful when you want to discourage users from using
a package, but don't want to break existing projects that depend on it. Unlike
yanking, your package will still be able to be installed fresh. However, when it
is installed, a warning will be shown to the user.

To deprecate a package, you can use the `pesde deprecate` command:

```sh
pesde deprecate <PACKAGE> [REASON]
```

You must provide a non-empty reason when deprecating a package. This is to
inform users why the package is deprecated. For example, if your package
has been replaced by another package, you can provide a reason like:

```sh
pesde deprecate acme/old-package "This package has been replaced by acme/new-package."
```

## Other Options

There are other situations in which you might want to remove a package from
the registry. Please refer to the policies of the registry you are using for
more information on how to handle these situations. The process for the official
registry is described [here](/registry/policies/#package-removal).
