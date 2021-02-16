output "sql_subnet_id" {
  value = azurerm_subnet.sql_subnet.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}

output "orchestrator_subnet_id" {
  value = azurerm_subnet.orchestrator_subnet.id
}

output "bastion_public_ip_id" {
  value = azurerm_public_ip.bastion_public_ip.id
}

output "es_subnet_id" {
  value = azurerm_subnet.es_subnet.id
}

output "haa_subnet_id" {
  value = azurerm_subnet.haa_subnet.id
}

output "robot_subnet_id" {
  value = azurerm_subnet.robot_subnet.id
}

output "cyberark_subnet_id" {
  value = azurerm_subnet.cyberArk_subnet.id
}

output "dc_subnet_id" {
  value = azurerm_subnet.domain_controller_subnet.id
}