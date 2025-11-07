# Output public IP
output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "function_app_name" {
  value = azurerm_function_app.function.name
}

output "function_app_host" {
  value = azurerm_function_app.function.default_hostname
}