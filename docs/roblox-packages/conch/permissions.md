Permissions
Setting up permissions and roles in Conch is really simple. In Conch, each role and permission is just a string. Users are given roles, and roles have a list of permissions that they are granted. In order to set the permissions a role grants, you can use conch.set_role_permissions when the server starts.

conch.set_role_permissions("vip",
"use-capes",
"use-server-command"
)
Roles can then be granted to a user through the user.give_roles function. You'll first need to obtain the user with user.get_user.

local player = Players.alicesays_hallo
local user = conch.get_user(player)
conch.give_roles(user, "vip")
This will now give alicesays_hallo the vip role, which gives them the permissions to use-capes and use-server-commands.

It's important to register permissions for each command, as not doing so allows anyone to run that command, even if they just joined.

Super User
Conch has a special case for the super-user, which is a special role that should only be granted to only those you can trust. This role gives the user access to every permission that the developer has registered. When adding a command that allows users to give roles, please explicitly check that this role cannot be given.
