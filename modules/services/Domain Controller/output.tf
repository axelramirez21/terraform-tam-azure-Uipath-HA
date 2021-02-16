output "dc_private_ip" {
  value = azurerm_network_interface.dc_interface.private_ip_address
}