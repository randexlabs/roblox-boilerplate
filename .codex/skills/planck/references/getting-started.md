# Getting Started

## Install The Core Package

Wally:

```toml
[dependencies]
Planck = "yetanotherclown/planck@0.2.0"
```

The docs also describe `.rbxm` distribution in releases, but the primary usage path in the supplied material is package-manager installation.

## Create A Scheduler

```luau
local Planck = require("@packages/Planck")
local Scheduler = Planck.Scheduler

local world = {}
local state = {}

local scheduler = Scheduler.new(world, state)
```

Whatever arguments you pass to the scheduler constructor become the arguments given to every system and condition.

## Define A Basic System

```luau
local function systemA(world, state)
	-- ...
end

return systemA
```

Add it to the scheduler:

```luau
scheduler:addSystem(systemA)
```

## Use A System Table When Metadata Helps

```luau
local function systemA(world, state)
	-- ...
end

return {
	name = "systemA",
	system = systemA,
	phase = Planck.Phase.PreStartup,
	runConditions = {
		function(world, state)
			return true
		end,
	},
}
```

System tables are the normal way to bundle:

- readable names
- phase assignment
- run conditions

## Add Multiple Systems

```luau
local systems = { systemA, systemB, systemC }
scheduler:addSystems(systems)
```

This is especially useful in startup/bootstrap code that discovers systems from folders.

## Create A Custom Phase

```luau
local Planck = require("@packages/Planck")
local Phase = Planck.Phase

local myPhase = Phase.new("myPhase")

scheduler
	:insert(myPhase)
	:addSystem(systemA, myPhase)
```

## Use Built-In Startup Phases

```luau
local Phase = Planck.Phase

local PreStartup = Phase.PreStartup
local Startup = Phase.Startup
local PostStartup = Phase.PostStartup
```

These run once and before the rest of the schedule.

## Initializer Systems

Initializer systems perform setup on first execution and then become normal runtime systems.

```luau
local function renderSystem(world, state)
	local cached = world:query(Transform, Model):cached()

	return function(world, state)
		for id, transform, model in cached do
			-- ...
		end
	end
end

return renderSystem
```

They may also return a cleanup function:

```luau
local function networkSystem(world, state)
	local connection = Players.PlayerAdded:Connect(function(player)
		-- ...
	end)

	return function(world, state)
		-- ...
	end, function()
		connection:Disconnect()
	end
end
```

That cleanup runs when the system is removed or replaced.

## RunService Integration

With the official RunService plugin:

```luau
local PlanckRunService = require("@packages/PlanckRunService")
local runServicePlugin = PlanckRunService.Plugin.new()

local scheduler = Scheduler.new(world)
	:addPlugin(runServicePlugin)
```

That plugin inserts built-in pipelines and phases for:

- `PreRender`
- `PreAnimation`
- `PreSimulation`
- `PostSimulation`
- `Heartbeat`

## Jabby Integration

```luau
local PlanckJabby = require("@packages/PlanckJabby")
local jabbyPlugin = PlanckJabby.new()

local scheduler = Scheduler.new(world)
	:addPlugin(jabbyPlugin)
```

This adds the scheduler to Jabby, but not your ECS world registration or any other debugger setup outside the scheduler integration itself.

## Jecs-Oriented Project Pattern

The setup guide strongly suggests:

- one shared `world` module
- one shared `scheduler` module
- shared/client/server system folders
- a startup function that gathers systems and bulk-adds them

The guide also recommends passing dependencies like `world` through system parameters instead of requiring them directly inside systems. That keeps systems more pure, testable, and reusable.
