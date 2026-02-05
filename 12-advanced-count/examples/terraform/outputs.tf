# Reference the first resource group
output "first_rg_id" {
  description = "ID of the first resource group"
  value       = azurerm_resource_group.rg[0].id
}

# Reference the last resource group
output "last_rg_id" {
  description = "ID of the last resource group"
  value       = azurerm_resource_group.rg[2].id
}

# All resource group IDs
output "all_rg_ids" {
  description = "List of all resource group IDs"
  value       = azurerm_resource_group.rg[*].id
}
