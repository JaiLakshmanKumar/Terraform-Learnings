output "private_ip_address" {
  value = azurerm_network_interface.example_RG_nic.private_ip_address
}

output "private_ip_addresses" {
  value = azurerm_network_interface.example_RG_nic.private_ip_addresses
}