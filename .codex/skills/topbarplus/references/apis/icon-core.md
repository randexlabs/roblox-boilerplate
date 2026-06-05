# `Icon` Core API

## Identification And Lookup

### `icon:setName(name: string) -> Icon`

Sets the widget name used by `Icon.getIcon(name)`.

### `icon:getInstance(instanceName: string) -> Instance?`

Finds the first descendant inside the widget by name.

## State And Visibility

### `icon:setEnabled(enabled: boolean) -> Icon`

Shows or hides the icon and updates parent layout behavior.

### `icon:disableOverlay(disabled: boolean) -> Icon`

Disables or re-enables the pressed/released overlay shade effect.

### `icon:select(fromSource?, sourceIcon?) -> Icon`

Selects the icon.

### `icon:deselect(fromSource?, sourceIcon?) -> Icon`

Deselects the icon.

### `icon:lock() -> Icon`

Disables user-input toggling while still allowing scripted toggles.

### `icon:unlock() -> Icon`

Re-enables user-input toggling.

### `icon:debounce(seconds: number) -> Icon`

Locks, waits, then unlocks. This method yields.

### `icon:autoDeselect(enabled?: boolean) -> Icon`

Controls whether selecting another icon auto-deselects this icon. Defaults to `true`.

### `icon:oneClick(enabled?: boolean) -> Icon`

Makes the icon behave like a single-click action by auto-deselecting after selection.

## Appearance

### `icon:setImage(imageId: string | number, iconState?) -> Icon`

Applies an icon image. The runtime also preloads the image if needed.

### `icon:setLabel(text: string, iconState?) -> Icon`

Sets the icon label text.

### `icon:setOrder(order: number, iconState?) -> Icon`

Sets layout order. Internally multiplied by `100` to preserve decimal-style ordering semantics.

### `icon:setCornerRadius(value, iconState?) -> Icon`

Sets corner radius styling for icon corners.

Docs present scale/offset wording; source forwards a radius value directly to the `CornerRadius` property.

### `icon:align(alignment: "Left" | "Center" | "Right") -> Icon`

Changes screen-side alignment.

### `icon:setWidth(minimumWidth: number, iconState?) -> Icon`

Sets minimum width.

### `icon:setImageScale(scale: number, iconState?) -> Icon`

Controls image scale within the icon.

### `icon:setImageRatio(ratio: number, iconState?) -> Icon`

Controls image aspect ratio.

### `icon:setTextSize(size: number, iconState?) -> Icon`

Sets label text size.

### `icon:setTextColor(color: Color3, iconState?) -> Icon`

Sets label text color.

Runtime caveat:

- invalid or missing color values are coerced to white with a warning

### `icon:setTextFont(font, fontWeight?, fontStyle?, iconState?) -> Icon`

Sets `FontFace` using one of several accepted forms:

- font family name string
- `Enum.Font`
- numeric font ID
- `rbxasset://fonts/families/...` path

## Properties

Documented instance properties:

- `icon.name`
- `icon.isSelected`
- `icon.isEnabled`
- `icon.totalNotices`
- `icon.locked`

Runtime also exposes additional fields like `UID`, `alignment`, `screenGui`, and various janitors/signals, but those are implementation-level unless a task explicitly depends on them.
