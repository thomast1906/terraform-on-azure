# Terraform Variables - Complete Guide

Variables are the foundation of flexible, reusable Terraform configurations. This comprehensive guide covers everything from basic variable declarations to advanced validation patterns and best practices.

## 🎯 Learning Objectives

By completing this section, you will learn how to:
- **Declare and use** different types of Terraform variables
- **Implement** variable validation for robust configurations
- **Organize** variables effectively in your projects
- **Apply** variable precedence and scoping rules
- **Use** environment-specific configurations
- **Follow** naming conventions and documentation standards

## 📋 Prerequisites

- Completed [Section 1: Terraform Basics](../1-terraform-basics/)
- Understanding of HCL syntax and Terraform resources
- Terraform installed and Azure CLI configured

## 🔧 Variable Fundamentals

### Basic Variable Declaration

Variables in Terraform are declared using `variable` blocks with optional configuration:

```hcl
# Basic variable
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

# Required variable (no default)
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

# Complex type variable
variable "allowed_ips" {
  description = "List of allowed IP addresses"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12"]
}
```

### Variable Types

Terraform supports several built-in types:

**Primitive Types:**
```hcl
variable "instance_count" {
  type = number
  default = 2
}

variable "enable_monitoring" {
  type = bool
  default = true
}

variable "application_name" {
  type = string
  default = "myapp"
}
```

**Collection Types:**
```hcl
# List of strings
variable "availability_zones" {
  type = list(string)
  default = ["eastus-1", "eastus-2", "eastus-3"]
}

# Map of strings
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "terraform-learning"
    ManagedBy   = "terraform"
  }
}
```

## ✅ Variable Validation

Modern Terraform supports validation rules to ensure variables meet specific criteria:

### Basic Validation

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}
```

### Advanced Validation Examples

```hcl
# Validate Azure region
variable "location" {
  description = "Azure region"
  type        = string
  
  validation {
    condition = contains([
      "eastus", "eastus2", "westus", "westus2", "centralus",
      "northeurope", "westeurope", "uksouth", "ukwest"
    ], lower(replace(var.location, " ", "")))
    error_message = "Location must be a valid Azure region."
  }
}

# Validate resource naming convention
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  
  validation {
    condition     = can(regex("^rg-[a-z0-9-]+$", var.resource_group_name))
    error_message = "Resource group name must start with 'rg-' and contain only lowercase letters, numbers, and hyphens."
  }
  
  validation {
    condition     = length(var.resource_group_name) >= 5 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 5 and 90 characters."
  }
}
```

## 🔄 Using Variables in Resources

### Basic Usage

```hcl
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}-${var.application_name}"
  location = var.location
  tags     = var.resource_tags
}

resource "azurerm_storage_account" "main" {
  name                     = "st${var.environment}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  
  tags = merge(var.resource_tags, {
    Purpose = "Application Storage"
  })
}
```

## 🎯 Practical Exercise

Create a complete variable configuration for a web application:

### Step 1: Create variables.tf

```hcl
variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "application_name" {
  description = "Name of the application"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.application_name))
    error_message = "Application name must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}
```

### Step 2: Test the Configuration

```bash
# Validate syntax
terraform validate

# Plan with different environments
terraform plan -var="environment=dev" -var="application_name=myapp"
terraform plan -var="environment=prod" -var="application_name=myapp"
```

## 💡 Best Practices Summary

- **Always include descriptions** for all variables
- **Use validation rules** to catch errors early
- **Group related variables** logically in files
- **Use consistent naming conventions** (snake_case recommended)
- **Provide sensible defaults** where appropriate
- **Document complex types** with examples
- **Use locals** for computed values and complex expressions
- **Separate environment-specific** values into .tfvars files

## 🔗 What's Next?

Continue your learning journey with:
- [Section 3: Terraform State Management](../3-terraform-state/) - Learn about local vs remote state
- [Variable file examples](./2-terraform-tfvars.md) - Working with .tfvars files
- [Local variables](./3-terraform-local-variables.md) - Computed values and expressions

---

*Variables are the key to creating flexible, reusable Terraform configurations. Master them, and you'll build infrastructure that adapts to any environment!* 🚀


