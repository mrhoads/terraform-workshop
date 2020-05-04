provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
    name = "terraform-example-rg"
    location = var.location
    tags = {
        purpose = var.tagPurpose
        keepUntil = var.tagKeepUntil
    }
}

resource "azurerm_network_interface" "web-nic" {
  name                = "web-server-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "web-ipconfig"
    subnet_id                     = azurerm_subnet.subnet[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-pip.id
  }
}

resource "azurerm_public_ip" "web-pip" {
  name                = "web-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"

}

resource "azurerm_linux_virtual_machine" "web-server-vm" {
  name                  = "webserver"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  network_interface_ids = [azurerm_network_interface.web-nic.id]
  size                  = "Standard_B1ms"
  admin_username        = var.vm-username

  source_image_reference {
    publisher = "Canonical"
    sku       = "18.04-LTS"
    offer     = "UbuntuServer"
    version   = "18.04.201909030"
  }

  os_disk {
    name                 = "webserver01-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.vm-username
    public_key = file("~/.ssh/id_rsa.pub")
  }

}

output "public_ip" {
    value = azurerm_public_ip.web-pip.ip_address
}