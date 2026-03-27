QuickZone
An unopinionated, physics-free spatial library for Roblox. Maintain 60 FPS with over a million zones.

Types
ShapeType
</>
type ShapeType = "Block" | "Ball" | "Cylinder" | "Wedge" | "CornerWedge"
The geometric shape of a Zone.

EntityTable
</>
interface EntityTable {
Position: Vector3?
WorldPosition: Vector3?
CFrame: CFrame?
Transform:: CFrame?
GetPivot: ((any) → CFrame)?
}
A custom table that mimics the spatial properties of a Roblox Instance.

Entity
</>
type Entity = BasePart | Model | Camera | Attachment | Bone | EntityTable
Functions
configure
</>
QuickZone:configure(config: {
enabled: boolean?,
autoSyncRate: number?,
frameBudget: number?
}) → QuickZone
Configure the QuickZone settings.

QuickZone:configure({
enabled = true,
autoSyncRate = 10,
frameBudget = 0.5,
})
setEnabled
</>
QuickZone:setEnabled(enabled: boolean) → QuickZone
Enables or disables automatic updating. If false, you must call QuickZone:update(dt) manually.

update
</>
QuickZone:update(
dt: number-- Delta time
) → QuickZone
Manually processes the spatial queries and trigger callbacks. This is only necessary if you disabled automatic updating.

setAutoSyncRate
</>
QuickZone:setAutoSyncRate(
hz: number-- Sync frequency in Hz. Set to 0 to disable auto-syncing.
) → QuickZone
Sets the automatic sync rate for zones with references. This controls how often QuickZone checks the reference's position and updates the zone accordingly.

rebuild
</>
QuickZone:rebuild() → QuickZone
Instantly forces the internal trees to rebuild if any zones have been modified.

This is only necessary if you have made manual changes to zones or references and want to ensure the changes take effect immediately. Otherwise, the Scheduler will automatically rebuild the trees on the next update step.

setReference
</>
QuickZone:setReference(
entity: Entity,
reference: any?
) → QuickZone
Set a reference to an entity. If set, the callbacks will now pass the reference instead of the entity.

QuickZone:setReference(transformComponent, numberId)

local entityGroup = QuickZone.Group.new({ Entities = { entityId } })
local observer = QuickZone.Observer.new({ Groups = {entityGroup} })

observer:onEnter(function(numberId, zone)
print(tostring(numberId) .. " entered!")
end)
setFrameBudget
</>
QuickZone:setFrameBudget(
ms: number-- Time in milliseconds
) → QuickZone
Sets the global execution budget for the Scheduler per frame in milliseconds.

The Scheduler will 'dispatch' entity steps until this threshold is reached, at which point it yields until the next frame to prevent render stutter.

Defaults to 1ms.

-- Allow QuickZone to use up to 0.5ms of frame time
QuickZone:setFrameBudget(0.5)
removeEntity
</>
QuickZone:removeEntity(entity: any) → QuickZone
Instantly and safely removes the entity from QuickZone. It will be removed from all Groups, resolving any active Observers and firing their onExit events.

getEntityOfReference
</>
QuickZone:getEntityOfReference(reference: any) → Entity?
Returns the physical Entity associated with the reference.

getReferenceOfEntity
</>
QuickZone:getReferenceOfEntity(reference: any) → any
Returns the reference associated with the Entity.

getObservers
</>
QuickZone:getObservers() → {Observer}
Returns an array of all Observers currently existing.

getGroups
</>
QuickZone:getGroups() → {Group}
Returns an array of all Groups (including PlayerGroups) currently registered.

getZones
</>
QuickZone:getZones() → {Zone}
Returns an array containing every Zone currently registered. This includes both static and dynamic zones.

getEntities
</>
QuickZone:getEntities() → {any}
Returns a flattened array of every entity currently being tracked across all Groups.

getZonesAtPoint
</>
QuickZone:getZonesAtPoint(
position: Vector3-- The world position to check.
) → {Zone}
Performs a spatial query to find all Zones containing the given point.

getZonesOfEntity
</>
QuickZone:getZonesOfEntity(entity: any) → {Zone}
Returns an array of all Zones the given entity is actively inside, based on its observer memberships.

getGroupsOfEntity
</>
QuickZone:getGroupsOfEntity(entity: any) → {Group}
Returns an array of all Groups that the specified entity is currently in.

iterGroups
</>
QuickZone:iterGroups() → () → Group?
Returns a zero-allocation iterator for all Groups.

iterZones
</>
QuickZone:iterZones() → () → Zone?
Returns a zero-allocation iterator for all Zones.

iterEntities
</>
QuickZone:iterEntities() → () → any?
Returns a zero-allocation iterator for all entities.

iterObservers
</>
QuickZone:iterObservers() → () → Observer?
Returns a zero-allocation iterator for all Observers.

iterGroupsOfEntity
</>
QuickZone:iterGroupsOfEntity(entity: any) → () → Group?
Returns a zero-allocation iterator for all Groups that the specified entity is currently in.

iterZonesOfEntity
</>
QuickZone:iterZonesOfEntity(entity: any) → () → Zone?
Returns an iterator for all unique Zones the given entity is actively inside.

iterZonesAtPoint
</>
QuickZone:iterZonesAtPoint(point: Vector3) → () → Zone?
Returns an iterator that returns every Zone intersecting the given point. Ideal for zero-allocation ECS queries. Safe to break out of early.

visualizeDebug
</>
QuickZone:visualize(
enabled: boolean-- Whether to show the debug visuals.
) → QuickZone
Enables or disables visual rendering of all registered Zones. Static and Dynamic zones are colored differently based on their active status.
