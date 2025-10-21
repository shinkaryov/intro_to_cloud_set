variable "resource_group_name" {
  type        = string
  default     = "rg-tfstate"
  description = "Resource group for Terraform state"
}

variable "location" {
  type        = string
  default     = "Poland Central"
  description = "Azure region"
}

variable "storage_account_name" {
  type        = string
  default     = "settfstatestorageaccount"
  description = "Globally unique storage account name"
}

variable "container_name" {
  type        = string
  default     = "tfstate"
  description = "Container name to store state"
}
