# Runtime Extensions And Compatibility

These methods or aliases are present in the source but are not all foregrounded in the docs as the primary public surface.

## Compatibility Aliases

### `icon:disableStateOverlay(bool)`

Alias of `disableOverlay`.

### `icon:setAlignment(...)`

Alias of `align`.

### `icon:setLeft()`

Compatibility alias for `align("Left")`.

### `icon:setMid()`

Compatibility alias for `align("Center")`.

### `icon:setRight()`

Compatibility alias for `align("Right")`.

### `icon:setFrozenMenu(...)`

Alias of `setFixedMenu`.

### `icon:Destroy()`

Alias of `destroy`.

## Advanced Theme And Behavior Hooks

### `icon:setBehaviour(instanceOrCollectiveName, property, callback, refreshAppearance?)`

Registers a custom property behavior hook used before appearance changes are applied.

Useful for advanced integrations, but it is an internal-style extension point rather than mainstream user API.

### `icon:removeModification(modificationUID) -> Icon`

Removes a specific prior modification by ID.

### `icon:removeModificationWith(instanceName, property, state?) -> Icon`

Removes a matching modification by target details.

### `icon:setTheme(theme) -> Icon`

Applies a full theme object directly.

## Feature Helpers

### `icon:getDropdown() -> Instance`

Lazily creates or returns the dropdown instance.

### `icon:clipOutside(instance) -> (Icon, cloneInstance)`

Creates clone-based clipping support for overflow visuals like notices or dropdowns.

### `icon:setIndicator(keyCode?)`

Controls controller indicator affordances for the icon. Runtime does not explicitly return `self`.

### `icon:freezeMenu()`

Forces the icon into a permanently selected menu state with hidden toggle UI. Runtime does not explicitly return `self`.

## Runtime Signals Not Centered In Main Docs

The instance creates many additional signals beyond the six primary documented events, including:

- `stateChanged`
- `noticeStarted`
- `noticeChanged`
- `endNotices`
- `toggleKeyAdded`
- `fakeToggleKeyChanged`
- `alignmentChanged`
- `updateSize`
- `resizingComplete`
- `joinedParent`
- `menuSet`
- `dropdownSet`
- `updateMenu`
- `startMenuUpdate`
- `childThemeModified`
- `indicatorSet`
- `dropdownChildAdded`
- `menuChildAdded`

These are useful for source-level extension work but should be treated as less stable than the documented event list unless the version is pinned and verified.
