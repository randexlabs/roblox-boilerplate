Group
Groups represent a collection of entities that should be tracked by the system.

Observer
Every entity must be in a group to be observed.

Functions
newConstructor
</>
Group.new(config: {
entities: {T}?,
autoClean: boolean?
}?) → Group
Creates a generic Group. Groups manage collections of Entities (any instance with a position in the world like BaseParts, Models, Attachments, etc.) that Observers should track.

local myGroup = Group.new({
entities = { NPC1, NPC2, NPC3 }, -- Add entities
autoClean = true, -- Entities in group are cleaned up when entities are destroyed
})
fromTagConstructor
</>
Group.fromTag(tag: string) → Group
Creates a dynamic Group that automatically tracks all instances with a specific tag. Instances are only tracked while they are descendants of the Workspace.

playersConstructor
</>
Group.players() → Group
Returns a Group that automatically tracks all Players in the server.

Behavior
Automatically tracks the HumanoidRootPart of every player.
Handles PlayerAdded and CharacterAdded internally.
localPlayer ClientConstructor
</>
Group.localPlayer() → Group
Returns a Group that tracks only the LocalPlayer.

Behavior
Automatically tracks the HumanoidRootPart of the local player.
Handles CharacterAdded internally.
setAutoClean
</>
Group:setAutoClean(enabled: boolean) → Group
Enables or disables automatic cleanup for Instances in this group. When enabled, if an Instance is Destroyed() or parented to nil, it will be automatically removed from this group.

add
</>
Group:add(
entity: any-- The object to track.
) → Group
Adds an entity to the group. If the entity is already in another group, it is automatically removed from the old one first.

Example: Adding Different Entity Types
-- Adding a BasePart and a Model
myGroup:add(workspace.Part):add(workspace.NPCModel)

-- Adding a custom table
local spell = {
CFrame = CFrame.new(0, 10, 0),
Name = 'Fireball'
}
myGroup:add(spell)
Strategy Detection
QuickZone automatically determines how to track the entity's position:

BasePart: Uses Position
Model: Uses PrimaryPart.Position or GetPivot()
Attachment/Bone: Uses WorldPosition
Camera: Uses CFrame
Table: Looks for .Position, .CFrame, .WorldPosition, or :GetPivot().
addBulk
</>
Group:addBulk(
entities: {any}-- Array of entities to add.
) → Group
Adds multiple entities to the group.

-- Add an entire folder of NPCs at once
myGroup:addBulk(workspace.Enemies:GetChildren())
remove
</>
Group:remove(entity: any) → Group
Removes the entity from the group.

removeBulk
</>
Group:removeBulk(entities: {any}) → Group
Removes multiple entities from the group.

clear
</>
Group:clear() → Group
Removes all entities from the group. This fires 'onExit' events for every entity currently inside a zone.

contains
</>
Group:contains(entity: any) → boolean
Checks if a specific entity is currently a member of this group.

getId
</>
Group:getId() → number
Returns the unique internal ID of the group.

getEntities
</>
Group:getEntities() → {any}
Returns a list of all entities currently belonging to the group.

iterEntities
</>
Group:iterEntities() → () → any?
Iterates over all entities currently belonging to the group. Provides a zero-allocation way to loop through entities, ideal for high-frequency checks.

for entity in myGroup:iterEntities() do
print(entity.Name .. " is in the group!")
end
onDestroyEvent
</>
Group:onDestroy(callback: () → ()) → () → ()-- Disconnect function
Fires when destroy() is called on the group.

local disconnect = myGroup:onDestroy(function()
print('Group was destroyed!')
end)
destroyDestructor
</>
Group:destroy() → ()
Cleans up the group, removes all tracked entities, and detaches any associated observers.
