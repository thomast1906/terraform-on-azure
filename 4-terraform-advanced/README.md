# Terraform Advanced

In this section we will be looking at some more advanced Terraform concepts:

- Depends On 
- For Each
- Count
- Conditional Expressions
- Dynamic Blocks

## Prerequisites

1. Set up a remote state storage account before starting this section. Each example uses its own state key.

Follow the steps in [Terraform Remote State Deploy](../3-terraform-state/3-terraform-remote-state-deploy.md).

Each example includes a `providers.tf`. Update the backend values to match your resource group, storage account, and container:

```terraform
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstate12345"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

2. Update `variables.tf` with your own values. Example: [1-depends-on/terraform/variables.tf](./1-depends-on/terraform/variables.tf)

```terraform
variable "resource_group_name" {
  type    = string
  default = "tamopsrg"
}
```

