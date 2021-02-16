resource "azurerm_lb" "orchestrator-vmss-lb" {
  name                = "orchestrator-vmss-lb"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku = "Standard"

  frontend_ip_configuration {
    name      = "privateIPAddress"
    subnet_id = var.orchestrator_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.3.7"
  }
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.orchestrator-vmss-lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.orchestrator-vmss-lb.id
  name                = "ssh-running-probe"
  port                = "443"
}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.orchestrator-vmss-lb.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = "443"
  backend_port                   = "443"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
  frontend_ip_configuration_name = "privateIPAddress"
  probe_id                       = azurerm_lb_probe.vmss.id
  load_distribution = "SourceIPProtocol"
}

resource "azurerm_windows_virtual_machine_scale_set" "example" {
  name                = "orchestrator-vmss"
  computer_name_prefix = "orch"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = var.vm_size
  instances           = 2
  admin_password      = var.vm_password
  admin_username      = var.vm_username

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "orchestrator-network-interface"
    primary = true

    ip_configuration {
      name      = "orchestrator-internal"
      primary   = true
      subnet_id = var.orchestrator_subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
    }
  }

  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
    "AlwaysPoweredOn" = var.tag_AlwaysPoweredOn
  }
}