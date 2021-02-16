terraform {
  required_providers {
    azurerm   = {
      source  = "hashicorp/azurerm"
      version = "=2.46.1"
    }
  }
}
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  skip_provider_registration = true
  features {}
}

locals {
  resource_group_name       = "TAM-Americas-RG"
  resource_group_location   = "West US"
  tag_owner                 = "axel.ramirez@uipath.com"
  tag_project               = "TAM"
  tag_AlwaysPoweredOn       = "true"
}

#NETWORK MODULES TO PROVISION VNETS
module "network" {

  source                                = "../../modules/network"

  resource_group_name                   = local.resource_group_name
  resource_group_location               = local.resource_group_location

  #VNET SQL REGION 1
  vnet_name                             = "tam-vnet"
  vnet_location                         = local.resource_group_location
  vnet_address_space                    ="10.0.0.0/16"

  #Static IP for DNS server, if you change it you will have to change the IP address for the domain controller VM
  vnet_dns_server                       ="10.0.8.5"

  sql_subnet_name                       ="tam-sqlserver-subnet"
  sql_subnet_address_prefixes           ="10.0.1.0/24"
  sql_subnet_address_service_endpoints  ="Microsoft.Sql"

  #VNET REGION 1 Bastion host subnet
  bastion_subnet_name                   ="AzureBastionSubnet"
  bastion_subnet_address_prefixes       ="10.0.2.0/24"
  bastion_public_ip_name                = "tam-bastion_ip"
  bastion_allocation_method             = "Static"
  bastion_sku                           = "Standard"

  #VNET REGION 1 Orchestrator subnet
  orchestrator_subnet_name              ="tam-orchestrator-subnet"
  orchestrator_subnet_address_prefixes  ="10.0.3.0/24"

  #VNET REGION 1 HAA subnet
  haa_subnet_name                       ="tam-haa-subnet"
  haa_subnet_address_prefixes           ="10.0.4.0/24"

  #VNET REGION 1 ElasticSearch subnet
  es_subnet_name                        ="tam-elasticsearch-subnet"
  es_subnet_address_prefixes            ="10.0.5.0/24"

  #VNET REGION 1 Robots subnet
  robot_subnet_name                     ="tam-robots-subnet"
  robot_subnet_address_prefixes         ="10.0.6.0/24"

  #VNET REGION 1 CyberArk subnet
  cyberark_subnet_name                  ="tam-cyberark-subnet"
  cyberark_subnet_address_prefixes      ="10.0.7.0/24"

  #VNET REGION 1 DC subnet
  dc_subnet_name                        ="tam-domain-controller-subnet"
  dc_subnet_address_prefixes            ="10.0.8.0/24"

  nat_gateway_name                      = "tam-nat-gateway"
  nat_public_ip_name                    = "tam-nat-ip"
  nat_public_ip_prefix_name             = "tam-nat-ip-prefix"
  nat_gateway_sku                       = "Standard"
  nat_gateway_idle_timeout_mins         = 10
  nat_public_ip_allocation_method       = "Static"
  nat_public_ip_sku                     = "Standard"
  nat_public_ip_prefix_lenght           = 30

  tag_owner                             = local.tag_owner
  tag_project                           = local.tag_project

}

#Services Bastion Host
module "BastionHost" {

  depends_on                            = [module.network]

  source                                = "../../modules/services/BastionHost"

  resource_group_name                   = local.resource_group_name
  resource_group_location               = local.resource_group_location

  bastion_subnet_id                     = module.network.bastion_subnet_id
  bastion_public_ip_address_id          = module.network.bastion_public_ip_id

  bastion_host_name                     = "tam-bastion-host"
  bastion_ip_configuration_name         = "bastionipconfig"

  tag_owner                             = local.tag_owner
  tag_project                           = local.tag_project
}

module "DomainController" {
  source                                = "../../modules/services/Domain Controller"

  depends_on                            = [module.network]

