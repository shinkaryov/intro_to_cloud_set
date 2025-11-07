# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-set-cloud"
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}