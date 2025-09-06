# Importing Existing Azure Resources

## 📋 Overview

Learn how to bring existing Azure resources under Terraform management using the `terraform import` command and modern configuration generation techniques. This is essential when adopting Terraform in environments with pre-existing infrastructure.

## 🎯 Learning Objectives

By the end of this section, you will be able to:
- Understand when and why to import existing resources
- Use `terraform import` to bring resources under management
- Generate Terraform configuration from existing resources
- Plan and execute complex import strategies
- Handle import challenges and edge cases

## 📚 Prerequisites

- Completed sections 1-3 (Terraform Basics, Variables, State)
- Basic understanding of Azure CLI
- Access to existing Azure resources (or ability to create them for practice)

## 🔍 Understanding Terraform Import

### When to Use Import

- **Adopting Terraform** in environments with existing infrastructure
- **Migrating** from other infrastructure tools
- **Recovering** from state file loss or corruption
- **Integrating** manually created resources into Terraform workflows
- **Bringing compliance** to unmanaged resources

### Import Limitations

- **Configuration not generated automatically** (in older Terraform versions)
- **State only** - you must write matching configuration
- **No resource relationships** imported automatically
- **Complex resources** may require multiple import commands
- **Provider-specific considerations** for Azure resources

## 🛠️ Import Strategies

### 1. Single Resource Import

The basic import command structure:

```bash
terraform import [options] ADDRESS ID
```

**Example: Importing a Resource Group**

```bash
# Step 1: Create the configuration
cat > main.tf << EOF
resource "azurerm_resource_group" "imported" {
  name     = "existing-rg"
  location = "East US"
  
  tags = {
    Environment = "Production"
    Imported    = "true"
  }
}
EOF

# Step 2: Initialize Terraform
terraform init

# Step 3: Import the resource
terraform import azurerm_resource_group.imported /subscriptions/subscription-id/resourceGroups/existing-rg

# Step 4: Verify the import
terraform plan
```

### 2. Configuration Generation (Terraform 1.5+)

Modern Terraform can generate configuration during import:

```bash
# Generate configuration and import simultaneously
terraform plan -generate-config-out=generated.tf

# Review generated configuration
cat generated.tf

# Apply any necessary modifications
terraform apply
```

### 3. Bulk Import Strategy

For importing multiple resources systematically:

```bash
#!/bin/bash
# bulk-import.sh

# Array of resources to import
declare -a RESOURCES=(
    "azurerm_resource_group.rg1:/subscriptions/sub-id/resourceGroups/rg-prod-001"
    "azurerm_resource_group.rg2:/subscriptions/sub-id/resourceGroups/rg-prod-002"
    "azurerm_storage_account.sa1:/subscriptions/sub-id/resourceGroups/rg-prod-001/providers/Microsoft.Storage/storageAccounts/saprod001"
)

# Import each resource
for resource in "${RESOURCES[@]}"; do
    IFS=':' read -r tf_address azure_id <<< "$resource"
    echo "Importing $tf_address..."
    terraform import "$tf_address" "$azure_id"
done
```

## 🔧 Practical Examples

### Example 1: Importing a Storage Account

```hcl
# 1. First, create the basic configuration
resource "azurerm_storage_account" "imported_storage" {
  name                     = "existingstorageacct"
  resource_group_name      = "existing-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Add other required settings after examining existing resource
}
```

```bash
# 2. Get the resource ID
az storage account show --name existingstorageacct --resource-group existing-rg --query id -o tsv

# 3. Import the resource
terraform import azurerm_storage_account.imported_storage \
  /subscriptions/subscription-id/resourceGroups/existing-rg/providers/Microsoft.Storage/storageAccounts/existingstorageacct

# 4. Run plan to see differences
terraform plan
```

### Example 2: Importing with Data Sources

Sometimes it's better to reference existing resources via data sources:

```hcl
# Reference existing resources without importing
data "azurerm_resource_group" "existing" {
  name = "existing-rg"
}

data "azurerm_virtual_network" "existing" {
  name                = "existing-vnet"
  resource_group_name = data.azurerm_resource_group.existing.name
}

# Create new resources that depend on existing ones
resource "azurerm_subnet" "new_subnet" {
  name                 = "new-subnet"
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  address_prefixes     = ["10.0.3.0/24"]
}
```

