locals {
  application_rule_collections = [
    {
      name       = "app_rule_allow1"
      priority   = "1500"
      actiontype = "Allow"

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
          sourceAddresses = []
          targetFqdns     = ["ifconfig.me"]
          fqdnTags        = []
          sourceIpGroups  = [azurerm_ip_group.MainUSVnetIPSpace.id]
        }
      ]
    }
  ]
}
