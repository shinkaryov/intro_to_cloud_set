terraform {
  required_version = ">= 1.0"

  # Configure Azure backend
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"                    # From bootstrap output
    storage_account_name = "settfstatesa15996"             # From bootstrap output (with random suffix)
    container_name       = "tfstate"                       # From bootstrap output
    key                  = "terraform.tfstate"   # Unique key per project/environment
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}