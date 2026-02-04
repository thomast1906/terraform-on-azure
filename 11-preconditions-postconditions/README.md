# Use pre-conditions and post-conditions

Catch configuration errors early with lifecycle validation rules. Check inputs before creating resources and validate outputs after.

## What are conditions

Conditions validate assumptions about your infrastructure. They run during plan and apply operations.

Pre-conditions check inputs and dependencies before Terraform creates or modifies a resource.

Post-conditions verify outputs and resource state after Terraform creates or modifies a resource.

Both fail the operation immediately if validation fails.

## Why use conditions

- Catch errors in plan phase instead of during apply.
- Explain what's wrong and how to fix it with clear messages.
- Require specific configurations (tags, security settings, naming patterns).
- Check that Azure regions support features, SKUs are compatible, and resources exist.

## Pre-conditions

Pre-conditions validate inputs before creating resources.

### Basic pre-condition

Check that a variable meets requirements:

```terraform
variable "location" {
  type = string
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = var.location
  
  lifecycle {
    precondition {
      condition     = contains(["uksouth", "ukwest", "northeurope"], var.location)
      error_message = "Location must be uksouth, ukwest, or northeurope. Got: ${var.location}"
    }
  }
}
```

If you try to deploy with `location = "westus"`:

```
Error: Resource precondition failed

  on main.tf line 9, in resource "azurerm_resource_group" "example":
   9:       condition     = contains(["uksouth", "ukwest", "northeurope"], var.location)

Location must be uksouth, ukwest, or northeurope. Got: westus
```

Terraform stops before creating anything.

### Validate Azure region availability

Check that a region supports the service you're deploying:

```terraform
data "azurerm_locations" "available" {
  location = var.location
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "aks-example"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "aks-example"
  
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v5"
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  lifecycle {
    precondition {
      condition     = length(data.azurerm_locations.available.locations) > 0
      error_message = "AKS is not available in ${var.location}"
    }
  }
}
```

### Validate SKU compatibility

Check that VM size is available in the region:

```terraform
variable "vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}

variable "location" {
  type    = string
  default = "uksouth"
}

locals {
  # Map regions to supported VM sizes
  supported_vm_sizes = {
    uksouth = [
      "Standard_B2s",
      "Standard_D2s_v5",
      "Standard_D4s_v5"
    ]
    ukwest = [
      "Standard_B2s",
      "Standard_D2s_v5"
    ]
    northeurope = [
      "Standard_B2s",
      "Standard_D2s_v5",
      "Standard_D4s_v5",
      "Standard_E4s_v5"
    ]
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  size                = var.vm_size
  
  # ... other configuration
  
  lifecycle {
    precondition {
      condition = contains(
        local.supported_vm_sizes[var.location],
        var.vm_size
      )
      error_message = <<-EOT
        VM size ${var.vm_size} is not available in ${var.location}.
        Available sizes: ${join(", ", local.supported_vm_sizes[var.location])}
      EOT
    }
  }
}
```

### Validate environment tags

Require specific tags on all resources:

```terraform
variable "environment" {
  type = string
}

variable "cost_center" {
  type = string
}

resource "azurerm_storage_account" "example" {
  name                     = "stexample"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = {
    Environment = var.environment
    CostCenter  = var.cost_center
    ManagedBy   = "Terraform"
  }
  
  lifecycle {
    precondition {
      condition     = contains(["dev", "staging", "prod"], var.environment)
      error_message = "environment must be dev, staging, or prod. Got: ${var.environment}"
    }
    
    precondition {
      condition     = can(regex("^CC-[0-9]{4}$", var.cost_center))
      error_message = "cost_center must match pattern CC-XXXX (e.g., CC-1234). Got: ${var.cost_center}"
    }
  }
}
```

### Validate naming conventions

Enforce resource naming patterns:

```terraform
variable "resource_group_name" {
  type = string
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "uksouth"
  
  lifecycle {
    precondition {
      condition     = can(regex("^rg-[a-z0-9-]+$", var.resource_group_name))
      error_message = "Resource group name must start with 'rg-' and contain only lowercase letters, numbers, and hyphens. Got: ${var.resource_group_name}"
    }
    
    precondition {
      condition     = length(var.resource_group_name) <= 90
      error_message = "Resource group name must be 90 characters or less. Got: ${length(var.resource_group_name)} characters"
    }
  }
}
```

### Check dependencies exist

Verify that required resources are present:

