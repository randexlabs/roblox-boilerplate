local ServerScriptService = game:GetService 'ServerScriptService'

local coins_100_product =
	require(ServerScriptService.products.coins_100_product)

export type ProductDefinition = coins_100_product.ProductDefinition

local product_catalog: { [number]: ProductDefinition } = {}

assert(
	product_catalog[coins_100_product.Id] == nil,
	`Duplicate developer product id: {coins_100_product.Id}`
)
product_catalog[coins_100_product.Id] = coins_100_product

return table.freeze(product_catalog)
