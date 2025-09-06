# Resource Group with Best Practices
# This example demonstrates a well-structured Terraform configuration
# that follows best practices for testing and validation

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group with proper naming and tagging
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Storage Account with security best practices
resource "azurerm_storage_account" "main" {
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Security settings
  min_tls_version                = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false
  
  # Enable blob encryption
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
  }

  # Network access restrictions
  network_rules {
    default_action = "Deny"
    ip_rules       = var.allowed_ip_ranges
  }

  tags = var.tags

  depends_on = [
    azurerm_resource_group.main
  ]
}