terraform {
  required_providers {
    azurerm = {
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resourceGroupName
  location = var.location
}

