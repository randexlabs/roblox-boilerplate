# Troubleshooting

## Nothing Appears

Common causes:

- requiring TopbarPlus from server code instead of client code
- requiring it before client UI context is appropriate
- constructing icons but never setting visible label/image/theme changes you expect

TopbarPlus internally waits for `PlayerGui` and parents its ScreenGuis there.

## Toggle Binding Fails

`bindToggleItem` only accepts `GuiObject` or `LayerCollector`. Passing anything else raises an error.

`bindToggleKey` and `setCaptionHint` require `Enum.KeyCode` values. Passing non-enum values asserts.

## Theme Change Seems Ignored

Possible reasons:

- wrong instance or collective name in the modification array
- change applied to the wrong state
- a later modification overwrote the earlier one
- you are styling a clone-managed element such as dropdown/caption visuals and need to let the library's internal clone handling mirror it

For advanced debugging, runtime helpers like `setBehaviour`, `removeModification`, and `removeModificationWith` are useful.

## `oneClick` Looks Sticky

The implementation always sets `self.oneClickEnabled = true`, but the actual automatic deselect behavior is governed by the janitor-managed selected connection. If you call `oneClick(false)`, the connection is cleaned and the behavior stops even though the internal flag name remains misleading.

## `setFixedMenu` Return Shape Is Different

Most documented methods are chainable and return the icon. In the source, `setFixedMenu`, `freezeMenu`, and `setIndicator` do not explicitly return `self`. Treat them as behavior helpers, not guaranteed fluent methods, unless you confirm the version you're using.

## Source And Docs Mismatches Worth Remembering

- Docs say `disableOverlay`; runtime also exposes alias `disableStateOverlay`.
- Docs show `setCornerRadius(scale, offset, iconState)` but the runtime implementation takes a `UDim`-style value directly and forwards it to the `CornerRadius` property.
- Docs list six primary events, but runtime also creates many additional signals used for internal coordination.
- Runtime exposes extra methods like `getIconByUID`, `getDropdown`, `clipOutside`, and modification-removal helpers that are not centered in the main docs.

## Reset-On-Spawn Behavior

The runtime checks whether the requiring script originated under a `ScreenGui` with `ResetOnSpawn = true`. If so, the icon is destroyed on respawn to avoid stale UI duplication. This can surprise you if your script lifecycle is tied to resettable UI.
