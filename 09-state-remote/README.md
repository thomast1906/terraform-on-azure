# Deploy with remote state

Remote state stores your state file in Azure Storage. This enables team collaboration and provides state locking to prevent conflicts.

## Create the storage account

You need an Azure Storage Account to hold your state file. Run the provided script:

```bash
cd 09-state-remote/scripts
chmod +x 1-create-terraform-storage.sh
```

Edit the variables at the top of `1-create-terraform-storage.sh`:

```bash
RESOURCE_GROUP_NAME="rg-terraform-state"
STORAGE_ACCOUNT_NAME="sttfstate${RANDOM}"
```

Run the script:

```bash
./1-create-terraform-storage.sh
```

The script creates:
- An Azure resource group
- An Azure storage account with a unique name
- A blob container named `tfstate`
- Blob versioning enabled for state history

The script outputs the values you'll need for your backend configuration.

> **Important**: Keep this storage account! You will use it throughout the remaining lessons in this course. Every example from lesson 10 onwards references this same storage account for remote state. Do not delete it until you've completed all lessons.

## Configure remote backend

Navigate to the remote state example:

```bash
cd ./examples/remote-state-example
```

Check `providers.tf`. Update it with your storage account details:

```terraform
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstate12345"  # Use your storage account name
    container_name       = "tfstate"
    key                  = "demo.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
```

The `backend "azurerm"` block tells Terraform where to store state remotely.

## Initialize with remote backend

```bash
terraform init
```

Terraform configures the Azure backend:

```
Initializing the backend...

Successfully configured the backend "azurerm"!
```

## Deploy the resource

Check the configuration in `main.tf`:

```terraform
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-remote-state"
  location = "uksouth"
}
```

Validate and plan:

```bash
terraform validate
terraform plan
```

Apply:

```bash
terraform apply
```

Type `yes` when prompted.

## Verify remote state

After applying, check the storage account. Your state file now exists in Azure:

```bash
az storage blob list \
  --account-name sttfstate12345 \
  --container-name tfstate \
  --output table
```

You'll see `demo.terraform.tfstate` in the container.

View it in the [Azure Portal](https://portal.azure.com) under Storage Account > Containers > tfstate.

## Test state locking

Remote state includes automatic state locking. Try running two `terraform apply` commands simultaneously from different terminals:

Terminal 1:
```bash
terraform apply
```

Terminal 2 (while first is still running):
```bash
terraform apply
```

The second command waits or fails with a lock error. This prevents concurrent modifications that could corrupt state.

## Clean up

To clean up the demo resource group created in this lesson:

```bash
terraform destroy
```

The state file remains in Azure Storage but shows zero resources.

> **Note**: Do NOT delete the storage account yet if you plan to continue with the remaining lessons. See the "Reusing the Storage Account" section below.

## Reusing the storage account

**Keep your storage account for the rest of the course.** All subsequent lessons (10-17) use this same storage account for remote state.

Each lesson uses a different container name within the same storage account:
- Lesson 10 (Dependencies): `dependson`
- Lesson 11 (For Each): `foreach`
- Lesson 12 (Count): `count`
- Lesson 13 (Conditionals): `conditional`
- Lesson 14 (Dynamic Blocks): `dynamicblocks`
- Lesson 15 (Secret Management): `keyvault`
- Lesson 16 (Modules): `modules`
- Lesson 17 (AzAPI): `azapi`

This approach:
- Demonstrates real-world usage where teams share a single state storage account
- Keeps costs minimal by using one storage account
- Organizes state files logically by container
- Shows how multiple projects can coexist in the same backend

Update the `storage_account_name` in each lesson's `providers.tf` file with your actual storage account name created in this lesson.

## Final cleanup

When you've completed all lessons in the course, delete the storage account:

```bash
cd scripts
./2-delete-terraform-storage.sh
```

Update the script variables to match your resource group name before running.

This removes:
- The storage account
- All state containers and files
- The `rg-terraform-state` resource group

## Key takeaways

- Remote state enables team collaboration
- Azure Storage provides state locking automatically
- State files are encrypted and backed up
- Blob versioning gives you state history
- Use remote state for any shared or production infrastructure
