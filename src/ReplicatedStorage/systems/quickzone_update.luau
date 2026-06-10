local ReplicatedStorage = game:GetService 'ReplicatedStorage'

local planck_runservice = require(ReplicatedStorage.pkg.planck_runservice)
local quickzone = require(ReplicatedStorage.pkg.quickzone)

local did_setup = false
local last_update_time: number? = nil

local function apply_quickzone_config(quickzone_module: any)
	quickzone_module:configure {
		enabled = false,
	}
end

local function step_quickzone(quickzone_module: any, delta_time: number)
	quickzone_module:update(delta_time)
end

local function configure_quickzone()
	apply_quickzone_config(quickzone)
end

local function setup_quickzone()
	if did_setup then return end

	configure_quickzone()

	did_setup = true
end

local function update_quickzone()
	local now = time()
	local delta_time = if last_update_time then now - last_update_time else 0

	last_update_time = now
	step_quickzone(quickzone, delta_time)
end

local function system()
	setup_quickzone()
	update_quickzone()
end

return {
	name = 'QuickZone: Update',
	phase = planck_runservice.Phases.PostSimulation,
	system = system,
}
