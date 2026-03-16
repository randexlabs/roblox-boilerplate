local profilestore = require(script.profilestore)
local world = require(script.Parent.world)

return {
	player_store = profilestore.player_store,
	profile = profilestore.profile,
	player = world:component<<Player>>(),
	profile_loading = profilestore.profile_loading,
}
