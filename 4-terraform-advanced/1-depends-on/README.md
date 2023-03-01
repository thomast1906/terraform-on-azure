# Terraform Depends On
[]: # 
[]: # A guide on how to use

In this section we will be looking at the depends_on argument in Terraform.

## Terraform Depends On - pros

- Allows you to control the order in which resources are created

## Terraform Depends On - cons

- Requires additional configuration

## Terraform Depends On - example

In this example, we will be creating a resource group in Azure. We will be using the `depends_on` argument to control the order in which resources are created.

### Terraform Depends On - example - variables.tf

Creating variable files is a best practice, this allows you to keep all of your variables in one place.

Variable `resource_group_name` is of type `string` and has a default value of `tamopsrg`.

```terraform

variable "resource_group_name" {
  type = string
  default = "tamopsrg"
}

```

### Terraform Depends On - example - main.tf

In this example, we are creating a resource group and a storage account. We are using the depends_on argument to control the order in which resources are created.

```terraform

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "uksouth"
}

resource "azurerm_storage_account" "sa" {
  name                     = "tamopsstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [
    azurerm_resource_group.rg
  ]
}

```

### Run example

You can now run the example found in this section.

Run Terraform from [here](https://github.com/thomast1906/terraform-on-azure/tree/main/4-terraform-advanced/1-depends-on/terraform)
