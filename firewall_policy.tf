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
      action   = application_rule_collection.value.action
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
          source_addresses      = rule.value.source_addresses[*]
          destination_fqdns     = rule.value.destination_fqdns[*]
          destination_fqdn_tags = rule.value.destination_fqdn_tags[*]
          source_ip_groups      = rule.value.source_ip_groups[*]
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = local.network_rule_collections
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action
      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols[*]
          source_ip_groups      = rule.value.source_ip_groups[*]
          destination_ip_groups = rule.value.destination_ip_groups[*]
          destination_ports     = rule.value.destination_ports[*]
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = local.nat_rule_collections
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action
      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.value.name
          protocols           = rule.value.protocols[*]
          source_ip_groups    = rule.value.source_ip_groups[*]
          destination_address = rule.value.destination_address
          destination_ports   = rule.value.destination_ports[*]
          translated_address  = rule.value.translated_address
          translated_port     = rule.value.translated_port
        }
      }
    }
  }
}
