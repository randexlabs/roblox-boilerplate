# Moonwave Configuration API

## Supported Config Files

Moonwave reads configuration from either:

- `moonwave.toml`
- `moonwave.json`

The public docs focus on TOML, but the CLI accepts JSON too.

## Top-Level Keys

Common Moonwave-owned keys:

| Key               | Type       | Meaning                                                                       |
| ----------------- | ---------- | ----------------------------------------------------------------------------- |
| `title`           | `string`   | Project/site title                                                            |
| `gitRepoUrl`      | `string`   | Repo URL, usually inferred from Git                                           |
| `gitSourceBranch` | `string`   | Source branch for edit/source links; defaults to `master` behavior if omitted |
| `changelog`       | `boolean`  | Whether `CHANGELOG.md` should be exposed as a page                            |
| `classOrder`      | `array`    | Controls API ordering and grouping                                            |
| `apiCategories`   | `string[]` | Creates TOC categories based on `@tag` matches                                |
| `autoSectionPath` | `string`   | Auto-groups classes by folders under a path prefix                            |

## `[docusaurus]`

These keys are passed through to Docusaurus config:

| Key                     | Meaning                                          |
| ----------------------- | ------------------------------------------------ |
| `title`                 | Docusaurus site title                            |
| `tagline`               | Site tagline                                     |
| `url`                   | Site origin, especially important for publishing |
| `baseUrl`               | Path prefix under the origin                     |
| `onBrokenLinks`         | Broken link behavior                             |
| `onBrokenMarkdownLinks` | Broken markdown link behavior                    |
| `favicon`               | Favicon path                                     |
| `organizationName`      | Usually the GitHub owner                         |
| `projectName`           | Usually the repo name                            |

Important defaults inferred by the CLI:

- `title` falls back to top-level `title`, then repo name
- `organizationName` and `projectName` come from the Git remote when possible
- `baseUrl` defaults to `/${repoName}/` when a repo name exists, otherwise `/`
- the generated Docusaurus config sets `url` to `https://<organizationName>.github.io` unless overridden

## `[navbar]`

Navbar items can be extended with custom entries:

```toml
[[navbar.items]]
href = "https://discord.gg/abcdefghijk"
label = "Discord"
position = "right"
```

Moonwave also injects navbar items automatically when relevant:

- `Docs` if `docs/` exists
- `Blog` if `blog/` exists
- `API` if any configured code roots exist
- `Changelog` if `CHANGELOG.md` is enabled and present
- `GitHub` if `gitRepoUrl` is known

## `classOrder`

Supported shapes:

1. Flat string list:

```toml
classOrder = ["MyClass", "Sample"]
```

2. Sectional objects:

```toml
[[classOrder]]
section = "Utilities"
classes = ["A", "B"]
```

3. Tag-driven sections:

```toml
[[classOrder]]
section = "Tagged"
tag = "Network"
```

4. Nested sections using repeated `items`

```toml
[[classOrder]]
section = "Parent"

[[classOrder.items]]
section = "Child"
classes = ["Class1"]
```

Notes:

- unlisted classes are appended alphabetically
- naming a class that does not exist is an error
- `collapsed = false` expands a section by default
- when `autoSectionPath` is enabled, use sectional object style rather than bare string entries

## `apiCategories`

`apiCategories` creates TOC subheadings within a class page by grouping members that carry matching `@tag` values.

Example:

```toml
apiCategories = ["constructor", "utility", "random"]
```

## `autoSectionPath`

`autoSectionPath` derives API sidebar sections from source file folder names under a given path prefix.

Example:

```toml
autoSectionPath = "packages"
```

This turns something like `packages/thing-doer/init.lua` into a section named `Thing Doer`.

## `[home]`

Keys observed in docs and implementation:

| Key             | Type                  | Meaning                                                               |
| --------------- | --------------------- | --------------------------------------------------------------------- |
| `enabled`       | `boolean`             | Use generated custom homepage instead of plain README page            |
| `bannerImage`   | `string`              | Homepage banner image                                                 |
| `includeReadme` | `boolean` or `string` | Append README content; implementation also accepts a custom file path |

Home features:

```toml
[[home.features]]
title = "Feature 1"
description = "This is a feature"
image = "https://example.com/feature.png"
```

If a feature image starts with `/`, Moonwave prefixes it with `baseUrl`.

## `[footer]`

Footer config is passed through and merged with defaults. The generated default copyright string is:

- `Copyright © <current year> <organizationName>. Built with Moonwave and Docusaurus.`

## Project Folders With Special Meaning

| Path                    | Meaning                                 |
| ----------------------- | --------------------------------------- |
| `docs/`                 | Docusaurus docs content                 |
| `blog/`                 | Docusaurus blog content                 |
| `pages/`                | Custom hosted pages                     |
| `.moonwave/static/`     | Static assets served from the site root |
| `.moonwave/custom.css`  | Global CSS override                     |
| `.moonwave/sidebars.js` | Custom docs sidebar                     |
| `CHANGELOG.md`          | Optional generated changelog page       |
