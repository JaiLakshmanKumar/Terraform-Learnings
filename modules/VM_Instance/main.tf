resource "azurerm_resource_group" "example_RG" {
  name     = "demo_RG"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example_RG_Vnet" {
  name                = "demo_Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example_RG.location
  resource_group_name = azurerm_resource_group.example_RG.name
}

resource "azurerm_subnet" "example_RG_subnet" {
  name                 = "VM-internal"
  resource_group_name  = azurerm_resource_group.example_RG.name
  virtual_network_name = azurerm_virtual_network.example_RG_Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example_RG_nic" {
  name                = "example_RG-nic"
  location            = azurerm_resource_group.example_RG.location
  resource_group_name = azurerm_resource_group.example_RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_RG_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example_RG_vm" {
  name                = "exampleVMmachine"
  resource_group_name = azurerm_resource_group.example_RG.name
  location            = azurerm_resource_group.example_RG.location
  size                = "Standard_F2"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
   disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.example_RG_nic.id,
  ]

  

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}