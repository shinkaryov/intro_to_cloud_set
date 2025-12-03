# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "publicip-nginx"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-nginx"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.main.id}/subnets/subnet-backend"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Cloud-init script
data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    PRIVATE_IP = var.PRIVATE_IP
  }
}

# Linux VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "vm-nginx"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  size = "Standard_B1s"

  os_disk {
    name                 = "osdisk-nginx"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  custom_data = base64encode(data.template_file.cloud_init.rendered)

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}