resource "azurerm_resource_group" "rg" {
  for_each = toset(var.resource_group_names)
  name     = each.key
  location = "uksouth"
}
