variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the container registry."
  default     = "tamopsrg"
}

variable "location" {
  type        = string
  description = "The Azure location where the container registry should exist."
  default     = "uksouth"
}

variable "acr_name" {
  type        = string
  description = "The name of the container registry."
  default     = "tamopsacr"
}
