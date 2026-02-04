# Create multiple resources with for_each

The `for_each` argument creates multiple instances of a resource. Use it when you need several similar resources with different configurations.

## for_each basics

`for_each` accepts a map or set:

```terraform
resource "azurerm_resource_group" "example" {
  for_each = toset(["dev", "staging", "prod"])
  
  name     = "rg-${each.key}"
  location = "uksouth"
  
  tags = {
    Environment = each.key
  }
}
```

Inside the resource:
- `each.key` is the current element
- `each.value` is the value (same as key for sets)

## Using maps for complex configurations

Maps let you specify different properties per resource:

```terraform
variable "environments" {
  description = "Environment configurations"
  type = map(object({
    location = string
    sku      = string
  }))
  default = {
    dev = {
      location = "uksouth"
      sku      = "Standard_B2s"
    }
    staging = {
      location = "ukwest"
      sku      = "Standard_D2s_v5"
    }
    prod = {
      location = "northeurope"
      sku      = "Standard_D4s_v5"
    }
  }
}

resource "azurerm_resource_group" "example" {
  for_each = var.environments
  
  name     = "rg-${each.key}"
  location = each.value.location
  
  tags = {
    Environment = each.key
  }
}
```

## Reference specific instances

Access created resources by their key:

```terraform
resource "azurerm_storage_account" "example" {
  name                     = "stdemo${each.key}"
  resource_group_name      = azurerm_resource_group.example["prod"].name  # Reference prod RG
  location                 = azurerm_resource_group.example["prod"].location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
```

## Create related resources

```terraform
resource "azurerm_resource_group" "example" {
  for_each = toset(["dev", "staging", "prod"])
  
  name     = "rg-${each.key}"
  location = "uksouth"
}

resource "azurerm_storage_account" "example" {
  for_each = azurerm_resource_group.example
  
  name                     = "st${each.key}${random_string.suffix.result}"
  resource_group_name      = each.value.name
  location                 = each.value.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
```

## Output all resources

```terraform
output "resource_group_ids" {
  description = "Map of environment names to resource group IDs"
  value       = { for k, rg in azurerm_resource_group.example : k => rg.id }
}
```

## for_each vs count

Use `for_each` when:
- Each instance has a meaningful identifier
- You might add or remove instances
- Resources aren't identical

Use `count` when:
- You need a specific number of identical resources
- Order matters
- Resources are truly identical

Prefer `for_each` in most cases. It handles resource changes better.

## Try it yourself

```bash
cd 4-terraform-advanced/2-for-each/terraform
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```
