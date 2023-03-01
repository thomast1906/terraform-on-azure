# Terraform For Each
[]: # 
[]: # A guide on how to use

In this section we will be looking at the for_each argument in Terraform.

## Terraform For Each - pros

- Allows you to create multiple resources in a single resource block
- Allows you to create multiple resources in a single resource block

## Terraform For Each - cons

- Requires additional configuration

## Terraform For Each - example

In this example, we will be creating a resource group in Azure. We will be using the `for_each` argument to create multiple resource groups.

### Terraform For Each - example - variables.tf

Creating variable files is a best practice, this allows you to keep all of your variables in one place.

Variable `resource_group_names` is of type `list(string)` and has a default value of `["tamopsrg", "tamopsrg2"]`.

```terraform

variable "resource_group_names" {
  type = list(string)
  default = ["tamopsrg", "tamopsrg2"]
}

```

### Terraform For Each - example - main.tf

In this example, we are creating a resource group. We are using the for_each argument to create multiple resource groups.

```terraform

resource "azurerm_resource_group" "rg" {
  for_each = toset(var.resource_group_names)
  name     = each.key
  location = "uksouth"
}

```

### Terraform For Each - example - output.tf

In this example, we are creating an output. We are using the for_each argument to create multiple outputs.

```terraform

output "resource_group_names" {
  value = azurerm_resource_group.rg[*].name
}

```

### Terraform For Each - example - output

```bash

Outputs:

resource_group_names = [
  "tamopsrg",
  "tamopsrg2",
]

```

## Terraform For Each - further reading

- [Terraform for_each](https://www.terraform.io/docs/language/meta-arguments/for_each.html)

### Run example

You can now run the example found in this section.

Run Terraform from [here](https://github.com/thomast1906/terraform-on-azure/tree/main/4-terraform-advanced/2-for-each/terraform)
