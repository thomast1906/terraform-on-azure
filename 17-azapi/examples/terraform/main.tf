resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azapi_resource" "acr" {
  location  = azurerm_resource_group.rg.name
  type      = "Microsoft.ContainerRegistry/registries@2020-11-01-preview"
  name      = var.acr_name
  parent_id = azurerm_resource_group.rg.id
  body = jsonencode({
    sku = {
      name = "Standard"
    }
    properties = {
      adminUserEnabled = true
    }
  })
}