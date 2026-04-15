local Players = game:GetService 'Players'

local cache = require(script.Parent.cache)
local store = require(script.Parent.store)

local function start_session_async(player: Player)
	return store:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})
end

local function player_added(player: Player)
	local profile = start_session_async(player)

	if not profile then
		player:Kick(`Profile load fail - Please rejoin`)
		return
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	if player.Parent ~= Players then
		profile:EndSession()
		return
	end

	profile.OnSessionEnd:Connect(function()
		cache.remove_player(player)
		player:Kick(`Profile session end - Please rejoin`)
	end)

	cache.add_player(player, profile)
end

local function player_removing(player: Player)
	local profile = cache.get_profile(player)
	if not profile then return end
	profile:EndSession()
end

Players.PlayerAdded:Connect(player_added)
Players.PlayerRemoving:Connect(player_removing)
