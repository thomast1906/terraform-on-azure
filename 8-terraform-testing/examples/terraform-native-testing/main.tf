terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Purpose     = "Terraform Testing"
    ManagedBy   = "Terraform"
    CreatedBy   = "TerraformTest"
  }
}

resource "azurerm_storage_account" "test" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  account_kind             = "StorageV2"
  
  # Security best practices
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  
  tags = azurerm_resource_group.test.tags
}