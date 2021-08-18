resource "azurerm_public_ip" "azurefirewall-pip" {
  name                = "azurefirewall-pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = var.firewallSku
}

resource "azurerm_firewall" "example" {
  name                = "testfirewall"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  firewall_policy_id  = azurerm_firewall_policy.example.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.azurefirewall-pip.id
  }
  depends_on = [
    # sometimes deployment fails if rule collection is being created/changed when firewall is applying the policy
    azurerm_firewall_policy_rule_collection_group.example,
    azurerm_firewall_policy.example
  ]
}

output "firewallPrivateIP" {
  value = azurerm_firewall.example.ip_configuration[0].private_ip_address
}

output "firewallPublciIP" {
  value = azurerm_public_ip.azurefirewall-pip.ip_address
}

