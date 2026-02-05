# Create multiple resources with count

The `count` argument creates multiple identical resources. Use it when you need a specific number of instances.

## count basics

```terraform
resource "azurerm_resource_group" "example" {
  count = 3
  
  name     = "rg-demo-${count.index}"
  location = "uksouth"
  
  tags = {
    Index = count.index
  }
}
```

`count.index` is the current iteration (0, 1, 2).

This creates:
- `rg-demo-0`
- `rg-demo-1`
- `rg-demo-2`

## Use with variables

```terraform
variable "instance_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 3
}

resource "azurerm_linux_virtual_machine" "example" {
  count = var.instance_count
  
  name                = "vm-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B2s"
  
  # ... other configuration
}
```

## Reference specific instances

Access a specific resource by index:

```terraform
# Reference the first VM
output "first_vm_id" {
  value = azurerm_linux_virtual_machine.example[0].id
}

# Reference the last VM
output "last_vm_id" {
  value = azurerm_linux_virtual_machine.example[var.instance_count - 1].id
}
```

## Use with lists

```terraform
variable "locations" {
  description = "Azure regions"
  type        = list(string)
  default     = ["uksouth", "ukwest", "northeurope"]
}

resource "azurerm_resource_group" "example" {
  count = length(var.locations)
  
  name     = "rg-${var.locations[count.index]}"
  location = var.locations[count.index]
}
```

## Output all resources

```terraform
output "resource_group_names" {
  description = "Names of all resource groups"
  value       = azurerm_resource_group.example[*].name
}

output "resource_group_ids" {
  description = "IDs of all resource groups"
  value       = azurerm_resource_group.example[*].id
}
```

The `[*]` splat expression returns all values.

## Conditional count

Use `count` for conditional resource creation:

```terraform
variable "create_backup" {
  description = "Whether to create backup resources"
  type        = bool
  default     = false
}

resource "azurerm_backup_vault" "example" {
  count = var.create_backup ? 1 : 0
  
  name                = "bv-demo"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
}
```

When `create_backup` is `false`, Terraform creates zero backup vaults.

## Limitations

**Don't remove items from the middle of a count list.** Terraform identifies resources by index. Removing index 1 causes all subsequent resources to shift:

```terraform
# Before: 3 VMs (0, 1, 2)
count = 3

# After removing one: Terraform destroys VM-2 and recreates VM-1
count = 2
```

Terraform thinks:
- Index 0: no change
- Index 1: changed (was VM-1, now VM-2)
- Index 2: deleted

This destroys your VM-2.

Use `for_each` when you might add or remove instances.

## Try it yourself

```bash
cd 12-advanced-count/examples/terraform
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```