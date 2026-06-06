# Moonwave Extractor And Plugin API

## Extractor CLI Surface

The Rust extractor exposes one documented subcommand:

```bash
moonwave-extractor extract [input_path] [--base <path>]
```

Parameters:

- `input_path`: source folder or file to scan
- `--base`, `-b`: base path used to make `source.path` values relative in the JSON output

If `--base` is omitted, the input path is used as the base path.

## Extractor Output Model

The extractor emits JSON arrays of class entries. Each class entry contains, at minimum:

- `name`
- `desc`
- `functions`
- `properties`
- `types`
- `source`

Common member fields observed in snapshots:

| Field            | Applies To              | Meaning                                               |
| ---------------- | ----------------------- | ----------------------------------------------------- |
| `name`           | all                     | Member or class name                                  |
| `desc`           | all                     | Markdown-capable description                          |
| `source.line`    | all                     | Source line number                                    |
| `source.path`    | all                     | Source path relative to base path                     |
| `tags`           | most items              | User tags from `@tag`                                 |
| `realm`          | class/function/property | Realm list like `Client`, `Server`, `Plugin`          |
| `since`          | many items              | Version introduced                                    |
| `deprecated`     | many items              | Deprecation object with `version` and optional `desc` |
| `private`        | many items              | Private marker                                        |
| `ignore`         | many items              | Hide from output                                      |
| `unreleased`     | many items              | Pre-release marker                                    |
| `external_types` | many items              | External link definitions                             |

Function-specific fields:

- `params`
- `returns`
- `errors`
- `function_type`
- `yields`

Property-specific fields:

- `lua_type`
- `readonly`

Type/interface-specific fields:

- `lua_type` for named type aliases
- `fields` for interfaces

## Function Type Values

Observed function-call styles rendered by the plugin:

- `"static"` renders as `.name`
- `"method"` renders as `:name`
- `__call` is rendered specially as `ClassName()`

## Plugin Options

The Docusaurus plugin expects these meaningful options:

| Option            | Meaning                                             |
| ----------------- | --------------------------------------------------- |
| `code`            | array of code roots to scan                         |
| `sourceUrl`       | base URL used to build source links                 |
| `projectDir`      | project root for extraction and prepared-site logic |
| `classOrder`      | sidebar ordering and grouping                       |
| `apiCategories`   | TOC grouping by tags                                |
| `binaryPath`      | extractor binary path                               |
| `autoSectionPath` | folder-driven section grouping                      |

Validation behavior:

- `code` must exist on disk
- `code` is normalized into an array
- nested `classOrder.items` structure is type-checked
- `autoSectionPath` cannot be combined with bare string `classOrder` entries

## Plugin Runtime Behavior

During `loadContent`, the plugin:

1. runs the extractor for each configured code root
2. parses each extractor result as JSON
3. flattens all class arrays together

During `contentLoaded`, the plugin:

1. filters out ignored classes
2. sorts classes by name
3. builds sidebar data
4. generates type-link maps
5. creates `/api/`
6. creates `/api/<ClassName>` for each class

## Type-Link Resolution Order

The plugin combines type links in this order:

1. generated Roblox types
2. class names
3. named class-local types
4. external type mappings

Later mappings can override earlier ones.

## Source Links

The CLI passes:

```text
<gitRepoUrl>/blob/<gitSourceBranch>
```

as `sourceUrl`.

This is why incorrect `gitRepoUrl` or `gitSourceBranch` config leads to broken "view source" style links.

## Docusaurus Integration Choices Added By Moonwave

Generated config includes:

- `docusaurus-plugin-moonwave`
- `docusaurus-lunr-search`
- `@docusaurus/preset-classic`

Feature activation is conditional:

- docs plugin is enabled when `docs/` exists
- blog plugin is enabled when `blog/` exists
- pages support is always configured against `pages/`
- API navbar item appears only when at least one configured code path exists

## Useful Error Surface

Practical plugin errors include:

- nonexistent code path
- invalid nested `classOrder` shape
- missing class named in `classOrder`
- extractor failures surfaced as `Moonwave: Failed to extract. Check the error above.`
