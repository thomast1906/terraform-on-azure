terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

provider "azurerm" {
  features {}
}

# Import block - this tells Terraform what to import
# Replace {subscription-id} with your actual subscription ID
import {
  to = azurerm_resource_group.imported
  id = "/subscriptions/{subscription-id}/resourceGroups/existing-resource-group"
}

# Resource configuration
resource "azurerm_resource_group" "imported" {
  name     = "existing-resource-group"
  location = "East US"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    ImportedOn  = "2024-01-01"
  }
}