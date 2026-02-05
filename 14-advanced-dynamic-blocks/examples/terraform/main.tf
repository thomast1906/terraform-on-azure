resource "azurerm_resource_group" "rg" {
  dynamic "name" {
    for_each = var.resource_group_names
    content {
      name     = name.value
      location = "uksouth"
    }
  }
}