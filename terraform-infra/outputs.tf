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
  value       = "https://${azurerm_storage_account.storage_hw4.name}.blob.core.windows.net/${azurerm_storage_container.container_hw4.name}/${azurerm_storage_blob.hello_file.name}${data.azurerm_storage_account_blob_container_sas.sas.sas}"
  description = "SAS URL to access hello.txt"
  sensitive   = true
}

# Output ACI
output "public_ip_address" {
  value       = azurerm_container_group.nginx.ip_address
  description = "The public IP address of the nginx container"
}

output "fqdn" {
  value       = azurerm_container_group.nginx.fqdn
  description = "The fully qualified domain name of the container group"
}

output "nginx_url" {
  value       = "http://${azurerm_container_group.nginx.fqdn}"
  description = "Direct URL to access nginx"
}