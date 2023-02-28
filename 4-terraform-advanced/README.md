# Terraform Advanced

In this section we will be looking at some more advanced Terraform concepts:

- Depends On 
- For Each
- Count
- Conditional Expressions
- Dynamic Blocks

# Pre-requisites

1. Ensure remote storage account is configured for Terraform state. Each of the above, will contain a Terraform configuration that will be used to deploy resources to Azure to show its concept with a new state file for each.

To do this, follow the steps in the [Terraform Remote State Deploy](https://github.com/thomast1906/terraform-on-azure/tree/main/2-terraform-state/3-terraform-remote-state-deploy.md) section.

Please note, I will be using storage account name `deployfirsttamopssa` for the remote state storage account. You will need to change this to your own storage account name.

Each will have providers.tf, to which you change the storage account name to your own. As shown below:

```terraform

terraform {
   backend "azurerm" {
        resource_group_name  = "deploy-first-rg"
        storage_account_name = "deployfirsttamopssa"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }

}

provider "azurerm" {
  features {}
}
    
    ```

2. Update variables.tf with your own values. Example below shown as part of [1-depends-on](https://github.com/thomast1906/terraform-on-azure/tree/main/4-terraform-advanced/1-depends-on/1-depends-on-example/variables.tf)

```terraform

variable "resource_group_name" {
  type = string
  default = "tamopsrg"
}
    
    ```

