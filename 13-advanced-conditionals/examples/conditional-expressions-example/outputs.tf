output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.rg.location
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.sa.name
}

output "storage_replication_type" {
  description = "Replication type based on environment"
  value       = azurerm_storage_account.sa.account_replication_type
}

output "min_tls_version" {
  description = "Minimum TLS version based on environment"
  value       = azurerm_storage_account.sa.min_tls_version
}
