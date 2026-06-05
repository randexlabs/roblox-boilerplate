# Overview

## What TopbarPlus Is

TopbarPlus is a Roblox client-side UI library for constructing dynamic topbar icons. It provides a chainable `Icon` API for building buttons, labels, image icons, menus, dropdowns, captions, notices, and related topbar interactions.

The library is designed around a single core object:

- the static `Icon` module
- icon instances created with `Icon.new()`

## What It Solves

- topbar icon construction with a consistent fluent API
- theming and state-based appearance changes
- built-in dropdown and menu composition
- toggle bindings for GUI, keybinds, and captions
- gamepad and console navigation support
- overflow handling across screen sizes and device classes

## Runtime Model

TopbarPlus creates ScreenGuis under `PlayerGui` and manages layout internally. It supports:

- PC
- mobile and tablet
- gamepad and console
- localization-aware label resizing

The source also defends against multiple copies of TopbarPlus being required in the same experience by electing one dominant package instance.

## Core Vocabulary

| Term               | Meaning                                                               |
| ------------------ | --------------------------------------------------------------------- |
| `Icon`             | The required module and static API namespace                          |
| icon               | An instance created by `Icon.new()`                                   |
| icon state         | `Deselected`, `Selected`, or `Viewing`                                |
| theme modification | A `{name, property, value, iconState?}` array or collection of arrays |
| dropdown           | Vertical child icon list                                              |
| menu               | Horizontal child icon list                                            |
| fixed menu         | Menu forced open with hidden close button                             |
| toggle item        | `GuiObject` or `LayerCollector` shown/hidden with icon state          |

## Good Fit

- navigation bars
- action buttons that open UI panels
- compact status or notice surfaces
- controller-friendly topbar UI
- apps or admin tools that need robust topbar integration

## Less Ideal Fit

- server-side scripting
- fully custom UI frameworks where you do not want TopbarPlus to own topbar layout
- cases where direct Roblox CoreGui manipulation is preferable to icon abstraction
