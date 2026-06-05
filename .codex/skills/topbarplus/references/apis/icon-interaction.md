# `Icon` Interaction API

## Theme Methods

### `icon:modifyTheme(modifications) -> Icon`

Applies one or many theme modifications to this icon.

### `icon:modifyChildTheme(modifications, modificationUID?) -> Icon`

Applies modifications to child icons in menus or dropdowns.

## Notices And Captions

### `icon:notify(clearNoticeEvent?, noticeId?) -> Icon`

Creates or increments a notice bubble.

`clearNoticeEvent` may be a TopbarPlus signal or a Roblox event object.

### `icon:clearNotices() -> Icon`

Clears active notices.

### `icon:setCaption(text?: string) -> Icon`

Sets or removes caption text.

### `icon:setCaptionHint(keyCode: Enum.KeyCode) -> Icon`

Sets a visible caption hint without binding the key as a real toggle.

## Toggle Bindings

### `icon:bindToggleItem(guiObjectOrLayerCollector) -> Icon`

Shows/hides the target with icon selection.

### `icon:unbindToggleItem(guiObjectOrLayerCollector) -> Icon`

Removes the toggle binding.

### `icon:bindToggleKey(keyCode: Enum.KeyCode) -> Icon`

Binds a keycode to toggle the icon and also updates caption hotkey behavior.

### `icon:unbindToggleKey(keyCode: Enum.KeyCode) -> Icon`

Removes a bound toggle key.

## Events

### `icon:bindEvent(eventName, callback) -> Icon`

Connects to a named icon event and passes `self` as the first callback argument.

Documented event names:

- `selected`
- `deselected`
- `toggled`
- `viewingStarted`
- `viewingEnded`
- `notified`

### Direct event signals

You can also connect to the primary signals directly:

- `icon.selected`
- `icon.deselected`
- `icon.toggled`
- `icon.viewingStarted`
- `icon.viewingEnded`
- `icon.notified`

### `icon:unbindEvent(eventName) -> Icon`

Disconnects a named bound event.

## Child Composition

### `icon:setDropdown(icons: {Icon}) -> Icon`

Creates or replaces a dropdown.

### `icon:joinDropdown(parentIcon: Icon) -> Icon`

Joins another icon's dropdown.

### `icon:setMenu(icons: {Icon}) -> Icon`

Creates or replaces a menu.

### `icon:setFixedMenu(icons: {Icon})`

Creates an always-open menu with hidden close button. Runtime does not explicitly return `self`.

### `icon:joinMenu(parentIcon: Icon) -> Icon`

Joins another icon's menu.

### `icon:leave() -> Icon`

Leaves a parent dropdown or menu.

## Utility

### `icon:call(callback, ...args) -> Icon`

Runs `callback(self, ...args)` through `task.spawn`, preserving fluent call style.

### `icon:addToJanitor(resource, methodName?, index?) -> Icon`

Registers a resource for cleanup when the icon is destroyed.

### `icon:convertLabelToNumberSpinner(numberSpinner, readyCallback) -> Icon`

Converts the label into a NumberSpinner-driven display and calls `readyCallback` after setup.

### `icon:destroy() -> Icon`

Destroys UI, signals, connections, notices, and feature memberships associated with the icon.
