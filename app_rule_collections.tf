locals {
  application_rule_collections = [
    {
      name     = "app_rule_allow1"
      priority = "1500"
      action   = "Allow"

      rules = [
        {
          name = "app_rule_allow_ifconfig.me"
          protocols = [
            {
              protocolType = "Http"
              port         = "80"
            },
            {
              protocolType = "Https"
              port         = "443"
            }
          ]
          source_addresses      = []
          destination_fqdns     = ["ifconfig.me"]
          destination_fqdn_tags = []
          source_ip_groups      = [azurerm_ip_group.MainUSVnetIPSpace.id]
        }
      ]
    }
  ]

  network_rule_collections = [
    {
      name     = "Basic-RuleCollection"
      priority = 1000
      action   = "Allow"
      rules = [
        {
          name                  = "Ping"
          protocols             = ["ICMP"]
          source_ip_groups      = [azurerm_ip_group.MainUSVnetIPSpace.id]
          destination_ip_groups = [azurerm_ip_group.MainUSVnetIPSpace.id]
          destination_ports     = ["*"]
        },
        {
          name                  = "RDP"
          protocols             = ["TCP"]
          source_ip_groups      = [azurerm_ip_group.MainUSVnetIPSpace.id]
          destination_ip_groups = [azurerm_ip_group.MainUSVnetIPSpace.id]
          destination_ports     = ["3389"]
        }
      ]
    }
  ]

  nat_rule_collections = [
    {
      name     = "nat_rule_collection1"
      priority = "500"
      action   = "Dnat"

      rules = [
        {
          name                = "nat_rule_sshToVMs"
          protocols           = ["TCP", "UDP"]
          source_ip_groups    = [azurerm_ip_group.HomeBase.id]
          destination_address = azurerm_public_ip.azurefirewall-pip.ip_address
          destination_ports   = ["22"]
          translated_address  = "10.3.0.4"
          translated_port     = "22"
        }
      ]
    }
  ]
}
