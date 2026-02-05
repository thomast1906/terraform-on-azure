# Use variables

Variables make your Terraform configurations reusable. Instead of hardcoding values, you define them once and reference them everywhere.

## Define a variable

Create `variables.tf`:

```terraform
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-terraform-demo"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "uksouth"
}

variable "environment" {
  description = "Environment name"
  type        = string
}
```

Each variable has:
- A name (e.g., `resource_group_name`)
- An optional type (`string`, `number`, `bool`, `list`, `map`)
- An optional description
- An optional default value

## Use variables in your configuration

Reference variables with `var.variable_name`:

```terraform
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
  
  tags = {
    Environment = var.environment
  }
}
```

## Set variable values

You have several options for setting variables without defaults:

### Command line

```bash
terraform apply -var="environment=dev"
```

### Environment variables

```bash
export TF_VAR_environment="dev"
terraform apply
```

### Variable files

Create `terraform.tfvars`:

```terraform
environment = "dev"
```

Terraform automatically loads `terraform.tfvars`. For other file names, use the `-var-file` flag:

```bash
terraform apply -var-file="dev.tfvars"
```

## Variable types

Use specific types for validation:

```terraform
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 3
}

variable "allowed_locations" {
  description = "List of allowed Azure regions"
  type        = list(string)
  default     = ["uksouth", "ukwest", "northeurope"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    ManagedBy = "Terraform"
    Project   = "Demo"
  }
}
```

## Add validation

Validate input values:

```terraform
variable "location" {
  description = "Azure region for resources"
  type        = string
  
  validation {
    condition     = contains(["uksouth", "ukwest", "northeurope"], var.location)
    error_message = "Location must be uksouth, ukwest, or northeurope."
  }
}
```

## Mark variables as sensitive

Prevent sensitive values from appearing in logs:

```terraform
variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
}
```

Terraform masks this value in output and logs.


