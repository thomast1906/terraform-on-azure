output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.test.id
}

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.test.name
}

output "storage_account_id" {
  description = "ID of the created storage account"
  value       = azurerm_storage_account.test.id
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.test.name
}

output "storage_primary_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.test.primary_blob_endpoint
}