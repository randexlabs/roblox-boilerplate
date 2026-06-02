# Properties Overview

## Contents

1. Scope of support
2. Support matrix
3. Reading the matrix correctly
4. Gaps and unfinished areas

## Scope of Support

The official docs state that Rojo supports most Roblox properties, but the properties page is explicitly marked as a work in progress and may be incomplete or inaccurate.

That warning matters. When the docs are uncertain, answers should preserve that uncertainty instead of overstating guarantees.

## Support Matrix

The current docs present the following support matrix.

| Property Type           | Example Property                | Build | Live Sync | Project Files |
| ----------------------- | ------------------------------- | ----- | --------- | ------------- |
| Attributes              | `Instance.Attributes`           | Yes   | Yes       | Yes           |
| Axes                    | `ArcHandles.Axes`               | Yes   | Yes       | Yes           |
| BinaryString            | `BinaryStringValue.Value`       | Yes   | No        | Yes           |
| Bool                    | `Part.Anchored`                 | Yes   | Yes       | Yes           |
| BrickColor              | `Part.BrickColor`               | Yes   | Yes       | Yes           |
| CFrame                  | `Camera.CFrame`                 | Yes   | Yes       | Yes           |
| Color3                  | `Lighting.Ambient`              | Yes   | Yes       | Yes           |
| Color3uint8             | `Part.BrickColor`               | Yes   | Yes       | Yes           |
| ColorSequence           | `Beam.Color`                    | Yes   | Yes       | Yes           |
| Content                 | `Decal.Texture`                 | Yes   | Yes       | Yes           |
| Enum                    | `Part.Shape`                    | Yes   | Yes       | Yes           |
| Faces                   | `Handles.Faces`                 | Yes   | Yes       | Yes           |
| Float32                 | `Players.RespawnTime`           | Yes   | Yes       | Yes           |
| Float64                 | `Sound.PlaybackLoudness`        | Yes   | Yes       | Yes           |
| Font                    | `TextLabel.FontFace`            | Yes   | Yes       | Yes           |
| Int32                   | `Frame.ZIndex`                  | Yes   | Yes       | Yes           |
| Int64                   | `Player.UserId`                 | Yes   | Yes       | Yes           |
| MaterialColors          | `Terrain.MaterialColors`        | Yes   | Yes       | Yes           |
| NumberRange             | `ParticleEmitter.Lifetime`      | Yes   | Yes       | Yes           |
| NumberSequence          | `Beam.Transparency`             | Yes   | Yes       | Yes           |
| OptionalCoordinateFrame | `Model.WorldPivotData`          | Yes   | No        | Yes           |
| PhysicalProperties      | `Part.CustomPhysicalProperties` | Yes   | Yes       | Yes           |
| ProtectedString         | `ModuleScript.Source`           | Yes   | Yes       | Yes           |
| Ray                     | `RayValue.Value`                | Yes   | Yes       | Yes           |
| Rect                    | `ImageButton.SliceCenter`       | Yes   | Yes       | Yes           |
| Ref                     | `Model.PrimaryPart`             | Yes   | Yes       | No            |
| Region3                 | N/A                             | Yes   | Yes       | No            |
| Region3int16            | `Terrain.MaxExtents`            | Yes   | Yes       | No            |
| SharedString            | N/A                             | Yes   | Yes       | No            |
| String                  | `Instance.Name`                 | Yes   | Yes       | Yes           |
| Tags                    | `Instance.Tags`                 | Yes   | Yes       | Yes           |
| UDim                    | `UIListLayout.Padding`          | Yes   | Yes       | Yes           |
| UDim2                   | `Frame.Size`                    | Yes   | Yes       | Yes           |
| Vector2                 | `ImageLabel.ImageRectSize`      | Yes   | Yes       | Yes           |
| Vector2int16            | N/A                             | Yes   | Yes       | Yes           |
| Vector3                 | `Part.Size`                     | Yes   | Yes       | Yes           |
| Vector3int16            | `TerrainRegion.ExtentsMax`      | Yes   | Yes       | Yes           |
| QDir                    | `Studio.Auto-Save Path`         | No    | No        | No            |
| QFont                   | `Studio.Font`                   | No    | No        | No            |

## Reading the Matrix Correctly

The matrix uses three separate capability columns:

| Column        | Meaning                                                       |
| ------------- | ------------------------------------------------------------- |
| Build         | Rojo can emit the property into generated place/model output  |
| Live Sync     | Rojo can synchronize the property in an active Studio session |
| Project Files | The property can be represented in project/meta JSON syntax   |

Do not collapse these into one notion of "supported."

Examples:

- `BinaryString` works for build and project files, but not live sync.
- `Ref`, `Region3`, and `SharedString` may be supported in build/live contexts without being writable in project files.
- `OptionalCoordinateFrame` is buildable and writable in project files, but not live-syncable according to the docs.

## Gaps and Unfinished Areas

The detailed property page explicitly leaves some areas unfinished:

- `OptionalCoordinateFrame` is marked `TODO`
- `Ref`, `Region3`, `Region3int16`, and `SharedString` are listed as not implemented in the detailed section

When those types come up, rely on the matrix for the highest-level capability and keep the documentation gap explicit.

For exact encodings and examples, continue into `properties-reference.md`.
