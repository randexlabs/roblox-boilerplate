Environment
UI Labs creates a virtual environment for each story, this replaces the require function, the script global and the \_G table.

This is needed to allow sandboxing and avoid require caching.
Addionally, UI Labs injects extra values and functions that can be useful inside the environment.

Because the entire story runs inside the same environment, you can use any of these utilities from anywhere in the story. The Utility Package will provide a way to access these variables.

Environment.IsStory
Environment.IsStory( ):boolean

Returns true if the current story is running inside UI Labs.

Environment.Unmount
Environment.Unmount( )

Unmounts the story. This is useful when the story should no longer keep running.

Defaults to an empty function in non-story environments

Environment.Reload
Environment.Reload( )

Reloads the story. You can use this if you wanna force a reload when something external changed, or it can be an alternative to Environment.Unmount.

DANGER

This has the potential to cause an infinite loop.

Defaults to an empty function in non-story environments

Environment.CreateSnapshot
Environment.CreateSnapshot(name?:string)

Does the same as Create Snapshot button does. Useful for cloning the UI automatically.
An additional name argument can be given for the created ScreenGui

Defaults an empty function in non-story environments

Environment.SetStoryHolder
Environment.SetStoryHolder(target?:Instance)

Changes what the View On Explorer button selects when clicked.
Useful when the story does not use the provided target frame (e.g using React Portals), or when the story is not a UI.

Calling this function without a value will reset the story holder to the target frame

Defaults to an empty function in non-story environments

Environment.GetJanitor
Environment.GetJanitor( ):Janitor

Gives you a Janitor object that gets destroyed when the story is unmounted. Useful for cleaning up without having to access the cleanup functions.

Returns nil in non-story environments

Environment.InputListener
Environment.InputListener:InputSignals

Gives you a user input listener. This is useful as UserInputService will not work inside Plugin Widgets

The type of the listener is:

type InputSignals = {
InputBegan: UserInputService.InputBegan;
InputChanged: UserInputService.InputChanged;
InputEnded: UserInputService.InputEnded;
MouseMoved: Signal<(mousePos: Vector2)>;
}
Defaults to nil in non-story environments

Environment.UserInput
Environment.UserInput:UserInputService

Same as Environment.InputListener. The difference is that this is typed as UserInputService and will default to it. This will also fallback to UserInputService for any missing methods.

Defaults to UserInputService in non-story environments

Environment.EnvironmentUID
Environment.EnvironmentUID:string

Gives you the GUID of the environment. Changes everytime the story is reloaded.

Defaults to nil in non-story environments

Environment.PreviewUID
Environment.PreviewUID:string

Gives you the GUID of the preview. Changes everytime the story is mounted, but stays the same between reloads.

Defaults to nil in non-story environments

Environment.OriginalG
Environment.OriginalG:\_G

Holds the original \_G table. Can be used to leave the sandboxed Environment.

Defaults to the current \_G table in non-story environments

Environment.Plugin
Environment.Plugin:Plugin

Gives you access to the plugin global. This is useful for accessing the plugin's API.

Defaults to nil in non-story environments

Environment.PluginWidget
Environment.PluginWidget:DockWidgetPluginGui

References where the plugin is mounted. This is useful because Sounds can only be played inside a DockWidgetPluginGui in Edit Mode.

WARNING

You should only parent instances directly inside the plugin widget. Touching UI Labs plugin elements can break the plugin.

Defaults to nil in non-story environments
