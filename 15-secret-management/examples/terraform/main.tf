data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "uksouth"
}

resource "azurerm_key_vault" "kv" {
  name                       = "tamopskv"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  # Use RBAC for access control (recommended in azurerm 4.0+)
  rbac_authorization_enabled = true
}

# Assign Key Vault Secrets Officer role
resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "sa" {
  name         = "saname"
  value        = "tamopsstoragekv"
  key_vault_id = azurerm_key_vault.kv.id
  
  depends_on = [azurerm_role_assignment.kv_secrets_officer]
}

data "azurerm_key_vault_secret" "sa" {
  name         = "saname"
  key_vault_id = azurerm_key_vault.kv.id
  
  depends_on = [azurerm_key_vault_secret.sa]
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