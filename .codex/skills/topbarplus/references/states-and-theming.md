# States And Theming

## Icon States

TopbarPlus uses three named states:

- `Deselected`
- `Selected`
- `Viewing`

`Viewing` means hover-like attention: mouse hover, gamepad highlight, or mobile long-press before release.

Many methods accept an optional `iconState`. If omitted, the change applies across states.

```lua
Icon.new()
    :setImage(4882429582)
    :setLabel("Closed", "Deselected")
    :setLabel("Open", "Selected")
    :setLabel("Viewing", "Viewing")
```

The docs say state names are case-insensitive in practice.

## Chainable And Toggleable Methods

Docs mark some methods as:

- `chainable`: returns the icon for fluent calls
- `toggleable`: accepts an `iconState`

This matters because some appearance methods are global, while others are state-aware.

## Theme Modification Model

`modifyTheme` and `modifyBaseTheme` operate on modification arrays shaped like:

```lua
{name, property, value, iconState}
```

Meaning of each field:

| Field       | Meaning                                         |
| ----------- | ----------------------------------------------- |
| `name`      | Instance name or collective group name          |
| `property`  | Roblox property name or fallback attribute name |
| `value`     | New value to apply                              |
| `iconState` | Optional state filter                           |

## Single Modification Or Collection

Both are valid:

```lua
icon:modifyTheme({"IconLabel", "TextSize", 16})

icon:modifyTheme({
    {"Widget", "MinimumWidth", 290},
    {"IconCorners", "CornerRadius", UDim.new(0, 0)},
})
```

## Per-Icon Versus Global Theme

- `icon:modifyTheme(...)` changes one icon
- `icon:modifyChildTheme(...)` changes menu/dropdown children
- `Icon.modifyBaseTheme(...)` changes the base appearance of all icons

## Theme Sources

The docs point users to the built-in `Default` theme module for examples. The runtime also includes theme modules like `Default` and `Classic`.

## Lower-Level Theme Control

The source exposes lower-level helpers like `setTheme`, `setBehaviour`, `removeModification`, and `removeModificationWith`. These are not centered in the public docs, but they are real runtime surface and useful for advanced customization or undoing specific modifications.
