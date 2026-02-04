output "resource_group_name" {
  description = "Name of the validated resource group"
  value       = azurerm_resource_group.validated.name
}

output "storage_account_name" {
  description = "Name of the validated storage account"
  value       = azurerm_storage_account.validated.name
}

output "storage_account_id" {
  description = "ID of the validated storage account"
  value       = azurerm_storage_account.validated.id
  
  # Pre-condition: Ensure all required tags are present
  precondition {
    condition = alltrue([
      for tag in local.required_tags :
      contains(keys(azurerm_storage_account.validated.tags), tag)
    ])
    error_message = "Cannot output storage account ID: Missing required tags. Required: ${join(", ", local.required_tags)}"
  }
}

output "public_ip_address" {
  description = "Allocated public IP address"
  value       = azurerm_public_ip.validated.ip_address
  
  # Pre-condition: Ensure IP was allocated
  precondition {
    condition     = azurerm_public_ip.validated.ip_address != ""
    error_message = "Cannot output IP address: IP was not allocated"
  }
}

output "storage_https_only" {
  description = "Whether HTTPS is enforced"
  value       = azurerm_storage_account.validated.enable_https_traffic_only
}

output "storage_tls_version" {
  description = "Minimum TLS version"
  value       = azurerm_storage_account.validated.min_tls_version
}

output "validation_summary" {
  description = "Summary of applied validations"
  value = {
    environment      = var.environment
    location         = var.location
    cost_center      = var.cost_center
    https_enforced   = azurerm_storage_account.validated.enable_https_traffic_only
    tls_version      = azurerm_storage_account.validated.min_tls_version
    replication_type = azurerm_storage_account.validated.account_replication_type
  }
}
