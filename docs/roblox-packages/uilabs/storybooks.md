Storybooks
UI Labs lets you create Storybooks to group your stories together. They are a great way to organize your stories and make them easier to find.

By default, stories will be in the inside of Unknown Stories if they haven't been assigned to a storybook.
While you can use them like that, it's recommended to eventually group them in storybooks.

Creating a Storybook
Similar to stories, storybooks are ModuleScript's that ends with .storybook in their name. UI Labs will search for these modules in your game tree.

A storybook module should return a table with the following structure:

Key Type Description
name Optional string Display name of the storybook. If not provided, the module name will be used
storyRoots Required Instance[] Array of Instances where UI Labs will search for stories. Any subfolder will create a subfolder in UI Labs too.
groupRoots Optional boolean If true, UI Labs will create subfolders for every entry in storyRoots
roact Ignored Roact You can't provide your UI Library here, Included here for Flipbook compatibility
react Ignored React You can't provide your UI Library here, Included here for Flipbook compatibility
reactRoblox Ignored ReactRoblox You can't provide your UI Library here, Included here for Flipbook compatibility
Finding Stories
Let's suppose we have this folder structure:

File Structure

Icons: Vanilla 3
ServerScriptService
GameStories
GameStory1.story
GameStory2.story
ReplicatedStorage
OtherStories
OtherStory1.story
OtherStory2.story
Let's create a Storybook for this hierarchy:

Luau

Roblox-TS

local storybook = {
name = "Stories",
storyRoots = {
game.ServerScriptService.GameStories,
game.ReplicatedStorage.OtherStories,
},
}

return storybook
Now we can see our Stories organized in the UI Labs explorer:

storybookstories
Grouping Story Roots
IF you want to group every storyRoots entry in a separated folder, you can set the groupRoots key to true. This can allow you to organize different stories with a single storybook.

Luau

Roblox-TS

local storybook = {
name = "Stories",
storyRoots = {
game.ServerScriptService.GameStories,
game.ReplicatedStorage.OtherStories,
},
groupRoots = true,
}
Now we can see that every storyRoots entry is grouped in a separated folder:

groupedstories.png
Setting groupRoots to true will also add stories that are directly added in the storyRoots array.

This allows you to provide the stories directly in the array.

Luau

Roblox-TS

local storybook = {
name = "Stories",
storyRoots = game.ServerScriptService.GameStories:GetChildren(),
groupRoots = true
}
groupedstories.png
