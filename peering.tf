resource "azurerm_virtual_network_peering" "peerHUBtoWUS" {
  name                      = "peerHUBtoWUS"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.WUS.name
  remote_virtual_network_id = azurerm_virtual_network.HUB.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peerWUStoHUB" {
  name                      = "peerWUStoHUB"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.HUB.name
  remote_virtual_network_id = azurerm_virtual_network.WUS.id
}

resource "azurerm_virtual_network_peering" "peerHUBtoEUS" {
  name                      = "peerHUBtoEUS"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.EUS.name
  remote_virtual_network_id = azurerm_virtual_network.HUB.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peerEUStoHUB" {
  name                      = "peerEUStoHUB"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.HUB.name
  remote_virtual_network_id = azurerm_virtual_network.EUS.id
}

