Zone
Zones define physical areas in world space. They can be static or dynamic and support shapes like Blocks, Balls, and Cylinders.

Zones themselves are 'passive', meaning they must be attached to an Observer before any detection occurs.

Performance
If a zone moves (e.g., attached to a moving platform) or changes size, you should make the zone dynamic by setting isDynamic to true.

Static zones are optimized into a large, pre-calculated tree. Updating a static zone forces a full recalculation of that tree, which is expensive. Dynamic zones are handled separately and are much cheaper to update.

Functions
newConstructor
</>
Zone.new(config: {
cframe: CFrame,
size: Vector3,
shape: Types.ShapeType?,
reference: (BasePart | Attachment | Bone)?,
isDynamic: boolean?,
metadata: any?,
autoSync: boolean?
}?) → Zone
Creates a Zone object.

local zone = QuickZone.Zone({
cframe = CFrame.new(0, 10, 0),
size = Vector3.new(10, 10, 10),
shape = 'Block',
isDynamic = false,
metadata = { Name = "Lobby" },
observers = { observer1, observer2 }
})
Dynamic Zones
If a zone moves, set isDynamic to true for maximum performance.

Rebuild Request
Requests a rebuild of corresponding tree (batched per frame).

fromPartConstructor
</>
Zone.fromPart(
part: BasePart,-- The part to derive the zone from.
config: {
isDynamic: boolean?,
metadata: any?,
autoSync: boolean?
}?
) → Zone
Creates a Zone automatically based on the Part's properties. Supported shapes: Block, Ball (Spheres), Cylinder, Wedge, and CornerWedge.

local part = workspace.ZonePart
local zone = QuickZone.Zone.fromPart(part, {
observers = { safeObserver, healingObserver }
})
Dynamic Zones
If a zone moves, set isDynamic to true for maximum performance.

Rebuild Request
Requests a rebuild of corresponding tree (batched per frame).

fromPartsConstructor
</>
Zone.fromParts(
parts: {BasePart},
config: {
isDynamic: boolean?,
metadata: any?,
autoSync: boolean?
}?
) → Zones
Creates and manages a collection of Zones from a static array of BaseParts.

fromChildrenConstructor
</>
Zone.fromChildren(
parent: Instance,
config: {
isDynamic: boolean?,
metadata: any?,
autoSync: boolean?
}?
) → Zones
Dynamically creates and manages a Zones object from all BaseParts that are direct children of the given Instance. Automatically updates as children are added/removed.

fromDescendantsConstructor
</>
Zone.fromDescendants(
parent: Instance,-- The container (Model, Folder, etc.) to search through.
config: {
isDynamic: boolean?,
metadata: any?,
autoSync: boolean?
}?
) → Zones
Dynamically creates and manages a Zones object from all BaseParts contained anywhere within the given Instance. Automatically updates as descendants are added/removed.

local mapZones = QuickZone.Zone.fromDescendants(workspace.HazardFolder, {
observers = { hazardObserver }
})
fromTagConstructor
</>
Zone.fromTag(
tag: string,
config: {
isDynamic: boolean?,
metadata: any?,
autoSync: boolean?
}?
) → Zones
Dynamically creates and manages Zones for all BaseParts with a specific CollectionService tag.

setAutoSync
</>
Zone:setAutoSync(autoSync: boolean) → Zone
Enables or disables automatic polling and syncing to the tracked BasePart. If the zone is currently static, it will automatically be set to dynamic.

setReference
</>
Zone:setReference(reference: (BasePart | Attachment | Bone)?) → Zone
Updates the tracked reference for this zone. If autoSync is enabled, the zone will immediately start syncing to the new reference.

sync
</>
Zone:sync() → Zone
Update the zone to the reference. For a part-based zone, this will sync the zone's CFrame, Size and Shape to match the reference's. For attachment/bone-based zones, only the WorldCFrame is synced.

Rebuild
This method flags the zone for an update. The actual tree rebuild is batched and occurs once per frame.

Static Zones: Expensive. Forces a rebuild of the main static tree.
Dynamic Zones: Cheap. Forces a rebuild of the smaller dynamic tree.
setDynamic
</>
Zone:setDynamic(isDynamic: boolean) → Zone
Promotes or demotes a zone between the Static and Dynamic trees.

Performance
Changing a zone's dynamic state forces both the static and dynamic trees to rebuild. Use this sparingly (e.g., when a static bridge breaks and becomes dynamic).

setCFrame
</>
Zone:setCFrame(cf: CFrame) → Zone
Updates the Zone's CFrame.

Rebuild Request
Requests a rebuild of corresponding tree (batched per frame).

setPosition
</>
Zone:setPosition(pos: Vector3) → Zone
Updates the Zone's Position while preserving its current Rotation.

Rebuild Request
Requests a rebuild of corresponding tree (batched per frame).

setSize
</>
Zone:setSize(size: Vector3) → Zone
Updates the Zone's Size.

Rebuild Request
Requests a rebuild of corresponding tree (batched per frame).

setShape
</>
Zone:setShape(shape: ShapeType) → Zone
Updates the Zone's geometric shape.

setMetadata
</>
Zone:setMetadata(metadata: any?) → Zone
Set the metadata of the zone.

getMetadata
</>
Zone:getMetadata() → any?
Returns the metadata of the zone.

getId
</>
Zone:getId() → number
Returns the unique internal ID of the zone.

getReference
</>
Zone:getReference() → (BasePart | Attachment | Bone)?
Returns the reference associated with this zone, if any.

getPosition
</>
Zone:getPosition() → CFrame
Returns the current position of the zone.

getCFrame
</>
Zone:getCFrame() → CFrame
Returns the current CFrame of the zone.

getSize
</>
Zone:getSize() → Vector3
Returns the full size of the zone.

getShape
</>
Zone:getShape() → ShapeType
Returns the geometric shape type of the zone.

isPointInside
</>
Zone:isPointInside(point: Vector3) → boolean
Checks if a point is inside this specific zone.

isDynamic
</>
Zone:isDynamic() → boolean
Returns whether the zone is currently registered as a dynamic object.

onDestroyEvent
</>
Zone:onDestroy(callback: () → ()) → () → ()-- Disconnect function
Fires when destroy() is called on the zone

local disconnect = myZone:onDestroy(function()
print('Zone was destroyed!')
end)
destroyDestructor
</>
Zone:destroy() → ()
Cleans up the zone, removes it from the LBVH tree, and detaches all observers.

Rebuild Request
Requests a rebuild of corresponding tree (batched per frame).
