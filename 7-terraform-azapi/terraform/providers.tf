provider "azapi" {
}

terraform {
  backend "azurerm" {
    resource_group_name  = "deploy-first-rg"
    storage_account_name = "deployfirsttamopssa"
    container_name       = "azapi"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
    azapi = {
      source = "azure/azapi"
    }
  }

}

provider "azurerm" {
  features {}
}