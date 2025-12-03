# Outputs
output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.nic.private_ip_address
}

output "nginx_url" {
  description = "URL to access Nginx"
  value       = "http://${azurerm_public_ip.public_ip.ip_address}"
}