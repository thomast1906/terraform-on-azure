resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.environment == "prod" ? "northeurope" : "uksouth"
  
  tags = {
    Environment = var.environment
    CostCenter  = var.environment == "prod" ? "Production" : "Development"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "st${var.environment}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  
  https_traffic_only_enabled = true
  min_tls_version           = var.environment == "prod" ? "TLS1_2" : "TLS1_0"
  
  tags = azurerm_resource_group.rg.tags
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}