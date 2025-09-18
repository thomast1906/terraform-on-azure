variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.resource_group_name))
    error_message = "Resource group name must only contain alphanumeric characters, hyphens, and underscores."
  }
  
  validation {
    condition     = length(var.resource_group_name) >= 1 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
  
  validation {
    condition = contains([
      "eastus", "eastus2", "westus", "westus2", "centralus",
      "northeurope", "westeurope", "uksouth", "ukwest",
      "southeastasia", "eastasia", "japaneast", "australiaeast"
    ], lower(replace(var.location, " ", "")))
    error_message = "Location must be a valid Azure region."
  }
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.storage_account_name))
    error_message = "Storage account name must only contain lowercase letters and numbers."
  }
  
  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "Storage account name must be between 3 and 24 characters."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}