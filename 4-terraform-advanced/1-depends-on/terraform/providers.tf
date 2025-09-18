terraform {
  # Modern Terraform version constraint
  required_version = ">= 1.5"
  
   backend "azurerm" {
        resource_group_name  = "deploy-first-rg"
        storage_account_name = "deployfirsttamopssa"
        container_name       = "dependson"
        key                  = "terraform.tfstate"
    }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.98"  # Updated with flexible versioning
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {
    # Enable advanced provider features for better resource management
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}