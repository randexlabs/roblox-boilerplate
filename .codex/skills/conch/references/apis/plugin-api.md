# Plugin API

## Purpose

The plugin-facing API is a small Studio bridge for exposing and consuming package APIs through folders, bindables, and attributes.

The concrete runtime bridge in the available material is used to share Conch UI history.

## Generic Plugin API Surface

### `get_signal<T...>(): (Signal<T...>, fireFn)`

Create a signal-like table plus a fire function.

Use this for event-style plugin APIs.

### `expose(version, key, value): void`

Expose a table API under a named Studio folder.

Behavior:

- Studio-only.
- Rejects non-table roots.
- Rejects recursive table graphs.
- Serializes nested tables into nested folders.
- Serializes functions into `BindableFunction`s.
- Serializes signals into `BindableEvent`s.

### `load(front): T`

Load a previously exposed API from a folder reference.

The plugin package copy appears to be the intended consumer-facing implementation.

### `find_plugins_api(name)`

Return matching exposed APIs and their version metadata.

### `wait_for_first_api(name)`

Wait for the first matching API exposure.

## Version Metadata

Each exposed API carries:

- user-facing major/minor/patch
- package major/minor/patch

There is also a semver helper with:

- `is_compatible(requirement, against)`

Return states:

- `"ok"`
- `"compatible"`
- `"likely_incompatible"`
- `"bad"`

## Runtime UI History API

The UI package exposes a history bridge with:

### `set_history(history: { string }): void`

Replace the full command history and emit an update.

### `get_history(): { string }`

Return the current command history array.

### `add(text: string): void`

Insert a new history entry at the front, removing prior duplicates and trimming to a max history size.

### `updated_history: Signal<{ string }>`

Event fired whenever history changes.

## Practical Caveats

- The history list is capped at 500 items.
- Re-adding an existing entry moves it to the front instead of keeping duplicates.
- The UI package internally exposes the bridge automatically; plugin consumers typically load it through the plugin runtime package.
- There is an apparent implementation discrepancy in one `load()` copy under the UI package. Prefer the dedicated plugin package consumer path when possible.
