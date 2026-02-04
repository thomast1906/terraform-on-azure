terraform {
  backend "local" {
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }

}

provider "azurerm" {
  features {}
}