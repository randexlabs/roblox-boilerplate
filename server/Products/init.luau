local ServerScriptService = game:GetService 'ServerScriptService'

local Coins100Product = require(ServerScriptService.Products.Coins100Product)

export type ProductDefinition = Coins100Product.ProductDefinition

local ProductCatalog: { [number]: ProductDefinition } = {}

assert(
	ProductCatalog[Coins100Product.Id] == nil,
	`Duplicate developer product id: {Coins100Product.Id}`
)
ProductCatalog[Coins100Product.Id] = Coins100Product

return table.freeze(ProductCatalog)