  resource_group_name                   = local.resource_group_name
  resource_group_location               = local.resource_group_location

  dc_subnet_id                          = module.network.dc_subnet_id

  network_interface_name                = "DC-acctni"
  IP_configuration_name                 = "testconfiguration"
  private_ip_allocation                 = "dynamic"
  private_ip_address                    = "10.0.8.5"

  vm_name                               = "DC-VM"
  vm_size                               = "Standard_E4d_v4"
  vm_username                           = "uipathadmin"
  vm_password                           = "P@ssW0rd#123"

  os_caching                            = "ReadWrite"
  storage_account_type                  = "Standard_LRS"

  source_image_publisher                = "MicrosoftWindowsServer"
  source_image_offer                    = "WindowsServer"
  source_image_sku                      = "2019-Datacenter"
  source_image_version                  = "latest"

  tag_owner                             = local.tag_owner
  tag_project                           = local.tag_project
  tag_AlwaysPoweredOn                   = local.tag_AlwaysPoweredOn

}

#SQL Server primary and secondary
module "SQLServer" {

  depends_on                = [module.network]

  source                    = "../../modules/data-stores/SQLServer"

  resource_group_name       = local.resource_group_name
  resource_group_location   = local.resource_group_location

  #SQL Server
  sql_server_name           ="tam-sql-server"
  sql_version               ="12.0"
  sql_admin_login           ="uipath_sql"
  sql_admin_password        ="P@ssW0rd#123"
  sql_vnet_rule_name        ="tam-sql-vnet-rule"
  sql_subnet_id             = module.network.sql_subnet_id
  sql_location              = local.resource_group_location

  sql_orchestartor_db_name  = "UiPath"
  sql_identity_db_name      = "Identity"
  sql_insights_db_name      = "Insights"

  sql_firewall_rule_name    = "tam-firewall-sql-rule"
  sql_firewall_end_ip       = "0.0.0.0"
  sql_firewall_start_ip     = "0.0.0.0"

  tag_owner                 = local.tag_owner
  tag_project               = local.tag_project
}

module "SharedStorage"{

  source                           = "../../modules/data-stores/SharedStorage"
  resource_group_location          = local.resource_group_location
  resource_group_name              = local.resource_group_name

  storage_account_name             = "tamstorage"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"

  storage_share_name               = "tam-storage-share"
  storage_share_directory_name     = "tam-storage-directory"
  storage_share_quota              = 50

  tag_owner                        = local.tag_owner
  tag_project                      = local.tag_project
}

#Services HAA
module "HaaCluster" {

  depends_on                                = [module.network]

  source                                    = "../../modules/services/HAA"

  resource_group_name                       = local.resource_group_name
  resource_group_location                   = local.resource_group_location

  haa_subnet_id                             = module.network.haa_subnet_id

  availability_set_name                     = "tam-haa-avset"
  availability_update_domain_count          = 2
  availability_set_fault_domain_count       = 2
  availability_set_managed                  = true

  private_ip_allocation                     = "dynamic"

  master_network_interface_name             = "haa-master-accti"
  master_IP_configuration_name              = "masteripconf"

  slave_instance_number                     = 2
  slave_network_interface_name              = "haa-slave-acctni-"
  slave_IP_configuration_name               = "slaveipconf"

  master_vm_disable_password_authentication = false
  master_vm_name                            = "haa-master"
  master_vm_size                            = "Standard_D4s_v3"
  master_vm_username                        = "uioadmin"
  master_vm_password                        = "P@ssW0rd#123"

  master_os_caching                         = "ReadWrite"
  master_storage_account_type               = "Standard_LRS"
  master_source_image_publisher             = "RedHat"
  master_source_image_offer                 = "RHEL"
  master_source_image_sku                   = "7.8"
  master_source_image_version               = "latest"

  slave_vm_disable_password_authentication  = false
  slave_vm_name                             = "haa-slave-"
  slave_vm_size                             = "Standard_D4s_v3"
  slave_vm_username                         = "uioadmin"
  slave_vm_password                         = "P@ssW0rd#123"

