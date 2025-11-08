# Random string for unique naming
resource "random_string" "unique" {
  length  = 8
  special = false
  upper   = false
}

# Storage Account (required for Function App)
resource "azurerm_storage_account" "storage" {
  name                     = "stfuncapp${random_string.unique.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Storage Container for function package
resource "azurerm_storage_container" "deployments" {
  name                  = "function-releases"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Upload function ZIP to blob storage
resource "azurerm_storage_blob" "function_package" {
  name                   = "function-${filemd5(data.archive_file.function_zip.output_path)}.zip"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.deployments.name
  type                   = "Block"
  source                 = data.archive_file.function_zip.output_path
}

# Generate SAS token for the blob
data "azurerm_storage_account_blob_container_sas" "function_sas" {
  connection_string = azurerm_storage_account.storage.primary_connection_string
  container_name    = azurerm_storage_container.deployments.name

  start  = "2024-01-01T00:00:00Z"
  expiry = "2026-12-31T00:00:00Z"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

# App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "asp-function-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  sku_name            = "Y1" # Consumption plan
}

# Function App
resource "azurerm_windows_function_app" "function" {
  name                = "func-app-${random_string.unique.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  service_plan_id            = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      node_version = "~18"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = "node"
    "WEBSITE_NODE_DEFAULT_VERSION"   = "~18"
    "WEBSITE_RUN_FROM_PACKAGE"       = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.deployments.name}/${azurerm_storage_blob.function_package.name}${data.azurerm_storage_account_blob_container_sas.function_sas.sas}"
    "FUNCTIONS_EXTENSION_VERSION"    = "~4"
  }
}

# Create ZIP package from function code
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/function-app"
  output_path = "${path.module}/function-app.zip"
}