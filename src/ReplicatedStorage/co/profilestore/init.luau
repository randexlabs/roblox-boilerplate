local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local types = require(script.types)
local world = require(ReplicatedStorage.world)
type profile = types.profile

return {
	profile = world:component<<profile>>(),
	profile_loading = world:component(),
	player_store = require '@self/player_store',
}
