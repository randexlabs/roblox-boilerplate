# `planck_jabby` Plugin

## `Plugin`

| API                       | Purpose                                                 |
| ------------------------- | ------------------------------------------------------- |
| `Plugin.new()`            | Construct the Jabby integration plugin                  |
| `plugin:build(scheduler)` | Register scheduler state and execution hooks with Jabby |
| `plugin:cleanup()`        | Not exposed in the supplied runtime or typings          |

## What The Plugin Does

- mirror scheduler systems into Jabby scheduler applets
- mark paused systems when run conditions prevent execution
- wrap system execution so Jabby can time runs
- separate startup-phase systems into a dedicated Jabby scheduler view

It only adds the scheduler integration to Jabby. World registration and other debugger setup still belong to the caller.