  slave_os_caching                          = "ReadWrite"
  slave_storage_account_type                = "Standard_LRS"
  slave_source_image_publisher              = "RedHat"
  slave_source_image_offer                  = "RHEL"
  slave_source_image_sku                    = "7.8"
  slave_source_image_version                = "latest"


  haa-user                                  = "tam.email@uipath.com"
  haa-password                              ="P@ssW0rd#123"
  haa-license                               = "2353tgewsdfweg34t342rftg23g2g23t2r32r2353tgewsdfweg34t342rftg23g2g23t2r32r2353tgewsdfweg34t342rftg23g2g23t2r32r2353tgewsdfweg34t342rftg23g2g23t2r32r"

  tag_owner                                 = local.tag_owner
  tag_project                               = local.tag_project
  tag_AlwaysPoweredOn                       = local.tag_AlwaysPoweredOn
}

#Services ElasticSearch
/*
module "ElasticSearchCluster" {

  source = "../../modules/services/ElasticSearch"

  resource_group_name=local.resource_group_name
  resource_group_location=local.resource_group_location

  dns_private_zone_name=module.network.dns_private_zone_name
  dns_lb_record_name="es"

  es_subnet_id = module.network.es_subnet_id

  tag_owner = local.tag_owner
  tag_project = local.tag_project
  tag_AlwaysPoweredOn = local.tag_AlwaysPoweredOn
}
*/

#Services Robot
/*
module "RobotCluster" {

  source = "../../modules/services/Robots"

  resource_group_name=local.resource_group_name
  resource_group_location=local.resource_group_location

  robot_subnet_id = module.network.robot_subnet_id

  tag_owner = local.tag_owner
  tag_project = local.tag_project
  tag_AlwaysPoweredOn = local.tag_AlwaysPoweredOn
}
*/

#Services CyberArk
/*
module "CyberArkCluster" {

  source = "../../modules/services/CyberArk"

  resource_group_name=local.resource_group_name
  resource_group_location=local.resource_group_location

  dns_private_zone_name=module.network.dns_private_zone_name
  dns_lb_record_name="ca"

  cyberark_subnet_id = module.network.cyberark_subnet_id

  tag_owner = local.tag_owner
  tag_project = local.tag_project
  tag_AlwaysPoweredOn = local.tag_AlwaysPoweredOn
}
*/

#Services Orchestrator
module "OrchestratorScaleSet" {

  depends_on = [module.network, module.SQLServer]

  source = "../../modules/services/Orchestrator"

  resource_group_name=local.resource_group_name
  resource_group_location=local.resource_group_location

  #dns_private_zone_name=module.network.dns_private_zone_name
  dns_lb_record_name="orchestrator"

  orchestrator_subnet_id = module.network.orchestrator_subnet_id

  set_local_adminpass= "yes"
  admin_password= "P@ssW0rd#123"
  orchestrator_local_account_role= "localadmin"
  vm_username= "uioadmin"
  vm_password= "P@ssW0rd#123"
  vm_size = "Standard_D4s_v3"

  orchestrator_version= "19.10.19"
  orchestrator_passphrase="P@ssW0rd#123"
  orchestrator_orchestratoradminpassword="P@ssW0rd#123"

  orchestrator_databaseservername= "sqlhost"
  orchestrator_databasename="uipath"
  orchestrator_databaseusername="sqlserver"
  orchestrator_databaseuserpassword="P@ssW0rd#123"

  #ENABLE THIS LINE WHEN YOU HAVE REDIS MODULE ENABLED
  haa_master_network_ip = module.HaaCluster.haa_master_network_ip
  haa-password = "P@ssW0rd#123"

  tag_owner = local.tag_owner
  tag_project = local.tag_project
  tag_AlwaysPoweredOn = local.tag_AlwaysPoweredOn
}