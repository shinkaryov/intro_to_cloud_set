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
  sensitive   = true
}

variable "PRIVATE_IP" {
  type    = string
  default = "10.0.0.4"
}