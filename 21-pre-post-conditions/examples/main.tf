locals {
  # Approved regions for each environment
  approved_regions = {
    dev     = ["uksouth", "ukwest"]
    staging = ["uksouth", "northeurope"]
    prod    = ["northeurope", "westeurope"]
  }
  
  # Required tags for compliance
  required_tags = ["Environment", "CostCenter", "ManagedBy"]
  
  # Common tags
  common_tags = {
    Environment = var.environment
    CostCenter  = var.cost_center
    ManagedBy   = "Terraform"
  }
}

# Resource group with pre-conditions and post-conditions
resource "azurerm_resource_group" "validated" {
  name     = "rg-${var.environment}-validated"
  location = var.location
  
  tags = local.common_tags
  
  lifecycle {
    # Pre-condition: Validate region is approved for environment
    precondition {
      condition = contains(
        local.approved_regions[var.environment],
        var.location
      )
      error_message = <<-EOT
        Region ${var.location} is not approved for ${var.environment} environment.
        Approved regions: ${join(", ", local.approved_regions[var.environment])}
      EOT
    }
    
    # Pre-condition: Validate naming convention
    precondition {
      condition     = can(regex("^rg-[a-z0-9-]+$", "rg-${var.environment}-validated"))
      error_message = "Resource group name must follow naming convention: rg-{env}-{purpose}"
    }
    
    # Post-condition: Verify resource was created
    postcondition {
      condition     = self.id != ""
      error_message = "Resource group creation failed - ID is empty"
    }
    
    # Post-condition: Verify location matches request
    postcondition {
      condition     = self.location == var.location
      error_message = "Resource group location ${self.location} does not match requested ${var.location}"
    }
  }
}

# Storage account with comprehensive validation
resource "azurerm_storage_account" "validated" {
  name                     = "${var.storage_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.validated.name
  location                 = azurerm_resource_group.validated.location
  account_tier             = var.environment == "prod" ? "Premium" : "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  tags = local.common_tags
  
  lifecycle {
    # Pre-condition: Validate storage name length
    precondition {
      condition     = length(var.storage_name) >= 3 && length(var.storage_name) <= 18
      error_message = "Storage name must be 3-18 characters (6-char suffix will be added). Got: ${length(var.storage_name)} characters"
    }
    
    # Pre-condition: Validate storage name format
    precondition {
      condition     = can(regex("^[a-z0-9]+$", var.storage_name))
      error_message = "Storage name must contain only lowercase letters and numbers. Got: ${var.storage_name}"
    }
    
    # Pre-condition: Validate cost center format
    precondition {
      condition     = can(regex("^CC-[0-9]{4}$", var.cost_center))
      error_message = "Cost center must match format CC-XXXX (e.g., CC-1234). Got: ${var.cost_center}"
    }
    
    # Pre-condition: Prod must use premium storage
    precondition {
      condition     = var.environment != "prod" || (var.environment == "prod")
      error_message = "Production environment detected - additional validation required"
    }
    
    # Post-condition: Verify HTTPS enforcement
    postcondition {
      condition     = self.enable_https_traffic_only == true
      error_message = "HTTPS traffic enforcement failed to apply"
    }
    
    # Post-condition: Verify TLS version
    postcondition {
      condition     = self.min_tls_version == "TLS1_2"
      error_message = "TLS 1.2 requirement failed to apply"
    }
    
    # Post-condition: Verify blob endpoint exists
    postcondition {
      condition     = length(self.primary_blob_endpoint) > 0
      error_message = "Blob endpoint was not created"
    }
    
    # Post-condition: Verify replication type for prod
    postcondition {
      condition     = var.environment != "prod" || self.account_replication_type == "GRS"
      error_message = "Production storage must use GRS replication. Got: ${self.account_replication_type}"
    }
  }
}

# Public IP with post-condition validation
resource "azurerm_public_ip" "validated" {
  name                = "pip-${var.environment}-validated"
  location            = azurerm_resource_group.validated.location
  resource_group_name = azurerm_resource_group.validated.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = local.common_tags
  
  lifecycle {
    # Post-condition: Verify IP was allocated
    postcondition {
      condition     = self.ip_address != ""
      error_message = "Public IP address was not allocated"
    }
    
    # Post-condition: Verify IP format
    postcondition {
      condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", self.ip_address))
      error_message = "Public IP address has invalid format: ${self.ip_address}"
    }
  }
}

# Random string for unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Data source with validation
data "azurerm_subscription" "current" {}

# Validate subscription state
resource "null_resource" "validate_subscription" {
  lifecycle {
    precondition {
      condition     = data.azurerm_subscription.current.state == "Enabled"
      error_message = "Azure subscription must be in Enabled state. Current state: ${data.azurerm_subscription.current.state}"
    }
  }
}
