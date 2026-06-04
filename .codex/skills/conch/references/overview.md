# Overview

## What Conch Provides

Conch is a developer console and command language aimed at Roblox. At the top level it gives developers:

- A runtime package for registering commands, permissions, users, custom argument types, and command lifecycle hooks.
- A client UI package for mounting and toggling the console.
- A standalone bundle that combines runtime and UI into a single entry point.
- A language layer for parsing, executing, displaying, and analyzing Conch source.
- A plugin-facing API used by the UI package to expose command history inside Studio.

## Package Map

| Package               | Purpose                                                                                                                         | Typical consumer                  |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `conch`               | Main runtime package. Connects command registration, execution, permissions, networking, analysis, and built-in types.          | Game code on server and client    |
| `conch_ui`            | UI wrapper built on top of the runtime package. Handles mounting, toggle state, focus state, theme, and plugin-exposed history. | Client code                       |
| `conch_standalone`    | Bundle used by the standalone model install. Mirrors `conch` and adds `ui` under `conch.ui`.                                    | Standalone consumers              |
| `conch_language`      | Language VM, parser, AST utilities, analysis/autocomplete, and display helpers.                                                 | Advanced integrations and tooling |
| `conch_analysis`      | Analysis/autocomplete layer conceptually exposed through `conch_language`.                                                      | Usually indirect                  |
| `conch_ast`           | AST parser, visitor, and display layer conceptually exposed through `conch_language`.                                           | Usually indirect                  |
| `conch_compiler`      | Mentioned as part of the ecosystem, but no separate developer-facing API surface is documented in the available material.       | Internal ecosystem component      |
| `conch_types`         | Mentioned as a types package, but no separate developer-facing API surface is documented in the available material.             | Internal ecosystem component      |
| `conch_vm`            | Mentioned as the VM package, but the locally available developer-facing entry point is `conch_language.run`.                    | Internal ecosystem component      |
| Plugin runtime bridge | Small Studio-only bridge for sharing UI history with plugins.                                                                   | Studio plugin code                |

## Mental Model

Use Conch as two stacked systems:

1. The runtime and UI layer:
    - Register commands.
    - Register or reuse argument types.
    - Assign roles and permissions.
    - Mount and open the console on the client.

2. The language layer:
    - Parse and execute command source.
    - Analyze input for autocomplete and hints.
    - Inspect or traverse AST nodes.

## What Matters Most In Practice

- `conch` is the normal entry point for gameplay code.
- `conch_ui` is optional but is what exposes the console interface to players.
- `conch_language` matters when you need autocomplete, custom type analysis, AST tooling, or direct language execution outside the higher-level runtime.
- The runtime implementation exposes more than the docs and typings admit. See [troubleshooting.md](troubleshooting.md) before relying only on the published docs.
