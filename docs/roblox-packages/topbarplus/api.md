API
Functions¶
getIcons¶

local icons = Icon.getIcons()
Returns a dictionary of icons where the key is the icon's UID and value the icon.
getIcon¶

local icon = Icon.getIcon(nameOrUID)
Returns an icon of the given name or UID.
setTopbarEnabled¶

Icon.setTopbarEnabled(bool)
When set to false all TopbarPlus ScreenGuis are hidden. This does not impact Roblox's Topbar.
modifyBaseTheme¶

Icon.modifyBaseTheme(modifications)
Updates the appearance of all icons. See themes for more details.
setDisplayOrder¶

Icon.setDisplayOrder(integer)
Sets the base DisplayOrder of all TopbarPlus ScreenGuis.
Constructors¶
new¶

local icon = Icon.new()
Constructs an empty 32x32 icon on the topbar.
Methods¶
setName¶ chainable

icon:setName(name)
Sets the name of the Widget instance. This can be used in conjunction with Icon.getIcon(name).
getInstance¶

local instance = icon:getInstance(instanceName)
Returns the first descendant found within the widget of name instanceName.
modifyTheme¶ chainable

icon:modifyTheme(modifications)
Updates the appearance of the icon. See themes for more details.
modifyChildTheme¶ chainable

icon:modifyChildTheme(modifications)
Updates the appearance of all icons that are parented to this icon (for example when a menu or dropdown). See themes for more details.
setEnabled¶ chainable

icon:setEnabled(bool)
When set to false the icon will be disabled and hidden.
select¶ chainable

icon:select()
Selects the icon (as if it were clicked once).
deselect¶ chainable

icon:deselect()
Deselects the icon (as if it were clicked, then clicked again).
notify¶ chainable

icon:notify(clearNoticeEvent)
Prompts a notice bubble which accumulates the further it is prompted. If the icon belongs to a dropdown or menu, then the notice will appear on the parent icon when the parent icon is deselected.
clearNotices¶ chainable

icon:clearNotices()
disableOverlay¶ chainable

icon:disableStateOverlay(bool)
When set to true, disables the shade effect which appears when the icon is pressed and released.
setImage¶ chainable toggleable

icon:setImage(imageId, iconState)
Applies an image to the icon based on the given imageId. imageId can be an assetId or a complete asset string.
setLabel¶ chainable toggleable

icon:setLabel(text, iconState)
setOrder¶ chainable toggleable

icon:setOrder(order, iconState)
setCornerRadius¶ chainable toggleable

icon:setCornerRadius(scale, offset, iconState)
align¶ chainable

icon:align(alignment)
This enables you to set the icon to the "Left" (default), "Center" or "Right" side of the screen. See alignments for more details.
setWidth¶ chainable toggleable

icon:setWidth(minimumSize, iconState)
This sets the minimum width the icon can be (it can be larger for instance when setting a long label). The default width is 44.
setImageScale¶ chainable toggleable

icon:setImageScale(number, iconState)
How large the image is relative to the icon. The default value is 0.5.
setImageRatio¶ chainable toggleable

icon:setImageRatio(number, iconState)
How stretched the image will appear. The default value is 1 (a perfect square).
setTextSize¶ chainable toggleable

icon:setTextSize(number, iconState)
The size of the icon labels' text. The default value is 16.
setTextColor¶ chainable toggleable

icon:setTextColor(color, iconState)
The color of the icon labels' text.
setTextFont¶ chainable toggleable

icon:setTextFont(font, fontWeight, fontStyle, iconState)
Sets the labels FontFace. font can be a font family name (such as "Creepster"), a font enum (such as Enum.Font.Bangers), a font ID (such as 12187370928) or font family link (such as "rbxasset://fonts/families/Sarpanch.json").
bindToggleItem¶ chainable

icon:bindToggleItem(guiObjectOrLayerCollector)
Binds a GuiObject or LayerCollector to appear and disappeared when the icon is toggled.
unbindToggleItem¶ chainable

icon:unbindToggleItem(guiObjectOrLayerCollector)
Unbinds the given GuiObject or LayerCollector from the toggle.
bindEvent¶ chainable

icon:bindEvent(iconEventName, callback)
Connects to an icon event with iconEventName. It's important to remember all event names are in camelCase. callback is called with arguments (self, ...) when the event is triggered.
unbindEvent¶ chainable

icon:unbindEvent(iconEventName)
Unbinds the connection of the associated iconEventName.
bindToggleKey¶ chainable

icon:bindToggleKey(keyCodeEnum)
Binds a keycode which toggles the icon when pressed. See toggle keys for more details.
unbindToggleKey¶ chainable

icon:unbindToggleKey(keyCodeEnum)
Unbinds the given keycode.
call¶ chainable

icon:call(func)
Calls the function immediately via task.spawn. The first argument passed is the icon itself. This is useful when needing to extend the behaviour of an icon while remaining in the chain.
addToJanitor¶ chainable

