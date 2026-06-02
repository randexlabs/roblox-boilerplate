# Integrations, Cookbook, and Recipes

## Table of Contents

1. Read this when
2. Primary source files
3. Integration surfaces
4. CI and generated artifacts
5. Cookbook topics
6. Language/runtime recipes
7. Practical routing tips

## Read this when

Use this reference for:

- CI/CD integration
- GitHub Actions or devcontainer generation
- editor or direnv integration
- MCP, OCI, or sync workflows
- practical example-driven questions
- language/runtime-specific setup guidance

## Primary source files

- `mise/docs/continuous-integration.md`
- `mise/docs/ide-integration.md`
- `mise/docs/direnv.md`
- `mise/docs/mcp.md`
- `mise/docs/dev-tools/mise-oci.md`
- `mise/docs/mise-cookbook/index.md`
- `mise/docs/mise-cookbook/*.md`
- `mise/docs/lang/*.md`
- `mise/docs/cli/generate*.md`
- `mise/docs/cli/sync*.md`
- `mise/docs/cli/oci*.md`
- `mise/docs/cli/mcp.md`

## Integration surfaces

These docs are useful when users are not asking about core config syntax, but about fitting `mise` into a real workflow:

- shell + `direnv`
- IDE/editor behavior
- CI runners
- OCI/container flows
- MCP integration
- runtime-specific sync helpers

## CI and generated artifacts

Important CLI docs:

- `mise/docs/cli/generate/bootstrap.md`
- `mise/docs/cli/generate/config.md`
- `mise/docs/cli/generate/devcontainer.md`
- `mise/docs/cli/generate/git-pre-commit.md`
- `mise/docs/cli/generate/github-action.md`
- `mise/docs/cli/generate/task-docs.md`
- `mise/docs/cli/generate/task-stubs.md`
- `mise/docs/cli/generate/tool-stub.md`

When users ask for generated setup files, check whether `mise` already ships the relevant generator before proposing custom glue.

## Cookbook topics

The cookbook exists specifically for practical patterns. Current areas include:

- C++
- Docker
- Neovim
- Node.js
- presets
- Python
- Ruby
- shell tricks
- Terraform

Source files:

- `mise/docs/mise-cookbook/cpp.md`
- `mise/docs/mise-cookbook/docker.md`
- `mise/docs/mise-cookbook/neovim.md`
- `mise/docs/mise-cookbook/nodejs.md`
- `mise/docs/mise-cookbook/presets.md`
- `mise/docs/mise-cookbook/python.md`
- `mise/docs/mise-cookbook/ruby.md`
- `mise/docs/mise-cookbook/shell-tricks.md`
- `mise/docs/mise-cookbook/terraform.md`

## Language/runtime recipes

Use `mise/docs/lang/*.md` when the question is runtime-specific and the answer depends on ecosystem conventions, not just generic `mise` commands.

Examples:

- Node and package-manager behavior
- Python virtualenv or version-file workflows
- Ruby or Java ecosystem-specific conventions
- Rust, Go, or Swift runtime/toolchain differences

## Practical routing tips

- For "how do I wire `mise` into GitHub Actions?" start with `continuous-integration.md` and `cli/generate/github-action.md`.
- For "can `mise` help generate local setup files?" inspect the `generate` command family.
- For "show me a real pattern" prefer cookbook pages over abstract conceptual docs.
