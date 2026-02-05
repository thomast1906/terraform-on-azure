variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "cost_center" {
  description = "Cost center code (format: CC-XXXX)"
  type        = string
  default     = "CC-1234"
}

variable "storage_name" {
  description = "Base storage account name (3-18 characters)"
  type        = string
  default     = "stvalidated"
}
