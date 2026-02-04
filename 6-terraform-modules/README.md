# Build reusable modules

Modules package Terraform configurations into reusable components. Instead of copying resources, you create a module once and use it everywhere.

## Why use modules

You'll deploy similar infrastructure repeatedly:\n- Multiple environments (dev, staging, prod)\n- Multiple projects with common patterns\n- Standard resource configurations\n\nModules eliminate duplication and enforce standards.

## Module structure

A module is a directory with Terraform files:

```
modules/
└── storage-account/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## Create a module

Create `modules/storage-account/main.tf`:

```terraform
resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  tags = var.tags
}
```

Create `modules/storage-account/variables.tf`:

```terraform
variable "name" {
  description = "Storage account name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Replication type"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
```

Create `modules/storage-account/outputs.tf`:

```terraform
output "id" {
  description = "Storage account ID"
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Storage account name"
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}
```

## Use the module

In your root `main.tf`:

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rg-demo"
  location = "uksouth"
}

module "storage_dev" {
  source = "./modules/storage-account"
  
  name                = "stdev${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  replication_type    = "LRS"
  
  tags = {
    Environment = "Development"
  }
}

module "storage_prod" {
  source = "./modules/storage-account"
  
  name                = "stprod${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  replication_type    = "GRS"  # Geo-redundant for production
  
  tags = {
    Environment = "Production"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
```

## Access module outputs

```terraform
output "dev_storage_id" {
  value = module.storage_dev.id
}

output "prod_storage_endpoint" {
  value = module.storage_prod.primary_blob_endpoint
}
```

## Use public modules

The Terraform Registry has thousands of public modules:

```terraform
module "network" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"
  
  resource_group_name = azurerm_resource_group.example.name
  vnet_location       = azurerm_resource_group.example.location
  vnet_name           = "vnet-demo"
  address_space       = ["10.0.0.0/16"]
  
  subnet_names     = ["subnet-web", "subnet-data"]
  subnet_prefixes  = ["10.0.1.0/24", "10.0.2.0/24"]
}
```

Always specify a version to avoid unexpected changes.

## Build a complete module

Here's a more realistic module for an Azure Container Registry:

`modules/acr/main.tf`:

```terraform
resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  
  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
  
  tags = var.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  count = length(var.pull_role_principal_ids)
  
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = var.pull_role_principal_ids[count.index]
}
```

`modules/acr/variables.tf`:

```terraform
variable "name" {
  description = "ACR name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "ACR SKU"
  type        = string
  default     = "Basic"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Enable admin user"
  type        = bool
  default     = false
}

variable "identity_enabled" {
  description = "Enable managed identity"
  type        = bool
  default     = false
}

variable "pull_role_principal_ids" {
  description = "Principal IDs to grant AcrPull role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
```

`modules/acr/outputs.tf`:

```terraform
output "id" {
  description = "ACR ID"
  value       = azurerm_container_registry.this.id
}

output "name" {
  description = "ACR name"
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "ACR login server"
  value       = azurerm_container_registry.this.login_server
}

output "admin_username" {
  description = "ACR admin username"
  value       = azurerm_container_registry.this.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "ACR admin password"
  value       = azurerm_container_registry.this.admin_password
  sensitive   = true
}
```

## Try it yourself

```bash
cd 6-terraform-modules/terraform
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Module best practices

- Keep modules focused on one purpose
- Use meaningful variable names and descriptions
- Add validation rules to variables
- Document all inputs and outputs
- Version your modules when sharing
- Test modules before using in production
- Don't over-abstract—simple is better
