# Deploy with local state

You'll deploy a simple Azure resource using local state to see how Terraform tracks infrastructure.

## Create your configuration

Navigate to the `local-state-example` directory:

```bash
cd 3-terraform-state/local-state-example
```

Check the contents of `providers.tf`:

```terraform
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  
  backend "local" {}
}

provider "azurerm" {
  features {}
}
```

The `backend "local" {}` block tells Terraform to store state locally.

Check `main.tf`:

```terraform
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-local-state"
  location = "uksouth"
}
```

## Initialize Terraform

```bash
terraform init
```

You'll see:

```
Initializing the backend...

Successfully configured the backend "local"!
```

## Deploy the resource

Check your configuration:

```bash
terraform validate
terraform plan
```

The plan shows:

```
Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "rg-terraform-local-state"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

Apply the configuration:

```bash
terraform apply
```

Type `yes` when prompted.

## Inspect the state file

Terraform created `terraform.tfstate` in your directory:

```bash
ls -la terraform.tfstate
```

View its contents:

```bash
cat terraform.tfstate
```

The state file is JSON. It contains:
- Resource IDs
- Resource attributes
- Dependencies between resources
- Provider configuration

You'll see your resource group's Azure ID, location, and other properties.

## Verify in Azure

Check that the resource exists:

```bash
az group show --name rg-terraform-local-state
```

View it in the [Azure Portal](https://portal.azure.com/#blade/HubsExtension/BrowseResourceGroups).

## Make a change

Edit `main.tf` to add tags:

```terraform
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-local-state"
  location = "uksouth"
  
  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}
```

Plan the change:

```bash
terraform plan
```

Terraform detects the difference:

```
Terraform will perform the following actions:

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
      + tags     = {
          + "Environment" = "Demo"
          + "ManagedBy"   = "Terraform"
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

The `~` symbol means Terraform will modify the resource in place.

Apply the change:

```bash
terraform apply
```

## Clean up

Destroy the resource:

```bash
terraform destroy
```

Type `yes` when prompted. The state file now shows zero resources.

## Key takeaways

- Terraform stores state in `terraform.tfstate`
- State maps your configuration to real Azure resources
- Terraform uses state to plan changes
- Local state works for single-user scenarios but not teams



