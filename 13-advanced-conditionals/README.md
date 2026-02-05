# Use conditional expressions

Conditional expressions let you make decisions in your Terraform configuration. They use the format: `condition ? true_value : false_value`

## Basic conditionals

```terraform
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-demo"
  location = var.environment == "prod" ? "northeurope" : "uksouth"
  
  tags = {
    Environment = var.environment
    CostCenter  = var.environment == "prod" ? "Production" : "Development"
  }
}
```

Production resources deploy to North Europe. Everything else goes to UK South.

## Conditional resource creation

Create resources only when needed:

```terraform
variable "enable_backup" {
  description = "Enable backup vault"
  type        = bool
  default     = false
}

resource "azurerm_data_protection_backup_vault" "example" {
  count = var.enable_backup ? 1 : 0
  
  name                = "bv-demo"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
}
```

When `enable_backup` is `false`, count is 0 and Terraform creates nothing.

## Choose SKUs by environment

```terraform
variable "environment" {
  type    = string
  default = "dev"
}

locals {
  # Use smaller SKUs in non-prod
  vm_size = var.environment == "prod" ? "Standard_D4s_v5" : "Standard_B2s"
  
  storage_replication = var.environment == "prod" ? "GRS" : "LRS"
  
  database_sku = var.environment == "prod" ? "GP_Gen5_4" : "GP_Gen5_2"
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm-demo"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = local.vm_size
  
  # ... other configuration
}
```

## Nested conditionals

```terraform
locals {
  # Chain conditions for complex logic
  vm_size = (
    var.environment == "prod" ? "Standard_D4s_v5" :
    var.environment == "staging" ? "Standard_D2s_v5" :
    "Standard_B2s"
  )
}
```

## Conditional properties

Some resources require different configurations per environment:

```terraform
resource "azurerm_storage_account" "example" {
  name                     = "stdemo${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  
  # Enable advanced threat protection in prod
  enable_https_traffic_only = true
  min_tls_version          = var.environment == "prod" ? "TLS1_2" : "TLS1_0"
  
  tags = {
    Environment = var.environment
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
```

## Validate with conditionals

Use conditionals in validation rules:

```terraform
variable "environment" {
  description = "Environment name"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  
  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}
```

## Try it yourself

```bash
cd 13-advanced-conditionals/examples/conditional-expressions-example
terraform init
terraform validate
terraform plan
terraform apply -var="environment=prod"
terraform destroy
```