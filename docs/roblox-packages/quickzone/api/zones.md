Zones
Zones manages multiple individual Zone objects as a single, unified entity. This allows you to create complex shapes and structures by combining multiple zones together. You can attach observers to a Zones instance, and they will be automatically attached to all contained zones. When a zone is added or removed from the Zones instance, observers will be updated accordingly.

Functions
attach
</>
Zones:attach(observer: Observer) → Zones
Attaches an Observer to all underlying zones.

detach
</>
Zones:detach(observer: Observer) → Zones
Detaches an Observer from all underlying zones.

sync
</>
Zones:sync() → Zones
Forces all dynamic underlying zones to recalculate their spatial geometry.

getZones
</>
Zones:getZones() → {Zone}
Returns an array of all individual Zone objects currently managed.

isDynamic
</>
Zones:isDynamic() → boolean
Returns whether Zones is set to dynamic.

isPointInside
</>
Zones:isPointInside(point: Vector3) → boolean
Checks if a given Vector3 point resides inside of the underlying zones.

setAutoSync
</>
Zones:setAutoSync(autoSync: boolean) → Zones
Enables or disables automatic polling and syncing to the tracked BaseParts for all underlying zones. If any zones are currently static, they will automatically be set to dynamic.

setDynamic
</>
Zones:setDynamic(isDynamic: boolean) → Zones
Promotes or demotes all underlying zones between the Static and Dynamic trees.

Performance
Changing a zone's dynamic state forces both the static and dynamic trees to rebuild.

setMetadata
</>
Zones:setMetadata(metadata: any) → Zones
Sets metadata to all underlying zones.

getMetadata
</>
Zones:getMetadata() → any
Returns the metadata.

contains
</>
Zones:contains(zone: Zone) → boolean
Checks if a specific Zone object is managed by this Zones collection.

iterZones
</>
Zones:iterZones() → () → Zone?
Returns a zero-allocation iterator for all Zones within this group.

getReferences
</>
Zones:getReferences() → {BasePart | Attachment | Bone}
Returns an array of all references from the underlying zones.

iterReferences
</>
Zones:iterReferences() → () → (
(BasePart | Attachment | Bone)?,
Zone?
)
Returns a zero-allocation iterator for all references within this group of zones. Yields both the reference and the specific Zone it belongs to.

onDestroyEvent
</>
Zones:onDestroy(callback: () → ()) → () → ()-- Disconnect function
Fires when destroy() is called on zones

destroyDestructor
</>
Zones:destroy() → ()
Cleans up the zones, removes them from the LBVH tree, and detaches all observers.

Rebuild Request
Requests a rebuild of corresponding tree (batched per frame).
