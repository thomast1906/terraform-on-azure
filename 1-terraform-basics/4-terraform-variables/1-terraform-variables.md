# Terraform Variables

Terraform Variables are a way to pass information into Terraform, this can be done in a number of ways, but the most common is to use a `variables.tf` file.

## Terraform Variables - pros

- Allows you to pass information into Terraform
- Allows you to reuse the same Terraform configuration with different values

## Terraform Variables - cons

- Requires additional configuration

## Terraform Variables - example

In this example, we will be creating a resource group in Azure. We will be using a variable to pass the name of the resource group into Terraform.

### Terraform Variables - example - variables.tf

Creating variable files is a best practice, this allows you to keep all of your variables in one place.

Variable `resource_group_name` is of type `string` and has a default value of `tamopsrg`.

```terraform

variable "resource_group_name" {
  type = string
  default = "tamopsrg"
}

```

### Terraform Variables - example - main.tf

As below, we are using the variable `resource_group_name` to pass the value `tamopsrg` to the resource `azurerm_resource_group`.

```terraform

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "uksouth"
}

```
