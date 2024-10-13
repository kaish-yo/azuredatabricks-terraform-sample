resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_subnet" "private" {
  name                 = "priavte-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.CognitiveServices"]
  delegation {
    name = "DatabrocksDelegation"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.CognitiveServices"]
  delegation {
    name = "DatabrocksDelegation"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "adb-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_network_security_rule" "outbound" {
  name                        = "Outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_network_security_rule" "inbound" {
  name                        = "Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_association" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.private,
    azurerm_network_security_group.nsg
  ]
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.public,
    azurerm_network_security_group.nsg
  ]
}
