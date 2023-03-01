# Terraform Dynamic Blocks

## Introduction

Dynamic blocks are a new feature in Terraform 0.12 that allow you to create dynamic blocks of configuration within your Terraform configuration files. This is useful when you want to create a block of configuration that is repeated multiple times, but with different values for each instance.

## Terraform Dynamic Blocks - pros

- Allows you to create multiple resources in a single resource block

## Terraform Dynamic Blocks - cons

- Requires additional configuration

## Terraform Dynamic Blocks - example

In this example, we will be creating a resource group in Azure. We will be using the `dynamic` argument to create multiple resource groups.

### Terraform Dynamic Blocks - example - variables.tf

Creating variable files is a best practice, this allows you to keep all of your variables in one place.

Variable `resource_group_names` is of type `list(string)` and has a default value of `["tamopsrg", "tamopsrg2"]`.

```terraform

variable "resource_group_names" {
  type = list(string)
  default = ["tamopsrg", "tamopsrg2"]
}

```

### Terraform Dynamic Blocks - example - main.tf

In this example, we are creating a resource group. We are using the dynamic argument to create multiple resource groups.

```terraform

resource "azurerm_resource_group" "rg" {
  dynamic "name" {
    for_each = var.resource_group_names
    content {
      name     = name.value
      location = "uksouth"
    }
  }
}

```

### Run example

You can now run the example found in this section.

Run Terraform from [here](https://github.com/thomast1906/terraform-on-azure/tree/main/4-terraform-advanced/5-dynamic-blocks/terraform)