# Runtime API

## Exports At A Glance

The main runtime package exports the documented command API plus several additional helpers.

## Core Lifecycle

### `version: string`

Current runtime version string exposed by the module.

### `initiate_default_lifecycle(): void`

Initialize networking, player user management, command replication, and client readiness flow.

Use this once runtime setup is complete on each side that loads Conch.

### `register_default_commands(): void`

Bootstrap built-in commands.

Current runtime bootstrap covers:

- `license`
- `print`
- `sleep`
- `error`
- `warn`
- `info`
- `set`

## Command Registration

### `register_quick(name: string, fn: (...args) -> unknown, ...permissions: string[]): void`

Register a command directly from a callback without argument metadata or analysis information.

Use for:

- Temporary commands
- Admin/debug shortcuts
- Cases where autocomplete quality does not matter

### `register(name: string, props): void`

Register a structured command with:

- `description?: string`
- `permissions: string[]`
- `arguments: () -> argument tuple`
- `callback: (...typedArgs) -> unknown`

Behavior notes:

- Command visibility is permission-aware.
- On the server, eligible commands are replicated only to users who can see them.
- Overloads are supported through the argument helper layer.

## Execution

### `execute(src: string): void`

Execute Conch source as the local user on the client.

Caveats:

- Client-only.
- Requires the local user to exist.
- Errors are written to the console output.
- The executed text is also logged through the client network path.

### `cancel(): void`

Cancel the currently running command execution if there is a suspended execution thread.

This export exists at runtime but is not part of the primary published docs.

## Permissions And Users

### `has_permissions(user: User, ...permissions: string[]): boolean`

Return whether the user satisfies all required permissions, or is a `super-user`.

### `set_role_permissions(role: string, ...permissions: string[]): void`

Overwrite the permission set for a role.

### `give_roles(user: User, ...roles: string[]): void`

Assign roles to a user, deduplicating new assignments.

### `remove_roles(user: User, ...roles: string[]): void`

Remove the specified roles from a user.

### `get_user(key: string | Player): User`

Return or create a `User`.

Behavior notes:

- With a `Player`, user ids look like `player-<UserId>`.
- With a string key, the runtime creates a non-player-backed user id like `server-<name>`.
- Player-backed users participate in replication; string-backed users are useful for server/internal contexts.

## Variables And Context

### `set_var(global: string, value: unknown): void`

Set a global command value.

Caveats:

- Client-only.
- The global name must match `^[A-z%-@_]*$`.
- The runtime allows letters, dashes, underscores, and `@`.

### `get_command_context(): CommandContext`

Return the current execution context:

- `executor: User`
- `invocation_id: number | false`

Use inside running command callbacks when you need to know who invoked the command.

## Logging

### `log(kind, text): void`

Documented kinds:

- `"warn"`
- `"info"`
- `"error"`
- `"normal"`

Runtime also supports:

- `"success"`

Behavior:

- On the server, it targets the current command executor if context exists.
- On the client, it writes directly to local console output.

### `log_to(player: Player, kind, text): void`

Send a log to a specific player from the server, or echo locally if the given player is the local player on the client.

This export exists at runtime but is not part of the main published docs.

## Analysis And Hooks

### `analyze(src: string, where: number): AnalysisResult`

Analyze source for issues, suggestions, and context at a cursor position.

### `on_command_run(fn): () -> void`

Subscribe to post-command execution events.

Callback shape:

```luau
{
	ok: boolean,
	who: User,
	command: string,
	arguments: { unknown },
	result: { unknown },
}
```

Returns a disconnect function.

### `on_execution(fn): () -> void`

Subscribe to raw execution attempts from players.

Callback:

```luau
(player: Player, src: string) -> ()
```

Returns a disconnect function.

## Type Helpers Re-Exported At Runtime

The module also re-exports lower-level type tools:

- `args`
- `get_strange_type`
- `register_strange_type`
- `pluralize_type`
- `wrap_type`

These are useful for advanced integrations and custom type plumbing.

## Additional Exports

### `console`

The underlying console object, containing:

- `vm`
- `commands`
- `output(log)`

### `_`

Underscored runtime helpers:

- `type`
- `create_user`
- `disconnect_user`
- `create_local_user`

These are exported and therefore part of the accessible surface, but they should be treated as low-level runtime hooks rather than the stable first-choice API.
