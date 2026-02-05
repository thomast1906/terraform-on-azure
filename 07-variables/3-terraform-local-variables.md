# Use local values

Local values let you compute values once and reuse them throughout your configuration. Use locals for transformations, computations, or values derived from other variables.

## Define locals

Create a `locals` block in your configuration:

```terraform
locals {
  resource_suffix      = "${var.environment}-${var.location}"
  common_tags = {
    ManagedBy   = "Terraform"
    Environment = var.environment
    Location    = var.location
  }
}
```

## Use locals in resources

Reference locals with `local.name`:

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rg-${local.resource_suffix}"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "example" {
  name                     = "st${replace(local.resource_suffix, "-", "")}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags
}
```

## Locals vs variables

Variables are inputs from users. Locals are computed values internal to your configuration.

Use variables when:
- Values come from outside (user input, tfvars files, environment variables)
- You want to parameterize your configuration

Use locals when:
- You're computing or transforming values
- You want to avoid repeating the same expression
- You're building complex values from multiple sources

## Common patterns

### Conditional values

```terraform
locals {
  # Use smaller SKUs in dev
  vm_size = var.environment == "production" ? "Standard_D4s_v5" : "Standard_B2s"
}
```

### String manipulation

```terraform
locals {
  # Storage account names can't have hyphens
  storage_name = lower(replace(var.resource_group_name, "-", ""))
}
```

### Merging tags

```terraform
locals {
  default_tags = {
    ManagedBy = "Terraform"
    Project   = "Demo"
  }
  
  # Merge default tags with user-provided tags
  all_tags = merge(local.default_tags, var.tags)
}
```

### Building resource names

```terraform
locals {
  # Consistent naming across resources
  prefix = "${var.project}-${var.environment}"
  
  resource_group_name  = "rg-${local.prefix}"
  storage_account_name = "st${replace(local.prefix, "-", "")}"
  key_vault_name       = "kv-${local.prefix}"
}
```

## Complete example

`variables.tf`:
```terraform
variable "project" {
  description = "Project name"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}
```

`main.tf`:
```terraform
locals {
  prefix = "${var.project}-${var.environment}"
  
  common_tags = {
    ManagedBy   = "Terraform"
    Project     = var.project
    Environment = var.environment
  }
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${local.prefix}"
  location = var.location
  tags     = local.common_tags
}
```

`dev.tfvars`:
```terraform
environment = "dev"
```

Deploy:
```bash
terraform apply -var-file="dev.tfvars"
```

This creates `rg-myapp-dev` with consistent tags across all resources.