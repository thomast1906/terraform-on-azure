# Import existing Azure resources

You can bring existing Azure resources under Terraform management without recreating them. This lets you adopt Terraform gradually.

## Why import resources

Common scenarios:
- Migrating manually created resources to Terraform
- Adopting Terraform in an existing Azure environment
- Managing resources created by other tools
- Recovering from state file loss

## Import basics

Importing requires two steps:
1. Write the resource configuration in Terraform
2. Run `terraform import` to link the resource to your state

## Import a resource group

### 1. Find the resource ID

```bash
az group show --name rg-existing --query id --output tsv
```

Output:
```
/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing
```

### 2. Write the configuration

Create `main.tf`:

```terraform
resource "azurerm_resource_group" "imported" {
  name     = "rg-existing"
  location = "uksouth"
}
```

### 3. Import the resource

```bash
terraform import azurerm_resource_group.imported /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing
```

Terraform adds the resource to state without modifying Azure.

### 4. Verify the import

```bash
terraform plan
```

If the plan shows no changes, your configuration matches the existing resource. If it shows changes, update your configuration to match:

```bash
terraform show
```

This displays the current state. Copy values to your configuration.

## Import a storage account

### 1. Get the resource ID

```bash
az storage account show --name stexisting --resource-group rg-existing --query id --output tsv
```

### 2. Write the configuration

```terraform
resource "azurerm_storage_account" "imported" {
  name                     = "stexisting"
  resource_group_name      = "rg-existing"
  location                 = "uksouth"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

### 3. Import

```bash
terraform import azurerm_storage_account.imported /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Storage/storageAccounts/stexisting
```

### 4. Match configuration

Run `terraform plan`. Terraform shows differences:

```
  ~ account_replication_type = "GRS" -> "LRS"
  + enable_https_traffic_only = true
  + min_tls_version = "TLS1_2"
```

Update your configuration to match the actual resource:

```terraform
resource "azurerm_storage_account" "imported" {
  name                      = "stexisting"
  resource_group_name       = "rg-existing"
  location                  = "uksouth"
  account_tier              = "Standard"
  account_replication_type  = "GRS"  # Match actual value
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
}
```

Run `terraform plan` again. It should show no changes.

## Import blocks (Terraform 1.5+)

Terraform 1.5 introduced import blocks that generate configuration automatically.

### 1. Write an import block

Create `imports.tf`:

```terraform
import {
  to = azurerm_resource_group.imported
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing"
}
```

### 2. Generate configuration

```bash
terraform plan -generate-config-out=generated.tf
```

Terraform creates `generated.tf` with the resource configuration:

```terraform
resource "azurerm_resource_group" "imported" {
  location = "uksouth"
  name     = "rg-existing"
  tags     = {}
}
```

### 3. Apply the import

```bash
terraform apply
```

Terraform imports the resource and updates state.

### 4. Clean up

Move the generated configuration to your main files and delete `imports.tf`.

## Import multiple resources

Create multiple import blocks:

```terraform
import {
  to = azurerm_resource_group.app
  id = "/subscriptions/.../resourceGroups/rg-app"
}

import {
  to = azurerm_storage_account.data
  id = "/subscriptions/.../resourceGroups/rg-app/providers/Microsoft.Storage/storageAccounts/stdata"
}

import {
  to = azurerm_key_vault.secrets
  id = "/subscriptions/.../resourceGroups/rg-app/providers/Microsoft.KeyVault/vaults/kv-secrets"
}
```

Generate all configurations:

```bash
terraform plan -generate-config-out=imported.tf
```

## Find resource IDs

### Azure CLI

```bash
# Resource group
az group show --name <name> --query id -o tsv

# Storage account
az storage account show --name <name> --resource-group <rg> --query id -o tsv

# Key Vault
az keyvault show --name <name> --query id -o tsv

# Virtual network
az network vnet show --name <name> --resource-group <rg> --query id -o tsv

# Any resource (if you know the type)
az resource show --name <name> --resource-group <rg> --resource-type <type> --query id -o tsv
```

### Azure Portal

1. Navigate to the resource
2. Click "JSON View" in the Overview
3. Copy the "Resource ID" field

### Resource ID format

Azure resource IDs follow this pattern:

```
/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/{provider}/{type}/{name}
```

Example:
```
/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-prod/providers/Microsoft.Network/virtualNetworks/vnet-prod
```

## Import child resources

Some resources have child resources:

```terraform
# Import VNet
terraform import azurerm_virtual_network.example /subscriptions/.../resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet

# Import subnet (child of VNet)
terraform import azurerm_subnet.example /subscriptions/.../resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet1
```

Import parent resources before children.

## Common issues

### Configuration doesn't match

After import, `terraform plan` shows changes. You need to update your configuration to match the actual resource.

Use `terraform show` to see the imported values, then copy them to your configuration file.

### Resource already in state

Error: "Resource already managed by Terraform"

The resource is already in your state file. Check with:

```bash
terraform state list
```

Remove it if needed:

```bash
terraform state rm azurerm_resource_group.example
```

### Wrong resource ID

Error: "Cannot import: invalid ID"

Verify the resource ID format. Each resource type expects a specific format. Check the provider documentation.

## Import workflow script

Automate importing multiple resources:

```bash
#!/bin/bash

# List of resource IDs to import
resources=(
  "azurerm_resource_group.app:/subscriptions/.../resourceGroups/rg-app"
  "azurerm_storage_account.data:/subscriptions/.../storageAccounts/stdata"
  "azurerm_key_vault.secrets:/subscriptions/.../vaults/kv-secrets"
)

for resource in "${resources[@]}"; do
  IFS=: read -r tf_address azure_id <<< "$resource"
  echo "Importing $tf_address..."
  terraform import "$tf_address" "$azure_id"
done

echo "Import complete. Run 'terraform plan' to verify."
```

## Best practices

**Start small:** Import one resource at a time until you understand the process.

**Verify with plan:** Always run `terraform plan` after import to check for differences.

**Use import blocks:** For Terraform 1.5+, import blocks with `-generate-config-out` save time.

**Document imports:** Keep a list of imported resources and their IDs.

**Test destroy:** After import, test that `terraform destroy` works without errors (in a dev environment).

**Import dependencies together:** If resources reference each other, import them in dependency order.

## Try it yourself

1. Create a resource group manually in Azure Portal
2. Write a matching Terraform configuration
3. Import the resource group
4. Verify with `terraform plan`
5. Test with `terraform destroy` (optional)

Check the [Azure Provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) for resource-specific import formats.
