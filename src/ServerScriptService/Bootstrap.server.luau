local servicesFolder = script.Parent.Services

local MonetizationService = require(servicesFolder.MonetizationService)
local ProfileStoreService = require(servicesFolder.ProfileStoreService)

ProfileStoreService.Start()
MonetizationService.Start()
