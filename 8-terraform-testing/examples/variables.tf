# Variables for the testing example
# All variables should be properly documented and typed

variable "resource_group_name" {
  description = "The name of the resource group to create"
  type        = string
  
  validation {
    condition     = length(var.resource_group_name) > 0 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
  
  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US",
      "West Central US", "Canada Central", "Canada East",
      "Brazil South", "North Europe", "West Europe",
      "UK South", "UK West", "France Central",
      "Germany West Central", "Switzerland North",
      "Norway East", "Sweden Central"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

variable "storage_account_name" {
  description = "The name of the storage account to create (must be globally unique)"
  type        = string
  
  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "Storage account name must be between 3 and 24 characters."
  }
  
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.storage_account_name))
    error_message = "Storage account name can only contain lowercase letters and numbers."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "TerraformTesting"
    Owner       = "DevOps Team"
  }
  
  validation {
    condition     = contains(keys(var.tags), "Environment")
    error_message = "Tags must include an 'Environment' key."
  }
  
  validation {
    condition     = contains(keys(var.tags), "Project")
    error_message = "Tags must include a 'Project' key."
  }
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access the storage account"
  type        = list(string)
  default     = []
  
  validation {
    condition = alltrue([
      for ip in var.allowed_ip_ranges : can(cidrhost(ip, 0))
    ])
    error_message = "All IP ranges must be valid CIDR blocks."
  }
}