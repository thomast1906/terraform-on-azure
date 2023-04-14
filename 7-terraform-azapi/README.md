# Terraform AzAPI

A few months ago, there was an announcement of AzAPI Terraform provider, that enables you to manage any Azure resource type using any API version. You may be wondering, why the need for this?

Some times with new resource updates or additions, the Terraform AzureRM provider is not up to date or missing a piece of functionality within a particular resource. With this new provider, you can begin deploying using Terraform from day 1 without the need to wait until AzureRM has been updated – awesome!

In this section, we will be looking at how to use the AzAPI provider to deploy resources to Azure.

# Terraform AzAPI - Pros

- You can deploy any Azure resource type using any API version
- You can deploy resources that are not yet supported by the AzureRM provider

# Terraform AzAPI - Cons

- You need to know the API version of the resource you are deploying

# Terraform AzAPI - example

In this example, we will be deploying a new Azure Container Registry (ACR) using the AzAPI provider.

Example below of the Terraform configuration files:

providers.tf - this is the provider configuration file, showing the AzAPI provider information required.

```terraform

provider "azapi" {
}

terraform {
  backend "local" {
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

```


main.tf

```terraform
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azapi_resource" "acr" {
  location  = azurerm_resource_group.rg.name
  type      = "Microsoft.ContainerRegistry/registries@2020-11-01-preview"
  name      = var.acr_name
  parent_id = azurerm_resource_group.rg.id
  body = jsonencode({
    sku = {
      name = "Standard"
    }
    properties = {
      adminUserEnabled = true
    }
  })
}

```

variables.tf

```terraform

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the container registry."
  default     = "tamopsrg"
}

variable "location" {
  type        = string
  description = "The Azure location where the container registry should exist."
  default     = "uksouth"
}

variable "acr_name" {
  type        = string
  description = "The name of the container registry."
  default     = "tamopsacr"
}


```

### Run example

You can now run the example found in this section.

Run Terraform from [here](https://github.com/thomast1906/terraform-on-azure/tree/main/7-terraform-azapi/terraform)
