# Troubleshooting

## Changes Are Not Showing Up

If `moonwave dev` is running and docs are not updating:

- restart Moonwave first
- verify the file lives under one of the configured `--code` roots
- verify the project content folder being changed is one Moonwave actually watches

Moonwave's dev command watches the project and selectively rebuilds when changes affect:

- the configured README include target
- `moonwave.toml`
- `moonwave.json`
- `CHANGELOG.md`
- `.moonwave/`
- `docs/`
- `blog/`
- `pages/`

## API Item Does Not Appear

Check these first:

- the item belongs to a class
- non-class doc comments include `@within`
- the doc comment is attached to the right function or declaration
- the item is not tagged with `@ignore`
- the source file is under a configured code root

For function docs, missing output is often caused by the comment not being directly above the function or by trying to document a free function without `@within`.

## Validation Failures

Moonwave is intentionally strict. Common failures include:

- a function parameter has no Luau type and no matching `@param`
- a `@param` references a name that is not a real function parameter
- a non-class doc comment is missing `@within`
- incompatible tags are mixed in the same comment
- `classOrder` names a class that does not exist

Observed extractor diagnostics include messages like:

- `Function parameter "..." has no type. Document with @param or insert Luau type annotation`
- `Param "..." does not actually exist in function`
- `This tag is mutually exclusive...`

## `autoSectionPath` Pitfall

When `autoSectionPath` is enabled, `classOrder` cannot contain bare string entries. The plugin requires sectional object style in that mode.

If this rule is violated, Moonwave throws an explicit plugin error instead of partially applying the config.

## Publish And Source-Link Pitfalls

- The docs still assume `master` as the default source branch unless `gitSourceBranch` is configured.
- If your real default branch is `main`, configure it explicitly or edit links will be wrong.
- If you host at a custom domain or site root instead of `/projectName/`, set both `url` and `baseUrl`, and use `baseUrl = "/"` when appropriate.

## README Homepage Surprises

- If `README.md` is missing and no title can be inferred from Git, the generated home page becomes a placeholder.
- If `home.includeReadme` points to a custom path, that path becomes the watched README source instead of the root `README.md`.
- HTML hide markers are processed repeatedly until no marker pairs remain, so nested or repeated trimming patterns can change more content than expected if written carelessly.

## Cache And Dependency Issues

Useful recovery commands:

```bash
moonwave dev --fresh
moonwave dev --install
moonwave build --install
```

What they do:

- `--fresh` clears cached build artifacts but keeps `node_modules`
- `--install` forces a full reinstall of the cached site workspace

## Docs Vs Implementation Mismatches Worth Remembering

- The public docs focus on `moonwave.toml`, but the CLI also reads `moonwave.json`.
- The docs present `home.includeReadme` like a boolean, but implementation also accepts a string path.
- The plugin validates more structure in nested `classOrder.items` than the docs spell out.
- The CLI development instructions for Moonwave contributors use newer Node.js requirements than the end-user website docs.
