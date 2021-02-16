terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.1"
    }
  }
}

provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  #skip_provider_registration = true
  features {}
}

locals {
  resource_group_name="CSM-PreSales-RG"
  resource_group_primary_location= "USGov Virginia"
  resource_gropu_secondary_location = "USGov Texas"
  tag_owner = "tam.email@uipath.com"
  tag_project = "TAM"
  tag_AlwaysPoweredOn = "true"
}

#NETWORK MODULES TO PROVISION VNETS
module "network" {

  source = "../../modules/network"

  resource_group_name= local.resource_group_name
  resource_group_location= local.resource_group_primary_location

  domain_name = "tam.uipath.com"

  #VNET SQL REGION 1
  network_region1_location=local.resource_group_primary_location
  network_region1_name="tam-vnet"
  network_region1_address_space="10.0.0.0/16"

  sql_subnetwork_region1_name="sqlserver-subnet1"
  sql_subnetwork_region1_address_prefixes="10.0.1.0/24"
  sql_subnetwork_region1_address_service_endpoints="Microsoft.Sql"

  #VNET REGION 1 Bastion host subnet
  bastion_subnetwork_name="AzureBastionSubnet"
  bastion_subnetwork_address_prefixes="10.0.2.0/24"

  #VNET REGION 1 Orchestrator subnet
  orchestrator_subnetwork_name="tam-orchestrator"
  orchestrator_subnetwork_address_prefixes="10.0.3.0/24"

  #VNET REGION 1 HAA subnet
  haa_subnetwork_name="tam-haa"
  haa_subnetwork_address_prefixes="10.0.4.0/24"

  #VNET REGION 1 ElasticSearch subnet
  es_subnetwork_name="tam-elasticsearch"
  es_subnetwork_address_prefixes="10.0.5.0/24"

  #VNET REGION 1 Robots subnet
  robot_subnetwork_name="tam-robots"
  robot_subnetwork_address_prefixes="10.0.6.0/24"

  #VNET REGION 1 CyberArk subnet
  cyberark_subnetwork_name="tam-cyberark"
  cyberark_subnetwork_address_prefixes="10.0.7.0/24"

  #VNET REGION 1 Domain Controller subnet
  dc_subnetwork_name="tam-domain-controller"
  dc_subnetwork_address_prefixes="10.0.8.0/24"

  #VNET SQL REGION 2
  network_region2_location=local.resource_gropu_secondary_location
  network_region2_name="tam-vnet2"
  network_region2_address_space="10.1.0.0/16"

  sql_subnetwork_region2_name="sqlserver-subnet2"
  sql_subnetwork_region2_address_prefixes="10.1.1.0/24"
  sql_subnetwork_region2_address_service_endpoints="Microsoft.Sql"

  tag_owner = local.tag_owner
  tag_project = local.tag_project
}

#SQL Server primary and secondary nodes
module "SQLServer" {

  depends_on = [module.network]

  source = "../../modules/data-stores/SQLServer"

  resource_group_name= local.resource_group_name
  resource_group_location= local.resource_group_primary_location

  #SQL REGION 1
  primary_sql_server_name="tam-sql-primary"
  primary_sql_version="12.0"
  primary_sql_admin_login="uipath_sql"
  primary_sql_admin_password="P@ssW0rd#123"
  primary_sql_vnet_rule_name="primary_sql-vnet-rule"
  primary_sql_subnet_id= module.network.sql_subnet1_id
  primary_location = local.resource_group_primary_location

  #SQL REGION 2
  secondary_sql_server_name="tam-sql-secondary"
  secondary_sql_version="12.0"
  secondary_sql_admin_login="uipath_sql"
  secondary_sql_admin_password="P@ssW0rd#123"
  secondary_sql_vnet_rule_name="secondary_sql-vnet-rule"
  secondary_sql_subnet_id= module.network.sql_subnet2_id
  secondary_location = local.resource_gropu_secondary_location

  tag_owner = local.tag_owner
  tag_project = local.tag_project
}

#Services HAA
module "HaaCluster" {

  depends_on = [module.network]

  source = "../../modules/services/HAA"

  resource_group_name=local.resource_group_name
  resource_group_location=local.resource_group_primary_location

  haa_subnet_id = module.network.haa_subnet_id

  vm_username= "uioadmin"
  vm_password= "P@ssW0rd#123"
  vm_size = "Standard_D4s_v3"

  haa-user = "tam.email@uipath.com"
  haa-password="P@ssW0rd#123"
  haa-license = "2353tgewsdfweg34t342rftg23g2g23t2r32r2353tgewsdfweg34t342rftg23g2g23t2r32r2353tgewsdfweg34t342rftg23g2g23t2r32r2353tgewsdfweg34t342rftg23g2g23t2r32r"


  tag_owner = local.tag_owner
  tag_project = local.tag_project
  tag_AlwaysPoweredOn = local.tag_AlwaysPoweredOn
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

module "DomainController" {
  source = "../../modules/services/Domain Controller"

  depends_on = [module.network]

  resource_group_name=local.resource_group_name
  resource_group_location=local.resource_group_primary_location

  dc_subnet_id = module.network.dc_subnet_id

  tag_owner = local.tag_owner
  tag_project = local.tag_project
  tag_AlwaysPoweredOn = local.tag_AlwaysPoweredOn
}

#Services Bastion Host
module "OrchestratorScaleSet" {

  depends_on = [module.network, module.SQLServer]

  source = "../../modules/services/Orchestrator"

  resource_group_name=local.resource_group_name
  resource_group_location=local.resource_group_primary_location

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


#Services Bastion Host
module "BastionHost" {

  depends_on = [module.network]

  source = "../../modules/services/BastionHost"

  resource_group_name=local.resource_group_name
  resource_group_location=local.resource_group_primary_location

  bastion_subnet_id= module.network.bastion_subnet_id
  bastion_public_ip_address_id= module.network.bastion_public_ip_id

  tag_owner = local.tag_owner
  tag_project = local.tag_project
}