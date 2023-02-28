# Terraform Resources

The primary deployments of Terraform is doing using one or more resources. They are the most commonly used component within Terraform. Each resource block will destroy at least one Azure resource. Resource blocks include virtual machines, virtual networks, resource groups etc.

## Resource example

The below contains a resource called `rg` that uses the terraform resource `azurerm_resource_group` to create an Azure Resource Group called `tamops` in region `UK South`

```terraform
resource "azurerm_resource_group" "rg" {
  name     = "tamops"
  location = "UK South"
}
```

Read further on resource usage [here](https://developer.hashicorp.com/terraform/language/resources/syntax)

## Data source example

If the above Azure Resource Group `tamops` has already been created previously or within another Terraform deployment, utilising the Data source - you can make reference to the resource group.

The below references the data resource `azurerm_resource_group` `rg` to deploy Azure Storage Account `tamopsstorage` into.
- notice the reference of `resource_group_name` & `location` is using the data reference of Resource Group?

```terraform
data "azurerm_resource_group" "rg" {
  name = "tamops"
}

resource "azurerm_storage_account" "sa" {
  name                     = "tamopsstorage"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
}
```

Each resource and data resource has various outputs available, [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group.html#attributes-reference) shows the outputs available for the above data resource.