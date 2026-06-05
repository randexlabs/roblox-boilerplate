# Composition And Features

## Labels And Images

Icons can show:

- image only
- label only
- both together

Width is dynamic, but `setWidth` can establish a minimum width to reduce resizing churn for changing labels.

## Captions

`icon:setCaption(text)` adds a caption. Passing `nil` or an empty string removes it.

`icon:setCaptionHint(keyCode)` customizes the hotkey hint appearance without binding a real toggle key.

## Notices

`icon:notify()` creates an accumulating notice bubble. Child-icon notices can bubble up to the parent icon when the parent is deselected.

Relevant helpers:

- `icon:notify(...)`
- `icon:clearNotices()`

## Toggle Items

`bindToggleItem` wires a `GuiObject` or `LayerCollector` to icon selection:

- selected -> shown
- deselected -> hidden

This is a convenience wrapper over event connections and also helps controller navigation track toggle item buttons.

## Dropdowns

Dropdowns are vertical child-icon containers:

```lua
icon:setDropdown({ childIcon1, childIcon2 })
```

Key rules:

- pass `{}` to remove the dropdown
- icons with dropdowns can join menus
- docs warn they cannot join other dropdowns

## Menus

Menus are horizontal child-icon containers:

- `icon:setMenu(...)`
- `icon:setFixedMenu(...)`
- `icon:joinMenu(parentIcon)`

Fixed menus are effectively always open and hide their close button.

## Joining And Leaving

Child icons can explicitly join or leave parent features:

- `joinDropdown`
- `joinMenu`
- `leave`

The runtime also tracks child theme inheritance through `modifyChildTheme`.

## One-Click Icons

`icon:oneClick(true)` makes the icon select and then immediately deselect, behaving like a button rather than a persistent toggle.

## NumberSpinner Integration

`convertLabelToNumberSpinner(numberSpinner, readyCallback)` replaces the label behavior with a NumberSpinner-like UI object.

Important caveat from the docs:

- perform NumberSpinner customization inside `readyCallback`

The method internally resizes and mirrors label styling, so mutating the spinner too early can break appearance.
