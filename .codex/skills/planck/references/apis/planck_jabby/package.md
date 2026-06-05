# `planck_jabby` Package

## Runtime Export Shape

```luau
return Plugin
```

Typical usage:

```luau
local PlanckJabby = require("@packages/PlanckJabby")
local jabbyPlugin = PlanckJabby.new()

scheduler:addPlugin(jabbyPlugin)
```

Unlike `planck_runservice`, this package exports the plugin directly rather than inside a wrapper table.

## Relationship To Core `planck`

`planck_jabby` is entirely hook-driven on top of the core scheduler. It does not create phases, pipelines, or conditions of its own; it observes and instruments what `planck` already manages.