```terraform
data "azurerm_key_vault" "existing" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

resource "azurerm_app_service" "example" {
  name                = "app-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
  
  lifecycle {
    precondition {
      condition     = data.azurerm_key_vault.existing.id != null
      error_message = "Key Vault ${var.key_vault_name} must exist in resource group ${var.key_vault_rg}"
    }
    
    precondition {
      condition     = data.azurerm_key_vault.existing.vault_uri != ""
      error_message = "Key Vault ${var.key_vault_name} must be properly configured"
    }
  }
}
```

## Post-conditions

Post-conditions validate resource state after Terraform creates or updates it.

### Verify resource was created

Check that Azure created the resource successfully:

```terraform
resource "azurerm_storage_account" "example" {
  name                     = "stexample${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  lifecycle {
    postcondition {
      condition     = self.id != ""
      error_message = "Storage account was not created successfully"
    }
    
    postcondition {
      condition     = self.primary_blob_endpoint != ""
      error_message = "Storage account blob endpoint was not configured"
    }
  }
}
```

### Validate security settings

Confirm security features are enabled:

```terraform
resource "azurerm_storage_account" "secure" {
  name                      = "stsecure${random_string.suffix.result}"
  resource_group_name       = azurerm_resource_group.example.name
  location                  = azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  
  lifecycle {
    postcondition {
      condition     = self.enable_https_traffic_only == true
      error_message = "HTTPS traffic enforcement failed to apply"
    }
    
    postcondition {
      condition     = self.min_tls_version == "TLS1_2"
      error_message = "TLS 1.2 requirement failed to apply"
    }
    
    postcondition {
      condition     = self.account_replication_type == "GRS"
      error_message = "Geo-redundant storage failed to apply"
    }
  }
}
```

### Verify outputs meet requirements

Check computed values:

```terraform
resource "azurerm_public_ip" "example" {
  name                = "pip-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  lifecycle {
    postcondition {
      condition     = self.ip_address != ""
      error_message = "Public IP address was not allocated"
    }
    
    postcondition {
      condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", self.ip_address))
      error_message = "Public IP address has invalid format: ${self.ip_address}"
    }
  }
}
```

## Multiple conditions

Add multiple validation rules:

```terraform
resource "azurerm_storage_account" "validated" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = var.location
  account_tier             = var.environment == "prod" ? "Premium" : "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  tags = {
    Environment = var.environment
    CostCenter  = var.cost_center
  }
  
  lifecycle {
    # Pre-conditions (check inputs)
    precondition {
      condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
      error_message = "Storage account name must be 3-24 characters. Got: ${length(var.storage_account_name)}"
    }
    
    precondition {
      condition     = can(regex("^[a-z0-9]+$", var.storage_account_name))
      error_message = "Storage account name must contain only lowercase letters and numbers. Got: ${var.storage_account_name}"
    }
    
    precondition {
      condition     = contains(["dev", "staging", "prod"], var.environment)
      error_message = "environment must be dev, staging, or prod. Got: ${var.environment}"
    }
    
    precondition {
      condition     = can(regex("^CC-[0-9]{4}$", var.cost_center))
      error_message = "cost_center must match CC-XXXX. Got: ${var.cost_center}"
    }
    
    # Post-conditions (verify result)
    postcondition {
      condition     = self.enable_https_traffic_only == true
      error_message = "HTTPS enforcement failed"
    }
    
    postcondition {
      condition     = self.min_tls_version == "TLS1_2"
      error_message = "TLS 1.2 requirement failed"
    }
    
    postcondition {
      condition     = self.primary_blob_endpoint != ""
      error_message = "Blob endpoint not configured"
    }
  }
}
```

## Conditions in outputs

Validate output values:

```terraform
output "storage_account_id" {
  value = azurerm_storage_account.example.id
  
  precondition {
    condition     = azurerm_storage_account.example.enable_https_traffic_only == true
    error_message = "Cannot output storage account ID: HTTPS not enforced"
  }
}

output "storage_connection_string" {
  value     = azurerm_storage_account.example.primary_connection_string
  sensitive = true
  
  precondition {
    condition     = azurerm_storage_account.example.min_tls_version == "TLS1_2"
    error_message = "Cannot output connection string: TLS 1.2 not configured"
  }
}
```

## Conditions in data sources

Validate data source lookups:

```terraform
data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
  
  lifecycle {
    postcondition {
      condition     = self.location == var.expected_location
      error_message = "Resource group is in ${self.location}, expected ${var.expected_location}"
    }
    
    postcondition {
      condition     = contains(keys(self.tags), "Environment")
      error_message = "Resource group missing required Environment tag"
    }
  }
}
```

## Complete Azure example

Full working example with validation:

