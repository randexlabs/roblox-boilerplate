local ReplicatedStorage = game:GetService 'ReplicatedStorage'
local RunService = game:GetService 'RunService'
local ServerScriptService = game:GetService 'ServerScriptService'
local UserInputService = game:GetService 'UserInputService'

local jecs = require(ReplicatedStorage.pkg.jecs)
local planck = require(ReplicatedStorage.pkg.planck)
local planck_runservice = require(ReplicatedStorage.pkg.planck_runservice)
local world = require(ReplicatedStorage.world)

type PluginList = { any }
type World = jecs.World
type SystemList = { planck.System<World> }

local function load_systems(folder: Instance): SystemList
	local modules = {}

	for _, child in folder:GetChildren() do
		if not child:IsA 'ModuleScript' then continue end
		table.insert(modules, child)
	end

	if next(modules) == nil then
		warn(`No systems found in {folder:GetFullName()}`)
	end

	local systems = {} :: SystemList

	for _, module in modules do
		local success, result = pcall(require, module)
		if not success then
			error(
				`Failed to load system module {module:GetFullName()}: {result}`
			)
		end

		local system = result :: any
		table.insert(systems, system)
	end

	return systems
end

local function create_scheduler(
	side_systems_folder: Instance,
	plugins: PluginList?
): planck.Scheduler<World>
	local shared_systems =
		load_systems(ReplicatedStorage:FindFirstChild 'systems' :: any)
	local side_systems = load_systems(side_systems_folder)

	local scheduler = planck.Scheduler.new(world)

	scheduler:addPlugin(planck_runservice.Plugin.new())

	if plugins ~= nil then
		for _, plugin in plugins do
			scheduler:addPlugin(plugin)
		end
	end

	if next(shared_systems) ~= nil then scheduler:addSystems(shared_systems) end
	if next(side_systems) ~= nil then scheduler:addSystems(side_systems) end

	if next(shared_systems) == nil and next(side_systems) == nil then
		warn(
			`No systems loaded for scheduler from {side_systems_folder:GetFullName()}`
		)
	end

	return scheduler
end

local function start_server()
	local planck_jabby = require(ReplicatedStorage.pkg.planck_jabby)

	return create_scheduler(
		ServerScriptService:FindFirstChild 'systems' :: any,
		{
			planck_jabby.new(),
		}
	)
end

local function start_client()
	local jabby = require(ReplicatedStorage.pkg.jabby)
	local jabby_client = jabby.obtain_client()
	local unmount_jabby: (() -> ())? = nil

	UserInputService.InputBegan:Connect(function(input, game_processed)
		if game_processed then return end
		if input.KeyCode ~= Enum.KeyCode.F2 then return end

		if unmount_jabby ~= nil then
			jabby_client.unmount_all()
			unmount_jabby = nil
			return
		end

		unmount_jabby = jabby_client.spawn_app(jabby_client.apps.home, nil)
	end)

	return create_scheduler(
		ReplicatedStorage.client:FindFirstChild 'systems' :: any
	)
end

local function start()
	if RunService:IsServer() then return start_server() end

	return start_client()
end

return table.freeze {
	start = start,
}
