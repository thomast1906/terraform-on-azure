# Terraform Count

In this section we will look at the count parameter in Terraform. This is a very useful parameter that allows you to create multiple resources of the same type. This is useful for creating multiple VMs, multiple NICs, multiple disks etc.

## Terraform Count - pros

- Allows you to create multiple resources in a single resource block

## Terraform Count - cons

- Requires additional configuration
- Sometimes you need to use the `count.index` to reference the correct resource, this can be confusing and sometimes not recommended. It is worth adding this section, but I do much prefer using `depends_on` if you can

## Terraform Count - example

In this example, we will be creating a resource group in Azure. We will be using the `count` parameter to create multiple resource groups.

### Terraform Count - example - variables.tf

Creating variable files is a best practice, this allows you to keep all of your variables in one place.

Variable `resource_group_names` is of type `list(string)` and has a default value of `["tamopsrg", "tamopsrg2"]`.

```terraform

variable "resource_group_names" {
  type = list(string)
  default = ["tamopsrg", "tamopsrg2"]
}

```

### Terraform Count - example - main.tf

In this example, we are creating a resource group. We are using the count parameter to create multiple resource groups.

```terraform

resource "azurerm_resource_group" "rg" {
  count    = length(var.resource_group_names)
  name     = var.resource_group_names[count.index]
  location = "uksouth"
}

```

### Terraform Count - example - output.tf

In this example, we are creating an output. We are using the count parameter to create multiple outputs.

```terraform

output "resource_group_names" {
  value = azurerm_resource_group.rg[*].name
}

```

### Terraform Count - example - output

```bash

Outputs:

resource_group_names = [
  "tamopsrg",
  "tamopsrg2",
]

```

### Terraform Count - example - output second resource group

```terraform

output "resource_group_names" {
  value = azurerm_resource_group.rg[1].name
}

```

### Terraform Count - example - output second resource group

```bash

Outputs:

resource_group_names = "tamopsrg2"

```

### Run example

You can now run the example found in this section.

Run Terraform from [here](https://github.com/thomast1906/terraform-on-azure/tree/main/4-terraform-advanced/3-count/terraform)