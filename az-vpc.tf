# Create a VNet
resource "azurerm_virtual_network" "proxy" {
  name                = "vnet-proxy"
  location            = azurerm_resource_group.proxy.location
  resource_group_name = azurerm_resource_group.proxy.name
  address_space       = var.vnet_address_space

  tags = var.tags
}

# Create a subnet
resource "azurerm_subnet" "proxy" {
  name                 = "subnet-proxy"
  resource_group_name  = azurerm_resource_group.proxy.name
  virtual_network_name = azurerm_virtual_network.proxy.name
  address_prefixes     = var.subnet_address_prefixes
}

# Create a Static IP
resource "azurerm_public_ip" "proxy" {
  name                = "pip-proxy"
  resource_group_name = azurerm_resource_group.proxy.name
  location            = azurerm_resource_group.proxy.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# Create a Network Security Group
resource "azurerm_network_security_group" "proxy" {
  name                = "nsg-proxy"
  location            = azurerm_resource_group.proxy.location
  resource_group_name = azurerm_resource_group.proxy.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowOutbound"
    priority                   = 2000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Create a Network Interface
resource "azurerm_network_interface" "proxy" {
  name                = "nic-proxy"
  location            = azurerm_resource_group.proxy.location
  resource_group_name = azurerm_resource_group.proxy.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.proxy.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.proxy.id
  }

  tags = var.tags
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "proxy" {
  network_interface_id      = azurerm_network_interface.proxy.id
  network_security_group_id = azurerm_network_security_group.proxy.id
}
