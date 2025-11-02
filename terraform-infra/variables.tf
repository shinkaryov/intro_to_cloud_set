variable "location" {
  type        = string
  default     = "Poland Central"
  description = "Azure region"
}

variable "environment" {
  type        = string
  default     = "SET"
  description = "Environment name"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for VM access"
}