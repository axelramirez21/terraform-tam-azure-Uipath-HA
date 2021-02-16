resource "azurerm_lb" "es-lb" {
  name                = "elastic-search-loadBalancer"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku = "Standard"

  frontend_ip_configuration {
    name      = "privateIPAddress"
    subnet_id = var.es_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.5.7"
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_lb_backend_address_pool" "es-pool" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.es-lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "esss" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.es-lb.id
  name                = "ssh-running-probe"
  port                = "9200"

}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.es-lb.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = "9200"
  backend_port                   = "9200"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.es-pool.id
  frontend_ip_configuration_name = "privateIPAddress"
  probe_id                       = azurerm_lb_probe.esss.id

}

resource "azurerm_private_dns_a_record" "lb_dns_a_record" {
  name                = var.dns_lb_record_name
  zone_name           = var.dns_private_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_lb.es-lb.frontend_ip_configuration[0].private_ip_address]
}

resource "azurerm_network_interface" "test" {
  count               = 3
  name                = "elastic-search-acctni-${count.index}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = var.es_subnet_id
    private_ip_address_allocation = "dynamic"
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_managed_disk" "test" {
  count                = 3
  name                 = "elastic-search-datadisk-existing-${count.index}"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_availability_set" "avset" {
  name                         = "elastic-search-avset"
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 3
  managed                      = true
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_virtual_machine" "test" {
  count                 = 3
  name                  = "elastic-search-${count.index}"
  location              = var.resource_group_location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = var.resource_group_name
  network_interface_ids = [element(azurerm_network_interface.test.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "elastic-search-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "elastic-search-datadisk-${count.index}"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = element(azurerm_managed_disk.test.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.test.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = element(azurerm_managed_disk.test.*.disk_size_gb, count.index)
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "uipathadmin"
    admin_password = "P@ssW0rd#123"
  }

  os_profile_windows_config {
    enable_automatic_upgrades = "false"
  }

  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count = 3
  network_interface_id    = element(azurerm_network_interface.test.*.id, count.index)
  ip_configuration_name   = "testConfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.es-pool.id
}