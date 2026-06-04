# API Coverage Checklist

## Before Finishing

Check each of these against the target tool:

- top-level package exports
- namespaces
- classes
- functions
- methods
- constructors
- hooks or callbacks
- events or signals
- CLI commands and flags
- config keys and accepted values
- re-exported APIs
- typed helper builders
- plugin or extension APIs
- standalone bundles or convenience entry points
- public constants and enums when they matter to users

## Caveat Pass

For each API area, ask:

- Are there client/server or runtime/environment restrictions?
- Are docs stale relative to implementation?
- Are there undocumented but exported members?
- Are there deprecated aliases or renamed helpers?
- Are there overload-resolution or coercion rules?
- Are there failure modes that only comments or source reveal?

## Structural Pass

- Is every public API documented in `references/apis/`?
- Are APIs grouped semantically instead of by source file?
- Is conceptual material preserved outside the API folder?
- Does the skill remain useful if the raw source docs disappear?
