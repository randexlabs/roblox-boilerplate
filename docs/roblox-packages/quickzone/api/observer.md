Observer
Observers are the logical bridge between Groups and Zones. They monitor specific groups and trigger events when entities within those groups enter or exit any zones associated with the observer.

Functions
newConstructor
</>
Observer.new(config: {
groups: {Types.Group}?,
zones: {Types.Zone | Types.Zones}?,
priority: number?,
updateRate: number?,
precision: number?,
enabled: boolean?,
safety: boolean?
}?) → Observer
Creates an Observer. Observers listen for entities entering or exiting assigned Zones.

local observer = QuickZone.Observer.new({
groups = { enemyGroup, playerGroup } -- Immediately subscribe to these groups
zones = { damageZone } -- Immediately subscribe to these zones
priority = 20, -- The priority value is used to resolve overlaps
updateRate = 20, -- Check at 20Hz
precision = 0.5, -- Ignore movement smaller than 0.5 studs
enabled = false, -- Observer will not start processing spatial checks
safety = false, -- Do not wrap callbacks in task.spawn
})
Resolution Priority
When an entity is inside multiple zones watched by different observers, higher priority observers take complete control.

Safety
If set to unsafe, you are not allowed to yield in the callbacks anymore. If you do, QuickZone will throw errors.

Dynamic Instantiation
QuickZone will warn you if an Observer is created without groups or zones. To suppress this warning when building observers dynamically, explicitly pass an empty table (zones = {}) or instantiate the observer as disabled (enabled = false).

subscribe
</>
Observer:subscribe(
group: Group-- The group to monitor.
) → Observer
Links this observer to the specified group. The observer will only track entities that belong to subscribed groups.

observer:subscribe(playerGroup):subscribe(enemyGroup)
unsubscribe
</>
Observer:unsubscribe(
group: Group-- The group to stop monitoring.
) → Observer
Stops the observer from monitoring the specified group.

attach
</>
Observer:attach(
zone: Zone-- The zone to link.
) → Observer
Attaches the Observer to a zone. The observer will begin monitoring this area for entity overlaps.

-- You are also able to chain calls
observer:attach(zone1)
:attach(zone2)
:attach(zone3)
detach
</>
Observer:detach(
zone: Zone-- The zone to unlink.
) → Observer
Detaches the Observer from the zone. The observer will begin monitoring this area for entity overlaps.

observe
</>
Observer:observe(callback: (
entity: any,
zone: Zone
) → (() → ())?) → () → ()-- Disconnect function
Observes entities entering and exiting the zone. The callback executes on entry and expects a function to be returned, which is executed on exit.

observer:observe(function(entity, zone)
print("Entered", entity)
local highlight = Instance.new("Highlight", entity)

    -- Return cleanup function
    return function()
    	print("Exited", entity)
    	highlight:Destroy()
    end

end)
onEnterEvent
</>
Observer:onEnter(callback: (
entity: any,
zone: Zone
) → ()) → () → ()-- Disconnect function
Fires when any entity from a subscribed group enters a zone attached to this observer.

local disconnect = observer:onEnter(function(entity, zone)
print(entity.Name .. ' entered ' .. zone.id)
end)
onExitEvent
</>
Observer:onExit(callback: (
entity: any,
zone: Zone
) → ()) → () → ()-- Disconnect function
Fires when an entity exits all zones attached to this observer.

observePlayer
</>
Observer:observePlayer(callback: (
player: Player,
zone: Zone
) → (() → ())?) → () → ()-- Disconnect function
Observes players entering and exiting the zone.

observer:observePlayer(function(player, zone)
print(player.Name .. " entered!")
-- Return cleanup (optional)
return function()
print(player.Name .. " left!")
end
end)
onPlayerEnterEvent
</>
Observer:onPlayerEnter(callback: (
player: Player,
zone: Zone
) → ()) → () → ()-- Disconnect function
Specialized event for Player entities.

observer:onPlayerEnter(function(player, zone)
print(player.Name .. " entered safe zone " .. zone:getId())
-- Play a sound
local sound = workspace.Sounds.SafeZoneEnter:Clone()
sound.Parent = player.Character.PrimaryPart
sound:Play()
game.Debris:AddItem(sound, 2)
end)
onPlayerExitEvent
</>
Observer:onPlayerExit(callback: (
player: Player,
zone: Zone
) → ()) → () → ()-- Disconnect function
A specialized event for Player entities. Fires when a player's character exits all zones attached to this observer.

observeLocalPlayer Client
</>
Observer:observeLocalPlayer(callback: (zone: Zone) → (() → ())?) → () → ()-- Disconnect function
Observes the LocalPlayer.

observer:observeLocalPlayer(function(zone)
local blur = Instance.new("BlurEffect", game.Lighting)
return function()
blur:Destroy()
end
end)
onLocalPlayerEnter ClientEvent
</>
Observer:onLocalPlayerEnter(callback: (zone: Zone) → ()) → () → ()-- Disconnect function
Specialized event for the LocalPlayer.

observer:onLocalPlayerEnter(function(zone)
print("You entered zone " .. zone:getId())
local char = player.Character
if char and char:FindFirstChild("Humanoid") then
char.Humanoid.WalkSpeed = 24
end
end)
onLocalPlayerExit ClientEvent
</>
Observer:onLocalPlayerExit(callback: (zone: Zone) → ()) → () → ()-- Disconnect function
A specialized event for the LocalPlayer. Fires when the local player's character exits all zones attached to this observer.

observeGroup
</>
Observer:observeGroup(callback: (
group: Group,
zone: Zone
) → (() → ())?) → () → ()-- Disconnect function
Observes a Group's presence within the observer's zones. The callback fires when the first entity of a group enters, and the returned cleanup function fires when the last entity of the group leaves.

