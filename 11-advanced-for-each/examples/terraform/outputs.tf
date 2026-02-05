output "resource_group_ids" {
  description = "Map of environment names to resource group IDs"
  value       = { for k, rg in azurerm_resource_group.rg : k => rg.id }
}

output "storage_account_names" {
  description = "Map of environment names to storage account names"
  value       = { for k, sa in azurerm_storage_account.example : k => sa.name }
}
