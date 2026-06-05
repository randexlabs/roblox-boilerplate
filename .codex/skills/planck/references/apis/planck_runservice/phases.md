# `planck_runservice` Phases

## `Phases`

| Export           | Meaning                              |
| ---------------- | ------------------------------------ |
| `PreRender`      | Runs on `RunService.PreRender`       |
| `PreAnimation`   | Runs on `RunService.PreAnimation`    |
| `PreSimulation`  | Runs on `RunService.PreSimulation`   |
| `PostSimulation` | Runs on `RunService.PostSimulation`  |
| `First`          | First heartbeat update slice         |
| `PreUpdate`      | Runs before `Update`                 |
| `Update`         | Main heartbeat/default runtime phase |
| `PostUpdate`     | Runs after `Update`                  |
| `Last`           | Last heartbeat update slice          |

Useful note from the docs:

- `PreRender` is the modern equivalent of `RenderStepped`
- `PreSimulation` is the modern equivalent of `Stepped`
