# Permissions

## Model

Conch uses a simple string-based permission system:

- Roles are strings.
- Permissions are strings.
- Users receive roles.
- Roles map to permissions.
- Commands declare which permissions they require.

## Assign Role Permissions

Call `conch.set_role_permissions()` during server initialization:

```luau
conch.set_role_permissions("vip",
	"use-capes",
	"use-server-command"
)
```

This overwrites any previously stored permission list for that role.

## Give Roles To Users

Obtain a `User` and then grant roles:

```luau
local user = conch.get_user(player)
conch.give_roles(user, "vip")
```

Removing roles uses `conch.remove_roles(user, ...)`.

## Permission Checks

`conch.has_permissions(user, ...)` returns `true` when:

- The user has all required permissions through their roles.
- Or the user has the special `super-user` role.

## Super User

The privileged role name is literally:

```text
super-user
```

Treat it as a root-like capability:

- It bypasses normal permission checks.
- It should be granted only to highly trusted users.
- Any command that can mutate roles should explicitly prevent untrusted users from granting `super-user`.

## Important Behavior

- Commands with an empty permission list are effectively public to any user who can access the console.
- Role changes on player-backed users are replicated to the client and mark command visibility dirty.
- Server-created users that are not backed by a `Player` still participate in permission checks, but they are not replicated as player-facing users.
