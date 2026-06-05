# Static Module API

## Constructors

### `Icon.new() -> Icon`

Creates a new empty topbar icon.

Default documented behavior:

- empty `32x32` icon
- chainable instance methods used afterward

## Documented Static Functions

### `Icon.getIcons() -> {[uid]: Icon}`

Returns the dictionary of all live icons keyed by UID.

### `Icon.getIcon(nameOrUID: string | number) -> Icon?`

Returns an icon by UID or by the name set with `icon:setName(...)`.

### `Icon.setTopbarEnabled(enabled: boolean)`

Shows or hides all TopbarPlus ScreenGuis without affecting Roblox's native topbar.

### `Icon.modifyBaseTheme(modifications)`

Applies theme modifications to all icons by updating the base theme and reapplying it to existing icons.

### `Icon.setDisplayOrder(order: number)`

Sets the base `DisplayOrder` used by TopbarPlus ScreenGuis.

## Runtime-Visible Static State

These are source-visible and useful in advanced scenarios, but not all are emphasized as public API docs:

- `Icon.baseDisplayOrder`
- `Icon.baseDisplayOrderChanged`
- `Icon.baseTheme`
- `Icon.insetHeightChanged`
- `Icon.container`
- `Icon.topbarEnabled`
- `Icon.iconAdded`
- `Icon.iconRemoved`
- `Icon.iconChanged`
- `Icon.highlightKey`

Use caution when building hard dependencies on these unless the task explicitly needs runtime internals.

## Runtime Compatibility Function

### `Icon.getIconByUID(uid) -> Icon?`

Source-exposed helper that bypasses name lookup and fetches directly by UID.
