# Conceptual Guides

## Moonwave Classes Are Documentation Buckets

Moonwave requires documentable items to belong to a "class". In practice, that means:

- a service table can be a class
- an OOP constructor table can be a class
- a plain module table can be a class

This is a documentation model, not a runtime inheritance system.

## Comment Forms

Moonwave supports two doc-comment styles:

1. Multi-line comments using `--[=[ ... ]=]`
2. Triple-dash line comments using `---`

Any line inside a doc comment that does not start with `@` or `.` is description text. Descriptions support Markdown and admonitions.

## Automatic Vs Manual Function Modeling

Important practical split:

- If a comment sits directly above a real function definition, Moonwave can infer that it is a function doc comment.
- `@function` is mainly for documenting functions that do not physically appear in the file or are generated indirectly.
- `@method` is the explicit form for a method-style function when there is no matching definition directly below.

Moonwave also auto-detects parameter and return types from Luau annotations. Manual `@param` and `@return` tags are mainly for descriptions or overrides.

## API Organization Model

Each class page is split into:

- types
- properties
- functions

Within those sections, Moonwave can further categorize members using `@tag` plus `apiCategories` in config.

## Type Links And Cross-References

Moonwave resolves type links from several sources:

1. Built-in Roblox type links
2. Class names in the current docs set
3. Named types declared under classes
4. External type links declared through `@external`

Short-link syntax inside descriptions is a first-class part of the writing model:

- `[ClassName]`
- `[ClassName:method]`
- `[ClassName.member]`
- Roblox types like `[CFrame]`

## Sidebar And Section Mental Model

`classOrder` is not only an ordering list. It also controls grouping:

- flat ordering by class name
- top-level named sections
- tag-based sections
- nested sections through repeated `items`
- per-section collapsed state

`autoSectionPath` is a second grouping mechanism. It derives section names from folder names under a configured path prefix and converts common file/folder naming styles into title case section names.

## Homepage Generation Model

The homepage behavior has several modes:

1. No custom home config: `README.md` becomes the homepage.
2. `[home].enabled = true`: Moonwave writes a generated React homepage.
3. If `includeReadme` is enabled, README content can be appended to that generated homepage.
4. If a real `pages/index.*` already exists, Moonwave leaves homepage ownership to that custom page.

Moonwave also supports selective README inclusion through these HTML comments:

- `<!--moonwave-hide-before-this-line-->`
- `<!--moonwave-hide-after-this-line-->`

These markers can hide leading, trailing, or middle segments of README content from the homepage.

## Static Assets And Customization

Moonwave treats `.moonwave/` as the customization root:

- `.moonwave/static/` maps to website root assets
- `.moonwave/custom.css` overrides global styling
- `.moonwave/sidebars.js` overrides the docs sidebar

This is the main project-local extension surface short of replacing entire Docusaurus pages.