```terraform
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod"
  }
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "cost_center" {
  type = string
}

variable "storage_name" {
  type = string
}

locals {
  # Approved regions for each environment
  approved_regions = {
    dev     = ["uksouth", "ukwest"]
    staging = ["uksouth", "northeurope"]
    prod    = ["northeurope", "westeurope"]
  }
  
  # Required tags
  required_tags = ["Environment", "CostCenter", "ManagedBy"]
}

resource "azurerm_resource_group" "validated" {
  name     = "rg-${var.environment}-validated"
  location = var.location
  
  tags = {
    Environment = var.environment
    CostCenter  = var.cost_center
    ManagedBy   = "Terraform"
  }
  
  lifecycle {
    precondition {
      condition = contains(
        local.approved_regions[var.environment],
        var.location
      )
      error_message = <<-EOT
        ${var.location} is not approved for ${var.environment}.
        Approved regions: ${join(", ", local.approved_regions[var.environment])}
      EOT
    }
    
    precondition {
      condition     = can(regex("^rg-[a-z0-9-]+$", "rg-${var.environment}-validated"))
      error_message = "Resource group name must follow naming convention: rg-{env}-{purpose}"
    }
    
    postcondition {
      condition     = self.id != ""
      error_message = "Resource group creation failed"
    }
  }
}

resource "azurerm_storage_account" "validated" {
  name                     = "${var.storage_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.validated.name
  location                 = azurerm_resource_group.validated.location
  account_tier             = var.environment == "prod" ? "Premium" : "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  tags = azurerm_resource_group.validated.tags
  
  lifecycle {
    precondition {
      condition     = length(var.storage_name) >= 3 && length(var.storage_name) <= 18
      error_message = "Storage name must be 3-18 characters (suffix will be added)"
    }
    
    precondition {
      condition     = can(regex("^[a-z0-9]+$", var.storage_name))
      error_message = "Storage name must contain only lowercase letters and numbers"
    }
    
    precondition {
      condition     = can(regex("^CC-[0-9]{4}$", var.cost_center))
      error_message = "Cost center must match CC-XXXX format"
    }
    
    postcondition {
      condition     = self.enable_https_traffic_only == true
      error_message = "HTTPS enforcement failed to apply"
    }
    
    postcondition {
      condition     = self.min_tls_version == "TLS1_2"
      error_message = "TLS 1.2 failed to apply"
    }
    
    postcondition {
      condition     = length(self.primary_blob_endpoint) > 0
      error_message = "Blob endpoint not created"
    }
  }
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

output "storage_account_id" {
  value = azurerm_storage_account.validated.id
  
  precondition {
    condition = alltrue([
      for tag in local.required_tags :
      contains(keys(azurerm_storage_account.validated.tags), tag)
    ])
    error_message = "Storage account missing required tags: ${join(", ", local.required_tags)}"
  }
}
```

## Try the examples

```bash
cd 11-preconditions-postconditions/examples
terraform init

# Try with valid values
terraform apply \
  -var="environment=dev" \
  -var="cost_center=CC-1234" \
  -var="storage_name=stvalid"

# Try with invalid environment (fails pre-condition)
terraform apply \
  -var="environment=test" \
  -var="cost_center=CC-1234" \
  -var="storage_name=stvalid"

# Try with invalid cost center (fails pre-condition)
terraform apply \
  -var="environment=dev" \
  -var="cost_center=INVALID" \
  -var="storage_name=stvalid"

# Try with invalid storage name (fails pre-condition)
terraform apply \
  -var="environment=dev" \
  -var="cost_center=CC-1234" \
  -var="storage_name=UPPERCASE"
```

## When to use conditions vs validation blocks

Use variable validation blocks to check individual variable values.

```terraform
variable "location" {
  type = string
  
  validation {
    condition     = contains(["uksouth", "ukwest"], var.location)
    error_message = "Invalid location"
  }
}
```

Use pre-conditions to validate relationships between resources, check dependencies, and enforce complex rules.

```terraform
resource "azurerm_resource_group" "example" {
  # ...
  
  lifecycle {
    precondition {
      condition = contains(
        local.approved_regions[var.environment],
        var.location
      )
      error_message = "Region not approved for environment"
    }
  }
}
```

Use both for broader validation.

## Best practices

- Write clear error messages that explain the fix.
- Use pre-conditions to catch errors in plan phase.
- Focus on critical requirements so validation stays maintainable.
- Use locals for complex logic to keep condition expressions readable.
- Add comments explaining why validations exist.
- Run `terraform plan` with invalid inputs to verify error messages.
- Combine variable validation blocks for simple checks and conditions for complex logic.
