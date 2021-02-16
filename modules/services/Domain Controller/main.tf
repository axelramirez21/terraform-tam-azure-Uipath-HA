resource "azurerm_network_interface" "dc_interface" {
  name                = var.network_interface_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.IP_configuration_name
    subnet_id                     = var.dc_subnet_id
    private_ip_address_allocation = var.private_ip_allocation
    private_ip_address = var.private_ip_address
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_windows_virtual_machine" "dc_vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.vm_size
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  network_interface_ids = [azurerm_network_interface.dc_interface.id,]

  os_disk {
    caching              = var.os_caching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}