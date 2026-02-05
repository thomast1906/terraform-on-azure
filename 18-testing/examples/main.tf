resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = var.location
  
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_account" "test" {
  name                     = "${var.storage_account_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = var.environment == "prod" ? "Premium" : "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  tags = azurerm_resource_group.test.tags
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
