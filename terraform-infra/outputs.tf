# Output public IP
output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

# Output Function App details
output "function_app_name" {
  value       = azurerm_windows_function_app.function.name
  description = "Function App name for portal access"
}

output "function_app_url" {
  value       = "https://${azurerm_windows_function_app.function.default_hostname}"
  description = "Function App base URL"
}

output "http_trigger_url" {
  value       = "https://${azurerm_windows_function_app.function.default_hostname}/api/HttpTrigger"
  description = "HTTP Trigger endpoint - open this in browser"
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Resource Group name for portal access"
}

# Output SAS URL for the blob
output "sas_url" {
  value       = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.container.name}/${azurerm_storage_blob.hello_file.name}${data.azurerm_storage_account_blob_container_sas.sas.sas}"
  description = "SAS URL to access hello.txt"
  sensitive   = true
}