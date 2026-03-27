Primitive Controls
Primitive Controls are the simplest controls. They can be created by specifying the literal value you want to use.
This is how Flipbook's controls are created

These controls are a shorthand for the Primitive Control Object which is what UI Labs uses internally.

UI Labs will automatically search for literal values in your story and create the control values for you.
But you can also create them manually, sometimes, allowing you to further customize some of them.

Supported Primitives are:

String
Number
Boolean
Color3
Let's create all of them with literal values:

Luau

Roblox-TS

local controls = {
String = "Hello UI Labs!",
Number = 10,
Boolean = true,
Color3 = Color3.fromRGB(255, 0, 0),
}

local story = {
controls = controls,
story = ...
}

return story
Creating Primitive Controls Manually
As we said earlier, providing the literal is a shorthand, You can create them manually with the provided constructors in the Utility Package

These are the constructors:

String Control
string
String(def, filters? )

Arguments

def: string Default control value
filters: ArrayOptional Array of filters that changes the input, They are functions that takes the new input and the old input, and returns a filtered input. These filters are applied in order of the array
Number Control
number
Number( def, min? , max? , step? , dragger? , sens? )

Arguments

def number Default control value
min numberOptional Minimum accepted value Default: -inf
max numberOptional Maximum accepted value Default: inf
step numberOptional The increment/decrement step of the control Default: nil
dragger booleanOptional If the control should have a drag handle Default: true
sens numberOptional The sensitivity of the control. If not given, the def argument will be used Default: def
Boolean Control
boolean
Boolean(def)

Arguments

def boolean The default value of the control
Color3 Control
color3
Color3(def)

Arguments

def Color3 The default value of the control
