# `planck_runservice` Package

## Runtime Export Shape

```luau
return {
	Plugin = Plugin,
	Phases = Phases,
	Pipelines = Pipelines,
}
```

Typical usage:

```luau
local PlanckRunService = require("@packages/PlanckRunService")
local runServicePlugin = PlanckRunService.Plugin.new()

scheduler:addPlugin(runServicePlugin)
```

This runtime shape is important because some docs present construction more uniformly than the actual Luau export shape.

## Relationship To Core `planck`

`planck_runservice` does not define its own scheduler model. It layers on top of `planck` by:

- creating phases and pipelines
- binding them to Roblox `RunService` events
- selecting a default phase for implicit system placement
