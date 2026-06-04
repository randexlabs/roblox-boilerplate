# Source Hunting

## What To Inspect

Inspect any source that can reveal the public developer experience of the tool:

- `README` files
- `docs/` trees
- `*.md`
- inline comments that explain behavior, constraints, or edge cases
- declaration files such as `*.d.ts`
- exported functions, classes, modules, namespaces, and types
- examples that demonstrate intended usage
- source files where public APIs are defined or re-exported

## What To Extract

Extract information about:

- public APIs
- CLI commands or subcommands
- configuration shape
- runtime behavior
- extension points
- error cases
- migration notes
- caveats and mismatches
- conceptual explanations that help users reason about the tool

## What To Ignore

Ignore material that is only about maintaining the repository, unless it directly affects tool usage:

- CI workflows
- release automation
- formatter and lint configs
- contributor-only setup
- funding and community boilerplate
- unrelated test harness internals

## Reading Strategy

1. Start with overview docs to understand the product model.
2. Read API docs and type declarations to map the official surface.
3. Read source exports to catch missing or stale documentation.
4. Read examples and comments to capture tacit usage knowledge.
5. Re-check for re-exported APIs so nothing public is missed.
