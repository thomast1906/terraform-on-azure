resource "azurerm_resource_group" "rg" {
  for_each = toset(var.resource_group_names)
  name     = each.key
  location = "uksouth"
  
  tags = {
    Environment = each.key
  }
}

resource "azurerm_storage_account" "example" {
  for_each = azurerm_resource_group.rg
  
  name                     = replace("st${each.key}${random_string.suffix.result}", "-", "")
  resource_group_name      = each.value.name
  location                 = each.value.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = each.value.tags
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
