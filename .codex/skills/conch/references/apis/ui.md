# UI API

## Primary API

### `bind_to(input: Enum.KeyCode | Enum.UserInputType): void`

Bind the UI toggle to a key code or input type.

Behavior:

- Automatically mounts the UI if it has not already been mounted.
- On matching input, toggles `opened`.
- Also mirrors the opened state into `focused`.

### `mount(): void`

Mount the app into `PlayerGui`.

Behavior:

- Idempotent after the first mount.
- Uses the local player’s `PlayerGui`.

### `opened: Vide.Source<boolean>`

Reactive source storing whether the console is open.

Usage:

- Read current state via `opened()`
- Set state via `opened(true)` or `opened(false)`

### `app(): ScreenGui`

Return the UI component root.

## Additional Runtime Exports

These are present in the runtime module even though the published typings only document a subset:

### `alignment`

Reactive source storing `"bottom"` or `"top"`.

### `focused`

Reactive source storing whether the console should be considered focused.

### `theme`

Theme module containing:

- `selected`
- `select_color`
- `ansi_pallete`
- `background`
- `background_transparency`
- `text`
- `text_error`
- `text_info`
- `text_warn`
- `text_success`
- `font`

### `conch`

Nested reference to the runtime package.

## Output Stream Concepts

The UI package contains a rich-text output stream implementation used by the console:

- Supports ANSI-like styling tags.
- Tracks active formatting state across lines.
- Escapes HTML-sensitive characters.
- Maintains a rolling buffer.

Exposed low-level API in the output module:

- `create_stream()`
- `write(stream, buffer)`
- `view_from(stream, lineNumber)`

Tag kinds handled by the stream:

- `color`
- `bgcolor`
- `bold`
- `italic`
- `underline`
- `strikethrough`

## Caveats

- `bind_to()` does not appear to filter out processed input events. If the target game already uses the same hotkey, test the interaction.
- The UI plugin bridge is initialized automatically through `plugin_api.expose(...)` in Studio-oriented contexts.
