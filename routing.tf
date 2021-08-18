resource "azurerm_route_table" "EUS-RT" {
  name                = "EUS-RT"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_route" "EUS-Route1" {
  name                   = "EUS-Route1"
  resource_group_name    = azurerm_resource_group.example.name
  route_table_name       = azurerm_route_table.EUS-RT.name
  address_prefix         = "10.3.0.0/16"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.example.ip_configuration[0].private_ip_address
}

resource "azurerm_route_table" "WUS-RT" {
  name                = "WUS-RT"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_route" "WUS-Route1" {
  name                   = "WUS-Route1"
  resource_group_name    = azurerm_resource_group.example.name
  route_table_name       = azurerm_route_table.WUS-RT.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.example.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "EUS" {
  subnet_id      = azurerm_subnet.EUS-INFRA.id
  route_table_id = azurerm_route_table.EUS-RT.id
}

resource "azurerm_subnet_route_table_association" "WUS" {
  subnet_id      = azurerm_subnet.WUS-INFRA.id
  route_table_id = azurerm_route_table.WUS-RT.id
}