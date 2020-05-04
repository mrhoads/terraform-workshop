
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform-example"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet-space

}


resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet-list)
  name                 = element(var.subnet-names-list, count.index)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix      = element(var.subnet-list, count.index)

}


resource "azurerm_network_security_group" "default-nsg" {
  name                = "nsg-tf-ssh"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed-source-ssh
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "AllowWeb"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "default-ssh-assoc" {
  subnet_id                 = azurerm_subnet.subnet[0].id
  network_security_group_id = azurerm_network_security_group.default-nsg.id
}