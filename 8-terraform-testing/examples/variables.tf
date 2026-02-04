variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-test"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "storage_account_name" {
  description = "Storage account name"
  type        = string
  default     = "sttest"
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
