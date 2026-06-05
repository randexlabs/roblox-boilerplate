# Request Costs And Tuning

## Request Budget Shape

ProfileStore consumes both `DataStoreService` and `MessagingService` budget. The exact call count depends on conflict handling and manual saves.

## Operation Costs

| Operation                               | Typical Roblox API usage                                                                                         |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| Studio startup check                    | 1 `SetAsync()` call to test access                                                                               |
| `:StartSessionAsync()` with no conflict | Usually 1 `UpdateAsync()`                                                                                        |
| `:StartSessionAsync()` during conflict  | Repeated `UpdateAsync()` plus `PublishAsync()` retries until release or steal                                    |
| Active session idle time                | 1 `UpdateAsync()` every autosave period                                                                          |
| `:Save()`                               | 1 `UpdateAsync()` and resets autosave timing                                                                     |
| `:MessageAsync()`                       | 1 `UpdateAsync()` plus 1 `PublishAsync()`, plus another `UpdateAsync()` on the owning server if active elsewhere |
| `:GetAsync()`                           | 1 `GetAsync()`                                                                                                   |
| `:RemoveAsync()`                        | 1 `RemoveAsync()`                                                                                                |
| `VersionQuery:NextAsync()`              | May use `ListVersionsAsync()` and `GetAsync()`                                                                   |
| `Profile:SetAsync()`                    | 1 `UpdateAsync()`                                                                                                |

## Default Constants

The runtime exposes `ProfileStore.SetConstant(name, value)` for changing internals without forking. This is for experienced users only.

Supported constant names:

- `AUTO_SAVE_PERIOD`
- `LOAD_REPEAT_PERIOD`
- `FIRST_LOAD_REPEAT`
- `SESSION_STEAL`
- `ASSUME_DEAD`
- `START_SESSION_TIMEOUT`
- `CRITICAL_STATE_ERROR_COUNT`
- `CRITICAL_STATE_ERROR_EXPIRE`
- `CRITICAL_STATE_EXPIRE`
- `MAX_MESSAGE_QUEUE`

Observed defaults in the implementation:

| Constant                      | Default |
| ----------------------------- | ------- |
| `AUTO_SAVE_PERIOD`            | `300`   |
| `LOAD_REPEAT_PERIOD`          | `10`    |
| `FIRST_LOAD_REPEAT`           | `5`     |
| `SESSION_STEAL`               | `40`    |
| `ASSUME_DEAD`                 | `630`   |
| `START_SESSION_TIMEOUT`       | `120`   |
| `CRITICAL_STATE_ERROR_COUNT`  | `5`     |
| `CRITICAL_STATE_ERROR_EXPIRE` | `120`   |
| `CRITICAL_STATE_EXPIRE`       | `120`   |
| `MAX_MESSAGE_QUEUE`           | `1000`  |

## Tuning Guidance

- Lowering `AUTO_SAVE_PERIOD` increases write pressure.
- Lowering conflict retry intervals increases service pressure during reconnect storms.
- Raising `MAX_MESSAGE_QUEUE` increases payload churn and saved queue size.
- Adjusting conflict constants carelessly can make recovery slower or duplicate-prone.

Only change constants if you understand the runtime tradeoff, not just because a symptom is annoying.

## Critical State

ProfileStore tracks recent DataStore failures. If enough errors happen close together, `ProfileStore.IsCriticalState` becomes `true` and `ProfileStore.OnCriticalToggle` fires. This is a useful signal for telemetry and degraded-mode UX.
