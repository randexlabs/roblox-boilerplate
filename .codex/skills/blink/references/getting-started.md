# Getting Started

## Installation Paths

Recommended install path:

```sh
rokit add 1Axen/blink
```

Update with:

```sh
rokit update 1Axen/blink
```

Other supported distribution paths:

- Prebuilt binaries from GitHub Releases
- `pesde` package installs from Blink `0.18.5+`
- Roblox Studio plugin for authoring and generation inside Studio

## First Compile Flow

Create a schema file such as:

```blink
option ClientOutput = "path/to/client"
option ServerOutput = "path/to/server"

event MyFirstEvent {
    From: Server,
    Type: Reliable,
    Call: SingleSync,
    Data: string
}
```

Compile it with:

```sh
blink file-name
```

Blink resolves `file-name`, `file-name.txt`, or `file-name.blink` in the current directory.

## Output Expectations

- `ClientOutput` and `ServerOutput` are required for CLI generation.
- The compiler appends `.luau` to those output names.
- If the output file name is `init`, the generated TypeScript sibling becomes `index.d.ts`.
- Relative output paths are resolved from the schema file directory.
- Missing output directories trigger a prompt unless `--yes` is supplied.

## Watch Mode

Use:

```sh
blink file-name --watch
```

Watch mode:

- watches the entry file and all imported files recursively
- re-traverses imports on rebuild
- recompiles automatically on file timestamp changes
- runs with silent compile output by default inside the watch loop

## Studio Plugin Workflow

The Studio plugin is useful when you want to author and generate Blink files without leaving Studio.

High-level flow:

1. Open the plugin and grant script injection permissions.
2. Create or open a network description from the side menu.
3. Save the source file from the editor.
4. Choose `Generate`.
5. Pick an output location that both client and server can require.

Practical plugin limits from the docs:

- generation still depends on valid Blink source
- sibling `./` imports are supported in the Studio editor
- broader filesystem-style imports are not documented for Studio

## Typical Project Pattern

- Keep one or more `.blink` files near your networking package or feature folder.
- Generate a client and server module into a shared location that both sides can require appropriately.
- Optionally generate a shared types module if you want serializers or type exports without the runtime event surface.
- Treat the generated files as build artifacts and regenerate instead of hand-editing them.
