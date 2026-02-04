# Manage Terraform state

Terraform state commands let you inspect, modify, and troubleshoot your state file. These commands are essential when refactoring or fixing issues.

## List resources in state

Show all resources Terraform manages:

```bash
terraform state list
```

Output:
```
azurerm_resource_group.example
azurerm_storage_account.data
azurerm_key_vault.secrets
```

Filter resources:

```bash
terraform state list azurerm_storage_account.*
```

## Show resource details

View a resource's state:

```bash
terraform state show azurerm_storage_account.data
```

Output shows all attributes Terraform tracks:

```hcl
resource "azurerm_storage_account" "data" {
    id                       = "/subscriptions/.../storageAccounts/stdata"
    name                     = "stdata"
    resource_group_name      = "rg-prod"
    location                 = "uksouth"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    # ... more attributes
}
```

## Move resources with terraform state mv

Use `terraform state mv` to rename resources or move them between modules without recreating them in Azure.

### Rename a resource

You refactored code and renamed a resource:

```terraform
# Old
resource "azurerm_storage_account" "data" {
  # ...
}

# New
resource "azurerm_storage_account" "primary_data" {
  # ...
}
```

Without `state mv`, Terraform destroys the old resource and creates a new one. Instead:

```bash
terraform state mv azurerm_storage_account.data azurerm_storage_account.primary_data
```

Now `terraform plan` shows no changes.

### Move resources between modules

You extracted resources into a module:

Before:
```terraform
resource "azurerm_storage_account" "data" {
  name = "stdata"
  # ...
}
```

After:
```terraform
module "storage" {
  source = "./modules/storage"
  # ...
}
```

Move the resource:

```bash
terraform state mv azurerm_storage_account.data module.storage.azurerm_storage_account.data
```

### Move resources out of modules

The reverse works too:

```bash
terraform state mv module.storage.azurerm_storage_account.data azurerm_storage_account.data
```

### Move resources between workspaces

Move a resource from dev to prod workspace:

```bash
# Export from dev
terraform workspace select dev
terraform state pull > dev_state.json

# Import to prod
terraform workspace select prod
terraform state mv \
  -state=dev_state.json \
  -state-out=terraform.tfstate \
  azurerm_storage_account.data \
  azurerm_storage_account.data
```

### Move multiple resources

Move all resources from a module:

```bash
# List resources in module
terraform state list | grep "module.old_module"

# Move each one
terraform state mv module.old_module.azurerm_resource_group.example module.new_module.azurerm_resource_group.example
terraform state mv module.old_module.azurerm_storage_account.data module.new_module.azurerm_storage_account.data
```

## Remove resources from state

Remove a resource from state without destroying it in Azure:

```bash
terraform state rm azurerm_storage_account.data
```

The storage account continues running in Azure, but Terraform no longer manages it.

Use cases:
- Handing off management to another Terraform workspace
- Removing accidentally imported resources
- Splitting infrastructure across multiple state files

## Replace a resource

Force recreation of a specific resource:

```bash
terraform apply -replace=azurerm_linux_virtual_machine.example
```

This destroys and recreates the VM even if the configuration hasn't changed. Useful for:
- Fixing corrupted resources
- Applying changes that require recreation
- Testing disaster recovery

## Pull and push state

### Pull state to a file

```bash
terraform state pull > backup.tfstate
```

Use this to:
- Back up state before major changes
- Inspect state manually
- Debug state issues

### Push state from a file

```bash
terraform state push backup.tfstate
```

**Dangerous:** Only use this for disaster recovery. Pushing incorrect state causes Terraform to lose track of resources.

## Common scenarios

### Scenario 1: Rename resource type

You changed a resource type:

```terraform
# Old
resource "azurerm_sql_database" "example" {
  # ...
}

# New
resource "azurerm_mssql_database" "example" {
  # ...
}
```

Move it:

```bash
terraform state mv azurerm_sql_database.example azurerm_mssql_database.example
```

### Scenario 2: Split a resource group

You split one resource group into two:

```terraform
# Old
resource "azurerm_resource_group" "all" {
  name = "rg-all"
}

# New
resource "azurerm_resource_group" "web" {
  name = "rg-web"
}

resource "azurerm_resource_group" "data" {
  name = "rg-data"
}
```

You created `rg-web` and `rg-data` manually in Azure. Import them:

```bash
terraform import azurerm_resource_group.web /subscriptions/.../resourceGroups/rg-web
terraform import azurerm_resource_group.data /subscriptions/.../resourceGroups/rg-data
```

Remove the old one:

```bash
terraform state rm azurerm_resource_group.all
```

Then delete `rg-all` in Azure manually or with `az group delete`.

### Scenario 3: Extract to a module

You're converting resources to a module.

Before:
```terraform
resource "azurerm_virtual_network" "example" {
  name                = "vnet-prod"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "subnet-web"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

After creating the module:
```terraform
module "network" {
  source = "./modules/network"
  
  name                = "vnet-prod"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}
```

Move resources:

```bash
terraform state mv azurerm_virtual_network.example module.network.azurerm_virtual_network.this
terraform state mv azurerm_subnet.example module.network.azurerm_subnet.this
```

## Best practices

**Back up before moving:** Always run `terraform state pull > backup.tfstate` before state operations.

**Use version control:** Commit working state before refactoring. You can revert if something breaks.

**Plan after moving:** Always run `terraform plan` after state commands. It should show no changes.

**Test in dev first:** Practice state operations in a dev environment before touching production.

**Avoid manual edits:** Never edit state files directly. Use state commands.

**Document moves:** Keep notes on why you moved resources, especially in production.

## Dangerous operations

These commands can break your infrastructure:

**terraform state push:** Overwrites remote state. Use only for disaster recovery.

**terraform state rm:** Removes resources from Terraform without destroying them. Easy to lose track of resources.

**Editing state files manually:** Causes state corruption. Always use state commands.

## Recovery

If you break state:

1. **Restore from backup:**
   ```bash
   terraform state push backup.tfstate
   ```

2. **If using remote state with versioning:**
   Check your Azure Storage Account blob versions and restore a previous version.

3. **Re-import resources:**
   If state is gone but resources exist, re-import them:
   ```bash
   terraform import azurerm_resource_group.example /subscriptions/.../resourceGroups/rg-example
   ```

## Try it yourself

```bash
cd 10-state-management-commands/examples
terraform init
terraform apply

# List resources
terraform state list

# Show details
terraform state show azurerm_resource_group.example

# Rename a resource
terraform state mv azurerm_storage_account.data azurerm_storage_account.primary

# Verify
terraform plan  # Should show no changes

# Clean up
terraform destroy
```

## Next steps

Master state management to refactor Terraform confidently. Combined with modules (section 6) and imports (section 10), you can reorganize any Terraform codebase without downtime.
