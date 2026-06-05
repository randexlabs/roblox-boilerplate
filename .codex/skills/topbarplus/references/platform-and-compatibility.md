# Platform And Compatibility

## Gamepad And Console

TopbarPlus has built-in gamepad support. Users can highlight the topbar with a trigger key, documented as `DPadUp` by default.

Runtime detail:

- `Icon.highlightKey` is set by the gamepad feature module
- you can assign another `Enum.KeyCode`
- setting it to `false` disables the highlight trigger behavior

The source also manages indicator prompts on icons to show controller affordances.

## Overflow Handling

TopbarPlus includes an overflow system so icons do not overrun available space on smaller screens or awkward alignments. This is especially relevant for phones in portrait mode.

Behavior described in docs and source:

- left and right groups overflow against the opposite group or viewport bounds
- center icons can be realigned when they exceed nearby bounds

## Alignment Model

Primary public alignment API is:

- `icon:align("Left" | "Center" | "Right")`

Compatibility aliases still exist:

- `setAlignment`
- `setLeft`
- `setMid`
- `setRight`

The runtime also accepts spelling variants like `"centre"` and `"mid"`.

## Multiple TopbarPlus Copies

TopbarPlus explicitly supports multiple package copies in one experience, as long as they are v3+ compatible. The first required package becomes the dominant runtime, and later copies delegate to it through a reference object in `ReplicatedStorage`.

This matters when:

- HD Admin or another third-party library bundles TopbarPlus
- your game also requires its own copy

You do not need to coordinate this manually if all packages are modern enough.

## Version Runtime

The source contains a `VERSION` module with:

- app version `v3.4.0`
- a marketplace lookup to fetch the latest version label
- `isUpToDate()` logic

That module is runtime support, not part of the main documented `Icon` API.
