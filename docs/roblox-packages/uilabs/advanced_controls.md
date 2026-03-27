Advanced Controls
Advanced controls allow you to configure more complex values for your stories.
These controls are not available in Flipbook

They are created with the provided constructors in the Utility Package

These are the currently available advanced controls:

Slider Control
Slider control allows you to add a number between a range, it gets displayed as a Slider with a number input, this control takes a min and max as the range

slider
Slider(def, min, max, step? )

Arguments

def number Default control value
min number Minimum value range
max number Maximum value range
step numberOptional The increment/decrement step of the control, if not given the slider will be continuous Default: nil
RGBA Control
RGBA control is similar to the Color3 primitive, but this one allows you to modify the alpha value of the color.
The alpha value gets converted to transparency when used in your story.

The control type will be: { Color:Color3, Transparency:number }

rgba
RGBA(def, transparency? )

Arguments

def Color3 Default color value
transparency numberOptional Default transparency value Default: 0
Choose Control
Choose control allows you to select between a set of options, it gets displayed as a dropdown with the options as the entries.

Possible values for this are: Tables, Datatypes, Enums, Functions, Primitives. You can mix types but this is not recommended.

choose
Choose(options, index? , widen? )

Arguments

options Array Array of possible options
index numberOptional Index of the default option Default: 1
widen booleanOptional If true given, the control type will be widened (typescript only) Default: false
Enum List Control
Enum list control is similar to choose, but this one allows you to give a name to your options.
This is useful when the value itself doesn't provide enough information.

You can use the same types as Choose, and you can miix types, but this is, again, not recommended.

enumlist
EnumList(list, key, widen? )

Arguments

list { string: any } Record of possible options
key keyof list Key of the default option, this is required Default: 1
widen booleanOptional If true given, the control type will be widened (typescript only) Default: false
Widened Types (typescript only)

Choose and EnumList controls accept a third widen parameter.

This parameter doesn't change anything on runtime, but if true is given, the control values will be generalized instead of the value literals

Object Control
Object control will let you select a roblox Instance in the explorer, you can constraint what instance can be selected.

The type for this control can be nil as the instance can be destroyed at any time. It's recommended that your code can handle nil values.

enumlist
Object(className?, def? , predicator? )

Arguments

className stringOptional The required classname of the Instance to be selected, this is compared with Instance:IsA, so superclasses are also accepted Default: "Instance"
def InstanceOptional Default instance Default: nil
predicator functionOptional A function that receives the selected instance and returns a boolean, if the function returns false, the instance will not be assigned Default: nil
