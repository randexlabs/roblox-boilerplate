Advanced Stories
Advanced Stories are table stories that get mounted internally by UI Labs. They allow UI Labs to have more control and info over how your stories are rendered.

These stories also allows you to add Controls to edit properties of your story in real-time.

Creating an Advanced Story
All advanced stories share a base format table structure.

Key Type Description
name Ignored string Module name will be always used.
Included here for Flipbook compatibility
summary Optional string Summary of the story, this allows Rich Text.
Will be shown in the story preview
controls Optional { string: Control } Table of control objects to be used in your story
story Required (...args: any) => any Function that will render your story.
The implementation will vary
Let's see an example:

Luau

Roblox-TS

local story = {
summary = "This is a summary",
controls = nil, -- We'll learn about controls later
story = function()
...
end
}

return story
Story Types
You will need to add additional keys depending on the story type you are using.

UI Labs currently supports the following types of advanced stories:

Vide
Providing your library
To provide your library you will need to add the following keys to your story table:

Key Type Description
vide Required Vide Vide library to be used
Rendering your story
Vide stories will be renderer by calling the story function once. The story function will be called inside a stable scope that will be destroyed when the story is unmounted.

You can return an instance that will be applied as children on the target frame.

Luau

Roblox-TS

local story = {
vide = Vide,
story = function(props)
return Vide.create "Frame" {
Size = UDim2.fromOffset(200, 100),
}
end
}
Additionally, you can use the target key inside the props table to get the target frame.

This way you can set the parent of the component to the target frame and return nil.

Using controls
UI Labs will create Vide.Source's for every control and it will update them when the control changes. These controls will be available in the props table.

Luau

Roblox-TS

local controls = {
Visible = true
}

local story = {
vide = Vide,
controls = controls,
story = function(props)
return Vide.create "Frame" {
Size = UDim2.fromOffset(200, 100),
Visible = props.controls.Visible -- This will be a Vide.Source<boolean>
}
end
}
Cleaning up
The story function is called inside a stable, this means that you can use Vide.effect or Vide.cleanup to detect when the story is getting unmounted.

Using the Story Creator
You can use the Story Creator in the Utility Package to create your story. These will infer the control types for Roblox-TS.

UILabs.CreateVideStory(info, story):VideStory
