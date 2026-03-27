Adding Controls
UI Labs let's you add Controls. They are configurable values that you can modify while visualizing your interface.
This is useful for testing different values for your UI without needing to modify your code.

You can use Flipbook's Controls with UI Labs, but UI Labs allows for more customization and advanced controls.

controls
Configuring Controls
You can add your controls list in the controls key of your story table.

We'll learn how to use controls later, first let's see how you can create them.

The controls table, is a list of values where the key is the name of the control and the value is the control declaration.

Luau

Roblox-TS

local controls = {
control1 = ...,
control2 = ...,
control3 = ...,
}

local story = {
controls = controls,
story = ...
}

return story
