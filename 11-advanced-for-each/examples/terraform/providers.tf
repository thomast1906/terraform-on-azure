terraform {
   backend "azurerm" {
        resource_group_name  = "rg-terraform-state"
        storage_account_name = "YOUR_STORAGE_ACCOUNT_NAME" # Replace with the storage account name created in lesson 9
        container_name       = "foreach"
        key                  = "terraform.tfstate"
    }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8"
    }
  }

}

provider "azurerm" {
  features {}
}