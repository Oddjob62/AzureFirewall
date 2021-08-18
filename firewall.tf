resource "azurerm_public_ip" "azurefirewall-pip" {
  name                = "azurefirewall-pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
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
}

resource "azurerm_firewall_policy" "example" {
  name                = "example-fwpolicy"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  dns {
    servers = ["4.2.2.2"]
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "example" {
  name               = "example-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.example.id
  priority           = 500

  dynamic "application_rule_collection" {
    for_each = local.application_rule_collections
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.actiontype
      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name = rule.value.name
          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.protocolType
              port = protocols.value.port
            }
          }
          source_addresses      = rule.value.sourceAddresses[*]
          destination_fqdns     = rule.value.targetFqdns[*]
          destination_fqdn_tags = rule.value.fqdnTags[*]
          source_ip_groups      = rule.value.sourceIpGroups[*]
        }
      }
    }
  }

  network_rule_collection {
    name     = "Basic-RuleCollection"
    priority = 1000
    action   = "Allow"
    rule {
      name                  = "Ping"
      protocols             = ["ICMP"]
      source_ip_groups      = [azurerm_ip_group.MainUSVnetIPSpace.id]
      destination_ip_groups = [azurerm_ip_group.MainUSVnetIPSpace.id]
      destination_ports     = ["*"]
    }
    rule {
      name                  = "RDP"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.MainUSVnetIPSpace.id]
      destination_ip_groups = [azurerm_ip_group.MainUSVnetIPSpace.id]
      destination_ports     = ["3389"]
    }
  }

  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 500
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_ip_groups    = [azurerm_ip_group.HomeBase.id]
      destination_address = azurerm_public_ip.azurefirewall-pip.ip_address
      destination_ports   = ["22"]
      translated_address  = "10.3.0.4"
      translated_port     = "22"
    }
  }
}


output "firewallPrivateIP" {
  value = azurerm_firewall.example.ip_configuration[0].private_ip_address
}

output "firewallPublciIP" {
  value = azurerm_public_ip.azurefirewall-pip.ip_address
}

