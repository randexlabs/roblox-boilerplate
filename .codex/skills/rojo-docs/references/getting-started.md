# Getting Started

## Contents

1. Installation paths
2. Installing the server
3. Installing the Studio plugin
4. Creating a new project
5. Building a place
6. Live sync
7. Uploading a place
8. Practical caveats

## Installation Paths

The current docs present two supported installation paths:

- Visual Studio Code extension
- CLI-based installation

If the user only installs the VS Code extension, keep one caveat explicit:

> The extension does not add `rojo` to the system `PATH`.

The docs recommend installing the CLI separately if terminal usage is needed.

## Installing the Server

Rojo has two pieces:

- the server / CLI
- the Roblox Studio plugin

### Recommended: Rokit

The current docs recommend `Rokit` as the primary toolchain manager for installing Rojo.

```bash
rokit add rojo-rbx/rojo
rokit install
```

### Alternative: GitHub Releases

Pre-built binaries are available for Windows, macOS, and Linux from Rojo's GitHub releases page. The docs note that the CLI is expected to be run from a terminal and that putting it on `PATH` is recommended.

### Alternative: `crates.io`

Rojo can also be installed from Rust crates, which compiles it from source:

```sh
cargo install rojo --version ^7
```

Use this only when Rust-based installation is acceptable.

## Installing the Studio Plugin

The current docs give three options:

### Using the CLI

This is the cleanest option when the CLI is already installed:

```bash
rojo plugin install
```

### From GitHub Releases

The docs also allow manual plugin installation from the GitHub releases page.

Important warning preserved from the docs:

- Rojo ships a separate plugin for each major version
- users must install the plugin that matches their major Rojo version

For manual installation, the docs instruct users to place the downloaded `rbxm` into the Roblox Studio plugins folder and point out that Studio exposes a **Plugins Folder** button to locate it.

### From Roblox.com

The current docs also provide a Roblox.com plugin page for the Rojo 7 plugin.

## Creating a New Project

Rojo provides a built-in project initializer.

### VS Code flow

The docs describe this sequence:

1. Open an empty folder in VS Code.
2. Open the command palette.
3. Run `Rojo: Open Menu`.
4. Choose `Create one now`.

The expected result is a new set of project files that are sufficient to start with Rojo.

### CLI flow

```sh
rojo init my-new-game
```

The docs state that Rojo creates the folder if necessary and initializes the project contents.

## Building a Place

The docs position building as the simplest way to get a working place file quickly.

### VS Code flow

The user opens `Rojo: Open Menu` and clicks `Build project`.

### CLI flow

```sh
rojo build -o build.rbxlx
```

Important note preserved from the docs:

- use `build.rbxl` if a binary place file is preferred

After a successful build, the docs expect a `build.rbxlx` output file that can be opened in Roblox Studio.

## Live Sync

The docs distinguish live iteration from one-off builds. For active development, they recommend running the live sync server and connecting from the Studio plugin.

### Starting the server in VS Code

The documented flow is:

1. Run `Rojo: Open Menu`.
2. Choose the project from the workspace section.
3. Start the server.

### Starting the server in the CLI

```sh
rojo serve
```

Expected output:

```text
Rojo server listening:
  Address: localhost
  Port:    34872

Visit http://localhost:34872/ in your browser for more information
```

### Connecting from Studio

The docs describe opening the Rojo toolbar button in Studio, opening the plugin panel, and pressing **Connect**.

Once connected, filesystem edits should sync into Studio in real time.

The docs also note that the URL printed by `rojo serve` exposes extra information about the running session.

## Uploading a Place

The docs present upload automation as a more advanced workflow for teams that want serious automation.

Prerequisites preserved from the docs:

- an existing Roblox game
- a `.ROBLOSECURITY` cookie for an account with write access

Security guidance preserved from the docs:

- use a dedicated deployment account instead of a personal account whenever possible

CLI example:

```sh
rojo upload --asset_id [PLACE ID] --cookie "[SECURITY COOKIE]"
```

Windows-specific note from the docs:

- if Roblox Studio is installed on Windows, `--cookie` can be omitted and taken from the Studio session

The docs also reference the `Desert Bus 2077` GitHub repository as an example of automated deployment with GitHub Actions.

## Practical Caveats

- VS Code currently helps with initialization, build, and server control, but upload is not supported there according to the docs.
- Building and live sync solve different problems. Building is useful when live sync limitations block a workflow.
- Plugin version mismatches matter. Keep the major plugin version aligned with the installed Rojo version.
