## What is a Terraform Provider?

Terraform providers are plugins that allow Terraform to interact with the underlying API's of various services. In this case, we will be using the Azure Provider to interact with Azure.

## Why do we need a Terraform Provider?

Providers are needed to allow Terraform to interact with the underlying API's of various services. In this case, we will be using the Azure Provider to interact with Azure.

## Azure Provider

The Azure Provider is used to interact with the many resources supported by Azure Resource Manager (ARM). The provider needs to be configured with the proper credentials before it can be used.

## Azure Provider Configuration

The Azure Provider is used to configure the proper credentials before it can be used.

### Azure Provider Configuration - Azure CLI 2.0

The Azure Provider can be configured using the Azure CLI 2.0, which is installed as part of the Azure CLI 2.0. If you have already installed the Azure CLI 2.0, you can view the currently authenticated account name with the az account show command:

```bash
az account show --query "{ subscription_id: id, tenant_id: tenantId }"
```

The output should be similar to the following:

```json
{
  "subscription_id": "00000000-0000-0000-0000-000000000000",
  "tenant_id": "00000000-0000-0000-0000-000000000000"
}
```

The subscription_id and tenant_id values can be used in the provider configuration block:

```terraform

provider "azurerm" {
  features {}
}

```