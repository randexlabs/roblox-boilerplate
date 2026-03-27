Features
Images¶

Icon.new:setImage(shopImageId)

Labels¶

icon:setLabel("Shop")

icon:setImage(shopImageId)
icon:setLabel("Shop")

Alignments¶

-- Aligns the icon to the left bounds of the screen
-- This is the default behaviour so you do not need to do anything
-- This was formerly called :setLeft()
icon:align("Left")

-- Aligns the icon in the middle of the screen
-- This was formerly called :setMid()
icon:align("Center")

-- Aligns the icon to the right bounds of the screen
-- This was formerly called :setRight()
icon:align("Right")
Notices¶

icon:notify()

Captions¶

icon:setCaption("Open Shop")

Dropdowns¶
Dropdowns are vertical navigation frames that contain an array of icons:

Icon.new()
:setLabel("Example")
:modifyTheme({"Dropdown", "MaxIcons", 3})
:modifyChildTheme({"Widget", "MinimumWidth", 158})
:setDropdown({
Icon.new()
:setLabel("Category 1")
,
Icon.new()
:setLabel("Category 2")
,
Icon.new()
:setLabel("Category 3")
,
Icon.new()
:setLabel("Category 4")
,
})

Warning

Icons containing a dropdown can join other menus but not dropdowns.

Menus¶
Menus are horizontal navigation frames that contain an array of icons:

Icon.new()
:setLabel("Example")
:modifyTheme({"Menu", "MaxIcons", 2})
:setMenu({
Icon.new()
:setLabel("Item 1")
,
Icon.new()
:setLabel("Item 2")
,
Icon.new()
:setLabel("Item 3")
,
Icon.new()
:setLabel("Item 4")
,
})

Fixed Menus¶
Fixed Menus are the same as normal menus, except forcefully opened (selected), with their close button hidden:

Icon.new()
:modifyTheme({"Menu", "MaxIcons", 3})
:setFixedMenu({
Icon.new()
:setLabel("Item 1")
,
Icon.new()
:setLabel("Item 2")
,
Icon.new()
:setLabel("Item 3")
,
Icon.new()
:setLabel("Item 4")
,
Icon.new()
:setLabel("Item 5")
,
})

Modify Theme¶
You can modify the appearance of an icon doing:

icon:modifyTheme(modifications)
You can modify the appearance of all icons doing:

Icon.modifyBaseTheme(modifications)
modifications can be either a single array describing a change, or a colllection of these arrays. For example, both the following are valid:

-- Single array
icon:modifyTheme({"IconLabel", "TextSize", 16})

-- Collection of arrays
icon:modifyTheme({
{"Widget", "MinimumWidth", 290},
{"IconCorners", "CornerRadius", UDim.new(0, 0)}
})
A modification array has 4 components:

{name, property, value, iconState}

1. name required
   This can be:

"Widget" (which is the icon container frame)
The name of an instance within the widget such as IconGradient, IconSpot, Menu, etc
A 'collective' - the value of an attribute called 'Collective' applied to some instances. This enables them to be acted upon all at once. For example, 'IconCorners'. 2. property required
This can be either:

A property from the instance (Name, BackgroundColor3, Text, etc)
Or if the property doesn't exist, an attribute of that property name will be set 3. value required
The value you want the property to become ("Hello", Color3.fromRGB(255, 100, 50), etc)

4. iconState optional
   This determines when the modification is applied. See icon states for more details.

You can find example arrays under the 'Default' module:

One Click Icons¶
You can convert icons into single click icons (icons which instantly deselect when selected) by doing:

icon:oneClick()
For example:

Icon.new()
:setImage(shopImageId)
:setLabel("Shop")
:bindEvent("deselected", function()
shop.Visible = not shop.Visible
end)
:oneClick()

Toggle Items¶
Binds a GuiObject (such as a frame) to appear or disappear when the icon is toggled

icon:bindToggleItem(shopFrame)
It is equivalent to doing:

icon.deselected:Connect(function()
shopFrame.Visible = false
end)
icon.selected:Connect(function()
shopFrame.Visible = true
end)
Toggle Keys¶
Binds a keycode which toggles the icon when pressed. Also creates a caption hint of that keycode binding.

Icon.new()
:setLabel("Shop")
:bindToggleKey(Enum.KeyCode.V)
:setCaption("Open Shop")

Gamepad & Console Support¶
TopbarPlus comes with inbuilt support for gamepads (such as Xbox and PlayStation controllers) and console screens:

To highlight the last-selected icon (or left-most if none have been selected yet) users simply press DPadUp or navigate to the topbar via the virtual cursor. To change the default trigger keycode (from DPadUp) do:

Icon.highlightKey = Enum.KeyCode.NEW_KEYCODE
Overflows¶
When accounting for device types and screen sizes, icons may occasionally overlap. This is especially common for phones when they enter portrait mode. TopbarPlus solves this with overflows:

Overflows will appear when left-set or right-set icons exceed the boundary of the closest opposite-aligned icon or viewport.

If a center-aligned icon exceeds the bounds of another icon, its alignment will be set to the alignment of the icon it exceeded:
