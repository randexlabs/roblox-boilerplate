# Properties Reference

## Contents

1. General rules
2. Attribute-like and collection types
3. Scalars and strings
4. Geometry, transforms, and layout
5. Rich structured types
6. Known gaps

## General Rules

Many property types support both implicit and explicit syntax. The current docs defer the exact distinction to the project format rules:

- implicit syntax uses the value shape directly
- explicit syntax wraps the value under a single key named after the property type

When implicit syntax is available, it is usually the preferred form.

## Attribute-Like and Collection Types

### Attributes

Rojo treats `"Attributes"` on any instance as the `Attributes` type.

Format:

- the value is an object
- each key is an attribute name
- each attribute value must itself be an explicit property value

Example:

```json
{
    "$properties": {
        "Attributes": {
            "Foo": { "Bool": true },
            "Bar": { "Vector3": [1.0, 2.0, 3.0] }
        },
        "AttributesSerialized": {
            "Attributes": {
                "Foo": { "Bool": true },
                "Bar": { "Vector3": [1.0, 2.0, 3.0] }
            }
        }
    }
}
```

Supported attribute value types called out in the docs:

- `Bool`
- `BrickColor`
- `CFrame`
- `Color3`
- `ColorSequence`
- `Float64`
- `Font`
- `NumberRange`
- `NumberSequence`
- `Rect`
- `String`
- `UDim`
- `UDim2`
- `Vector2`
- `Vector3`

### Axes

Explicit only. Value is a list containing any of:

- `"X"`
- `"Y"`
- `"Z"`

### Faces

Explicit only. Value is a list containing any of:

- `"Right"`
- `"Top"`
- `"Back"`
- `"Left"`
- `"Bottom"`
- `"Front"`

### Tags

Implicit and explicit forms are supported. Value is a list of strings.

## Scalars and Strings

### BinaryString

Explicit only. Value is a base64-encoded string.

### Bool

Implicit or explicit. Value is a boolean.

### BrickColor

Explicit only. Value is the BrickColor numeric code.

### Content

Implicit or explicit. Value is a string such as an asset URI.

### Enum

Implicit form:

- string enum item name

Explicit form:

- integer enum value

Example implicit:

```json
{
    "$className": "SurfaceLight",
    "$properties": {
        "Face": "Front"
    }
}
```

Example explicit:

```json
{
    "$className": "SurfaceLight",
    "$properties": {
        "Face": {
            "Enum": 5
        }
    }
}
```

### Float32 / Float64

Implicit or explicit. Value is a number.

### Int32 / Int64

Implicit or explicit. Value is an integer.

### ProtectedString

Implicit or explicit. Value is a string. The docs use script source text as the example.

### String

Implicit or explicit. Value is a string.

## Geometry, Transforms, and Layout

### CFrame

Implicit form:

- flat list of numeric components

Explicit form:

- object with `position` and `orientation`

Implicit example:

```json
{
    "$properties": {
        "ImplicitExample": [
            1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0
        ]
    }
}
```

Explicit example:

```json
{
    "$properties": {
        "ExplicitExample": {
            "CFrame": {
                "position": [1.0, 2.0, 3.0],
                "orientation": [
                    [4.0, 5.0, 6.0],
                    [7.0, 8.0, 9.0],
                    [10.0, 11.0, 12.0]
                ]
            }
        }
    }
}
```

### Color3

Implicit or explicit. Value is `[R, G, B]` with floats in the range `[0, 1]`.

### Color3uint8

Explicit only. Value is `[R, G, B]` with integers in the range `[0, 255]`.

### Rect

Explicit only. Value is `[minVector2, maxVector2]`.

### UDim

Explicit only. Value is `[scale, offset]`.

### UDim2

Explicit only. Value is `[xUDim, yUDim]`.

### Vector2 / Vector2int16

Implicit or explicit. Value is `[x, y]`.

### Vector3 / Vector3int16

Implicit or explicit. Value is `[x, y, z]`.

## Rich Structured Types

### ColorSequence

Explicit only. Value is:

- object with `keypoints`
- each keypoint has `time` and `color`
- `color` uses `Color3` format

### Font

Implicit or explicit. Value is an object with:

- `family`
- `weight`
- `style`

### MaterialColors

Implicit or explicit. Value is an object mapping `Material` enum item names to RGB integer triplets.

The docs note that only overridden materials need to be specified.

### NumberRange

Explicit only. Value is `[min, max]`.

### NumberSequence

Explicit only. Value is an object with `keypoints`, where each keypoint has:

- `time`
- `value`
- `envelope`

### PhysicalProperties

Explicit only. Two supported forms:

- the string `"Default"`
- an object with:
    - `density`
    - `friction`
    - `elasticity`
    - `frictionWeight`
    - `elasticityWeight`

### Ray

Explicit only. Two supported forms:

- object with `origin` and `direction`
- list containing `[originVector3, directionVector3]`

## Known Gaps

### OptionalCoordinateFrame

The detailed docs leave this as `TODO`.

### Ref

Marked as not implemented in the detailed section.

### Region3

Marked as not implemented in the detailed section.

### Region3int16

Marked as not implemented in the detailed section.

### SharedString

Marked as not implemented in the detailed section.

## Practical Guidance

- For ordinary properties, prefer implicit syntax.
- Use explicit syntax when Rojo needs help with type selection or when dealing with types that have no implicit form.
- For complex hand-authored property blobs, keep this file and `properties-overview.md` together so support limitations stay visible.
