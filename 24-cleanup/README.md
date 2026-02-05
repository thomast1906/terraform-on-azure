# Cleanup Resources

After completing the course, clean up all Azure resources to avoid unnecessary charges. This lesson provides scripts and commands to remove everything created throughout the tutorials.

## What was created during the course

Throughout the course, you created:

**Storage Infrastructure (Lesson 9)**:
- Resource group: `rg-terraform-state`
- Storage account: `sttfstate<random>` (unique name)
- Multiple containers: `tfstate`, `dependson`, `foreach`, `count`, `conditional`, `dynamicblocks`, `keyvault`, `modules`, `azapi`

**Demo Resource Groups** (Lessons 8-17):
- `rg-demo-local` (Lesson 8: Local state)
- `rg-demo` (Lesson 9: Remote state)
- `rg-demo-depends` (Lesson 10: Dependencies)
- `rg-demo-foreach` (Lesson 11: For Each)
- `rg-demo-count` (Lesson 12: Count)
- `rg-demo-conditional` (Lesson 13: Conditionals)
- `rg-demo-dynamic` (Lesson 14: Dynamic blocks)
- `rg-demo-keyvault` (Lesson 15: Key Vault)
- `rg-demo-modules` (Lesson 16: Modules)
- `rg-demo-azapi` (Lesson 17: AzAPI)

**Additional Resources**:
- Storage accounts (within demo resource groups)
- Key Vault instances with secrets and RBAC assignments
- Azure Container Registry instances
- Virtual networks and subnets
- Network security groups with rules
- Various test resources from lessons 18-23

## Automated cleanup script

Use the provided script to check for and delete all course-related resources.

### Step 1: Review what exists

First, see what resources remain in your subscription:

```bash
cd 24-cleanup/scripts
chmod +x cleanup-all-resources.sh
./cleanup-all-resources.sh --check
```

This lists all resource groups matching the course naming patterns without deleting anything.

### Step 2: Run cleanup

After reviewing the list, run the full cleanup:

```bash
./cleanup-all-resources.sh --delete
```

The script:
- Lists all course-related resource groups
- Asks for confirmation before deletion
- Deletes each resource group and its contents
- Removes the Terraform state storage account
- Displays a summary of deleted resources

**Warning**: This permanently deletes all resources. Make sure you don't need any of them before proceeding.

## Manual cleanup

If you prefer manual cleanup or need to selectively remove resources, use these commands.

### Check for demo resource groups

```bash
az group list --query "[?starts_with(name, 'rg-demo')].{Name:name, Location:location}" --output table
```

### Delete individual resource groups

```bash
az group delete --name rg-demo-local --yes --no-wait
az group delete --name rg-demo --yes --no-wait
az group delete --name rg-demo-depends --yes --no-wait
az group delete --name rg-demo-foreach --yes --no-wait
az group delete --name rg-demo-count --yes --no-wait
az group delete --name rg-demo-conditional --yes --no-wait
az group delete --name rg-demo-dynamic --yes --no-wait
az group delete --name rg-demo-keyvault --yes --no-wait
az group delete --name rg-demo-modules --yes --no-wait
az group delete --name rg-demo-azapi --yes --no-wait
```

The `--no-wait` flag allows deletions to run in parallel, speeding up cleanup.

### Check deletion status

```bash
az group list --query "[?starts_with(name, 'rg-demo')].{Name:name, ProvisioningState:properties.provisioningState}" --output table
```

### Delete the Terraform state storage

**Delete this last** after all other resources are removed:

```bash
az group delete --name rg-terraform-state --yes
```

This removes:
- The storage account
- All state containers
- All state files
- The resource group itself

## Using Terraform destroy

Alternatively, navigate to each lesson's example directory and run `terraform destroy`:

```bash
# Lesson 8 - Local State
cd 08-state-local/examples/local-state-example
terraform destroy

# Lesson 9 - Remote State
cd ../../../09-state-remote/examples/remote-state-example
terraform destroy

# Lesson 10 - Dependencies
cd ../../../10-advanced-dependencies/examples/terraform
terraform destroy

# Continue for each lesson...
```

This approach:
- Ensures Terraform properly removes all dependencies
- Updates state files to reflect the deletion
- May take longer than direct Azure CLI deletion
- Useful if you want to preserve state files for reference

## Verify complete cleanup

After cleanup, verify no course resources remain:

```bash
# Check for any remaining demo resource groups
az group list --query "[?starts_with(name, 'rg-demo') || starts_with(name, 'rg-terraform-state')].name" --output table

# Check for storage accounts with course pattern (if you used custom names)
az storage account list --query "[?starts_with(name, 'sttfstate')].{Name:name, ResourceGroup:resourceGroup}" --output table

# List all resource groups (review for any missed resources)
az group list --output table
```

If the commands return no results, cleanup is complete.

## Troubleshooting

### Resource group deletion fails

Some resources have dependencies that prevent deletion:

```bash
# Get detailed error
az group delete --name rg-demo-keyvault --yes --verbose
```

**Key Vault with purge protection**: Key Vaults with purge protection enabled (lesson 15) need special handling:

```bash
# List deleted vaults
az keyvault list-deleted --query "[].{Name:name, Location:properties.location, DeletionDate:properties.deletionDate}" --output table

# Purge the vault (allows resource group deletion)
az keyvault purge --name kv-demo-abc12345 --location uksouth
```

**Storage account soft delete**: Storage accounts may have soft-deleted containers:

```bash
# Disable soft delete before deletion
az storage account blob-service-properties update \
  --account-name sttfstate12345 \
  --resource-group rg-terraform-state \
  --enable-container-delete-retention-policy false
```

### Cannot authenticate

If `az` commands fail with authentication errors:

```bash
# Re-authenticate
az login

# Verify correct subscription
az account show
az account set --subscription "Your Subscription Name"
```

## Cost considerations

Keeping resources running incurs charges:

**Storage Account**: ~$0.02-0.05 per GB per month
**Key Vault**: ~$0.03 per 10,000 operations
**Container Registry**: ~$5/month (Basic tier)
**Virtual Networks**: Usually free, but public IPs cost ~$3-4/month

Delete resources promptly after completing the course to avoid unnecessary costs.

## Best practices for future projects

When working on real projects:

**Use naming conventions**: Consistent names like `rg-project-environment` make bulk operations easier

**Tag resources**: Add tags to identify project, owner, and cost center:

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rg-production"
  location = "uksouth"
  
  tags = {
    Environment = "Production"
    Project     = "MyApp"
    ManagedBy   = "Terraform"
    Owner       = "ops-team@company.com"
  }
}
```

**Use workspaces or separate state files**: Isolate development, staging, and production

**Enable resource locks**: Prevent accidental deletion of production resources:

```bash
az lock create --name DoNotDelete \
  --lock-type CanNotDelete \
  --resource-group rg-production
```

**Document cleanup procedures**: Maintain runbooks for removing environments

## Summary

You've completed the Terraform on Azure course and cleaned up all resources. Key takeaways:

- Always clean up demo and test resources to control costs
- Use consistent naming for easier bulk operations
- State storage should be deleted last
- Resource dependencies matter during cleanup
- Terraform destroy vs Azure CLI deletion each have trade-offs

Thank you for completing the course!
