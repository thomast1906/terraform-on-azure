# Use the AzAPI provider

The AzAPI provider lets you use any Azure resource type on day one, even before the AzureRM provider adds support.

## Why use AzAPI

Azure releases new services constantly. The AzureRM provider lags behind because each resource needs coding, testing, and documentation. AzAPI works immediately because it calls Azure Resource Manager APIs directly.

Use AzAPI when:
- You need a brand new Azure service
- AzureRM doesn't support a specific property
- You need a preview API version

## Configure the provider

Add the AzAPI provider to `providers.tf`:

```terraform
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.1"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}
```

## Create a resource

AzAPI uses JSON for resource configuration:

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rg-azapi-demo"
  location = "uksouth"
}

resource "azapi_resource" "acr" {
  type      = "Microsoft.ContainerRegistry/registries@2023-07-01"
  name      = "acrdemo${random_string.suffix.result}"
  parent_id = azurerm_resource_group.example.id
  location  = azurerm_resource_group.example.location
  
  body = {
    sku = {
      name = "Standard"
    }
    properties = {
      adminUserEnabled = false
      publicNetworkAccess = "Enabled"
    }
  }
  
  tags = {
    Environment = "Demo"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
```

The `type` field specifies:
- Resource type: `Microsoft.ContainerRegistry/registries`
- API version: `@2023-07-01`

## Find API versions

Check Azure documentation for resource types and API versions:

- [Azure Resource Manager REST API](https://learn.microsoft.com/en-us/rest/api/azure/)
- Use `az provider show` to list API versions:

```bash
az provider show --namespace Microsoft.ContainerRegistry --query "resourceTypes[?resourceType=='registries'].apiVersions"
```

## Mix AzAPI with AzureRM

Use AzureRM for stable resources and AzAPI for new features:

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rg-mixed-demo"
  location = "uksouth"
}

# Use AzureRM for VNet (stable)
resource "azurerm_virtual_network" "example" {
  name                = "vnet-demo"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

# Use AzAPI for preview features
resource "azapi_resource" "bastion" {
  type      = "Microsoft.Network/bastionHosts@2024-01-01"
  name      = "bastion-demo"
  parent_id = azurerm_resource_group.example.id
  location  = azurerm_resource_group.example.location
  
  body = {
    properties = {
      dnsName = "bastion-demo"
      ipConfigurations = [
        {
          name = "ipconfig1"
          properties = {
            subnet = {
              id = "${azurerm_virtual_network.example.id}/subnets/AzureBastionSubnet"
            }
            publicIPAddress = {
              id = azurerm_public_ip.bastion.id
            }
          }
        }
      ]
      # New property only in preview API
      enableTunneling = true
    }
    sku = {
      name = "Standard"
    }
  }
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
```

## Update existing resources

Use `azapi_update_resource` to patch resources:

```terraform
resource "azurerm_storage_account" "example" {
  name                     = "stdemo${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Add properties not in AzureRM yet
resource "azapi_update_resource" "storage_advanced" {
  type        = "Microsoft.Storage/storageAccounts@2023-01-01"
  resource_id = azurerm_storage_account.example.id
  
  body = {
    properties = {
      dnsEndpointType = "Standard"
      publicNetworkAccess = "Enabled"
    }
  }
}
```

## Read data sources

```terraform
data "azapi_resource" "existing_acr" {
  type      = "Microsoft.ContainerRegistry/registries@2023-07-01"
  name      = "existing-acr"
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/rg-existing"
}

output "acr_login_server" {
  value = jsondecode(data.azapi_resource.existing_acr.output).properties.loginServer
}
```

## When to use AzAPI

**Use AzAPI for:**
- Brand new Azure services
- Preview API versions
- Properties missing from AzureRM
- Custom resource types

**Use AzureRM for:**
- Stable, mature resources
- Better validation and error messages
- Type safety
- Provider documentation

Start with AzureRM. Switch to AzAPI only when needed.

## Try it yourself

```bash
cd 7-terraform-azapi/terraform
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Finding resource schemas

Use Azure's ARM template reference:

1. Visit [Azure Template Reference](https://learn.microsoft.com/en-us/azure/templates/)
2. Find your resource type
3. Copy the JSON schema
4. Convert to Terraform's HCL syntax

Or use the Azure CLI:

```bash
az resource show --ids /subscriptions/.../resourceGroups/rg/providers/Microsoft.ContainerRegistry/registries/myacr
```

The output shows the exact JSON structure AzAPI expects.
