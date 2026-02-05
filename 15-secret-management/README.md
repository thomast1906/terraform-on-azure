# Manage secrets with Azure Key Vault

Store sensitive values in Azure Key Vault instead of putting them directly in your Terraform code. This keeps secrets secure and auditable.

## Why use Key Vault

Don't hardcode secrets:

```terraform
# DON'T DO THIS
resource "azurerm_linux_virtual_machine" "example" {
  admin_password = "SuperSecret123!"  # Exposed in code and state
}
```

Use Key Vault instead. Secrets stay encrypted, access is logged, and you can rotate values without changing code.

## Create a Key Vault

```terraform
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "rg-keyvault-demo"
  location = "uksouth"
}

resource "azurerm_key_vault" "example" {
  name                       = "kv-demo-${random_string.suffix.result}"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  # Use RBAC for access control (recommended)
  enable_rbac_authorization = true
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
```

## Grant yourself access

Assign the Key Vault Secrets Officer role:

```terraform
resource "azurerm_role_assignment" "example" {
  scope                = azurerm_key_vault.example.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
```

## Store a secret

```terraform
resource "azurerm_key_vault_secret" "db_password" {
  name         = "database-password"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.example.id
  
  depends_on = [azurerm_role_assignment.example]
}

resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
```

## Read a secret

```terraform
data "azurerm_key_vault_secret" "db_password" {
  name         = "database-password"
  key_vault_id = azurerm_key_vault.example.id
  
  depends_on = [azurerm_key_vault_secret.db_password]
}

resource "azurerm_mysql_flexible_server" "example" {
  name                   = "mysql-demo"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = "adminuser"
  administrator_password = data.azurerm_key_vault_secret.db_password.value
  sku_name               = "B_Standard_B1s"
  version                = "8.0.21"
}
```

## Use existing secrets

Reference secrets from an existing Key Vault:

```terraform
data "azurerm_key_vault" "existing" {
  name                = "kv-prod"
  resource_group_name = "rg-shared"
}

data "azurerm_key_vault_secret" "api_key" {
  name         = "api-key"
  key_vault_id = data.azurerm_key_vault.existing.id
}

resource "azurerm_app_configuration_key" "example" {
  configuration_store_id = azurerm_app_configuration.example.id
  key                    = "ApiKey"
  value                  = data.azurerm_key_vault_secret.api_key.value
}
```

## Mark outputs as sensitive

Prevent secrets from appearing in logs:

```terraform
output "database_password" {
  value     = data.azurerm_key_vault_secret.db_password.value
  sensitive = true
}
```

Terraform hides the value in output:

```
Outputs:

database_password = <sensitive>
```

## Store certificates

```terraform
resource "azurerm_key_vault_certificate" "example" {
  name         = "app-cert"
  key_vault_id = azurerm_key_vault.example.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=example.com"
      validity_in_months = 12
    }
  }
  
  depends_on = [azurerm_role_assignment.example]
}
```

## Try it yourself

```bash
cd 15-secret-management/examples/terraform
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Best practices

- Enable purge protection in production
- Use RBAC instead of access policies
- Store Terraform state remotely (see section 3)
- Mark secret variables as sensitive
- Rotate secrets regularly
- Audit Key Vault access logs
