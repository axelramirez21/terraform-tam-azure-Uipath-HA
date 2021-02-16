resource "azurerm_bastion_host" "tam-bastion-host" {
  name                = var.bastion_host_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = var.bastion_ip_configuration_name
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = var.bastion_public_ip_address_id
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}