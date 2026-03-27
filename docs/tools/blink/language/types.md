# Types

This section contains a deep dive explanation on all types supported by Blink.
If anything is missing or wrong, consider submitting an issue under the GitHub repo.

Ranges
Ranges can be used with various types like: Numbers, Strings, Arrays etc. to limit the extents of their representable values.

Full Ranges
A full range is one with both a minimum and maximum value.
An example full range from 0 to 100 is written like: 0..100.

Half Ranges
A half range is one where only a minimum or maximum value is given.
These are written like: 0.. or ..100.

Exact Ranges
An exact range has only one value, such as 0 or 100.

Examples
Range Min Max
0..100 0 100
0.. 0 +infinity
..100 -infinity 100
0 0 0
100 100 100
Numbers
Blink has support for all buffer implemented number types, signed integers, unsigned integers, floating points, and more.

Number types start with a prefix like: u, i or f, and are followed by the number of bits used to represent the number. The number of bits also corresponds to the cost of sending a particular number type over the network.

Unsigned Integers
Unsigned integers are whole numbers, greater than or equal to zero.

Name Size Min Max
u8 1 byte 0 255
u16 2 bytes 0 65,535
u32 4 bytes 0 4,294,967,295
Signed Integers
Signed integers, unlike unsigned integers, can represent both positive and negative whole numbers.

Name Size Min Max
i8 1 byte -128 127
i16 2 bytes -32,768 32,767
i32 4 bytes -2,147,483,648 2,147,483,647
Floating points
Floating points represent numbers with a decimal point.

Unlike integers, the bit size of a floating point does not correlate to a hard range limit. Instead it determines its numerical accuracy (or precision). For this reason, the table below lists the maximum accurately representable integer by each floating point type.

Internally Luau stores its numbers as a f64.

The f16 type isn't natively supported by the buffer library, making it slower to read and write than other types.

Name Size Min Max
f16 2 bytes -2048 2048
f32 4 bytes -16,777,216 16,777,216
f64 8 bytes -9,007,199,254,740,992 9,007,199,254,740,992
Bounding Numbers
The values of numbers can be bounded by placing a range within parenthesis after the type.
An example health u8 number type from 0 to 100 can be written like:

u8(0..100)
u8(..100)

Example Usage
```
type Health = u8(0..100)
type UserId = f64

```
Strings
Strings are Luau's text container, in blink a string can be defined using the string type.

Bounding Strings
The length of strings can be bounded by placing a range within parenthesis after the type.
For example, if you wanted to bound a string between 3 and 20 characters you can do:

string(3..20)

Example Usage
```
type UUID = string(36)
type Username = string(3..20)

```
This example assumes a username between 3 and 20 characters, but that may not always be the case in practice.

Booleans
Booleans are a true or false value.
They can be defined using the boolean type.

Example Usage
```
type Success = boolean
```

Buffers
Buffers can be defined using the buffer type.
Buffers allow you to pass your own custom serialized data while still taking advantage of blink's batching.

Bounding Buffers
The length of buffers can be bounded by placing a range within parenthesis after the type.
For example, if you wanted to bound a buffer between 0 and 900 bytes, you can do:

buffer(..900)

Example Usage
```
type BinaryBlob = buffer
type UnreliableEventBuffer = buffer(..950)

```
Vectors
Vectors represent a vector in 3D space, most often as a point in 3D space.
They can be defined using the vector type.

Bounding Vectors
The length (magnitude) of vectors can be bounded by placing a range within parenthesis after the type.
For example, if you wanted to create a unit vector (length between 0 and 1) you can do:

vector(0..1)

Specifying Encoding
Vectors can be passed a number type within angular brackets after the type, to be used for encoding. For example, an i16 vector can be defined like so:

```
type VectorI16 = vector<i16>

```
Since Luau stores vectors as three f32s internally, any encoding larger than a f32 (ex. f64) will have no real effect on the numerical precision of the vector.

Example Usage
```
type Position = vector
type UnitVector = vector(0..1)
type VectorU8 = vector<u8>
```

Optionals
Types can be made optional by appending a ? after the entire type, like so:

```
type Username = string(3..20)?

```
Arrays
Arrays are a list of homogeneous types.
They can be defined as a type followed by square brackets.
For example an array of strings would be:

string[]

Bounding Arrays
The length of arrays can be bounded by placing a range within the square brackets.
For example, if you wanted to bound the length of an array between 25 and 50 elements you can do:

string[25..50]

Example Usage
```
type UserIds = f64[1..50]

```
Maps
Maps are key-value pair tables that have keys of one type, and values of the same or different type.
They can be defined using the map type. For example, a map of string keys and f64 values would look like:

map StringToNumber = { [string]: f64 }

Bounding Maps
The number of elements in a map can be bounded by placing a range within parenthesis after the type.
For example, if you wanted to bound the number of elements between 1 and 100 you can do:

map StringToNumber = { [string]: f64 }(1..100)

Generics
Maps support the use of generics. Generics can be a powerful tool for code reuse.
For example a map template can be defined as:

