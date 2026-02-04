output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.test.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.test.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.test.name
}

output "storage_account_tier" {
  description = "Storage account tier"
  value       = azurerm_storage_account.test.account_tier
}

output "storage_replication_type" {
  description = "Storage replication type"
  value       = azurerm_storage_account.test.account_replication_type
}
