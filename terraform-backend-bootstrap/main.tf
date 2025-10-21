provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "sa" {
  name = "${var.storage_account_name}${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name = var.container_name
  storage_account_id = azurerm_storage_account.sa.id
  container_access_type = "private"
}