map Map<K, V> = {[K]: V}
map StringToNumber = Map<string, f64>

Example Usage
map UserIdToUsername = { [f64]: string }

Sets
Sets are a map of static string keys to true. They can be defined using the set type. For example, a set of feature flags would look like:

```
set Flags = {
```

FeatureA,
FeatureB,
FeatureC
}

Enums
Blink supports two types of enums, unit and tagged enums.

Unit Enums
Units enums represent a set of possible values.
They are defined using the enum type. For example, a unit enum representing the state of a character:

enum CharacterStatus = { Idling, Walking, Running, Jumping, Falling }

Tagged Enums
Tagged enums are a set of possible variants, each with some data attached.
They are defined using the enum type, then a string which is used for the tag field name, followed by the variants. Each variant is defined by a tag, followed by a struct. Variants are separated by a comma.

```
enum MouseEvent = "Type" {
Move {
```

Delta: vector,
Position: vector,
},
```
Drag {
```

Delta: vector,
Position: vector,
},
```
Click {
```

Button: enum { Left, Right, Middle },
Position: vector
}
}

Tagged enums are a very powerful way to represent many different types of data.
While not supported by blink, a union type can be substituted using tagged enums:

```
enum Union = "Type" {
Number {
```

Value: f64
},
```
String {
```

Value: string
}
}

This would result in the following Luau type:

```
type Union =
```

| {Type: "Number", Value: number}
| {Type: "String", Value: string}

Generics
Like maps, tagged enums also support generics.
For example, a tagged enum union template can be defined as:

```
enum Union<A, B> = "Type" {
A {
```

Value: A
},
```
B {
```

Value: B
},
}

enum NumberStringUnion = Union<f64, string>

Structs
Structs are a fixed set of statically named keys and values.
They can be defined using the struct type. For example, a struct representing a theoretical game entity would look like:

```
struct Entity {
```

Health: u8(0..100),
Position: vector,
Rotation: u8,
```
Animations: struct {
```

First: u8?,
Second: u8,
Third: u8
}
}

Merging
Structs can "merge" other structs into themselves, this is equivalent to a table union in Luau.
A merge is defined using two dots followed by the identifier of the target struct.

```
struct foo {
```

foo: u8
}

```
struct bar {
```

bar: string
}

```
struct foo_bar {
```

..foo,
..bar
}

The resulting Luau type for foo_bar would look like so:

```
type foo_bar = { foo: number, bar: string }

```
Generics
Structs, like maps and tagged enums, support the use of generics.
For example, a packet fragment can be typed using generic structs:

```
struct Fragment<T> {
```

Index: u8,
Sequence: u16,
Fragments: u8,
Data: T
}

```
type EntitiesFragment = Fragment<Entity[]>

```
Unknowns
The unknown type represents values which cannot be known until runtime.
For unions, use tagged enums instead.

Unknowns should be used sparingly as they utilize Roblox's serialization format thus negating most of the benefits of Blink.

Instances
Blink supports Roblox instances. They can be defined using the Instance type.

```
type AnInstance = Instance

```
If a non-optional instance results in nil on the receiving side, it will raise a deserialization error, and the rest of the data will be dropped. Instances turning nil can be caused by many things, for example: instance streaming, instances that only exist on the sender's side, etc.
If you plan on sending instances that might not exist, you must mark them optional.

Specifying Class
Instances can be further narrowed by specifying their class, for example:

```
type Player = Instance(Player)

```
Subclasses of the specified class will also be accepted.
For example, an Instance typed as BasePart will also accept a Part.

CFrames
CFrames represent a point and rotation about it in 3D space, most often as a point in 3D space.
They can be defined using the CFrame type.

```
type Location = CFrame

```
Specifying Encoding
CFrames can be passed two number types within angular brackets after the type, to be used for the positional and rotational encoding respectively. For example, a CFrame which uses an i16 for it's positional encoding and a f16 for it's rotational encoding can be defined like so:

```
type MyCFrame = CFrame<i16, f16>

```
The numerical precision limitations of vectors also apply to CFrames.
Furthermore, using an integer type for the rotational encoding will result in the rotation being zeroed out.

Other Roblox Types
Blink also supports a handful of other Roblox types like:

BrickColor
Color3
DateTime
DateTimeMillis
Exports
Blink supports exporting write and read functions for a specific type.
Exports can be a powerful way to leverage your blink types in various use-cases like: automatic ECS replication.
An export can be defined by prefixing the export keyword to a type's definition, for example:

```
export struct MyInterface = {
```

field: u8,
}

Exports do not currently support Instances and Unknowns.

Usage in Luau
The Luau facing API looks like so:

```
type MyInterfaceExport = {
```

Read: (buffer) -> MyInterface,
Write: (MyInterface) -> buffer
}
And a game script can use it like so:

```
example.lua
local Serialized = blink.MyInterface.Write(MyInterface)
local Deserialized = blink.MyInterface.Read(Serialized)

```
