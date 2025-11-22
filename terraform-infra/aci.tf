resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_container_group" "nginx" {
  name                = "nginx-container-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "nginx-aci-${random_string.suffix.result}"
  os_type             = "Linux"

  container {
    name   = "nginx"
    image  = "nginx:latest"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = "demo"
    application = "nginx"
  }
}