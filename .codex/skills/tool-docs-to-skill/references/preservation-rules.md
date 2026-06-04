# Preservation Rules

## Primary Principle

Do not optimize for brevity. Optimize for future usefulness.

## Keep

Keep anything that helps a future engineer understand or debug the tool:

- public API signatures
- overloads and variants
- documented and observed caveats
- examples
- warnings and notes
- behavior differences across environments
- assumptions made by the tool
- comments that explain non-obvious behavior
- author remarks that clarify intent
- troubleshooting and workaround material
- mismatches between docs and implementation

## Do Not Collapse Everything Into API Catalogs

API files are necessary, but they are not sufficient.

Preserve:

- conceptual explanations
- problem framing
- design constraints
- practical usage guidance
- debugging-oriented context

If a tool exposes a language, DSL, plugin system, or runtime model, document that model outside the raw API listings too.

## Resolve Ambiguity By Keeping More

When deciding whether a section is “too contextual” or “too specific,” prefer keeping it if it could help future diagnosis, onboarding, or usage decisions.

## Path Hygiene

Do not mention ingestion-only file paths or temporary source locations in the finished skill.

The skill should read like first-party documentation for the tool, not like notes about where the material was harvested from.
