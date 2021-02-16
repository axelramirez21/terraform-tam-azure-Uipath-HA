resource "azurerm_network_interface" "hd-robot-interface" {
  count               = 1
  name                = "hd-robot-acctni-${count.index}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = var.robot_subnet_id
    private_ip_address_allocation = "dynamic"
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_managed_disk" "test" {
  count                = 1
  name                 = "hd-robot-datadisk-existing-${count.index}"
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
  name                         = "hd-robot-avset"
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = 1
  platform_update_domain_count = 1
  managed                      = true
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_virtual_machine" "test" {
  count                 = 1
  name                  = "hd-robot-server-${count.index}"
  location              = var.resource_group_location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = var.resource_group_name
  network_interface_ids = [element(azurerm_network_interface.hd-robot-interface.*.id, count.index)]
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
    name              = "robot-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "hd-robot-datadisk-${count.index}"
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