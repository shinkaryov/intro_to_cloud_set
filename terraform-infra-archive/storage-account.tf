# Random string for unique naming
resource "random_string" "unique_sa" {
  length  = 8
  special = false
  upper   = false
}

# Storage Account
resource "azurerm_storage_account" "storage_hw4" {
  name                     = "stacc${random_string.unique_sa.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = true
}

# Blob Container
resource "azurerm_storage_container" "container_hw4" {
  name                  = "demo-files"
  storage_account_name  = azurerm_storage_account.storage_hw4.name
  container_access_type = "private"
}

# Upload hello.txt to blob storage
resource "azurerm_storage_blob" "hello_file" {
  name                   = "hello.txt"
  storage_account_name   = azurerm_storage_account.storage_hw4.name
  storage_container_name = azurerm_storage_container.container_hw4.name
  type                   = "Block"
  source                 = "${path.module}/files/hello.txt"
  content_type           = "text/plain"
}

# Generate SAS token for the blob
data "azurerm_storage_account_blob_container_sas" "sas" {
  connection_string = azurerm_storage_account.storage_hw4.primary_connection_string
  container_name    = azurerm_storage_container.container_hw4.name

  start  = "2025-11-01T00:00:00Z"
  expiry = "2025-12-01T00:00:00Z"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}