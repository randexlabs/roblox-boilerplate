local roblox = require '@lune/roblox'

local next_user_id = 1000
local kick_message_list_by_player =
	setmetatable({} :: { [Instance]: { string } }, { __mode = 'k' })

local on_player_kick = function(player: Instance, ...: any)
	local message = select(1, ...) :: string
	local kick_message_list = kick_message_list_by_player[player]
	if kick_message_list == nil then
		kick_message_list = {}
		kick_message_list_by_player[player] = kick_message_list
	end

	table.insert(kick_message_list, message)
end

roblox.implementMethod('Player', 'Kick', on_player_kick :: any)

local function create_test_player(user_id: number?): Player
	local resolved_user_id = user_id
	if resolved_user_id == nil then
		resolved_user_id = next_user_id
		next_user_id += 1
	end

	local player = roblox.Instance.new 'Player'
	player.Name = `Player{resolved_user_id}`
	player.UserId = resolved_user_id

	return player
end

local function get_kick_message_list(player: Instance): { string }
	local kick_message_list = kick_message_list_by_player[player]
	if kick_message_list == nil then return {} end

	return kick_message_list
end

return table.freeze {
	create_test_player = create_test_player,
	get_kick_message_list = get_kick_message_list,
}
