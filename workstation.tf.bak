locals {
  regions       = ["EUS", "WUS"]
  regionSubnets = [azurerm_subnet.EUS-INFRA.id, azurerm_subnet.WUS-INFRA.id]
  #regions2 = [for s in local.regions: "azurerm_subnet.${s}-INFRA" ]
}

resource "azurerm_network_interface" "example" {
  count               = 2
  name                = "nic-${local.regions[count.index]}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name      = "internal"
    subnet_id = local.regionSubnets[count.index]
    #subnet_id                     = "azurerm_subnet.${local.regions[count.index]}-INFRA.id"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  count               = 2
  name                = "LinuxVM-${local.regions[count.index]}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example[count.index].id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
