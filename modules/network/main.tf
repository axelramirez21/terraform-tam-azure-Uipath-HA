############# SQL VNET 1 ################################
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.vnet_location
  resource_group_name = var.resource_group_name
  dns_servers         = [var.vnet_dns_server]

  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}

#BASTION HOST SUBNET and PUBLIC IP on VNET1
resource "azurerm_subnet" "bastion_subnet" {
  name                 = var.bastion_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion_subnet_address_prefixes]
}

resource "azurerm_public_ip" "bastion_public_ip" {
  name                = var.bastion_public_ip_name
  location            = var.vnet_location
  resource_group_name = var.resource_group_name
  allocation_method   = var.bastion_allocation_method
  sku                 = var.bastion_sku
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}

#SQL SUBNET on VNET1
resource "azurerm_subnet" "sql_subnet" {
  name                 = var.sql_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.sql_subnet_address_prefixes]
  service_endpoints    = [var.sql_subnet_address_service_endpoints]
}

#Orchestrator SUBNET on VNET1
resource "azurerm_subnet" "orchestrator_subnet" {
  name                 = var.orchestrator_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.orchestrator_subnet_address_prefixes]
}

#HAA SUBNET on VNET1
resource "azurerm_subnet" "haa_subnet" {
  name                 = var.haa_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.haa_subnet_address_prefixes]
}

#ElasticSearch SUBNET on VNET1
resource "azurerm_subnet" "es_subnet" {
  name                 = var.es_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.es_subnet_address_prefixes]
}

#Robot SUBNET on VNET1
resource "azurerm_subnet" "robot_subnet" {
  name                 = var.robot_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.robot_subnet_address_prefixes]
}

#CyberArk SUBNET on VNET1
resource "azurerm_subnet" "cyberArk_subnet" {
  name                 = var.cyberark_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.cyberark_subnet_address_prefixes]
}

#Domain Controller SUBNET on VNET1
resource "azurerm_subnet" "domain_controller_subnet" {
  name                 = var.dc_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.dc_subnet_address_prefixes]
}


#NAT Gateway for subnet internet access
resource "azurerm_public_ip" "nat_public_ip" {
  name                = var.nat_public_ip_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = var.nat_public_ip_allocation_method
  sku                 = var.nat_public_ip_sku
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}

resource "azurerm_public_ip_prefix" "nat_public_ip_prefix" {
  name                = var.nat_public_ip_prefix_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  prefix_length       = var.nat_public_ip_prefix_lenght
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = var.nat_gateway_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  public_ip_prefix_ids    = [azurerm_public_ip_prefix.nat_public_ip_prefix.id]
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout_mins
  sku_name                = var.nat_gateway_sku
  tags = {
    "Owner" = var.tag_owner
    "Project" = var.tag_project
  }
}

#NAT Gateway association with subnets
resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "orchestrator-nat-association" {
  subnet_id      = azurerm_subnet.orchestrator_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "haa-nat-association" {
  subnet_id      = azurerm_subnet.haa_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "cyber-nat-association" {
  subnet_id      = azurerm_subnet.cyberArk_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "es-nat-association" {
  subnet_id      = azurerm_subnet.es_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "robots-nat-association" {
  subnet_id      = azurerm_subnet.robot_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "dc-nat-association" {
  subnet_id      = azurerm_subnet.domain_controller_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
