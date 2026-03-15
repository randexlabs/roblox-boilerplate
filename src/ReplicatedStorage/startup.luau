local ContextActionService = game:GetService 'ContextActionService'
local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local RunService = game:GetService 'RunService'
local ServerScriptService = game:GetService 'ServerScriptService'

local jabby = require(ReplicatedStorage.pkg.jabby)
local scheduler = require(script.Parent.scheduler)
local world = require(script.Parent.world)

local function setup_jabby_client()
	if RunService:IsServer() then return end
	local client = jabby.obtain_client()

	local function create_widget(_, state: Enum.UserInputState)
		if state ~= Enum.UserInputState.Begin then return end
		client.spawn_app(client.apps.home, nil)
	end

	ContextActionService:BindAction(
		'Open Jabby',
		create_widget,
		false,
		Enum.KeyCode.F2
	)
end

local function add_systems(container: Instance)
	local result = {}

	for _, modulescript in container:GetChildren() do
		if not modulescript:IsA 'ModuleScript' then continue end
		table.insert(result, (require)(modulescript))
	end

	if #result == 0 then return end
	scheduler:addSystems(result)
end

add_systems((ReplicatedStorage :: any).systems)

return function()
	if RunService:IsClient() then
		setup_jabby_client()
		add_systems(ReplicatedStorage.client.systems)
	elseif RunService:IsServer() then
		add_systems(ServerScriptService.systems)
	end

	jabby.register {
		applet = jabby.applets.world,
		name = 'Jecs world',
		configuration = { world = world },
	}
end
