# Resources and data sources

Resources are the building blocks of your infrastructure. Each resource block defines one piece of your Azure environment.

## Create a resource

Here's a resource that creates an Azure resource group:

```terraform
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-demo"
  location = "uksouth"
}
```

The structure is:
- `resource` keyword
- Resource type in quotes: `"azurerm_resource_group"`
- Local name in quotes: `"rg"` (you use this to reference the resource elsewhere)
- Block containing the resource properties

## Reference a resource

You can reference one resource from another:

```terraform
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-demo"
  location = "uksouth"
}

resource "azurerm_storage_account" "sa" {
  name                     = "sttfdemo${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
```

The storage account references the resource group using `azurerm_resource_group.rg.name` and `azurerm_resource_group.rg.location`. Terraform automatically understands the dependency.

## Use a data source

Data sources let you reference existing resources that Terraform doesn't manage. Use them when you need information about resources created outside Terraform:

```terraform
data "azurerm_resource_group" "existing" {
  name = "rg-existing"
}

resource "azurerm_storage_account" "sa" {
  name                     = "sttfdemo${random_string.suffix.result}"
  resource_group_name      = data.azurerm_resource_group.existing.name
  location                 = data.azurerm_resource_group.existing.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
```

The data source queries Azure for the existing resource group. You access its properties with `data.azurerm_resource_group.existing.name`.

## Find available properties

Every resource and data source has documented properties. Check the [Azure Provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) to see what's available.

For example, the [azurerm_resource_group data source](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) exposes properties like `name`, `location`, `tags`, and `id`.