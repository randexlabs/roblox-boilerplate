local services_folder = script.Parent.services

local monetization_service = require(services_folder.monetization_service)
local profile_store_service = require(services_folder.profile_store_service)

profile_store_service.start()
monetization_service.start()
