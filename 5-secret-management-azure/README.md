# Terraform secret management in Azure

Deploying resources in Azure, you will often need to pass sensitive information to the resources. This could be a password, a certificate or a key. In this tutorial, we will look at how to manage secrets in Terraform using an Azure Key Vault.

## Terraform secret management in Azure - pros

- Recommended for storing sensitive information
- Recommended for storing information that is not to be shared

## Terraform secret management in Azure - cons

- Requires additional configuration

## Terraform secret management in Azure - example

In this example, we will be creating a resource group in Azure. We will be using an Azure Key Vault to store the name of the storage account.

### Terraform secret management - example - variables.tf

Variable `resource_group_name` is of type `string` and has a default value of `tamopsrg`.

```terraform

variable "resource_group_name" {
  type = string
  default = "tamopsrg"
}

```

### Terraform secret management in Azure - example - main.tf

Storage Account name is stored in a Key Vault. The Key Vault is created in the same Terraform configuration. The Key Vault is created with an access policy that allows the current user to get the secret. The secret is then used to create the storage account.

```terraform

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "uksouth"
}

resource "azurerm_key_vault" "kv" {
  name                = "tamopskv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]
  }
}

resource "azurerm_key_vault_secret" "sa" {
  name         = "saname"
  value        = "tamopsstoragekv"
  key_vault_id = azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "sa" {
  name         = "saname"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_secret.sa
  ]
}

resource "azurerm_storage_account" "sa" {
  name                     = data.azurerm_key_vault_secret.sa.value
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [
    azurerm_resource_group.rg
  ]
}

```

Notice the use of data keyvault secret to get the secret from the Key Vault to be used as name of the storage account.

```terraform
data "azurerm_key_vault_secret" "sa" {
  name         = "saname"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_secret.sa
  ]
}

resource "azurerm_storage_account" "sa" {
  name                     = data.azurerm_key_vault_secret.sa.value
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [
    azurerm_resource_group.rg
  ]
}

```

### Run example

You can now run the example found in this section.

Run Terraform from [here](https://github.com/thomast1906/terraform-on-azure/tree/main/5-secret-management-azure/terraform)