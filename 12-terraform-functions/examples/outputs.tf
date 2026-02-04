output "resource_group_name" {
  description = "Generated resource group name"
  value       = azurerm_resource_group.example.name
}

output "storage_account_name" {
  description = "Generated storage account name (cleaned and truncated)"
  value       = azurerm_storage_account.example.name
}

output "primary_region" {
  description = "Primary region from list"
  value       = local.primary_region
}

output "is_production" {
  description = "Whether this is production environment"
  value       = local.is_production
}

output "replication_type" {
  description = "Storage replication type based on environment"
  value       = local.replication_type
}

output "all_tags" {
  description = "Merged tags applied to resources"
  value       = local.all_tags
}

output "parsed_resource_id" {
  description = "Parsed components from storage account resource ID"
  value = {
    full_id          = local.storage_id
    subscription_id  = local.subscription_id
    resource_group   = local.parsed_rg_name
    storage_name     = local.parsed_sa_name
    rg_from_regex    = local.rg_from_regex
  }
}

output "connection_string" {
  description = "Generated storage connection string"
  value       = local.connection_string
  sensitive   = true
}

output "app_config_json" {
  description = "Application configuration as JSON"
  value       = local.app_config_json
}

output "encoded_script" {
  description = "Base64 encoded initialization script"
  value       = local.encoded_script
}

output "nsg_rules" {
  description = "NSG rules created"
  value       = keys(local.nsg_rules)
}

output "string_functions_demo" {
  description = "Demonstration of string manipulation functions"
  value = {
    original_app_name = var.app_name
    clean_app_name    = local.clean_app_name
    upper_app_name    = local.app_name_upper
    formatted_name    = local.resource_group_name
    storage_base      = local.storage_base
    final_name        = local.storage_name
  }
}

output "collection_functions_demo" {
  description = "Demonstration of collection functions"
  value = {
    regions           = var.regions
    regions_joined    = join(", ", var.regions)
    region_count      = length(var.regions)
    primary_region    = local.primary_region
    flattened_combos  = local.all_region_combos
    vm_size           = local.vm_size
    cost_center_num   = local.cost_center_number
  }
}
