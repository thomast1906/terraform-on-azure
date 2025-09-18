# Example: Importing an Existing Azure Resource Group

This example demonstrates how to import an existing Azure resource group into Terraform state.

## Prerequisites

- Existing Azure resource group (or create one for this example)
- Azure CLI authenticated
- Terraform installed

## Quick Start

```bash
# Make the import script executable and run it
chmod +x import.sh
./import.sh
```

## Manual Steps

### Step 1: Create an Existing Resource Group (if needed)

```bash
# Create a resource group outside of Terraform
az group create --name "existing-resource-group" --location "East US"
```

### Step 2: Import the Resource

```bash
# Initialize Terraform
terraform init

# Get the resource ID and import
RESOURCE_ID=$(az group show --name "existing-resource-group" --query id --output tsv)
terraform import azurerm_resource_group.imported $RESOURCE_ID
```

### Step 3: Validate and Apply

```bash
# Check for differences and apply if needed
terraform plan
terraform apply
```

## Files in this Example

- `main.tf` - Terraform configuration for the resource group
- `import.sh` - Automated import script
- `README.md` - This documentation