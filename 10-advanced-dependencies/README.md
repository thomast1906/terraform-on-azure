# Control resource dependencies

Terraform automatically determines resource dependencies from references. Use `depends_on` only when Terraform can't detect dependencies automatically.

## When to use depends_on

Terraform infers dependencies from resource references:

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rg-demo"
  location = "uksouth"
}

resource "azurerm_storage_account" "example" {
  name                     = "stdemo${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.example.name  # Terraform knows to create RG first
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
```

Terraform creates the resource group first because the storage account references it.

Use `depends_on` when:
- A resource relies on another resource's side effects
- Dependencies aren't expressed through references
- You need to control creation order for resources that don't directly reference each other

## Example: Role assignment timing

Role assignments take time to propagate. Use `depends_on` to ensure permissions exist before using them:

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rg-demo"
  location = "uksouth"
}

resource "azurerm_user_assigned_identity" "example" {
  name                = "id-demo"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_resource_group.example.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}

resource "azurerm_container_group" "example" {
  name                = "aci-demo"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"
  }

  # Wait for role assignment to propagate
  depends_on = [azurerm_role_assignment.example]
}
```

The container group needs the role assignment to complete before it starts.

## Example: Module outputs

Use `depends_on` when a module's side effects matter:

```terraform
module "network" {
  source = "./modules/network"
  
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

module "compute" {
  source = "./modules/compute"
  
  subnet_id = module.network.subnet_id
  
  # Ensure network security rules are fully applied
  depends_on = [module.network]
}
```

## Try it yourself

Navigate to the example:

```bash
cd 10-advanced-dependencies/examples/terraform
```

Deploy:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Clean up:

```bash
terraform destroy
```
