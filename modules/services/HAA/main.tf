# using newer resource
resource "azurerm_availability_set" "haa-cluster-avset" {
  name                         = var.availability_set_name
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = var.availability_set_fault_domain_count
  platform_update_domain_count = var.availability_update_domain_count
  managed                      = var.availability_set_managed
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_network_interface" "haa_master_network_interface" {
  name                = var.master_network_interface_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.master_IP_configuration_name
    subnet_id                     = var.haa_subnet_id
    private_ip_address_allocation = var.private_ip_allocation
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_network_interface" "haa_slave_network_interface" {
  count               = var.slave_instance_number
  name                = "${var.slave_network_interface_name}${count.index}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.slave_IP_configuration_name}${count.index}"
    subnet_id                     = var.haa_subnet_id
    private_ip_address_allocation = var.private_ip_allocation
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_linux_virtual_machine" "haa-master-node" {
  name                = var.master_vm_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.master_vm_size
  disable_password_authentication = var.master_vm_disable_password_authentication
  admin_username      = var.master_vm_username
  admin_password      = var.master_vm_password
  network_interface_ids = [azurerm_network_interface.haa_master_network_interface.id,]

  custom_data =     base64encode(data.template_file.haa-master.rendered)

  availability_set_id   = azurerm_availability_set.haa-cluster-avset.id

  os_disk {
    caching              = var.master_os_caching
    storage_account_type = var.master_storage_account_type
  }

  source_image_reference {
    publisher = var.master_source_image_publisher
    offer     = var.master_source_image_offer
    sku       = var.master_source_image_sku
    version   = var.master_source_image_version
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_linux_virtual_machine" "haa-slave-node" {
  count = var.slave_instance_number
  name                = "${var.slave_vm_name}${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.slave_vm_size
  disable_password_authentication = var.slave_vm_disable_password_authentication
  admin_username      = var.slave_vm_username
  admin_password      = var.slave_vm_password
  network_interface_ids = [element(azurerm_network_interface.haa_slave_network_interface.*.id, count.index)]

  custom_data =  base64encode(data.template_file.haa-slave.rendered)

  depends_on = [azurerm_linux_virtual_machine.haa-master-node]

  availability_set_id   = azurerm_availability_set.haa-cluster-avset.id

  os_disk {
    caching              = var.slave_os_caching
    storage_account_type = var.slave_storage_account_type
  }

  source_image_reference {
    publisher = var.slave_source_image_publisher
    offer     = var.slave_source_image_offer
    sku       = var.slave_source_image_sku
    version   = var.slave_source_image_version
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}