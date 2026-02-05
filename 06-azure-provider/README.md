# Configure the Azure provider

The Azure provider lets Terraform interact with Azure resources. You configure it once at the start of your project.

## Authenticate with Azure

First, sign in to Azure using the Azure CLI:

```bash
az login
```

This opens your browser for authentication. Once you're signed in, the CLI displays your subscriptions:

```json
[
  {
    "id": "00000000-0000-0000-0000-000000000000",
    "name": "My Subscription",
    "tenantId": "00000000-0000-0000-0000-000000000000",
    "isDefault": true
  }
]
```

If you have multiple subscriptions, set the one you want to use:

```bash
az account set --subscription "00000000-0000-0000-0000-000000000000"
```

## Create your first Terraform configuration

Create a file called `providers.tf`:

```terraform
terraform {
  required_version = ">= 1.0"
  
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

This tells Terraform:
- Require Terraform 1.0 or later
- Use the Azure provider version 4.x
- Enable default Azure provider features

The `features {}` block is required. It controls provider-specific behaviors like how resources are deleted.

## Initialize the provider

Run init to download the provider:

```bash
terraform init
```

You'll see output showing the provider installation:

```
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 4.0"...
- Installing hashicorp/azurerm v4.x.x...
- Installed hashicorp/azurerm v4.x.x
```

## Deploy your first resource

Create `main.tf`:

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rg-terraform-demo"
  location = "uksouth"
}
```

Deploy it:

```bash
terraform validate
terraform plan
terraform apply
```

Type `yes` when prompted. Terraform creates the resource group in Azure.

## Verify in Azure

Check that the resource group exists:

```bash
az group show --name rg-terraform-demo
```

You can also view it in the [Azure Portal](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups).

## Clean up

Delete the resource group:

```bash
terraform destroy
```

Type `yes` when prompted.