### Example 3: Complex Resource Import

For complex resources like Virtual Machines:

```bash
# Import the VM
terraform import azurerm_linux_virtual_machine.imported_vm \
  /subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Compute/virtualMachines/vm-name

# Import associated resources
terraform import azurerm_network_interface.imported_nic \
  /subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Network/networkInterfaces/nic-name

terraform import azurerm_managed_disk.imported_disk \
  /subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Compute/disks/disk-name
```

## 🔍 Advanced Import Techniques

### 1. Import Blocks (Terraform 1.5+)

Use import blocks for more declarative imports:

```hcl
import {
  to = azurerm_resource_group.imported
  id = "/subscriptions/subscription-id/resourceGroups/existing-rg"
}

resource "azurerm_resource_group" "imported" {
  name     = "existing-rg"
  location = "East US"
}
```

### 2. State Manipulation

Sometimes you need to modify state after import:

```bash
# Move resources in state
terraform state mv azurerm_resource_group.old azurerm_resource_group.new

# Remove resources from state (without destroying)
terraform state rm azurerm_resource_group.unwanted

# Show current state
terraform state list
terraform state show azurerm_resource_group.imported
```

### 3. Handling Import Errors

Common issues and solutions:

```bash
# Provider version conflicts
terraform init -upgrade

# Resource already exists in state
terraform state rm resource.name
terraform import resource.name resource-id

# Configuration doesn't match existing resource
terraform plan  # Review differences
# Update configuration to match existing resource
```

## 📋 Import Planning Worksheet

Before starting a large import project:

### 1. Resource Inventory
```bash
# List all resources in a resource group
az resource list --resource-group "your-rg" --output table

# Get detailed resource information
az resource list --resource-group "your-rg" --output json > resources.json
```

### 2. Dependency Mapping
- Identify resource dependencies
- Plan import order (dependencies first)
- Consider using data sources for external dependencies

### 3. Configuration Strategy
- Decide on module structure
- Plan variable usage
- Consider existing naming conventions

### 4. Testing Approach
- Start with non-critical resources
- Test in development environment first
- Plan rollback strategy

## 🛠️ Practical Exercises

### Exercise 1: Basic Resource Import

1. Create a resource group manually in Azure Portal
2. Write Terraform configuration for it
3. Import the resource group
4. Verify the import with `terraform plan`

### Exercise 2: Storage Account Import

1. Create a storage account with specific settings
2. Import it into Terraform
3. Add additional configuration (tags, network rules)
4. Apply the changes

### Exercise 3: Complex Infrastructure Import

1. Create a small infrastructure manually (RG, VNet, Subnet, VM)
2. Plan the import strategy
3. Import all resources in the correct order
4. Refactor into modules

## ✅ Validation Checklist

- [ ] Successfully imported at least one resource
- [ ] Configuration matches existing resource properties
- [ ] `terraform plan` shows no unexpected changes
- [ ] Imported resources have appropriate tags
- [ ] Dependencies are correctly represented
- [ ] State file is clean and organized
- [ ] Documentation updated with import process

## 🎉 Summary

You've learned how to import existing Azure resources into Terraform:

- **Import command** usage and syntax
- **Configuration generation** for modern Terraform versions
- **Complex import strategies** for interconnected resources
- **State management** techniques
- **Best practices** for large-scale imports

## 🚀 Next Steps

Move on to **[Section 10: Modern Tooling and Workflows](../10-modern-tooling/)** to learn about contemporary Terraform development practices and productivity tools.

## 📚 Additional Resources

- [Terraform Import Documentation](https://www.terraform.io/docs/cli/import/index.html)
- [Azure Resource IDs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)
- [Azure CLI Resource Commands](https://docs.microsoft.com/en-us/cli/azure/resource)
- [Terraform State Management](https://www.terraform.io/docs/language/state/index.html)
- [Import Blocks](https://www.terraform.io/language/import)