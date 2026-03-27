Setting Up
Server Setup
Require on the server and run the following functions:

local conch = require(path.to.conch)

conch.initiate_default_lifecycle()
Client Setup
Require on the client and run the following functions. You can configure the hotkey used to activate Conch by changing bind_to.

local conch = require(path.to.conch)
local ui = require(path.to.conchui)

conch.initiate_default_lifecycle()
ui.bind_to(Enum.KeyCode.F4)
