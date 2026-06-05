# Module API

## Top-Level State

### `ProfileStore.IsClosing: boolean`

Read-only shutdown flag. It flips after `game:BindToClose()` begins. Many methods return early or fail silently once this becomes `true`.

### `ProfileStore.IsCriticalState: boolean`

Read-only service-health flag. It becomes `true` after enough recent DataStore failures and later returns to `false` after the failure window expires.

### `ProfileStore.DataStoreState: "NotReady" | "NoInternet" | "NoAccess" | "Access"`

Represents whether ProfileStore can use the live DataStore.

| Value          | Meaning                                    |
| -------------- | ------------------------------------------ |
| `"NotReady"`   | Startup check has not finished yet         |
| `"NoInternet"` | Network appears unavailable                |
| `"NoAccess"`   | Studio/game cannot use live DataStore APIs |
| `"Access"`     | Live DataStore writes are available        |

In Studio, the module performs a startup write check to detect access.

## Top-Level Signals

### `ProfileStore.OnError: Signal<(message, store_name, profile_key)>`

Fires when DataStore API calls error. Use it for logging or telemetry.

```luau
ProfileStore.OnError:Connect(function(error_message, store_name, profile_key)
    print(`DataStore error (Store:{store_name};Key:{profile_key}): {error_message}`)
end)
```

### `ProfileStore.OnOverwrite: Signal<(store_name, profile_key)>`

Fires when existing stored data appears structurally invalid and gets overwritten into ProfileStore's expected shape.

### `ProfileStore.OnCriticalToggle: Signal<(is_critical)>`

Fires whenever `ProfileStore.IsCriticalState` changes.

## Constructors And Helpers

### `ProfileStore.New(store_name: string, template: table?) -> ProfileStore`

Creates a store object bound to one DataStore name.

Behavior notes:

- `template` is deep-copied into new profiles only.
- Existing profiles do not receive new template fields unless you call `profile:Reconcile()`.
- Store names must be valid DataStore names.

### `ProfileStore.SetConstant(name: string, value: number)`

Overrides internal timing or queue constants.

Use sparingly. This is effectively an advanced tuning escape hatch, not everyday configuration.

### `store.Mock`

This is not a module-level constructor. It is exposed on each created store object. See [store.md](store.md) for behavior.

## Non-API Observations

The source contains `ProfileStore.Test()`. It is undocumented and should be considered unstable internal surface rather than a public API commitment.
