terraform {
  backend "azurerm" {
    resource_group_name  = "deploy-first-rg"
    storage_account_name = "deployfirsttamopssa"
    container_name       = "acr"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.90.0"
    }
  }

}

provider "azurerm" {
  features {}
}