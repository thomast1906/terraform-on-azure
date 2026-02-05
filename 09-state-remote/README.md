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

Destroy the resource:

```bash
terraform destroy
```

The state file remains in Azure Storage but shows zero resources.

## Delete the storage account

When you're done, delete the storage account:

```bash
cd ../scripts
./2-delete-terraform-storage.sh
```

Update the script variables to match your resource group name before running.

## Key takeaways

- Remote state enables team collaboration
- Azure Storage provides state locking automatically
- State files are encrypted and backed up
- Blob versioning gives you state history
- Use remote state for any shared or production infrastructure
