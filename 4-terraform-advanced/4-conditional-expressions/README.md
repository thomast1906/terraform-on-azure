# Terraform Conditions 

In this section we will look at how to use conditions in Terraform.

## Terraform Conditions - pros

- Allows you to control the order in which resources are created

## Terraform Conditions - cons

- Requires additional configuration

## Terraform Conditions - example

A conditional expression uses the value of a boolean expression to select one of two values.

In this example, we will be creating a resource group in Azure. We will be using a conditional expression to control the order in which resources are created.

### Terraform Conditions - example - variables.tf

Creating variable files is a best practice, this allows you to keep all of your variables in one place.

Variable `resource_group_name` is of type `string` and has a default value of `tamopsrg`.

```terraform

variable "resource_group_name" {
  type = string
  default = "tamopsrg"
}

variable "create_resource_group" {
  type = bool
  default = false
}

```


### Terraform Conditions - example - main.tf

In this example, we are creating a resource group and a storage account. We are using a conditional expression to determine whether or not to create the resource group.

1 returns true, 0 returns false.

Change the value of `create_resource_group` to `true` to create the resource group.

```terraform

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "uksouth"
}

resource "azurerm_storage_account" "sa" {
  count                    = var.create_resource_group ? 1 : 0
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

Run Terraform from [here](https://github.com/thomast1906/terraform-on-azure/tree/main/4-terraform-advanced/4-conditional-expressions/terraform)