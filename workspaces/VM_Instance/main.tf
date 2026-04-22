# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "05f2fe32-26a2-4fb0-921c-9aef6f3da248"
}




resource "azurerm_resource_group" "example_RG" {
  name     = "${terraform.workspace}-RG"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example_RG_Vnet" {
  name                = "${terraform.workspace}-vnet"
  address_space       = ["10.0.0.0/27"]
  location            = azurerm_resource_group.example_RG.location
  resource_group_name = azurerm_resource_group.example_RG.name
}

resource "azurerm_subnet" "example_RG_subnet" {
  name                 = "VM-internal"
  resource_group_name  = azurerm_resource_group.example_RG.name
  virtual_network_name = azurerm_virtual_network.example_RG_Vnet.name
  address_prefixes     = ["10.0.0.0/28"]
}

resource "azurerm_network_interface" "example_RG_nic" {
  name                = "${terraform.workspace}-nic" # Updated to use workspace
  location            = azurerm_resource_group.example_RG.location
  resource_group_name = azurerm_resource_group.example_RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_RG_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example_pip.id # ADD THIS LINE
  }
}


resource "azurerm_public_ip" "example_pip" {
  name                = "${terraform.workspace}-pip"
  resource_group_name = azurerm_resource_group.example_RG.name
  location            = azurerm_resource_group.example_RG.location
  allocation_method   = "Static" # or Dynamic
  sku                 = "Standard"
}


resource "azurerm_network_security_group" "example_nsg" {
  name                = "${terraform.workspace}-nsg"
  location            = azurerm_resource_group.example_RG.location
  resource_group_name = azurerm_resource_group.example_RG.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.my_ip}/32" # Consider restricted this to your IP for security
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "AllowWebInbound"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "AllowInternetOutbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet" # Built-in Service Tag
  }
}

resource "azurerm_network_interface_security_group_association" "example_assoc" {
  network_interface_id      = azurerm_network_interface.example_RG_nic.id
  network_security_group_id = azurerm_network_security_group.example_nsg.id
}

resource "azurerm_linux_virtual_machine" "example_RG_vm" {
  name                = "exampleVMmachine"
  resource_group_name = azurerm_resource_group.example_RG.name
  location            = azurerm_resource_group.example_RG.location
  size                = var.VM_Size
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