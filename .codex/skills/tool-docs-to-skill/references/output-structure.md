# Output Structure

## Required Shape

Create a skill folder with:

```text
skill-name/
├── SKILL.md
├── agents/openai.yaml
└── references/
    ├── overview.md
    ├── getting-started.md
    ├── conceptual-guides.md
    ├── troubleshooting.md
    └── apis/
        ├── runtime.md
        ├── cli.md
        ├── configuration.md
        ├── extension-points.md
        └── ...
```

The exact filenames can vary, but the organization should remain semantic and easy to scan.

## `SKILL.md`

Keep `SKILL.md` lean. It should:

- explain what the skill is for
- explain when to use it
- route to the right reference files
- state important operating rules

Do not copy the whole documentation into `SKILL.md`.

## `references/`

Use `references/` for:

- conceptual overview
- setup and first-use guidance
- architecture or mental models
- troubleshooting
- caveats
- compatibility notes
- migration or version mismatch notes

## `references/apis/`

This folder is mandatory for this skill pattern.

Split APIs by behavior:

- runtime API
- CLI surface
- configuration schema
- plugin or extension API
- language API
- AST API
- analysis API
- UI API
- standalone bundle API

Do not dump every API into one monolithic file unless the surface is trivially small.

## File Writing Style

- Use clear section titles.
- Use tables where they help compare APIs or capabilities.
- Preserve code examples.
- Preserve warnings, notes, and author commentary when they help future debugging.
- Prefer practical wording over academic taxonomy.
