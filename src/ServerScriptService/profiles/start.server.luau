local Players = game:GetService 'Players'

local runtime = require(script.Parent.runtime)

local player_session_service = runtime.session

for _, player in Players:GetPlayers() do
	task.spawn(player_session_service.load_profile_async, player)
end

Players.PlayerAdded:Connect(player_session_service.load_profile_async)
Players.PlayerRemoving:Connect(player_session_service.unload_profile)
