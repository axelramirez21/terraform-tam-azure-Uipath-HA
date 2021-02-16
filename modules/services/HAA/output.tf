output "haa_master_network_ip" {
  value = azurerm_network_interface.haa_master_network_interface.private_ip_address
}