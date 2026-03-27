Function Stories
Function stories are the basic stories, they are functions that UI Labs will run when the story is mounted.

These functions are used in Hoarcekat

Mounting the story
These functions will receive a target as a parameter, which is the Frame where the story should be rendered.

Luau

Roblox-TS

function story(target: Frame)
-- Render your story here inside "target"
end

return story
Cleaning up
After the function is executed, it should return a cleanup function that will be called when the story is unmounted.

Luau

Roblox-TS

function story(target: Frame)
-- Render your story here inside "target"

return function()
-- Clean up your story here
end
end

return story
Story Erroring

The cleanup function cant be executed if the mounting function errors. If the story did mount, a Studio restart may be needed to avoid memory leaks and non-destroyed Instances

UI Labs will warn you about this

local function story(target)
local newElement = Roact.createElement("TextLabel", {})
local handle = Roact.mount(newElement, target) --Roact mounted

error("error") --Will prevent the cleanup function from being returned
return function()
--Never unmounts
Roact.unmount(handle)
end
end

return story
