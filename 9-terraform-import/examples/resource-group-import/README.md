# Example: Importing an Existing Azure Resource Group

This example demonstrates how to import an existing Azure resource group into Terraform state using modern import blocks (Terraform >= 1.5).

## Prerequisites

- Existing Azure resource group (or create one for this example)
- Azure CLI authenticated  
- Terraform >= 1.5 installed

## Method 1: Using Import Blocks (Recommended)

### Step 1: Create an Existing Resource Group (if needed)

```bash
# Create a resource group outside of Terraform
az group create --name "existing-resource-group" --location "East US"
```

### Step 2: Create Terraform Configuration with Import Block

Create the following files in this directory:

**main.tf**
```hcl
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

provider "azurerm" {
  features {}
}

# Import block - this tells Terraform what to import
import {
  to = azurerm_resource_group.imported
  id = "/subscriptions/{subscription-id}/resourceGroups/existing-resource-group"
}

# Resource configuration
resource "azurerm_resource_group" "imported" {
  name     = "existing-resource-group"
  location = "East US"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    ImportedOn  = "2024-01-01"
  }
}
```

### Step 3: Plan and Apply the Import

```bash
# Initialize Terraform
terraform init

# Plan to see what will be imported
terraform plan

# Apply to perform the import
terraform apply
```

### Step 4: Remove Import Block and Validate

After successful import, remove the import block from main.tf:

```hcl
# Remove this block after import
# import {
#   to = azurerm_resource_group.imported
#   id = "/subscriptions/{subscription-id}/resourceGroups/existing-resource-group"
# }

# Keep the resource configuration
resource "azurerm_resource_group" "imported" {
  name     = "existing-resource-group"
  location = "East US"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform" 
    ImportedOn  = "2024-01-01"
  }
}
```

```bash
# Validate that Terraform can manage the resource
terraform plan
```

## Method 2: Legacy Import Command (Still Supported)

### Step 1: Create Configuration Without Import Block

```hcl
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "imported" {
  name     = "existing-resource-group"
  location = "East US"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

### Step 2: Import Using CLI Command

```bash
# Initialize Terraform
terraform init

# Get the resource ID and import
RESOURCE_ID=$(az group show --name "existing-resource-group" --query id --output tsv)
terraform import azurerm_resource_group.imported $RESOURCE_ID

# Verify the import
terraform show
```

### Step 3: Validate and Apply

```bash
# Check for differences and apply if needed
terraform plan
terraform apply
```

## Cleanup (Optional)

```bash
# If this was just for testing, clean up
terraform destroy

# Verify the resource is deleted
az group show --name "existing-resource-group" || echo "Resource group successfully deleted"
```

## Troubleshooting

### Common Issues

1. **Resource ID Format Error**
   ```bash
   # Wrong: terraform import azurerm_resource_group.imported "existing-resource-group"
   # Correct: Use full resource ID
   terraform import azurerm_resource_group.imported "/subscriptions/{subscription-id}/resourceGroups/existing-resource-group"
   ```

2. **Configuration Mismatch**
   - Run `terraform show` after import to see actual configuration
   - Match your Terraform configuration to the imported resource's current state

3. **Authentication Issues**
   ```bash
   # Verify Azure CLI authentication
   az account show
   az account list-locations --output table
   ```

## Files in this Example

- `main.tf` - Terraform configuration with import block
- `README.md` - This documentation