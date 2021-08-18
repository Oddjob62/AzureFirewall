variable "location" {
  type        = string
  description = "location of your resource group"
  default     = "uksouth"
}

variable "subscriptionID" {
  type        = string
  description = "Variable for our resource group"
}

variable "resourceGroupName" {
  type        = string
  description = "name of resource group"
  default     = "AzureFirewallRG"
}

variable "homebaseIPs" {
  type        = list(string)
  description = "trusted IPs"
  default     = ["50.40.30.20", "10.20.30.40."]
}

variable "firewallSku" {
  type        = string
  description = "Sku of Azure firewall, Standard or Premium"
  default     = "Standard"

  validation {
    condition = var.firewallSku == "Standard" || var.firewallSku == "Premium"
    error_message = "The Firewall Sku must be set to Standard or Premium."
  }
}