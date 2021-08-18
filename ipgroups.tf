resource "azurerm_ip_group" "HomeBase" {
  name                = "HomeBase"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  cidrs = var.homebaseIPs
}

resource "azurerm_ip_group" "MainUSVnetIPSpace" {
  name                = "MainUSVnetIPSpace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  cidrs = ["10.0.0.0/16", "10.1.0.0/16", "10.3.0.0/16"]
}
