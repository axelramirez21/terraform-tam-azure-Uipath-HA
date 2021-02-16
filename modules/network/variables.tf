############# AZURE REGION VARIABLES #########
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

############# VNET ###############
variable "vnet_name" {
  description = "Vnet Name"
  type        = string
}

variable "vnet_location" {
  description = "Vnet location"
  type        = string
}

variable "vnet_address_space" {
  description = "Vnet address space"
  type        = string
}

variable "vnet_dns_server" {
  description = "Vnet address space"
  type        = string
}

############# SQL ###############
variable "sql_subnet_name" {
  description = "SQL subnet name"
  type        = string
}

variable "sql_subnet_address_prefixes" {
  description = "SQL subnet address prefixes"
  type        = string
}

variable "sql_subnet_address_service_endpoints" {
  description = "SQL subnet service endpoints"
  type        = string
}

##Bastion subnet
variable "bastion_subnet_name" {
  description = "Bastion host subnet name"
  type        = string
}

variable "bastion_subnet_address_prefixes" {
  description = "Bastion host subnet address prefixes"
  type        = string
}

variable "bastion_public_ip_name" {
  description = "The name for the bastion public ip name"
  type        = string
}

variable "bastion_allocation_method" {
  description = "Bastion host allocation method, Static or Dynamic"
  type        = string
}

variable "bastion_sku" {
  description = "Azure SKU for the bastion host"
  type        = string
}

##Orchestrator subnet
variable "orchestrator_subnet_name" {
  description = "Orchestrator subnet name"
  type        = string
}

variable "orchestrator_subnet_address_prefixes" {
  description = "Orchestrator subnet address prefixes"
  type        = string
}

##HAA subnet
variable "haa_subnet_name" {
  description = "HAA subnet name"
  type        = string
}

variable "haa_subnet_address_prefixes" {
  description = "HAA subnet address prefixes"
  type        = string
}

##ElasticSearch subnet
variable "es_subnet_name" {
  description = "Elastic Search subnet name"
  type        = string
}

variable "es_subnet_address_prefixes" {
  description = "Elastic Search address prefixes"
  type        = string
}

##Robot subnet
variable "robot_subnet_name" {
  description = "Robots subnet name"
  type        = string
}

variable "robot_subnet_address_prefixes" {
  description = "Robot subnet address prefixes"
  type        = string
}

##CyberArk subnet
variable "cyberark_subnet_name" {
  description = "CyberArk subnet name"
  type        = string
}

variable "cyberark_subnet_address_prefixes" {
  description = "CyberArk subnet address prefixes"
  type        = string
}

##Domain Controller subnet
variable "dc_subnet_name" {
  description = "Domain controller subnet name"
  type        = string
}

variable "dc_subnet_address_prefixes" {
  description = "Domain controller subnet address prefixes"
  type        = string
}

##NAT Gateway variables
variable "nat_gateway_name" {
  description = "NAT Gateway name"
  type        = string
}

variable "nat_gateway_sku" {
  description = "NAT Gateway Sku"
  type        = string
}

variable "nat_gateway_idle_timeout_mins" {
  description = "NAT Gateway idle time expressed in minutes"
  type        = number
}

variable "nat_public_ip_name" {
  description = "NAT Gateway Public IP name"
  type        = string
}

variable "nat_public_ip_allocation_method" {
  description = "NAT Gateway ip allocation method"
  type        = string
}

variable "nat_public_ip_sku" {
  description = "NAT Gateway public IP sku"
  type        = string
}

variable "nat_public_ip_prefix_name" {
  description = "NAT Gateway public IP prefix name"
  type        = string
}

variable "nat_public_ip_prefix_lenght" {
  description = "NAT Gateway public IP prefix lenght"
  type        = number
}

##Azure Tags
variable "tag_owner" {
  description = "tag for the ouwner of the resource"
  type        = string
}

variable "tag_project" {
  description = "tag for the project of the resource"
  type        = string
}