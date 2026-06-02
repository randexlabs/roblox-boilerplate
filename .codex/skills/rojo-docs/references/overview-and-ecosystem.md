# Overview and Ecosystem

## Contents

1. What Rojo is
2. Why teams adopt it
3. Tooling ecosystem
4. Editor workflow
5. Version control and collaboration
6. TypeScript and other languages
7. Support and feedback channels

## What Rojo Is

Rojo is a project management tool for Roblox development that lets teams work from files on disk instead of treating Roblox Studio as the only source of truth. Its documentation positions it as a way to bring professional software workflows and tooling into Roblox projects.

The official docs describe the documentation itself as a work in progress and explicitly invite users to report issues on the Rojo website issue tracker.

## Why Teams Adopt It

The main value proposition is not just "sync files into Studio." Rojo exists to make the broader file-based software ecosystem available to Roblox developers.

Practical benefits called out in the docs:

- access to mature tooling that operates on files
- easier collaboration through version control
- better editor support outside Roblox Studio
- improved project organization
- compatibility with typed and compiled workflows such as TypeScript

## Tooling Ecosystem

The docs explicitly highlight several tools commonly paired with Rojo:

| Tool       | Purpose                                   |
| ---------- | ----------------------------------------- |
| `Selene`   | Static analysis for Lua/Luau              |
| `StyLua`   | Code formatting                           |
| `Wally`    | Package management for Roblox projects    |
| `Moonwave` | Documentation generation for Lua projects |

The intent is broader than these examples. Rojo makes it possible to use file-based tooling in general, not only Roblox-specific tools.

## Editor Workflow

The docs recommend external text editors because they expose stronger editing and navigation features than Roblox Studio. Visual Studio Code and Sublime Text are explicitly mentioned as popular choices.

Capabilities highlighted by the docs include:

- multi-cursor editing
- symbol navigation
- multi-file search and replace
- bookmarks
- plugin ecosystems

Common VS Code extensions mentioned alongside Rojo:

| Extension   | Purpose                      | Notes                                   |
| ----------- | ---------------------------- | --------------------------------------- |
| `luau-lsp`  | Luau language server support | Often overlaps with Selene analysis     |
| `StyLua`    | VS Code companion for StyLua | Formatting workflow                     |
| `Selene`    | VS Code companion for Selene | Static analysis                         |
| `roblox-ui` | Rojo project visualizer      | Helps navigate and extend project trees |

## Version Control and Collaboration

The docs make version control a first-class motivation for adopting Rojo.

Key points:

- when code and project assets are represented as individual files, Git becomes practical
- GitHub or GitLab can add code review and issue tracking workflows
- this aligns Roblox projects with how professional software teams collaborate

The docs are direct about this: version control is one of the biggest quality-of-life improvements unlocked by file-based workflows.

## TypeScript and Other Languages

Rojo pairs naturally with `roblox-ts`, which compiles TypeScript to Luau. The docs highlight:

- static type safety
- stronger autocomplete
- access to the TypeScript tooling ecosystem
- modern language features such as arrow functions and destructuring

The docs also mention other languages that compile to Lua, including MoonScript and Haxe, but warn that their tooling ecosystems are much weaker.

## Support and Feedback Channels

The docs point users to the Roblox Open Source Community Discord for help, specifically the `#rojo` channel.

Important guidance preserved from the original docs:

- ask Rojo questions in `#rojo`
- do not post Rojo support questions in `#general`
- file suspected bugs and feature ideas on the Rojo GitHub issue tracker

These support instructions matter because the docs position Rojo adoption as non-trivial and expect teams to need troubleshooting help.
