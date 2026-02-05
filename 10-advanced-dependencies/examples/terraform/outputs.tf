output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.rg.id
}

output "user_assigned_identity_id" {
  description = "ID of the user assigned identity"
  value       = azurerm_user_assigned_identity.example.id
}

output "container_group_id" {
  description = "ID of the container group"
  value       = azurerm_container_group.example.id
}

output "container_group_ip" {
  description = "IP address of the container group"
  value       = azurerm_container_group.example.ip_address
}