icon:addToJanitor(userdata)
Passes the given userdata to the icons janitor to be destroyed/disconnected on the icons destruction. If a function is passed, it will be called when the icon is destroyed.
lock¶ chainable

icon:lock()
Prevents the icon being toggled by user-input (such as clicking) however the icon can still be toggled via localscript using methods such as icon:select().
unlock¶ chainable

icon:unlock()
Re-enables user-input to toggle the icon again.
debounce¶ chainable yields

icon:debounce(seconds)
Locks the icon, yields for the given time, then unlocks the icon, effectively shorthand for icon:lock() task.wait(seconds) icon:unlock(). This is useful for applying cooldowns (to prevent an icon from being pressed again) after an icon has been selected or deselected.
autoDeselect¶ chainable

icon:autoDeselect(true)
When set to true (the default) the icon is deselected when another icon (with autoDeselect enabled) is pressed. Set to false to prevent the icon being deselected when another icon is selected (a useful behaviour in dropdowns).
oneClick¶ chainable

icon:oneClick(bool)
When set to true the icon will automatically deselect when selected. This creates the effect of a single click button.
setCaption¶ chainable

icon:setCaption(text)
Sets a caption. To remove, pass nil as text. See captions for more details.
setCaptionHint¶ chainable

icon:setCaptionHint(keyCodeEnum)
This customizes the appearance of the caption's hint without having to use icon:bindToggleKey.
setDropdown¶ chainable

icon:setDropdown(arrayOfIcons)
Creates a vertical dropdown based upon the given table array of icons. Pass an empty table {} to remove the dropdown. See dropdowns for more details.
joinDropdown¶ chainable

icon:joinDropdown(parentIcon)
Joins the dropdown of parentIcon. This is what icon:setDropdown calls internally on the icons within its array.
setMenu¶ chainable

icon:setMenu(arrayOfIcons)
Creates a horizontal menu based upon the given array of icons. Pass an empty table {} to remove the menu. See menus for more details.
setFixedMenu¶ chainable

icon:setFixedMenu(arrayOfIcons)
Creates a menu that is always selected and has its close button hidden. Pass an empty table {} to remove the menu. See menus for more details.
joinMenu¶ chainable

icon:joinMenu(parentIcon)
Joins the menu of parentIcon. This is what icon:setMenu calls internally on the icons within its array.
leave¶ chainable

icon:leave()
Unparents an icon from a parentIcon if it belongs to a dropdown or menu.
convertLabelToNumberSpinner¶ chainable

icon:convertLabelToNumberSpinner(numberSpinner, readyCallback)
Accepts a numberSpinner and converts the icon's label into that spinner. For example:

Icon.new()
:align("Right")
:setLabel("Points")
:setWidth(80)
:call(function(pointsIcon)
local NumberSpinner = require(ReplicatedStorage.NumberSpinner)
local numberSpinner = NumberSpinner.new()
pointsIcon:convertLabelToNumberSpinner(numberSpinner, function()
numberSpinner.Name = "LabelSpinner"
numberSpinner.Prefix = "$"
numberSpinner.Commas = true
numberSpinner.Decimals = 0
numberSpinner.Duration = 0.25
while true do
numberSpinner.Value = math.random(1,1000)
task.wait(1)
end
end)
end)
Warning

Any changes to the NumberSpinner must be made within readyCallback otherwise you risk breaking the icon's appearance

destroy¶ chainable

icon:destroy()
Clears all connections and destroys all instances associated with the icon.
Events¶
selected¶

icon.selected:Connect(function(fromSource)
-- fromSource can be useful for checking if the behaviour was triggered by a user (such as clicking)
-- fromSource values include "User", "OneClick", "AutoDeselect", "HideParentFeature", "Overflow"
local sourceName = fromSource or "Unknown"
print("The icon was selected by the "..sourceName)
end)
deselected¶

icon.deselected:Connect(function(fromSource)
local sourceName = fromSource or "Unknown"
print("The icon was deselected by the "..sourceName)
end)
toggled¶

icon.toggled:Connect(function(isSelected, fromSource)
local stateName = (isSelected and "selected") or "deselected"
print(`The icon was {stateName}!`)
end)
viewingStarted¶

icon.viewingStarted:Connect(function()
print("A mouse, long-pressed finger or gamepad selection is hovering over the icon")
end)
viewingEnded¶

icon.viewingEnded:Connect(function()
print("The input is no longer viewing (hovering over) the icon")
end)
notified¶

icon.notified:Connect(function()
print("New notice")
end)
Properties¶
name¶ read-only

local string = icon.name --[default: "Widget"]
isSelected¶ read-only

local bool = icon.isSelected
isEnabled¶ read-only

local bool = icon.isEnabled
totalNotices¶ read-only

local int = icon.totalNotices
locked¶ read-only

local bool = icon.locked
