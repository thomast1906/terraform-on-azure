variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "My Test App"
}

variable "regions" {
  description = "List of Azure regions"
  type        = list(string)
  default     = ["uksouth", "ukwest"]
}

variable "cost_center" {
  description = "Cost center code"
  type        = string
  default     = "CC-1234"
}
