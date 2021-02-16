resource "azurerm_network_interface" "master_image_interface" {
  name                = "orch-master-image-acctni"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "masterconfiguration"
    subnet_id                     = var.orchestrator_subnet_id
    private_ip_address_allocation = "dynamic"
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_network_interface" "node_image_interface" {
  name                = "orch-node-image-acctni"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "nodeconfiguration"
    subnet_id                     = var.orchestrator_subnet_id
    private_ip_address_allocation = "dynamic"
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_availability_set" "image-avset" {
  name                         = "master-image-avset"
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_windows_virtual_machine" "orchestrator_master_image" {
  name                = "orch-master"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.vm_size
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  network_interface_ids = [azurerm_network_interface.master_image_interface.id,]
  availability_set_id = azurerm_availability_set.image-avset.id
  custom_data =     base64encode(data.template_file.init.rendered)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_windows_virtual_machine" "orchestrator_node_image" {
  name                = "orch-node"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.vm_size
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  network_interface_ids = [azurerm_network_interface.node_image_interface.id,]
  availability_set_id = azurerm_availability_set.image-avset.id
  custom_data =     base64encode(data.template_file.init.rendered)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_lb_backend_address_pool" "address_bpepool" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.orchestrator-vmss-lb.id
  name                = "orch-vm-pool"
}

resource "azurerm_lb_probe" "master_image_vmss" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.orchestrator-vmss-lb.id
  name                = "orch-vm-probe"
  port                = "443"
}

resource "azurerm_network_interface_backend_address_pool_association" "master" {
  network_interface_id    = azurerm_network_interface.master_image_interface.id
  ip_configuration_name   = "masterconfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.address_bpepool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "node" {
  network_interface_id    = azurerm_network_interface.node_image_interface.id
  ip_configuration_name   = "nodeconfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.address_bpepool.id
}