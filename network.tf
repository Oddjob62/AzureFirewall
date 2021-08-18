
resource "azurerm_virtual_network" "HUB" {
  name                = "HUB"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.HUB.name
  address_prefixes     = ["10.0.0.0/26"]
}
resource "azurerm_virtual_network" "EUS" {
  name                = "EUS"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "EUS-INFRA" {
  name                 = "EUS-INFRA"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.EUS.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_virtual_network" "WUS" {
  name                = "WUS"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.3.0.0/16"]
}

resource "azurerm_subnet" "WUS-INFRA" {
  name                 = "WUS-INFRA"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.WUS.name
  address_prefixes     = ["10.3.0.0/24"]
}