observer:observeGroup(function(group, zone)
print("Group " .. group:getId() .. " has arrived!")
return function()
print("Group " .. group:getId() .. " has left entirely.")
end
end)
onGroupEnterEvent
</>
Observer:onGroupEnter(callback: (
group: Group,
zone: Zone
) → ()) → () → ()-- Disconnect function
Fires when the first member of a Group enters any zone attached to this observer. Subsequent entries by other members of the same group will not trigger this event until the group has completely exited and re-entered.

onGroupExitEvent
</>
Observer:onGroupExit(callback: (
group: Group,
zone: Zone
) → ()) → () → ()-- Disconnect function
Fires when the last remaining member of a Group exits all zones attached to this observer. This is useful for "cleared" states or stopping group-wide effects.

onTransitionEvent
</>
Observer:onTransition(callback: (
entity: any,
newZone: Zone
) → ()) → () → ()-- Disconnect function
Fires when an entity seamlessly transitions from one attached zone to another overlapping attached zone.

onPlayerTransitionEvent
</>
Observer:onPlayerTransition(callback: (
player: Player,
newZone: Zone
) → ()) → () → ()-- Disconnect function
Specialized event for Player entities transitioning between overlapping zones. If targetPlayer is provided, the event will only fire for that specific player.

onLocalPlayerTransition ClientEvent
</>
Observer:onLocalPlayerTransition(callback: (newZone: Zone) → ()) → () → ()-- Disconnect function
Specialized event for the LocalPlayer transitioning between overlapping zones.

setEnabled
</>
Observer:setEnabled(enabled: boolean) → Observer
Enables or disables the observer. When disabled, it will no longer process spatial checks or fire events.

setSafety
</>
Observer:setSafety(enabled: boolean) → Observer
Whether to wrap callbacks in task.spawn (safe) or not (unsafe).

Safety
If set to unsafe, you are not allowed to yield in the callbacks anymore. If you do, QuickZone will throw errors.

setPriority
</>
Observer:setPriority(p: number) → Observer
Updates the resolution priority of the observer.

setUpdateRate
</>
Observer:setUpdateRate(hz: number) → Observer
Updates the update frequency for this observer.

setPrecision
</>
Observer:setPrecision(n: number) → Observer
Updates the precision in studs for this observer.

isEnabled
</>
Observer:isEnabled() → boolean
Checks if the observer is currently enabled.

isPointInside
</>
Observer:isPointInside(position: Vector3) → boolean
Checks if a specific point in world space is inside any zone attached to this observer.

isSafe
</>
Observer:isSafe() → boolean
Checks if the observer wraps callbacks in task.spawn (safe) or not (unsafe).

getId
</>
Observer:getId() → number
Returns the unique internal ID of the observer.

getPriority
</>
Observer:getPriority() → number
Returns the current resolution priority.

getUpdateRate
</>
Observer:getUpdateRate() → number
Returns the current update frequency for this observer.

getPrecision
</>
Observer:getPrecision() → number
Updates the precision for this observer.

getEntitiesInside
</>
Observer:getEntitiesInside() → {any}
Returns a list of all tracked entities currently inside zones attached to this observer.

getPlayersInside
</>
Observer:getPlayersInside() → {Player}
Returns a list of all players currently inside zones attached to this observer.

getZones
</>
Observer:getZones() → {Zone}
Returns the list of Zones currently attached to this observer.

getGroups
</>
Observer:getGroups() → {Group}
Returns the list of Groups currently monitored by this observer.

getEntityInZone
</>
Observer:getEntityInZone(
entity: Entity-- The entity to get the zone for
) → Zone?
Returns the specific Zone this entity is currently tracked under for this Observer.

getPlayerInZone
</>
Observer:getPlayerInZone(
player: Player-- The player to get the zone for
) → Zone?
Returns the specific Zone a player is currently tracked under for this Observer.

getEntitiesInZone
</>
Observer:getEntitiesInZone(zone: Zone) → {any}
Returns an array of all entities currently inside a specific zone attached to this observer.

getPlayersInZone
</>
Observer:getPlayersInZone(zone: Zone) → {Player}
Returns an array of all players currently inside a specific zone attached to this observer.

iterZones
</>
Observer:iterZones() → () → Zone?
Returns a zero-allocation iterator for all Zones currently attached to this observer.

iterGroups
</>
Observer:iterGroups() → () → Group?
Returns a zero-allocation iterator for all Groups currently monitored by this observer.

iterEntitiesInside
</>
Observer:iterEntitiesInside() → () → (
Entity?,
Zone?
)
Iterates over all entities currently inside zones attached to this observer. Yields both the Entity and the specific Zone they are in.

iterPlayersInside
</>
Observer:iterPlayersInside() → () → (
Player?,
Zone?
)
Iterates over all players currently inside zones attached to this observer. Yields both the Player and the specific Zone they are in.

iterEntitiesInZone
</>
Observer:iterEntitiesInZone(zone: Zone) → () → Entity?
Returns a zero-allocation iterator for all entities currently inside a specific zone attached to this observer.

iterPlayersInZone
</>
Observer:iterPlayersInZone(zone: Zone) → () → Player?
Returns a zero-allocation iterator for all players currently inside a specific zone attached to this observer.

onDestroyEvent
</>
Observer:onDestroy(callback: () → ()) → () → ()-- Disconnect function
Fires when destroy() is called on the observer

local disconnect = myObserver:onDestroy(function()
print('Observer was destroyed!')
end)
destroyDestructor
</>
Observer:destroy() → ()
Cleans up the observer, disables tracking, and unsubscribes it from all groups and zones.
