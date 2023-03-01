# Terraform Modules

A module is a collection of resources that are used together. Modules are used to create reusable components, increase readability, and to organize infrastructure as code.

Writing Terraform, like any other IaC toolset, over time you may be repeating the same process for common resources such as an Azure Virtual network, Container registry, Postgres Database etc – instead of copying the same resource multiple times, you can create what is called a Terraform module to assist you with this repetition allowing you to create reusable Terraform. 

Modules are a great way to create reusable components, increase readability, and to organize infrastructure as code.

## Terraform Module - Pros

- Reusable
- Organised
- Readable
- Maintainable
- Versioned

## Terraform Module - Cons

- Complexity

## Terraform Module Structure

A Terraform module is a directory that contains Terraform configuration files. The directory structure of a module is as follows:

What can be included as part of a Terraform module?

- Terraform Resources – That deploy whenever you reference your module within Terraform
- Terraform Inputs – From your main Terraform deployment you will input various values and configurations that will be referenced within your Terraform module
- Terraform Outputs – Outputs that can be used once the module is deployed, for example the resource ID
- Whatever else you want to include 🙂 – What else you want to include can be decided by you and each module is certainly different!

## Standard Terraform Deployment

The below is a standard Terraform deployment that deploys an `Azure Resource Group` and `Azure Container Registry`

```terraform

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "tamops"
  location = "UK South"
}

# Azure Container Registry

resource "azurerm_container_registry" "acr" {
  name                = "tamopsacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

``` 

How can we make this more reusable? (This is a lightweight example) – We can create a Terraform module that will deploy the above resources. Allowing us to reference the module within our Terraform deployment and reuse the module as many times as we want.

## Terraform Module Deployment

### Terraform Module - Directory Structure

The below is the directory structure of a Terraform module, basic structure that can follow similar that you have created a standard Terraform deployment.

```bash
├── main.tf
├── outputs.tf
├── variables.tf
```

### Terraform Module - main.tf

The below is the `main.tf` file that will contain the resources that will be deployed when you reference the module within your Terraform deployment.

```terraform

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
}

```

### Terraform Module - variables.tf

The below is the `variables.tf` file that will contain the variables that will be referenced within the `main.tf` file.

```terraform

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the container registry."
}

variable "location" {
  type        = string
  description = "The Azure location where the container registry should exist."
}

variable "acr_name" {
  type        = string
  description = "The name of the container registry."
}

variable "acr_sku" {
  type        = string
  description = "The SKU of the container registry."
}

variable "acr_admin_enabled" {
  type        = bool
  description = "Should the admin user be enabled?"
}

```

### Terraform Module - outputs.tf

The below is the `outputs.tf` file that will contain the outputs that will be referenced within the `main.tf` file.

```terraform

output "acr_id" {
  value = azurerm_container_registry.acr.id
}

```

### Terraform Module - Reference

The below is the `main.tf` file that will reference the module within your Terraform deployment.

```terraform

module "acr" {
  source = "./modules/acr"

  resource_group_name = "tamops"
  location            = "UK South"
  acr_name            = "tamopsacr"
  acr_sku             = "Standard"
  acr_admin_enabled   = true
}

```

### Run example

You can now run the example found in this section.

Run Terraform from [here](https://github.com/thomast1906/terraform-on-azure/tree/main/4-terraform-advanced/6-terraform-modules/terraform)